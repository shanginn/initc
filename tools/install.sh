main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Cloning InitC repository...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }
  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    echo "Not for Windows, sorry"
    exit 1
  fi

  if [ ! -n "$INITC" ]; then
    INITC=~/.initc
  fi

  env git clone --depth=1 https://github.com/shanginn/initc.git $INITC || {
    printf "Error: git clone of InitC repo failed\n"
    exit 1
  }

  $INITC/initc

  printf "${GREEN}"
  echo '__/\\\\\\\\\\\______________________________________________/\\\\\\\\\_________'
  echo '__\/////\\\///____________________________________________/\\\////////_________'
  echo '_______\/\\\______________________/\\\______/\\\_________/\\\/_________________'
  echo '________\/\\\_______/\\/\\\\\\____\///____/\\\\\\\\\\\___/\\\__________________'
  echo '_________\/\\\______\/\\\////\\\____/\\\__\////\\\////___\/\\\_________________'
  echo '__________\/\\\______\/\\\__\//\\\__\/\\\_____\/\\\_______\//\\\_______________'
  echo '___________\/\\\______\/\\\___\/\\\__\/\\\_____\/\\\_/\\____\///\\\____________'
  echo '_________/\\\\\\\\\\\__\/\\\___\/\\\__\/\\\_____\//\\\\\_______\////\\\\\\\\\__'
  echo '_________\///////////___\///____\///___\///_______\/////___________\/////////__'
  echo ''
  printf "${NORMAL}"
}

install_deps () {
  curl -O https://raw.githubusercontent.com/shanginn/initc/master/tools/pacapt
  chmod +x pacapt
  ./pacapt -Sy
  ./pacapt --noconfirm -S curl vim htop git zsh
  rm -f pacapt
}

install_deps
main
