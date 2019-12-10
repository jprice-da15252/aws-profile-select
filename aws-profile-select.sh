#!/usr/bin/env bash
profiles=$(sed -nE "s/(\[|\[profile )(default|.+)\]/\2/p" < ~/.aws/config )

IFSBAK=$IFS
IFS=$'\n'
profiles=($profiles)
IFS=$IFSBAK

# Backup prompt as a separate variable if not already backed up
if [ -z "$PS1BAK" ]; then
  export PS1BAK="$PS1"
  PS1_local="$PS1"
else
  PS1_local="$PS1BAK"
fi

function main {
  echo
  echo ------------- AWS Profile Select-O-Matic -------------
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
      echo "Activating profile ${choice}: ${profiles[choice]}"
      export AWS_PROFILE="${profiles[choice]}"
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

# Kick off the main function:
main