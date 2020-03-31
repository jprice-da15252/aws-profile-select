#!/usr/bin/env bash

# Copyright 2019 Jesse Price

profiles=$(cat ~/.aws/config | grep  '^\['| sed  -E 's/\[profile (.*)/\1/g' | sed 's/\[//; s/\]//')

IFSBAK=$IFS
IFS=$'\n'
profiles=($profiles)
IFS=$IFSBAK

# Enable setting of AWS_SDK_LOAD_CONFIG by default
sdk=1

# Backup prompt as a separate variable if not already backed up
if [ -z "$PS1BAK" ]; then
  export PS1BAK="$PS1"
  PS1_local="$PS1"
else
  PS1_local="$PS1BAK"
fi

function main {
  printf "Current value of AWS_SDK_LOAD_CONFIG: ${AWS_SDK_LOAD_CONFIG}\n"
  echo
  echo ------------- AWS Profile Select-O-Matic -------------
  echo
  if [ -z "$AWS_PROFILE" ]; then
    printf "No profile set yet\n\n"
  else
    printf "\nCurrently-selected profile: ${AWS_PROFILE}\n\n"
  fi
  echo "Type the number of the profile you want to use from the list below, and press enter"
  echo

  # Show the menu
  selection_menu
}

function usage { 
  echo "Usage: aps [-n|--no-sdk] [-h|--help]"
  echo "For normal usage, just run aps and make your selection followed by Enter."
  echo "If you do not want the AWS_SDK_LOAD_CONFIG environment variable to be set to true, append -n or --no-sdk to the command"
  # exit 1
}

function selection_menu {
  echo "-: Unset Profile"
  for (( i=0; i<${#profiles[@]}; i++ )); do
      echo "$i: ${profiles[$i]}"
  done
  read_selection
}

function read_selection {
  echo
  printf 'Selection: '; read choice
  case $choice in
    ''|*[!0-9\-]*)
    clear
    echo Invalid selection. Make a valid selection from the list above or press ctrl+c to exit; 
    echo '-> Error: Not a number, and not "-"'
    echo
    selection_menu
  ;;
  esac
  in_range=false
  while [ $in_range != true ]; do
    if
      [[ $choice == '-' ]]; then
      echo "Deactivating all profiles"
      unset AWS_PROFILE
      export PS1="$PS1BAK"
      in_range=true
    elif (( $choice >= 0 )) && (( $choice <= ${#profiles[@]} )); then
      # Set AWS_SDK_LOAD_CONFIG to true to make this useful for tools such as Terraform and Serverless framework
      if [ $sdk == 1 ]; then
        export AWS_SDK_LOAD_CONFIG=1
      else
        export AWS_SDK_LOAD_CONFIG=0
      fi
      echo "Activating profile ${choice}: ${profiles[choice]}"
      export AWS_PROFILE="${profiles[choice]}"
      echo 
      export PS1="${PS1_local}(${profiles[choice]}): "
      in_range=true
    else
      clear
      echo Invalid selection. Select a valid profile number or press ctrl+c to exit
      echo "-> Error:  Number must be one of 0-"$((${#profiles[@]}-1))""
      echo
      selection_menu
    fi
  done
}

if [ $# -gt 0 ]; then
  while [ ! $# -eq 0 ]
  do
    case "$1" in
      --help | -h)
        usage
        ;;
      --no-sdk | -n)
        sdk=0
        # Kick off the main function:
        main
        ;;
    esac
    shift
  done
else 
  # Kick off the main function:
  main
fi