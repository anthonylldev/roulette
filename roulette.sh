#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

declare -a red_numbers=(1 3 5 7 9 12 14 16 18 19 21 23 25 27 30 32 34 36)
declare -a black_numbers=(2 4 6 8 10 11 13 15 17 20 22 24 26 28 29 31 33 35)

# Functions
function ctrl_c() {
  echo -e "\n\n${redColour}[!] Exiting...${endColour}\n"
  tput cnorm
  exit 1
}

function help_panel() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Script Usage:${endColour}\n"
  echo -e "\t${blueColour}h)${endColour} ${grayColour}Show help panel.${endColour}"
  echo -e "\t${blueColour}m)${endColour} ${grayColour}Set money to play.${endColour}"
  echo -e "\t${blueColour}o)${endColour} ${grayColour}Set technique to play:${endColour}"
  echo -e "\t\t${turquoiseColour}1${endColour} ${grayColour}- Martingale${endColour}"
  echo -e "\t\t${turquoiseColour}2${endColour} ${grayColour}- Reverse Labouchère${endColour}"
  echo -e "\t${blueColour}M)${endColour} ${grayColour}Set mode to play:${endColour}"
  echo -e "\t\t${turquoiseColour}1${endColour} ${grayColour}- Even / Odd${endColour}"
  echo -e "\t\t${turquoiseColour}2${endColour} ${grayColour}- Red / Black${endColour}"

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Example Usage:${endColour}\n"
  echo -e "\t${blueColour}bash roulette.sh -m <money> -t <technique> -M <mode>${endColour}\n"
}

function show_mode_message() {
  echo -e "\n${redColour}[!] The mode entered is not valid.${endColour}"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Please select one of these:${endColour}"
  echo -e "\t${turquoiseColour}1${endColour} ${grayColour}- Even / Odd${endColour}"
  echo -e "\t${turquoiseColour}2${endColour} ${grayColour}- Red / Black${endColour}\n"
}

function show_technique_message() {
  echo -e "\n${redColour}[!] The technique entered is not valid.${endColour}"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Please select one of these:${endColour}"
  echo -e "\t${turquoiseColour}1${endColour} ${grayColour}- Martingale${endColour}"
  echo -e "\t${turquoiseColour}2${endColour} ${grayColour}- Reverse Labouchère${endColour}\n"
}

function report() {
  initial_money=$1
  money=$2
  total_games=$3

  if [ "${money}" -lt "${initial_money}" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Final money: ${endColour}${redColour}${money}€${endColour}"
  elif [ "${money}" -eq "${initial_money}" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Final money: ${endColour}${turquoiseColour}${money}€${endColour}"
  else
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Final money: ${endColour}${greenColour}${money}€${endColour}"
  fi

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Total games: ${endColour}${turquoiseColour}${total_games}${endColour}\n"
}

function number_report() {
  verbose=$1
  mode=$2
  is_red=$3
  is_black=$4

  if [ "${verbose}" ]; then

    case ${mode} in
    1)
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}The number is:${endColour} ${yellowColour}${random_number}${endColour}"
      ;;
    2)
      if [ "${is_red}" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}The number is:${endColour} ${redColour}${random_number}${endColour}"
      elif [ "${is_black}" ]; then
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}The number is:${endColour} ${grayColour}${random_number}${endColour}"
      fi
      ;;
    esac
  fi
}

function martingale_game() {
  money=$1
  initial_money=$1
  verbose=$2
  mode=$3
  total_games=0
  echo -e "\n${purpleColour}MARTINGALE${endColour}"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Initial money: ${endColour}${turquoiseColour}${money}€${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}How much money do you want to bet?  ->  ${endColour}" && read initial_bet

  if ! [[ "${initial_bet}" =~ ^[0-9]+$ ]]; then
    echo -e "\n${redColour}[!] Bet must be a number${endColour}\n"
    exit 1
  fi

  case ${mode} in
  1)
    echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What do you want to bet on continuously even/odd?  ->  ${endColour}" && read even_odd
    if [ "${even_odd}" != "even" ]  && [ "${even_odd}" != "odd" ]; then
        echo -e "\n${redColour}[!] You must enter even or odd.${endColour}\n"
        exit 1
    fi
    ;;
  2)
    echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What do you want to bet on continuously red/black?  ->  ${endColour}" && read red_black
    if [ "${red_black}" != "red" ]  && [ "${red_black}" != "black" ]; then
        echo -e "\n${redColour}[!] You must enter black or red.${endColour}\n"
        exit 1
    fi
    ;;
  *)
    show_mode_message
    exit 1
    ;;
  esac

  # We check that the money we bet is not more than our current money.
  if [ "${initial_bet}" -gt "${money}" ]; then
    echo -e "\n${redColour}[!] You can't bet more money than you have.${endColour}\n"
    exit 1
  fi

  # Initialise the auxiliary variable of the bet.
  aux_bet=${initial_bet}

  if [ "${verbose}" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Betting${endColour} ${turquoiseColour}${initial_bet}€${endColour} ${grayColour}on${endColour} ${turquoiseColour}${even_odd}${endColour}${grayColour}.${endColour}"
  fi

  tput civis

  # As long as money is not less than or equal to 0.
  while [ ! "${money}" -le 0 ]; do

    # We check that the money we bet is not more than our current money.
    if [ "${aux_bet}" -gt "${money}" ]; then
      echo -e "\n${redColour}[!] The next bet is greater than the money you have remaining.${endColour}"
      report "${initial_money}" "${money}" "${total_games}"
      tput cnorm
      exit 1
    fi

    # We subtract the stake money from our money.
    money=$(("${money}" - "${aux_bet}"))

    # We get the roulette number.
    random_number=$(($RANDOM % 37))
    ((total_games+=1))

    number_report "${verbose}" "${mode}"

    case ${mode} in
    1)
      # We check whether it is odd-even or zero.
      if [ ${random_number} -eq 0 ]; then
        aux="zero"
      elif [ $(("${random_number}" % 2)) -eq 0 ]; then
        aux="even"
      else
        aux="odd"
      fi

      if [ "${aux}" == "${even_odd}" ]; then
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${greenColour}You win.${endColour}"
        fi

        # If we win we double the auxiliary bet and initialise the reward.
        reward=$(("${aux_bet}" * 2))

        # We add the reward to the current money.
        money=$(("${money}" + "${reward}"))

        # We leave the auxiliary bet as the current bet.
        aux_bet=${initial_bet}
      else
        # If we lose, we double the auxiliary bet.
        aux_bet=$(("${aux_bet}" * 2))
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${redColour}You lost.${endColour}"
        fi
      fi
      ;;
    2)
      for element in "${red_numbers[@]}"; do
        if [ ${element} -eq ${random_number} ]; then
          is_red=true
        fi
      done

      for element in "${black_numbers[@]}"; do
        if [ ${element} -eq ${random_number} ]; then
          is_black=true
        fi
      done

      number_report "${verbose}" "${mode}" "${is_red}" "${is_black}"

      if [ "${is_red}" ] && [ "${red_black}" == "red" ]; then
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${greenColour}You win.${endColour}"
        fi

        # If we win we double the auxiliary bet and initialise the reward.
        reward=$(("${aux_bet}" * 2))

        # We add the reward to the current money.
        money=$(("${money}" + "${reward}"))

        # We leave the auxiliary bet as the current bet.
        aux_bet=${initial_bet}
      elif [ "${is_black}" ] && [ "${red_black}" == "black" ]; then
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${greenColour}You win.${endColour}"
        fi

        # If we win we double the auxiliary bet and initialise the reward.
        reward=$(("${aux_bet}" * 2))

        # We add the reward to the current money.
        money=$(("${money}" + "${reward}"))

        # We leave the auxiliary bet as the current bet.
        aux_bet=${initial_bet}
      else
        # If we lose, we double the auxiliary bet.
        aux_bet=$(("${aux_bet}" * 2))
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${redColour}You lost.${endColour}"
        fi
      fi
    esac

    if [ "${verbose}" ]; then
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Actual money: ${endColour} ${yellowColour}${money}${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Next bet: ${endColour} ${yellowColour}${aux_bet}${endColour}"
    fi
  done

  echo -e "\n${redColour}You lost all money.${endColour}"
  report "${initial_money}" "${money}" "${total_games}"
  tput cnorm
}

function reverse_labouchere_game() {
  money=$1
  initial_money=$1
  verbose=$2
  mode=$3
  total_games=0
  echo -e "\n${purpleColour}MARTINGALE${endColour}"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Initial money: ${endColour}${turquoiseColour}${money}€${endColour}"

  case ${mode} in
  1)
    echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What do you want to bet on continuously even/odd?  ->  ${endColour}" && read even_odd
    if [ "${even_odd}" != "even" ]  && [ "${even_odd}" != "odd" ]; then
        echo -e "\n${redColour}[!] You must enter even or odd.${endColour}\n"
        exit 1
    fi
    ;;
  2)
    echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What do you want to bet on continuously red/black?  ->  ${endColour}" && read red_black
    if [ "${red_black}" != "red" ]  && [ "${red_black}" != "black" ]; then
        echo -e "\n${redColour}[!] You must enter black or red.${endColour}\n"
        exit 1
    fi
    ;;
  *)
    show_mode_message
    exit 1
    ;;
  esac

  declare -a sequence=(1 2 3 4)

  # shellcheck disable=SC2145
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Start with sequence${endColour} ${purpleColour}[${sequence[@]}]${endColour}"

  bet=$((${sequence[0]} + ${sequence[-1]}))

  tput civis

  # As long as money is not less than or equal to 0.
  while [ ! "${money}" -le 0 ]; do

    # We check that the money we bet is not more than our current money.
    if [ "${bet}" -gt "${money}" ]; then
      echo -e "\n${redColour}[!] The next bet is greater than the money you have remaining.${endColour}"
      report "${initial_money}" "${money}" "${total_games}"
      tput cnorm
      exit 1
    fi

    # We subtract the stake money from our money.
    money=$(("${money}" - "${bet}"))

    # We get the roulette number.
    random_number=$(($RANDOM % 37))
    ((total_games+=1))

    number_report "${verbose}" "${mode}"

    case ${mode} in
    1)
      # We check whether it is odd-even or zero.
      if [ ${random_number} -eq 0 ]; then
        aux="zero"
      elif [ $(("${random_number}" % 2)) -eq 0 ]; then
        aux="even"
      else
        aux="odd"
      fi

      if [ "${aux}" == "${even_odd}" ]; then
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${greenColour}You win.${endColour}"
        fi

        # If we win we double the auxiliary bet and initialise the reward.
        reward=$(("${bet}" * 2))

        # We add the reward to the current money.
        money=$(("${money}" + "${reward}"))

        # shellcheck disable=SC2206
        sequence+=($bet)

        # shellcheck disable=SC2206
        sequence=(${sequence[@]})

        if [ "${#sequence[@]}" -ne 1 ]; then
          # shellcheck disable=SC2004
          bet=$((${sequence[0]} + ${sequence[-1]}))
        elif [ "${#sequence[@]}" -eq 1 ]; then
          bet=${sequence[0]}
          else
          echo "zero"
        fi

        if [ "${verbose}" ]; then
        # shellcheck disable=SC2145
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Sequence${endColour} ${purpleColour}[${sequence[@]}]${endColour}"
        fi
      else
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${redColour}You lost.${endColour}"
        fi

        # shellcheck disable=SC2184
        unset sequence[0]

        # shellcheck disable=SC2184
        unset sequence[-1] 2>/dev/null

        # shellcheck disable=SC2206
        sequence=(${sequence[@]})

        if [ "${verbose}" ]; then
        # shellcheck disable=SC2145
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Sequence${endColour} ${purpleColour}[${sequence[@]}]${endColour}"
        fi

        if [ "${#sequence[@]}" -ne 1 ] && [ "${#sequence[@]}" -ne 0 ]; then
          # shellcheck disable=SC2004
          bet=$((${sequence[0]} + ${sequence[-1]}))
        elif [ "${#sequence[@]}" -eq 1 ]; then
          bet=${sequence[0]}
        else
          if [ "${verbose}" ]; then
              # shellcheck disable=SC2145
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Reset sequence.${endColour}"
          fi

          sequence=(1 2 3 4)
        fi
      fi
      ;;
    2)
      for element in "${red_numbers[@]}"; do
        if [ ${element} -eq ${random_number} ]; then
          is_red=true
        fi
      done

      for element in "${black_numbers[@]}"; do
        if [ ${element} -eq ${random_number} ]; then
          is_black=true
        fi
      done

      number_report "${verbose}" "${mode}" "${is_red}" "${is_black}"

      if [ "${is_red}" ] && [ "${red_black}" == "red" ]; then
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${greenColour}You win.${endColour}"
        fi

        # If we win we double the auxiliary bet and initialise the reward.
        reward=$(("${bet}" * 2))

        # We add the reward to the current money.
        money=$(("${money}" + "${reward}"))

        # shellcheck disable=SC2206
        sequence+=($bet)

        # shellcheck disable=SC2206
        sequence=(${sequence[@]})

        if [ "${#sequence[@]}" -ne 1 ]; then
          # shellcheck disable=SC2004
          bet=$((${sequence[0]} + ${sequence[-1]}))
        elif [ "${#sequence[@]}" -eq 1 ]; then
          bet=${sequence[0]}
          else
          echo "zero"
        fi

        if [ "${verbose}" ]; then
        # shellcheck disable=SC2145
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Sequence${endColour} ${purpleColour}[${sequence[@]}]${endColour}"
        fi
      elif [ "${is_black}" ] && [ "${red_black}" == "black" ]; then
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${greenColour}You win.${endColour}"
        fi

        # If we win we double the auxiliary bet and initialise the reward.
        reward=$(("${bet}" * 2))

        # We add the reward to the current money.
        money=$(("${money}" + "${reward}"))

        # shellcheck disable=SC2206
        sequence+=($bet)

        # shellcheck disable=SC2206
        sequence=(${sequence[@]})

        if [ "${#sequence[@]}" -ne 1 ]; then
          # shellcheck disable=SC2004
          bet=$((${sequence[0]} + ${sequence[-1]}))
        elif [ "${#sequence[@]}" -eq 1 ]; then
          bet=${sequence[0]}
          else
          echo "zero"
        fi

        if [ "${verbose}" ]; then
        # shellcheck disable=SC2145
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Sequence${endColour} ${purpleColour}[${sequence[@]}]${endColour}"
        fi
      else
        if [ "${verbose}" ]; then
          echo -e "${yellowColour}[+]${endColour} ${redColour}You lost.${endColour}"
        fi

        # shellcheck disable=SC2184
        unset sequence[0]

        # shellcheck disable=SC2184
        unset sequence[-1] 2>/dev/null

        # shellcheck disable=SC2206
        sequence=(${sequence[@]})

        if [ "${verbose}" ]; then
        # shellcheck disable=SC2145
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Sequence${endColour} ${purpleColour}[${sequence[@]}]${endColour}"
        fi

        if [ "${#sequence[@]}" -ne 1 ] && [ "${#sequence[@]}" -ne 0 ]; then
          # shellcheck disable=SC2004
          bet=$((${sequence[0]} + ${sequence[-1]}))
        elif [ "${#sequence[@]}" -eq 1 ]; then
          bet=${sequence[0]}
        else
          if [ "${verbose}" ]; then
              # shellcheck disable=SC2145
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Reset sequence.${endColour}"
          fi

          sequence=(1 2 3 4)
        fi
      fi
      ;;
    esac

    if [ "${verbose}" ]; then
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Actual money: ${endColour} ${yellowColour}${money}${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Next bet: ${endColour} ${yellowColour}${bet}${endColour}"
    fi

  done

  echo -e "\n${redColour}You lost all money.${endColour}"
  report "${initial_money}" "${money}" "${total_games}"
  tput cnorm
}

function validate() {
  money=$1
  technique=$2
  verbose=$3
  mode=$4

  if ! [[ "${money}" =~ ^[0-9]+$ ]]; then
    echo -e "\n${redColour}[!] Money must be a number${endColour}\n"
    exit 1
  fi

  case ${technique} in
  1)
    martingale_game "${money}" "${verbose}" "${mode}"
    ;;
  2)
    reverse_labouchere_game "${money}" "${verbose}" "${mode}"
    ;;
  *)
    show_technique_message
    exit 1
    ;;
  esac
}

# Pointer
declare -i parameter_counter=0

# Execution
trap ctrl_c INT

while getopts "m:t:M:hv" arg 2>/dev/null; do
  case $arg in
  h)
    ;;
  M)
    parameter_counter=1
    mode=$OPTARG
    ;;
  v)
    parameter_counter=1
    verbose=true
  ;;
  m)
    parameter_counter=1
    money=$OPTARG
    ;;
  t)
    parameter_counter=1
    technique=$OPTARG
    ;;
  *)
    echo -e "\n${redColour}[!] Invalid option${endColour}\n"
    exit 1
    ;;
  esac
done

if [ ${parameter_counter} -eq 1 ]; then

  if [ ! "${money}" ]; then
      echo -e "\n${redColour}[!] The money parameter is required.${endColour}\n"
  fi

  if [ ! "${technique}" ]; then
      echo -e "\n${redColour}[!] The technique parameter is required.${endColour}\n"
  fi

  if [ ! "${mode}" ]; then
      echo -e "\n${redColour}[!] The mode parameter is required.${endColour}\n"
  fi

  if [ "${money}" ] && [ "${technique}" ] && [ "${mode}" ]; then
     validate "${money}" "${technique}" "${verbose}" "${mode}"
  else
    exit 1
  fi
else
  help_panel
fi
