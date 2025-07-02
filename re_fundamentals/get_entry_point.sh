#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <elf_file>"
    exit 1
fi

# Get filename from command line argument
file_name="$1"

# Check if the file exists and is readable
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# Check if the file is an ELF file
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: File '$file_name' is not a valid ELF file."
    exit 1
fi

# Force English locale for consistent output
export LC_ALL=C

# Extract ELF header information using readelf
magic_number=$(readelf -h "$file_name" | grep "Magic:" | awk '{$1=""; print $0}' | sed 's/^ //')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk -F, '{print $2}' | xargs)
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $NF}')

# Source messages.sh if available, otherwise display directly
if [ -f "messages.sh" ]; then
    source ./messages.sh
    display_elf_header_info
else
    echo "ELF Header Information for '$file_name':"
    echo "----------------------------------------"
    echo "Magic Number:$magic_number"
    echo "Class: $class"
    echo "Byte Order:$byte_order"
    echo "Entry Point Address: $entry_point_address"
fi
