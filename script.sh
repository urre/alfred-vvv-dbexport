# Get arguments
line="{query}"

# Convert user input to array
arr=($line)

# Database and folder
folder=${arr[0]}
db=${arr[1]}

# User
username=$USER;

# Path to VVV Virtual Box Private key
privatekey=/Users/${username}/projects/vvv/.vagrant/machines/default/virtualbox/private_key

# IP address to VVV
ip=192.168.50.12

# Export selected database using WP-cli. If user has entered different names for folder and db name, use folder. Else use db name.
if [ -z "$folder" ]
then
	filename=${db}_`date '+%Y-%m-%d_%H-%M'`.sql
	ssh -i $privatekey vagrant@$ip  "cd /srv/www/$db/htdocs/ && wp db export /srv/www/$filename"
else
	filename=${folder}_`date '+%Y-%m-%d_%H-%M'`.sql
	ssh -i $privatekey vagrant@$ip  "cd /srv/www/$folder/htdocs/ && wp db export /srv/www/$filename"
fi

# Replace with your Dropbox user ID
dropboxuser=1162759

# Path to your Dropbox folder, I'm using my public folder
path=/users/${username}/dropbox/Public/

# Copy file to Dropbox
cp ~/projects/vvv/www/$filename $path

# Copy Dropbox public file link to clipboard. If you don't have the Public, folder
printf https://dl.dropboxusercontent.com/u/$dropboxuser/$filename | pbcopy

# Slack Settings (optional)
#USER="urre"
#CHANNEL="#general"
#TEXT="Here, download this dev database https://dl.dropboxusercontent.com/u/$dropboxuser/$filename"
#WEBHOOKURL="https://hooks.slack.com/services/*****************************************"

# Escape as JSON friendly test
#escapedText=$(echo $TEXT | sed 's/"/\"/g' | sed "s/'/\'/g" )

# JSON to send
#json="{\"channel\": \"$CHANNEL\", \"username\":\"$USER\", \"icon_emoji\":\":robot_face:\", \"attachments\":[{\"color\":\"good\" , \"author_name\":\"$SLACK_AUTHOR\" , \"color\":\"good\" ,\"text\": \"$escapedText\"}]}"

# Post to Slack
# curl -s -d "payload=$json" "$WEBHOOKURL"