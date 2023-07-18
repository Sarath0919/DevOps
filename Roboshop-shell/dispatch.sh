source common.sh

echo -e "${color}Installing Golang${nocolor}"
yum install golang -y &>> ${log_file}

echo -e "${color}Adding user${nocolor}"
useradd roboshop &>> ${log_file}

echo -e "${color}Cleaning application folder${nocolor}"
rm -rf /app &>> ${log_file}
mkdir /app 

echo -e "${color}Downloading the content${nocolor}"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>> ${log_file}

echo -e "${color}Unzipping the content${nocolor}"
cd /app 
unzip /tmp/dispatch.zip &>> ${log_file}

echo -e "${color}IInstalling dependencies${nocolor}"
cd /app 
go mod init dispatch &>> ${log_file}
go get &>> ${log_file}
go build &>> ${log_file}

echo -e "${color}Copying systemd  service files${nocolor}"
cp /home/centos/DevOps/Roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>> ${log_file}

echo -e "${color}Enabling systemd service${nocolor}"
systemctl daemon-reload &>> ${log_file}
systemctl enable dispatch &>> ${log_file}
systemctl start dispatch &>> ${log_file}