#!/bin/bash

package_file="packages.txt"

# Читаем имена пакетов из файла
readarray -t packages < "$package_file"

# Устанавливаем пакеты Ubuntu с помощью apt
# Клонируем Git-репозитории
# Устанавливаем пакеты Python с помощью pip или pip3
for package in "${packages[@]}"
do
    package_name=$(echo "$package" | awk -F'\t' '{print $1}')
    if [[ $package_name =~ ^git\+ ]]; then
        repository=$(echo "$package_name" | cut -d'+' -f2-)
        git clone "$repository"
    else
        if [[ $package_name == *":"* ]]; then
            package_name=$(echo "$package_name" | cut -d':' -f1)
        fi
        sudo apt install -y "$package_name" || true
        sudo apt-get install -y "$package_name" || true
        pip install --no-deps "$package_name" || true
        pip3 install --no-deps "$package_name" || true
    fi
done
