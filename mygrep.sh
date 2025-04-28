#!/bin/bash

# Help function
usage() {
    echo "Usage: $0 [-n] [-v] pattern file"
    echo "  -n    Show line numbers"
    echo "  -v         Invert match (show non-matching lines)"
    echo "  --help     Show help message"

    exit 1
}

line_numbers=0
invert=0

# Parse options with getopts
while getopts ":nvh" opt; do
    case $opt in
        n) line_numbers=1 ;;
        v) invert=1 ;;
        h) usage ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
    esac
done
shift $((OPTIND-1))

# Check arguments
if [ $# -ne 2 ]; then
    echo "Error: Need exactly 2 arguments" 
    usage
fi
if [ ! -f "$2" ]; then
    echo "Error: File not found: $2" >&2
    exit 1
fi
# Search logic
line_num=0
pattern_lower=${1,,}  # Convert pattern to lowercase
while IFS= read -r line; do
    line_num=$((line_num+1))
    line_lower=${line,,}  # Convert line to lowercase for comparison
    
    # Check if pattern exists in line (case insensitive)
    if [[ "$line_lower" == *"$pattern_lower"* ]]; then
        matched=1
    else
        matched=0
    fi
    
    # Invert match if -v flag
    [ $invert -eq 1 ] && matched=$((!matched))
    
    # Print if matched
    [ $matched -eq 1 ] && {
        [ $line_numbers -eq 1 ] && printf "%d:" "$line_num"
        echo "$line"
    }
done < "$2"