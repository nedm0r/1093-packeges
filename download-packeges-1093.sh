#!/bin/bash

package_file="packages.txt"

# Read package names from the file
readarray -t packages < "$package_file"

# Install Ubuntu packages using apt-get
# Clone Git repositories
# Install Python packages using pip or pip3
for package in "${packages[@]}"
do
    if [[ $package == *"/"* ]]; then
        sanitized_package=$(echo "$package" | cut -d'/' -f1)  # Extract package name before the '/'
        sudo apt-get install -y "$sanitized_package"
    elif [[ $package == "git+"* ]]; then
        repository=$(echo "$package" | cut -d'+' -f2)  # Extract repository URL after 'git+'
        git clone "$repository"
    else
        sanitized_package=$(echo "$package" | tr -d '\r')  # Remove carriage return if present
        sudo pip install "$sanitized_package"  # Use 'pip3' if required
    fi
done
