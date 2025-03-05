#!/bin/bash

# Reset
export Reset=$'\e[0m'

# Regular Colors
export Black=$'\e[30m'
export Red=$'\e[31m'
export Green=$'\e[32m'
export Yellow=$'\e[33m'
export Blue=$'\e[34m'
export Purple=$'\e[35m'
export Cyan=$'\e[36m'
export White=$'\e[37m'

# Bold
export Bold=$'\e[1m'
export Bold_Black=$'\e[1;30m'
export Bold_Red=$'\e[1;31m'
export Bold_Green=$'\e[1;32m'
export Bold_Yellow=$'\e[1;33m'
export Bold_Blue=$'\e[1;34m'
export Bold_Purple=$'\e[1;35m'
export Bold_Cyan=$'\e[1;36m'
export Bold_White=$'\e[1;37m'

# Background colors
export Bg_Black=$'\e[40m'
export Bg_Red=$'\e[41m'
export Bg_Green=$'\e[42m'
export Bg_Yellow=$'\e[43m'
export Bg_Blue=$'\e[44m'
export Bg_Purple=$'\e[45m'
export Bg_Cyan=$'\e[46m'
export Bg_White=$'\e[47m'

# Special effects
export Blink=$'\e[5m'$'\033[5m'

lf(){
  echo "${Reset}"
}

rainbow(){
  echo -ne "${Red}\u2588${Reset}"
  echo -ne "${Bold}${Red}\u2588${Reset}"
  echo -ne "${Yellow}\u2588${Reset}"
  echo -ne "${Bold}${Yellow}\u2588${Reset}"
  echo -ne "${Green}\u2588${Reset}"
  echo -ne "${Bold}${Green}\u2588${Reset}"
  echo -ne "${Cyan}\u2588${Reset}"
  echo -ne "${Bold}${Cyan}\u2588${Reset}"
  echo -ne "${Blue}\u2588${Reset}"
  echo -ne "${Bold}${Blue}\u2588${Reset}"
  echo -ne "${Purple}\u2588${Reset}"
  echo -ne "${Bold}${Purple}\u2588${Reset}"
  echo -ne "${Bold}${White}\u2588${Reset}"
  echo -ne "${White}\u2588${Reset}"
  echo -ne "${Bold}${Black}\u2588${Reset}"
  echo -ne "${Black}\u2588${Reset}"
  echo -ne "${Reset}"
}

colors_text_test(){
  lf
  echo -ne "${White}\u2588${Reset}"
  echo "${White} White Text (\${White})${Reset}"
  echo -ne "${Bold}${White}\u2588${Reset}"
  echo "${Bold_White} Bold White Text (\${Bold_White}/\${Bold}\${White})${Reset}"
  echo "${Bg_White}${Bold_White}  Bold White Text on White Background (\${Bg_White}\${Bold_White})     ${Reset}"
  lf
  echo -ne "${Red}\u2588${Reset}"
  echo "${Red} Red Text (\${Red})${Reset}"
  echo -ne "${Bold}${Red}\u2588${Reset}"
  echo "${Bold_Red} Bold Red Text (\${Bold_Red})${Reset}"
  echo "${Bg_Red}${Bold_Red}  Bold Red Text on Red Background (\${Bg_Red}\${Bold_Red})             ${Reset}"
  lf

  echo -ne "${Yellow}\u2588${Reset}"
  echo "${Yellow} Yellow Text(\${Yellow})${Reset}"
  echo -ne "${Bold}${Yellow}\u2588${Reset}"
  echo "${Bold}${Yellow} Bold Yellow Text (\${Bold}\${Yellow}) ${Reset}"
  echo "${Bg_Yellow}${Bold_Yellow}  Bold Yellow Text on Yellow Background (\${Bg_Yellow}\${Bold_Yellow}) ${Reset}"
  lf

  echo -ne "${Green}\u2588${Reset}"
  echo "${Green} Green Text(\${Green})${Reset} "
  echo -ne "${Bold}${Green}\u2588${Reset}"
  echo "${Bold}${Green} Bold Green Text (\${Bold}\${Green}) ${Reset}"
  echo "${Bg_Green}${Bold_Green}  Bold Green Text on Green Background (\${Bg_Green}\${Bold_Green})     ${Reset}"
  lf

  echo -ne "${Cyan}\u2588${Reset}"
  echo "${Cyan} Cyan Text(\${Cyan})${Reset} "
  echo -ne "${Bold}${Cyan}\u2588${Reset}"
  echo "${Bold_Cyan} Bold Cyan Text (\${Bold_Cyan})${Reset} "
  echo "${Bg_Cyan}${Bold_Cyan}  Bold Cyan Text on Cyan Background (\${Bg_Cyan}\${Bold_Cyan})         ${Reset}"
  lf

  echo -ne "${Blue}\u2588${Reset}"
  echo "${Blue} Blue Text(\${Blue})${Reset} "
  echo -ne "${Bold_Blue}\u2588${Reset}"
  echo "${Bold_Blue} Bold Blue Text (\${Bold_Blue})${Reset} "
  echo "${Bg_Blue}${Bold_Blue}  Bold Blue Text on Blue Background (\${Bg_Blue}\${Bold_Blue})         ${Reset}"
  lf
  echo -ne "${Purple}\u2588${Reset}"
  echo "${Purple} Purple Text(\${Purple})${Reset} "
  echo -ne "${Bold_Purple}\u2588${Reset}"
  echo "${Bold}${Purple} Bold Purple Text (\${Bold}\${Purple}) ${Reset}"
  echo "${Bg_Purple}${Bold_Purple}  Bold Purple Text on Purple Background (\${Bg_Purple}\${Bold_Purple}) ${Reset}"
  lf
}

# Test function
iterm_colors_demo() {

  if [[ "${1}" == "-b" ]]; then
    rainbow
    echo -ne "${Reset}"
    return
  fi

  if [[ "${1}" == "-t" ]]; then
    colors_text_test
    return
  fi

  colors_text_test
  rainbow
  lf
  lf
  echo "Color names and modifiers start with uppercase for each word."
  echo "The words are separated by a underbar/underscore."
  echo "Some combinations exist as a single variable."
  echo "Background colors start with \"Bg\""
  lf
  echo "${Bold}Variables${Reset}:"
  echo "  ${Red}Red${Reset} is \${Red}"
  echo "  ${Bold}Bold${Reset} is \${Bold}"
  echo "  ${Bold_Green}Bold green${Reset} text is \${Bold_Green} or \${Bold}\${Green}"
  echo "  ${Bg_Green}Green background${Reset} text is \${Bg_Green}"
  lf 
  echo "${Bold}Special cases${Reset}:"
  echo "${Bold}${Black} Bold Black Text (\${Bold}\${Black}/\${Bold_Black})${Reset}"
  echo " ${Blink}This should blink${Reset} (iterm settings Profiles>Text \"blinking text\")"
  lf
}

sizzle() {
  local colors=( "${Red}" "${Yellow}" "${Green}" "${Cyan}" "${Blue}" "${Purple}")
  local text="$*"
  local output=""
  local i=1

  for (( j=0; j<${#text}; j++ )); do
    local char="${text:$j:1}"
    if [[ "$char" =~ [[:graph:]] ]]; then
      # [[:graph:]] matches any visible character except spaces
      printf -v output '%s%s%s' "$output" "${colors[$i]}" "$char"
      i=$(( (i + 1) % 6 ))
      if [[ $i == 0 ]]; then
        i=1
      fi
    else
      printf -v output '%s%s' "$output" "$char"
    fi
  done

  printf '%s%s\n' "$output" "${Reset}"
}

