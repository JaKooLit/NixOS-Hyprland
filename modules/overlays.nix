{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: rec {
      # Helper: provide a clean cxxopts.pc to avoid broken upstream pc requiring non-existent icu-cu
      cxxoptsPcShim = final.runCommand "cxxopts-pc-shim" {} ''
        mkdir -p $out/lib/pkgconfig
        cat > $out/lib/pkgconfig/cxxopts.pc <<'EOF'
prefix=${final.cxxopts}
includedir=${final.cxxopts}/include

Name: cxxopts
Description: C++ command line parser headers
Version: ${final.cxxopts.version}
Cflags: -I${final.cxxopts}/include
Libs:
Requires:
EOF
      '';
      # Allow argtable to configure with newer CMake by declaring policy minimum
      argtable = prev.argtable.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or []) ++ [
          "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        ];
      });

      # Specifically patch the nested attribute path used by nixpkgs: antlr4_9.runtime.cpp
      # Add the policy flag and patch CMakeLists to bump minimum and force NEW policies
      antlr4_9 = prev.antlr4_9 // {
        runtime = prev.antlr4_9.runtime // {
          cpp = prev.antlr4_9.runtime.cpp.overrideAttrs (old: {
            cmakeFlags = (old.cmakeFlags or []) ++ [
              "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
            ];
            postPatch = (old.postPatch or "") + ''
              # Bump CMake minimum and force modern policies
              if [ -f runtime/Cpp/runtime/CMakeLists.txt ]; then
                sed -i -E 's/cmake_minimum_required\(VERSION [0-9.]+\)/cmake_minimum_required(VERSION 3.5)/' runtime/Cpp/runtime/CMakeLists.txt
                sed -i -E 's/(cmake_policy\(SET CMP[0-9]+ )OLD/\1NEW/g' runtime/Cpp/runtime/CMakeLists.txt || true
                sed -i -E 's/(CMAKE_POLICY\(SET CMP[0-9]+ )OLD/\1NEW/g' runtime/Cpp/runtime/CMakeLists.txt || true
              fi
              if [ -f runtime/Cpp/CMakeLists.txt ]; then
                sed -i -E 's/cmake_minimum_required\(VERSION [0-9.]+\)/cmake_minimum_required(VERSION 3.5)/' runtime/Cpp/CMakeLists.txt
                sed -i -E 's/(cmake_policy\(SET CMP[0-9]+ )OLD/\1NEW/g' runtime/Cpp/CMakeLists.txt || true
                sed -i -E 's/(CMAKE_POLICY\(SET CMP[0-9]+ )OLD/\1NEW/g' runtime/Cpp/CMakeLists.txt || true
              fi
            '';
          });
        };
      };

      # Fix libvdpau-va-gl CMake minimum for modern CMake
      libvdpau-va-gl = prev.libvdpau-va-gl.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or []) ++ [
          "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        ];
        postPatch = (old.postPatch or "") + ''
          # Bump top-level CMake minimum if present
          if [ -f CMakeLists.txt ]; then
            sed -i -E 's/cmake_minimum_required\(VERSION [0-9.]+\)/cmake_minimum_required(VERSION 3.5)/' CMakeLists.txt || true
          fi
        '';
      });

      # Work around pamixer failing to find cxxopts via pkg-config (bogus icu-cu requirement)
      pamixer = prev.pamixer.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ final."pkg-config" cxxoptsPcShim ];
        # Ensure our shim takes precedence over any other cxxopts.pc
        preConfigure = (old.preConfigure or "") + ''
          export PKG_CONFIG_PATH=${cxxoptsPcShim}/lib/pkgconfig:"$PKG_CONFIG_PATH"
        '';
      });
      
    })
  ];
}