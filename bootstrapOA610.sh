cd /tmp
sudo rm -rf /data
sudo mkdir /data
sudo mkfs.xfs /dev/sdb
sudo mount /dev/sdb /data
grep -q /dev/sdb /etc/fstab || echo "/dev/sdb       /data          xfs     defaults,noatime   1  1" | sudo tee --append /etc/fstab
curl -OL https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager-latest.x86_64.rhel7.rpm

sudo rpm -U mongodb-mms-automation-agent-manager-latest.x86_64.rhel7.rpm
sudo chown mongod:mongod /data

