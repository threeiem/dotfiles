# Use homebrew environment hints
export HOMEBREW_NO_ENV_HINTS="true"

# Core Homebrew install
export PATH="$(brew --prefix)/bin:${PATH}"

# GNU Core Utilities
export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:${PATH}"

# GNU sed
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:${PATH}"

# GNU AWK
export PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:${PATH}"

# GNU grep
export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:${PATH}"

# GNU tar
export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:${PATH}"

# GNU find
export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:${PATH}"
