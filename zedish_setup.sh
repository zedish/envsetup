#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    sudo "$0" "$@"
    exit
fi

# Define the options for the checklist
options=(
    "Basic" "Run Script 1" on 
    "Dev" "Run Script 2" on
    "Security" "Run Script 3" on
    "Electronics" "Run Script 3" on
    "Communications" "Run Script 3" on
)

# Display the checklist using whiptail
selected=$(whiptail --title "Select Scripts to Run" \
                    --checklist "Choose the scripts you want to execute:" \
                    15 60 5 \
                    "${options[@]}" \
                    3>&1 1>&2 2>&3)

# Check if the user pressed Cancel
if [ $? -ne 0 ]; then
    echo "User canceled."
    exit 1
fi

chmod 777 electronics.sh
chmod 777 coms.sh
chmod -R 777 basic_scripts
chmod -R 777 dev_scripts
chmod -R 777 security_scripts
#for option in ${selected_array[@]}; do
for option in $(echo "$selected" | sed 's/"//g' | tr -d '\n'); do
    echo "Installing $option..."
    case $option in
        "Basic")
            ./basic_scripts/basic.sh
            ;;
        "Dev")
            ./dev_scripts/dev.sh
            ;;
        "Security")
            ./security_scripts/security.sh
            ;;
        "Electronics")
            ./electronics.sh
            ;;
        "Communications")
            ./coms.sh
            ;;
        *)
            echo "Unknown option: $option"
            ;;
    esac
done

echo "All selected scripts have been executed."

