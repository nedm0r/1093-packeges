#!/bin/bash

package_file="packages.txt"

# Читаем имена пакетов из файла
readarray -t packages < "$package_file"

# Устанавливаем пакеты Ubuntu с помощью apt-get
# Клонируем Git-репозитории
# Устанавливаем пакеты Python с помощью pip или pip3
for package in "${packages[@]}"
do
    if [[ $package == *"/"* ]]; then
        package_name=$(echo "$package" | awk -F'/' '{print $1}')
        sudo apt-get install -y "$package_name"
    elif [[ $package =~ ^git\+ ]]; then
        repository=$(echo "$package" | cut -d'+' -f2-)
        git clone "$repository"
    elif [[ $package != "" ]]; then
        sanitized_package=$(echo "$package" | tr -d '\r')
        sudo pip install "$sanitized_package"
    fi
done
