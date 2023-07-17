echo -e "\e[33mInstalling Nginx\e[0m"
yum install nginx -y &>> /tmp/ngnix.log

echo -e "\e[33menabling ngnix and starting\e[0m"
systemctl enable nginx &>> /tmp/ngnix.log
systemctl start nginx &>> /tmp/ngnix.log

echo -e "\e[33mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/* &>> /tmp/ngnix.log

echo -e "\e[33mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> /tmp/ngnix.log

echo -e "\e[33mUnzipping files\e[0m"
cd /usr/share/nginx/html &>> /tmp/ngnix.log
unzip /tmp/frontend.zip  &>> /tmp/ngnix.log

echo -e "\e[33mCopying config file\e[0m"

cp DevOps\Shell\Roboshop-shell\roboshop.config  /etc/nginx/default.d/roboshop.conf &>> /tmp/ngnix.log


echo -e "\e[33mRestarting server\e[0m"
systemctl restart nginx &>>/tmp/ngnix.log