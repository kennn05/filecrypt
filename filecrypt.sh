\#!/bin/bash
clear
RED='\033[0;31m'
GREEN='\033[1;92m'
NC='\033[0m'

banner() { 
	echo -e """${RED}           
  	   .--------.                 
      / .------. \              
     / /        \ \                  
     | |        | |               
    _| |________| |_    
  .' |_|        |_| '.
  '._____ ____ _____.'
  |     .'____'.     |
  '.__.'.'    '.'.__.'
  '.__  |CRYPTO|   _.'
  |   '.'.____.'.'   |
  '.____'.____.'____.'
  '.________________.'"""
 	echo ""
    echo "Coded by Ken"
    echo -e "------------------------------------${NC}"
    ls 
    echo -e "${RED}------------------------------------"
}

# Check if OpenSSL is installed
if ! command -v openssl &> /dev/null; then
  echo "Error: OpenSSL is required for this script. Install it using your package manager."
  exit 1
fi

# Function to display menu
display_menu() {
  banner
  echo "Select an option:"
  echo "----------------------"
  echo "[1] Encrypt a file"
  echo "[2] Decrypt a file"
  echo "[0] Exit"
  echo ""
}

# Function to encrypt a file
encrypt_file() {
  read -p "Enter the file to encrypt: " input_file
  if [ ! -f "$input_file" ]; then
    echo ""
    echo "File '$input_file' not found."
    sleep 1.2
    return
  fi

  output_file="${input_file}.enc"
  read -sp "Enter password: " password
  echo ""
  openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass pass:"$password" >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}File Encrypted successfully -> $output_file${NC}"
    sleep 2
    echo ""
    exit 1
  else
    echo -e "${RED}Error encrypting the file.${NC}"
    sleep 2
    echo ""
    exit 1
  fi
}

# Function to decrypt a file
decrypt_file() {
  read -p "Enter the file to decrypt: " input_file
  if [ ! -f "$input_file" ]; then
    echo "File '$input_file' not found."
    sleep 1.2
    return
  fi

  if [[ "$input_file" != *.enc ]]; then
    echo -e "${RED}Error: Input file does not have .enc extension. Cannot decrypt.${NC}"
    return
  fi

  output_file="${input_file%.enc}"
  read -sp "Enter password: " password
  echo ""
  openssl enc -aes-256-cbc -d -salt -in "$input_file" -out "$output_file" -pass pass:"$password" >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}File Decrypted successfully -> $output_file${NC}"
    sleep 1.2
    echo ""
    exit 1
  else
    echo -e "${RED}Error decrypting the file. Please check the password.${NC}"
    sleep 2
    exit 1
  fi
}

# Main program
while true; do
  display_menu
  read -p "Enter your choice: " choice
  case $choice in
    1)
      encrypt_file
      ;;
    2)
      decrypt_file
      ;;
    0)
      echo "Exiting."
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid choice. Please try again.${NC}"
      sleep 1
      ;;
  esac
done
