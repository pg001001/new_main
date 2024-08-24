#!/bin/bash

# Function to perform LFI testing for given URLs
lfi_testing() {
    local input_file=$1
    local base_dir=$(dirname "${input_file}")
    local exploit_dir="${base_dir}/exploit"
    local original_dir=$(pwd)
    
    # Check if input file exists
    if [[ ! -f "${input_file}" ]]; then
        echo "Error: ${input_file} not found!"
        exit 1
    fi

    # Create exploit directory if it doesn't exist
    mkdir -p "${exploit_dir}"

    echo "Performing LFI testing on URLs in ${input_file}..."

    cat "${input_file}" | uro | sed 's/=.*/=/' | gf lfi | nuclei -tags lfi >> "${exploit_dir}/lfi_results.txt"

    echo "Script execution completed."
}

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Run the LFI testing function with the provided input file
lfi_testing "$1"
