#!/bin/bash

# Check if domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain=$1

# Ensure all required scripts are executable
chmod +x subdomain_find.sh url_find.sh js_find.sh port_scan.sh xss.sh sql.sh lfi.sh

# Run subdomain enumeration 
echo "Starting subdomain enumeration..."
./subdomain_find.sh "$domain"

# Run URL enumeration 
echo "Starting URL enumeration..."
./url_find.sh "$domain"

# Run JavaScript file analysis 
echo "Starting JavaScript file analysis..."
./js_find.sh "$domain"

# Run port scanning 
echo "Starting port scanning..."
./port_scan.sh "$domain"

# exploit 

mkdir "$domain"/exploit

# xss
./xss.sh /root/main/"$domain"/vuln/xss.txt

# sql
./sql.sh /root/main/"$domain"/vuln/sqli.txt

# lfi or directory transversal
./lfi.sh /root/main/"$domain"/vuln/lfi.txt


echo "All tasks completed for ${domain}. Results are stored in the respective directories."
