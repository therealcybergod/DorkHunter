#!/bin/bash

# Function to perform a Google search with a given dork
perform_search() {
    local dork="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "Searching with dork: $dork"
    echo "Timestamp: $timestamp" >> dorkhunter_log.txt
    echo "Search query: $dork" >> dorkhunter_log.txt
    echo "Domain: google.com" >> dorkhunter_log.txt
    echo "https://www.google.com/search?q=$dork" >> dorkhunter_log.txt
    open "https://www.google.com/search?q=$dork"
}

# Introducing the script
echo "Welcome to Dork Hunter! This script uses Google dorks to perform advanced searches for various types of information."
echo "Dork Hunter was created by George K. Ragsdale on June 19th, 2024."

while true; do
    # Prompt the user to start
    read -p "Would you like to begin? (Y/N): " start
    start=$(echo "$start" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$start" != "y" ]]; then
        echo "Exiting Dork Hunter. Have a great day!"
        exit 0
    fi

    # Ask what the user wants to search for
    echo "What are you searching for?"
    echo "1. Files"
    echo "2. Names"
    echo "3. Usernames"
    echo "4. Emails"
    echo "5. Phone numbers"
    echo "6. Images"
    read -p "Enter the number of your choice: " choice

    # Get the search query from the user and automatically wrap in quotes
    read -p "Enter your search query: " query
    query="\"$query\""

    # Determine the appropriate dork based on search type
    case $choice in
        1)
            file_types=("pdf" "doc" "docx" "xls" "xlsx" "ppt" "pptx" "txt" "rtf" "odt" "ods" "odp" "xml" "json" "csv" "epub" "mobi" "log" "bak" "cfg" "ini" "php" "asp" "aspx" "jsp" "html")
            for filetype in "${file_types[@]}"; do
                perform_search "$query filetype:$filetype"
            done
            ;;
        2)
            name_searches=(
                "$query site:linkedin.com"
                "$query site:facebook.com"
                "$query site:twitter.com"
                "$query site:instagram.com"
                "$query site:github.com"
                "$query site:medium.com"
                "$query site:reddit.com"
                "$query site:quora.com"
                "$query \"CV\" OR \"resume\""
                "$query \"biography\" OR \"bio\""
                "$query \"contact information\""
                "$query \"email address\""
                "$query \"phone number\""
                "$query intitle:\"index of\" \"parent directory\""
                "$query -inurl:html -inurl:htm -inurl:php -inurl:asp"
                "$query +home address"
                "$query +\"home phone\""
                "$query +\"contact details\""
            )

            # Ask if user wants to search by country
            read -p "Would you like to search by country? (Y/N): " search_country
            search_country=$(echo "$search_country" | tr '[:upper:]' '[:lower:]')

            if [[ "$search_country" == "y" ]]; then
                read -p "Enter a location (e.g., country code top-level domain like .uk, .fr): " location
                for search in "${name_searches[@]}"; do
                    perform_search "$search site:$location"
                done
            else
                for search in "${name_searches[@]}"; do
                    perform_search "$search"
                done
            fi
            ;;
        3)
            username_searches=(
                "intitle:\"index of\" $query"
                "inurl:\"profile\" $query"
                "inurl:\"user\" $query"
                "$query site:github.com"
                "$query site:stackoverflow.com"
                "$query site:reddit.com"
                "$query site:twitter.com"
                "$query site:facebook.com"
                "$query site:instagram.com"
                "$query site:linkedin.com"
                "$query site:medium.com"
                "$query site:pinterest.com"
                "$query site:quora.com"
                "$query site:bitbucket.org"
                "$query site:gitlab.com"
                "$query site:wordpress.com"
                "$query site:blogger.com"
                "$query site:wordpress.org"
                "$query site:discord.com"
            )
            for search in "${username_searches[@]}"; do
                perform_search "$search"
            done
            ;;
        4)
            email_providers=("gmail.com" "yahoo.com" "hotmail.com" "aol.com" "comcast.net" "outlook.com" "icloud.com" "mail.com" "zoho.com" "yandex.com" "protonmail.com" "gmx.com" "lycos.com" "inbox.com" "fastmail.com" "ymail.com" "googlemail.com" "live.com" "spectrum.net")
            for provider in "${email_providers[@]}"; do
                perform_search "\"$query@$provider\""
            done
            advanced_email_searches=(
                "intitle:\"index of\" $query ext:eml"
                "$query ext:eml"
                "$query ext:msg"
                "$query ext:mbox"
                "$query ext:email"
                "$query ext:mail"
                "$query ext:msf"
            )
            for search in "${advanced_email_searches[@]}"; do
                perform_search "$search"
            done
            ;;
        5)
            phone_formats=(
                "$query"
                "${query:0:3}-${query:3:3}-${query:6}"
                "(${query:0:3}) ${query:3:3}-${query:6}"
                "+1 ${query:0:3} ${query:3:3} ${query:6}"
                "${query:0:3}.${query:3:3}.${query:6}"
            )
            for format in "${phone_formats[@]}"; do
                perform_search "\"$format\""
            done
            advanced_phone_searches=(
                "\"$query\" \"contact\""
                "\"$query\" \"phone number\""
                "\"$query\" \"cell\""
                "\"$query\" \"mobile\""
                "\"$query\" \"home phone\""
                "\"$query\" \"fax\""
            )
            for search in "${advanced_phone_searches[@]}"; do
                perform_search "$search"
            done
            ;;
        6)
            image_types=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "webp" "svg" "ico" "psd" "eps" "ai" "raw" "cr2" "nef" "orf" "sr2" "heic" "indd" "jpe")
            for imgtype in "${image_types[@]}"; do
                perform_search "$query filetype:$imgtype"
            done
            advanced_image_searches=(
                "intitle:\"index of\" $query"
                "$query \"image\""
                "$query \"photo\""
                "$query \"picture\""
                "$query \"graphic\""
                "$query \"drawing\""
                "$query \"illustration\""
                "$query \"artwork\""
                "$query \"screenshot\""
                "$query \"icon\""
            )
            for search in "${advanced_image_searches[@]}"; do
                perform_search "$search"
            done
            ;;
        *)
            echo "Invalid selection. Please try again."
            ;;
    esac

    echo "Search completed. Ready for a new search."
done
