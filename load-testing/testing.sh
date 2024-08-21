#!/bin/bash

# Function to show usage
usage() {
  echo "Usage: $0 --url <url> or $0 -U <url>"
  exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -U|--url) url="$2"; shift ;;
        *) echo "Unknown parameter: $1"; usage ;;
    esac
    shift
done

# Check if the URL was provided
if [ -z "$url" ]; then
    echo "Error: URL is required."
    usage
fi

# Process the URL (placeholder for your logic)
echo "Processing URL: $url"
docker build -t alpine-bench . --no-cache --quiet
echo "Running Apache Benchmark (ab) with 1000 requests and 10 concurrent requests..."
docker run --rm alpine-bench ab -n 1000 -c 10 $url
