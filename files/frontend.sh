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
roboshop-shell/frontend.sh
@r-devops
r-devops Update roboshop-shell/
Latest commit 7e18a97 2 weeks ago
 History
 1 contributor
34 lines (23 sloc)  751 Bytes

source common.sh

print_head "Install Nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "Remove Nginx Old Content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check


print_head "Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}

print_head "Extract Frontend Content"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "Copy RoboShop Nginx Config File"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "Enable Nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head "Start Nginx"
systemctl restart nginx &>>${LOG}
status_check


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
roboshop-shell/frontend.sh at main · raghudevopsb70/roboshop-shell