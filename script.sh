#!/bin/bash
chmod 777 "$0"
frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
expected_answer_yes="yes"
expected_answer_no="no"

#!/bin/bash

# Set the welcome message
welcome_message="Welcome and Enjoy your stay"

# Set the user's name
user=$(whoami)

# Set the user's email
useremail="${user}@student@42porto.com"

# Define fixed parts of the text
user_label="User: "
email_label="Email: "

# Calculate the lengths of the fixed parts
welcome_length=${#welcome_message}
user_label_length=${#user_label}
email_label_length=${#email_label}

# Calculate the total lengths of the lines
user_line_length=$((user_label_length + ${#user}))
email_line_length=$((email_label_length + ${#useremail}))

# Determine the maximum length
max_length=$((welcome_length > user_line_length ? welcome_length : user_line_length))
max_length=$((max_length > email_line_length ? max_length : email_line_length))

# Create the border
border_length=$((max_length + 6))  # 6 accounts for the "   # " and " #  "
border=$(printf '#%.0s' $(seq 1 $border_length))

# Calculate the padding for the welcome message
padding_length=$((border_length - 4 - welcome_length))  # 4 accounts for the " # " and " # "
padding_half_length=$((padding_length / 2))

# Print the formatted output
header(){
	echo "$border"
	echo "#  $(printf '%*s' $((max_length)) "")  #"
	echo "# $(printf '%*s' $(((border_length - welcome_length - 4) / 2)))${welcome_message}$(printf '%*s' $(((border_length - welcome_length - 4) / 2 			+ ($(( (border_length - welcome_length - 4) % 2 ))) )) ) #"
	echo "#  $(printf '%*s' $(((max_length - ${#user_label} - ${#user}) / 2)))$user_label$user$(printf '%*s' $(((max_length - ${#user_label} - ${#user}) / 2)))   #"
	echo "#  $(printf '%*s' $(((max_length - ${#email_label} - ${#useremail}) / 2)))$email_label$useremail$(printf '%*s' $(((max_length - ${#email_label} - ${#useremail}) / 2)))  #"
	echo "$border"
	echo
}
header

# Friendly screen clear
echo "Want to clear the terminal before"
echo "executing the script?"
echo -n "(Type yes/no): "
read answer
while true; do
    if [ "$answer" == "$expected_answer_yes" ]; then
        clear
        header
        break
    elif [ "$answer" == "$expected_answer_no" ]; then
        break
    else
	tput cuu 1
	tput sc
	for i in {1..1}; do
		tput el
	if [ $i -lt 1 ]; then
        	tput cud1
    	fi
	done
	tput rc
	tput cuu 1
        echo "Answer not valid, please try again"
        echo "Want to clear the terminal before"
	echo "executing the script?"
	echo -n "(Type yes/no): "
        read answer
    fi
done


# Password Check
clear
header
echo -n "Enter your password: "
read -s pwd
tput cuu1
tput el
echo
echo "$password" | sudo -S ls / > /dev/null 2>&1
for frame in "${frames[@]}"; do
    echo -ne "$frame Checking if Password is correct\r"
    sleep 0.2
done
if [ $? -eq 0 ]; then
    tput el
    echo "Password is correct"
    sleep 2
    tput cuu1 && tput el
else
    tput el
    echo "Incorrect password"
    sleep 2
    clear
    exit
fi


# Fixing Debian 12 Problem of the package error
for frame in "${frames[@]}"; do
    echo -ne "$frame Fixing APT Sourcelist\r"
    sleep 0.2
done
echo $pwd | if ! grep -q "\[trusted=yes\]" /etc/apt/sources.list; then
    sudo sed -i '1d' /etc/apt/sources.list
    sudo sed -i 's/^deb /deb [trusted=yes] /g' /etc/apt/sources.list
    sudo sed -i 's/^deb-src /deb-src [trusted=yes] /g' /etc/apt/sources.list
    sleep 2
fi
tput el

# Install Make
sudo apt install make -y > /dev/null 2> install_errors.log
for frame in "${frames[@]}"; do
    echo -ne "$frame Installing make\r"
    sleep 0.2
done
tput el

# Install Docker
# https://docs.docker.com/engine/install/debian/
sudo apt update > /dev/null 2> install_errors.log
sudo apt install ca-certificates curl -y > /dev/null 2> install_errors.log
sudo install -m 0755 -d /etc/apt/keyrings > /dev/null 2> install_errors.log
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc > /dev/null 2> install_errors.log
sudo chmod a+r /etc/apt/keyrings/docker.asc > /dev/null 2> install_errors.log
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 2> install_errors.log
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y > /dev/null 2> install_errors.log
for frame in "${frames[@]}"; do
    echo -ne "$frame Installing Docker\r"
    sleep 0.2
done
tput el

# Install Git
sudo apt install git -y > /dev/null 2> install_errors.log
for frame in "${frames[@]}"; do
    echo -ne "$frame Installing git\r"
    sleep 0.2
done
tput el

#Install Vscode
echo -n "Want to install VScode?(yes/no): "
read answer1
if [ "$answer1" == "$expected_answer_yes" ]; then
    sudo apt install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |		sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https -y
    sudo apt update
    sudo apt install code -y
else
    tput el
fi

#The end
clear
welcome_message="Thank you for using me 😍  "
header
echo "Everything was Installed Successfully"

