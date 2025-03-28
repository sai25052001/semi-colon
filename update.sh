#!/bin/bash

# Path to your Trivy scan output file
SCAN_OUTPUT="$(pwd)/parse_trivy_output.txt"
# Path to your pom.xml file
POM_FILE="pom.xml"

# Extract the highest fixed version of log4j-core from the Trivy scan output
#NEW_VERSION=$(grep -oP 'Package: org.apache.logging.log4j:log4j-core, .*?Fixed: \K[0-9]+\.[0-9]+\.[0-9]+' "$SCAN_OUTPUT" | sort -V | tail -n 1)
#grep -oP '(?<=Fixed: )[0-9]+\.[0-9]+\.[0-9]+|(?<=, )[0-9]+\.[0-9]+\.[0-9]+' parse_trivy_output.txt | sort -V | tail -n 1
NEW_VERSION=$(grep -oP '(?<=Fixed: )[0-9]+\.[0-9]+\.[0-9]+|(?<=, )[0-9]+\.[0-9]+\.[0-9]+' "$SCAN_OUTPUT" | sort -V | tail -n 1)

# Check if a version is found
if [ -z "$NEW_VERSION" ]; then
    echo "No version found in scan output."
    exit 1
fi

# Use sed to replace the version in pom.xml with the new version
sed -i "s|<version>.*</version>|<version>${NEW_VERSION}</version>|" "$POM_FILE"

echo "Updated version to the new version in ${POM_FILE}"

