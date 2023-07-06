#!/bin/bash

package_file="packages.txt"

# Read package names from the file
readarray -t packages < "$package_file"

# Install Ubuntu packages using apt-get
for package in "${packages[@]}"
do
    if [[ $package == *"/"* ]]; then
        sudo apt-get install -y "$package"
    fi
done

# Install Python packages using pip or pip3
for package in "${packages[@]}"
do
    if [[ $package != *"/"* && $package != *"git clone"* ]]; then
        sudo pip install "$package"  # Use 'pip3' if required
    fi
done

# Install packages installed via git clone
for package in "${packages[@]}"
do
    if [[ $package == *"git clone"* ]]; then
        package_url="${package#*git clone }"
        package_name="$(basename "$package_url" .git)"
        git clone "$package_url"
        cd "$package_name" || continue
        sudo python setup.py install
        cd ..
        rm -rf "$package_name"
    fi
done
