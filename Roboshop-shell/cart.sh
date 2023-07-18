source common.sh
component="cart"

echo -e "${color}Downloading Nodejs${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_file}

echo -e "${color}Installing Nodejs${nocolor}"
yum install nodejs -y &>> ${log_file}

echo -e "${color}Adding cart${nocolor}"
cartadd roboshop

echo -e "${color}Creating application directory${nocolor}"
rm -rf /app &>> ${log_file}
mkdir ${app_path} 

echo -e "${color}Downloading cart content${nocolor}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>> ${log_file}

echo -e "${color}Extracting content${nocolor}"
cd ${app_path} 
unzip /tmp/${component}.zip &>> ${log_file}


echo -e "${color}Installing Nodejs Dependencies${nocolor}"
cd ${app_path} 
npm install &>> ${log_file}

echo -e "${color}Copying setup systemd service ${nocolor}"
cp /home/centos/DevOps/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>> ${log_file}

echo -e "${color}Start cart service${nocolor}"
systemctl daemon-reload &>> ${log_file}
systemctl enable ${component}  &>> ${log_file}
systemctl start ${component} &>> ${log_file}
