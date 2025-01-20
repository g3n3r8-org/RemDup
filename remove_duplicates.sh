#!/bin/bash

# Initialize counters
total_files=0
duplicate_count=0

# Iterate over all files in the current directory
for file in *; do
    # Skip directories
    if [[ -f "$file" ]]; then
        total_files=$((total_files + 1))
        
        # Calculate the file's hash
        hash=$(sha256sum "$file" | awk '{print $1}')
        
        # Check if another file with the same hash already exists
        if [[ -f ".hash_$hash" ]]; then
            # If a duplicate is found, remove the file
            echo "Removing duplicate file: $file"
            rm "$file"
            duplicate_count=$((duplicate_count + 1))
        else
            # Otherwise, create a marker file to track the hash
            touch ".hash_$hash"
        fi
    fi
done

# Cleanup temporary hash files
rm .hash_*

# Print summary
echo "Total files processed: $total_files"
echo "Duplicates removed: $duplicate_count"
echo "Remaining unique files: $((total_files - duplicate_count))"
