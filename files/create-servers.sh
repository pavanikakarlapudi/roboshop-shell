Skip to content
Search or jump to…
Pull requests
Issues
Codespaces
Marketplace
Explore

@pavanikakarlapudi
raghudevopsb70
/
roboshop-shell
Public
Fork your own copy of raghudevopsb70/roboshop-shell
Code
Issues
Pull requests
Actions
Projects
Security
Insights
roboshop-shell/create-servers.sh
@r-devops
r-devops Create Servers script
Latest commit 76c8791 2 weeks ago
 History
 1 contributor
49 lines (39 sloc)  1.69 KB

#!/bin/bash

##### Change these values ###
ZONE_ID="Z0366464237Z7LZLZPKFA"
DOMAIN="devopsb70.online"
SG_NAME="allow-all"
env=dev
#############################



create_ec2() {
  PRIVATE_IP=$(aws ec2 run-instances \
      --image-id ${AMI_ID} \
      --instance-type t3.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}, {Key=Monitor,Value=yes}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]"  \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
      --security-group-ids ${SGID} \
      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" -e "s/DOMAIN/${DOMAIN}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Server Created - SUCCESS - DNS RECORD - ${COMPONENT}.${DOMAIN}"
  else
     echo "Server Created - FAILED - DNS RECORD - ${COMPONENT}.${DOMAIN}"
     exit 1
  fi
}


## Main Program
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
if [ -z "${AMI_ID}" ]; then
  echo "AMI_ID not found"
  exit 1
fi

SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')
if [ -z "${SGID}" ]; then
  echo "Given Security Group does not exit"
  exit 1
fi


for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch; do
  COMPONENT="${component}-${env}"
  create_ec2
done
Footer
© 2023 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
roboshop-shell/create-servers.sh at main · raghudevopsb70/roboshop-shell