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
        package_name=$(echo "$package" | awk -F'/' '{print $1}')
        sudo apt-get install -y "$package_name"
    elif [[ $package =~ ^git\+ ]]; then
        repository=$(echo "$package" | cut -d'+' -f2-)
        git clone "$repository" || true
    elif [[ $package != "" ]]; then
        sanitized_package=$(echo "$package" | tr -d '\r')
        sudo pip install --no-deps "$sanitized_package" || true
    fi
done
