echo -e "\e[33mInstalling Nginx\e[0m"
yum install nginx -y &>>temp/ngnix.log

echo -e "\e[33enabling ngnix and starting\e[0m"
systemctl enable nginx &>>temp/ngnix.log
systemctl start nginx &>>temp/ngnix.log

echo -e "\e[33mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>temp/ngnix.log

echo -e "\e[33mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>temp/ngnix.log

echo -e "\e[33mUnzipping files\e[0m"
cd /usr/share/nginx/html &>>temp/ngnix.log
unzip /tmp/frontend.zip  &>>temp/ngnix.log

echo -e "\e[33mCopying config file\e[0m"

cp DevOps\Shell\Roboshop-shell\roboshop.config  /etc/nginx/default.d/roboshop.conf &>>temp/ngnix.log


echo -e "\e[33mRestarting server\e[0m"
systemctl restart nginx &>>temp/ngnix.log