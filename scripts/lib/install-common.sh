#!/usr/bin/env bash
# Common installer helpers for NixOS-Hyprland
# Sourced by install.sh and auto-install.sh

nhl_detect_gpu_and_toggle() {
  # Args: $1 = hostName
  local hostName="$1"
  local cfg="./hosts/$hostName/config.nix"
  [ -f "$cfg" ] || cfg="./hosts/default/config.nix"

  local has_vm=false has_nvidia=false has_amd=false has_intel=false

  if hostnamectl | grep -q 'Chassis: vm'; then
    has_vm=true
  fi
  if command -v lspci >/dev/null 2>&1; then
    while read -r line; do
      if echo "$line" | grep -qi 'nvidia'; then
        has_nvidia=true
      elif echo "$line" | grep -qi 'amd'; then
        has_amd=true
      elif echo "$line" | grep -qi 'intel'; then
        has_intel=true
      fi
    done < <(lspci | grep -iE '(VGA|3D)')
  fi

  # Default all drivers to false, then enable the detected one
  sed -i 's/drivers\.amdgpu\.enable = [^;]*;/drivers.amdgpu.enable = false;/' "$cfg" || true
  sed -i 's/drivers\.intel\.enable = [^;]*;/drivers.intel.enable = false;/' "$cfg" || true
  sed -i 's/drivers\.nvidia\.enable = [^;]*;/drivers.nvidia.enable = false;/' "$cfg" || true
  sed -i 's/drivers\.nvidia-prime\.[a-zA-Z]* = [^;]*;/drivers.nvidia-prime.enable = false;\n      intelBusID = "";\n      nvidiaBusID = "";/' "$cfg" || true
  sed -i 's/vm\.guest-services\.enable = [^;]*;/vm.guest-services.enable = false;/' "$cfg" || true

  if $has_vm; then
    sed -i 's/vm\.guest-services\.enable = [^;]*;/vm.guest-services.enable = true;/' "$cfg" || true
  fi

  # Helper to convert PCI BB:DD.F (hex) to PCI:b:d:f (decimal) string
  local _nhl_hex_to_dec
  _nhl_hex_to_dec() { printf '%d' "0x$1"; }
  local _nhl_pci_addr_to_busid
  _nhl_pci_addr_to_busid() {
    local addr="$1" # e.g., 01:00.0
    local bus=${addr%%:*}; local rest=${addr#*:}; local dev=${rest%%.*}; local fun=${addr##*.}
    # Convert potentially-hex values to decimal
    if echo "$bus$dev$fun" | grep -qi '[a-f]'; then
      bus=$(_nhl_hex_to_dec "$bus"); dev=$(_nhl_hex_to_dec "$dev"); fun=$(_nhl_hex_to_dec "$fun")
    fi
    printf 'PCI:%s:%s:%s' "$bus" "$dev" "$fun"
  }
  local _nhl_guess_busid
  _nhl_guess_busid() {
    local vendor_regex="$1"
    local addr
    addr=$(lspci | grep -iE '(VGA|3D)' | grep -i "$vendor_regex" | awk '{print $1; exit}')
    [ -n "$addr" ] || return 1
    _nhl_pci_addr_to_busid "$addr"
  }

  if $has_nvidia && $has_intel; then
    # NVIDIA laptop hybrid
    sed -i 's/drivers\.nvidia-prime\.enable = [^;]*;/drivers.nvidia-prime.enable = true;/' "$cfg" || true
    sed -i 's/drivers\.nvidia\.enable = [^;]*;/drivers.nvidia.enable = false;/' "$cfg" || true
    sed -i 's/drivers\.intel\.enable = [^;]*;/drivers.intel.enable = true;/' "$cfg" || true
    # Try to auto-populate bus IDs
    local intel_id nvidia_id
    if command -v lspci >/dev/null 2>&1; then
      intel_id=$(_nhl_guess_busid 'Intel') || true
      nvidia_id=$(_nhl_guess_busid 'NVIDIA') || true
    fi
    if [ -n "$intel_id" ]; then
      sed -i "s|intelBusID = \".*\";|intelBusID = \"$intel_id\";|" "$cfg" || true
    fi
    if [ -n "$nvidia_id" ]; then
      sed -i "s|nvidiaBusID = \".*\";|nvidiaBusID = \"$nvidia_id\";|" "$cfg" || true
    fi
  elif $has_nvidia; then
    sed -i 's/drivers\.nvidia\.enable = [^;]*;/drivers.nvidia.enable = true;/' "$cfg" || true
  elif $has_amd; then
    sed -i 's/drivers\.amdgpu\.enable = [^;]*;/drivers.amdgpu.enable = true;/' "$cfg" || true
  elif $has_intel; then
    sed -i 's/drivers\.intel\.enable = [^;]*;/drivers.intel.enable = true;/' "$cfg" || true
  fi
}

nhl_prompt_timezone_console() {
  # Args: $1 = hostName, $2 = defaultKeyboardLayout
  local hostName="$1"
  local defKb="${2:-us}"
  local cfg="./hosts/$hostName/config.nix"
  [ -f "$cfg" ] || cfg="./hosts/default/config.nix"

  # Timezone prompt (default: auto-detect)
  local timeZone
  read -rp "Enter your timezone (e.g. America/New_York) or leave blank for auto-detect: [auto-detect] " timeZone
  if [ -z "$timeZone" ]; then
    # Prefer automatic time zone
    if grep -q 'services\.automatic-timezoned\.enable' "$cfg"; then
      sed -i 's/services\.automatic-timezoned\.enable = [^;]*/services.automatic-timezoned.enable = true/' "$cfg" || true
    else
      printf '\n  services.automatic-timezoned.enable = true;\n' >> "$cfg"
    fi
    # Remove explicit time.timeZone if present
    sed -i '/time\.timeZone[[:space:]]*=/{d}' "$cfg" || true
  else
    # Set explicit timezone and disable automatic
    if grep -q 'time\.timeZone' "$cfg"; then
      sed -i "s|time\.timeZone = \".*\";|time.timeZone = \"$timeZone\";|" "$cfg" || true
    else
      printf '\n  time.timeZone = "%s";\n' "$timeZone" >> "$cfg"
    fi
    if grep -q 'services\.automatic-timezoned\.enable' "$cfg"; then
      sed -i 's/services\.automatic-timezoned\.enable = [^;]*/services.automatic-timezoned.enable = false/' "$cfg" || true
    else
      printf '\n  services.automatic-timezoned.enable = false;\n' >> "$cfg"
    fi
  fi

  # Console keymap prompt (defaults to keyboardLayout)
  local consoleKeyMap
  read -rp "Enter your console keymap: [$defKb] " consoleKeyMap
  consoleKeyMap=${consoleKeyMap:-$defKb}
  # Replace any existing console.keyMap assignment
  if grep -q 'console\.keyMap' "$cfg"; then
    sed -i "s|console\.keyMap = \".*\";|console.keyMap = \"$consoleKeyMap\";|" "$cfg" || true
  else
    # Fallback: append a console.keyMap line near the end
    printf '\n  console.keyMap = "%s";\n' "$consoleKeyMap" >> "$cfg"
  fi
}
