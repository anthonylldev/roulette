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

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Example Usage:${endColour}\n"
  echo -e "\t${blueColour}bash roulette.sh -m <money> -t <technique>${endColour}\n"
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

function martingale_game() {
  money=$1
  initial_money=$1
  verbose=$2
  var total_games=1
  echo -e "\n${purpleColour}MARTINGALE${endColour}"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Initial money: ${endColour}${turquoiseColour}${money}€${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}How much money do you want to bet?  ->  ${endColour}" && read initial_bet
  echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What do you want to bet on continuously even/odd?  ->  ${endColour}" && read even_odd

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

  if [ "${verbose}" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}The number is:${endColour} ${yellowColour}${random_number}${endColour}${grayColour}${endColour}"
  fi

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
}

function validate() {
  money=$1
  technique=$2
  verbose=$3

  if ! [[ "${money}" =~ ^[0-9]+$ ]]; then
    echo -e "\n${redColour}[!] Money must be a number${endColour}\n"
    exit 1
  fi

  case ${technique} in
  1)
    martingale_game "${money}" "${verbose}"
    ;;
  2)
    reverse_labouchere_game "${money}" "${verbose}"
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

while getopts "m:t:hv" arg 2>/dev/null; do
  case $arg in
  h)
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

  if [ "${money}" ] && [ "${technique}" ]; then
     validate "${money}" "${technique}" "${verbose}"
  else
    exit 1
  fi
else
  help_panel
fi
