source common.sh
component="frontend"

echo -e "${color}Installing Nginx${nocolor}"
yum install nginx -y &>> ${log_file}

echo -e "${color}Enabling ngnix and starting${nocolor}"
systemctl enable nginx &>> ${log_file}
systemctl start nginx &>> ${log_file}

echo -e "${color}Removing old content${nocolor}"
rm -rf /usr/share/nginx/html/* &>> ${log_file}

echo -e "${color}Downloading ${component} content${nocolor}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log_file}

echo -e "${color}Unzipping files${nocolor}"
cd /usr/share/nginx/html &>> ${log_file}
unzip /tmp/${component}.zip  &>> ${log_file}

echo -e "${color}Copying config file${nocolor}"

cp /home/centos/DevOps/Roboshop-shell/roboshop.config  /etc/nginx/default.d/roboshop.conf &>> ${log_file}


echo -e "${color}Restarting server${nocolor}"
systemctl restart nginx &>>${log_file}