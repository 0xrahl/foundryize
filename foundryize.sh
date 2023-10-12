#!/bin/bash

# Prompt the user for the folder where Solidity files are stored
echo "Please enter the path to the folder containing the contract files:"
read contracts_folder

# Check if the contracts folder exists
if [ ! -d "$contracts_folder" ]; then
  echo "Error: '$contracts_folder' folder does not exist."
  exit 1
fi

# Print the folder path for confirmation
echo "You entered: $contracts_folder"

# Check if 'forge' command is installed
if ! command -v forge &>/dev/null; then
  echo "Foundry is not installed. Installing it now..."
  # Install Foundry using curl and bash
  curl -L https://foundry.paradigm.xyz | bash
else
  echo "Foundry is already installed."
fi

# Initialize Foundry with 'forge init'
forge init temp_foundry_install

# Copy the "lib" folder from the temporary installation directory to the current directory
cp -r "temp_foundry_install/lib" ./lib

# Clean up the temporary installation directory
rm -rf "temp_foundry_install"

# Check if 'remappings.txt' exists in the current directory
if [ -e "remappings.txt" ]; then
  echo "Using existing remappings.txt. Please ensure it is up to date for Foundry to work correctly."
else
  echo "Auto-generating remappings.txt..."
  # Generate a new remappings.txt using 'forge remappings'
  forge remappings > remappings.txt
fi

# Create a foundry.toml file with the specified content
cat <<EOL > foundry.toml
[profile.default]
src = "$contracts_folder"
out = 'foundry-out'
libs = ['node_modules', 'lib']
test = 'foundry-test'
cache_path  = 'foundry-cache'

# See more config options https://book.getfoundry.sh/reference/config.html
EOL

# Separator line
echo -e "\n\n"
echo "============================================================"
# Inform the user about the next steps
echo -e "\e[32mAll set! Go forth and code like a Foundry ninja. 💻🚀"
echo -e "Next steps: Create tests in 'foundry-test' and run 'forge test'."
echo -e "Learn more: Visit \e[4;32mhttps://book.getfoundry.sh/\e[0m"
# Separator line
echo "============================================================"