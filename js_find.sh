#!/bin/bash

# Check if domain is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Function to scan for JavaScript files, download them, and search for sensitive information
scan_js() {
    local domain=$1
    local date=$(date +'%Y-%m-%d')
    local base_dir="${domain}/$([ "$IGNORE_SPLIT" = "false" ] && echo "${date}/")"
    mkdir -p "${base_dir}"

    # for i in $(cat $1)
    #     do
    #     waymore -i "${domain}" -mode U -c "${HOME}/config.yml" >> allfiles.txt
    #     gau "${domain}" >> allfiles.txt
    #     done

    # sort -ru allfiles.txt >> uniq_files.txt
    # grep -iv -E — ‘.js|.png|.jpg|.gif|.ico|.img|.css’ uniq_files.txt >> wayback_only_html.txt
    # cat uniq_files.txt | grep “\.js” | uniq | sort >> wayback_js_files.txt
    # grep —color=always -i -E — ‘admin|auth|api|jenkins|corp|dev|stag|stg|prod|sandbox|swagger|aws|azure|uat|test|vpn|cms’ wayback_only_html.txt >> important_http_urls.txt
    # grep —color=always -i -E — ‘aws|s3’ uniq_files.txt >> aws_s3_files.txt


    # subfinder -d domain.com | httpx -mc 200 | tee subdomains.txt && cat subdomains.txt | waybackurls | httpx -mc 200 | grep.js | tee js.txt
    
    # Scan for JavaScript files
    echo "Scanning for JavaScript files on ${domain}..."


    # echo "${domain}" | katana | grep "\.js$" | httpx -mc 200 | tee "${base_dir}/js.txt"
    # echo "${domain}" | gau | grep "\.js$" | httpx -mc 200 | tee "${base_dir}/js.txt"
    cat "${base_dir}/allurls.txt" | grep "\.js$" | httpx -mc 200 | tee "${base_dir}/js.txt"

    # Download each JavaScript file
    # file="${base_dir}/js.txt"
    # while IFS= read -r link; do
    #     wget -q "$link" -P "${base_dir}/js_files/"
    # done < "$file"

    mkdir -p "${base_dir}/js_files/"  && xargs -a "${base_dir}/js.txt" -I {} wget -q {} -P "${base_dir}/js_files/"

    # Search for sensitive information in downloaded JavaScript files
    echo "Searching for sensitive information in JavaScript files..."
    grep -r --color=always -i -E "aws_access_key|aws_secret_key|api key|passwd|pwd|heroku|slack|firebase" "${base_dir}/js_files/" | tee "${base_dir}/sensitive_info.txt"
    grep -r --color=always -i -E "access_key|access_token|admin_pass|admin_user|algolia_admin_key|algolia_api_key|alias_pass|alicloud_access_key|amazon_secret_access_key|amazonaws|ansible_vault_password|aos_key|api_key|api_key_secret|api_key_sid|api_secret|api.googlemaps AIza|apidocs|apikey|apiSecret|app_debug|app_id|app_key|app_log_level|app_secret|appkey|appkeysecret|application_key|appsecret|appspot|auth_token|authorizationToken|authsecret|aws_access|aws_access_key_id|aws_bucket|aws_key|aws_secret|aws_secret_key|aws_token|AWSSecretKey|b2_app_key|bashrc password|bintray_apikey|bintray_gpg_password|bintray_key|bintraykey|bluemix_api_key|bluemix_pass|browserstack_access_key|bucket_password|bucketeer_aws_access_key_id|bucketeer_aws_secret_access_key|built_branch_deploy_key|bx_password|cache_driver|cache_s3_secret_key|cattle_access_key|cattle_secret_key|certificate_password|ci_deploy_password|client_secret|client_zpk_secret_key|clojars_password|cloud_api_key|cloud_watch_aws_access_key|cloudant_password|cloudflare_api_key|cloudflare_auth_key|cloudinary_api_secret|cloudinary_name|codecov_token|config|conn.login|connectionstring|consumer_key|consumer_secret|credentials|cypress_record_key|database_password|database_schema_test|datadog_api_key|datadog_app_key|db_password|db_server|db_username|dbpasswd|dbpassword|dbuser|deploy_password|digitalocean_ssh_key_body|digitalocean_ssh_key_ids|docker_hub_password|docker_key|docker_pass|docker_passwd|docker_password|apikey|dockerhub_password|dockerhubpassword|dot-files|dotfiles|droplet_travis_password|dynamoaccesskeyid|dynamosecretaccesskey|elastica_host|elastica_port|elasticsearch_password|encryption_key|encryption_password|heroku_api_key|sonatype_password|awssecretkey" "${base_dir}/js_files/" >> "${base_dir}/sensitive_info.txt"

    # echo "JavaScript scanning completed. Results are stored in ${base_dir}."
    rm -r "${base_dir}/js_files/"
}

# Run the JS scan function with the provided domain
scan_js "$1"
