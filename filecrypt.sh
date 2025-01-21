#!/bin/bash

# Check for required commands
if ! command -v openssl &> /dev/null; then
  echo "Error: OpenSSL is not installed. Please install it and try again."
  exit 1
fi

# Function to display usage
usage() {
  echo "Usage: $0 <encrypt|decrypt> <file>"
  exit 1
}

# Check arguments
if [ "$#" -ne 2 ]; then
  usage
fi

# Get mode and file
mode=$1
file=$2

# Validate mode
if [[ "$mode" != "encrypt" && "$mode" != "decrypt" ]]; then
  usage
fi

# Check if file exists
if [ ! -f "$file" ]; then
  echo "Error: File '$file' not found."
  exit 1
fi

# Prompt for password
read -sp "Enter password: " password
echo

# Encryption
if [ "$mode" == "encrypt" ]; then
  output="${file}.enc"
  openssl enc -aes-256-cbc -salt -in "$file" -out "$output" -pass pass:"$password"
  if [ $? -eq 0 ]; then
    echo "File encrypted successfully: $output"
  else
    echo "Error encrypting file."
  fi

# Decryption
elif [ "$mode" == "decrypt" ]; then
  if [[ "$file" != *.enc ]]; then
    echo "Error: Input file does not have .enc extension. Cannot decrypt."
    exit 1
  fi
  output="${file%.enc}"
  openssl enc -aes-256-cbc -d -salt -in "$file" -out "$output" -pass pass:"$password"
  if [ $? -eq 0 ]; then
    echo "File decrypted successfully: $output"
  else
    echo "Error decrypting file. Please check the password."
  fi
fi
