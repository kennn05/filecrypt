#!/bin/bash

# Check if OpenSSL is installed
if ! command -v openssl &> /dev/null; then
  echo "Error: OpenSSL is not installed. Please install it and try again."
  exit 1
fi

# Function to display menu
display_menu() {
  echo "Select an option:"
  echo "1) Encrypt a file"
  echo "2) Decrypt a file"
  echo "0) Exit"
  read -p "Enter your choice: " choice
}

# Function to encrypt a file
encrypt_file() {
  read -p "Enter the file to encrypt: " input_file
  if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
  fi

  output_file="${input_file}.enc"
  read -sp "Enter password: " password
  echo
  openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass pass:"$password"

  if [ $? -eq 0 ]; then
    echo "File encrypted successfully: $output_file"
    exit 1
  else
    echo "Error encrypting the file."
    exit 1
  fi
}

# Function to decrypt a file
decrypt_file() {
  read -p "Enter the file to decrypt: " input_file
  if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
  fi

  if [[ "$input_file" != *.enc ]]; then
    echo "Error: Input file does not have .enc extension. Cannot decrypt."
    exit 1
  fi

  output_file="${input_file%.enc}"
  read -sp "Enter password: " password
  echo
  openssl enc -aes-256-cbc -d -salt -in "$input_file" -out "$output_file" -pass pass:"$password"

  if [ $? -eq 0 ]; then
    echo "File decrypted successfully: $output_file"
    exit 1
  else
    echo "Error decrypting the file. Please check the password."
    exit 1
  fi
}

# Main program
while true; do
  display_menu
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
      echo "Invalid choice. Please try again."
      ;;
  esac
done
