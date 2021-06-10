# display usage if the script is not run as root user 
echo "ENSURE YOUR API KEY is valid for host :" `curl -s ifconfig.me`
echo "Paste in your PROJECT ID to enable this host"

read GROUPID

if [ ${#GROUPID} -ne 24 ]; then echo "Invalid PROJECT ID Length" ; exit
fi


echo "Paste in your AGENT key to enable this host"

read AGENTKEY

if [ ${#AGENTKEY} -ne 56 ]; then echo "Invalid Key Length" ; exit
fi

echo "Registering Agent with Cloud Manager" 
sleep 30

sudo sed -i  "s#mmsGroupId=.*#mmsGroupId=${GROUPID}#" /etc/mongodb-mms/automation-agent.config
sudo sed -i  "s#mmsApiKey=.*#mmsApiKey=${AGENTKEY}#" /etc/mongodb-mms/automation-agent.config
sudo /sbin/service mongodb-mms-automation-agent restart
sudo systemctl disable mongod
sudo systemctl enable mongodb-mms-automation-agent

echo "Installing and configuring mongocli - Command line too to talk to the APIs"
sudo yum install -y mongocli

mongocli config  
sed -i  's/"cloud"/"cloud-manager"/' /home/ec2-user/.config/mongocli.toml
cd /home/ec2-user/OA610-Benchmarking

mongocli cm security enable MONGODB-CR SCRAM-SHA-256

mongocli cm dbuser create -u perftester -p P3rfTester --role "root@admin"
mongocli cm monitoring enable `hostname -f`

cp template.json config.json
MYNAME=`hostname -f`
sed -i  "s/HOSTNAME/$MYNAME/" config.json
mongocli cm cluster create -f config.json




