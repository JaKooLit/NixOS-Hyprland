{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
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
    })
  ];
}