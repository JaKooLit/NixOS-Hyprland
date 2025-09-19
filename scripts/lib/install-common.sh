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

  # Decide detected profile
  local detected=""
  if $has_vm; then
    detected="vm"
  elif $has_nvidia && $has_intel; then
    detected="nvidia-laptop"
  elif $has_nvidia; then
    detected="nvidia"
  elif $has_amd; then
    detected="amd"
  elif $has_intel; then
    detected="intel"
  fi

  # Confirm or manually choose profile
  local profile="$detected"
  if [ -n "$detected" ]; then
    printf "Detected GPU profile: %s. Use this? (Y/n): " "$detected"
    read -r _ans </dev/tty || true
    if [ -n "$_ans" ] && ! echo "$_ans" | grep -qi '^y'; then
      profile=""
    fi
  fi
  if [ -z "$profile" ]; then
    printf "Enter your GPU profile (amd|intel|nvidia|nvidia-laptop|vm): [amd] "
    read -r profile </dev/tty || true
    profile=${profile:-amd}
  fi

  # Reset toggles
  sed -i 's/drivers\.amdgpu\.enable = [^;]*;/drivers.amdgpu.enable = false;/' "$cfg" || true
  sed -i 's/drivers\.intel\.enable = [^;]*;/drivers.intel.enable = false;/' "$cfg" || true
  sed -i 's/drivers\.nvidia\.enable = [^;]*;/drivers.nvidia.enable = false;/' "$cfg" || true
  sed -i 's/drivers\.nvidia-prime\.enable = [^;]*;/drivers.nvidia-prime.enable = false;/' "$cfg" || true
  sed -i 's/vm\.guest-services\.enable = [^;]*;/vm.guest-services.enable = false;/' "$cfg" || true

  # Apply selected profile
  case "$profile" in
    vm)
      sed -i 's/vm\.guest-services\.enable = [^;]*;/vm.guest-services.enable = true;/' "$cfg" || true
      ;;
    nvidia-laptop)
      sed -i 's/drivers\.nvidia-prime\.enable = [^;]*;/drivers.nvidia-prime.enable = true;/' "$cfg" || true
      sed -i 's/drivers\.intel\.enable = [^;]*;/drivers.intel.enable = true;/' "$cfg" || true
      ;;
    nvidia)
      sed -i 's/drivers\.nvidia\.enable = [^;]*;/drivers.nvidia.enable = true;/' "$cfg" || true
      ;;
    amd)
      sed -i 's/drivers\.amdgpu\.enable = [^;]*;/drivers.amdgpu.enable = true;/' "$cfg" || true
      ;;
    intel)
      sed -i 's/drivers\.intel\.enable = [^;]*;/drivers.intel.enable = true;/' "$cfg" || true
      ;;
    *)
      # Fallback: do nothing if unknown
      ;;
  esac
}

nhl_prompt_timezone_console() {
  # Args: $1 = hostName, $2 = defaultKeyboardLayout
  local hostName="$1"
  local defKb="${2:-us}"
  local cfg="./hosts/$hostName/config.nix"
  [ -f "$cfg" ] || cfg="./hosts/default/config.nix"

  # Timezone prompt (default: auto-detect)
  local timeZone
  read -rp "Enter your timezone (e.g. America/New_York) or leave blank for auto-detect: [auto-detect] " timeZone </dev/tty
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
  read -rp "Enter your console keymap: [$defKb] " consoleKeyMap </dev/tty
  consoleKeyMap=${consoleKeyMap:-$defKb}
  # Replace any existing console.keyMap assignment
  if grep -q 'console\.keyMap' "$cfg"; then
    sed -i "s|console\.keyMap = \".*\";|console.keyMap = \"$consoleKeyMap\";|" "$cfg" || true
  else
    # Fallback: append a console.keyMap line near the end
    printf '\n  console.keyMap = "%s";\n' "$consoleKeyMap" >> "$cfg"
  fi
}
