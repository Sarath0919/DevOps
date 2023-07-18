source common.sh


echo -e "${color}Installing Maven${nocolor}"
yum install maven -y &>> ${log_file}

echo -e "${color}Adding user${nocolor}"
useradd roboshop &>> ${log_file}

echo -e "${color}Creating app folder${nocolor}"
rm -rf /app
mkdir /app 

echo -e "${color}Downloading Shipping content${nocolor}"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>> ${log_file}
cd /app 

echo -e "${color}Unzipping content${nocolor}"
unzip /tmp/shipping.zip &>> ${log_file}
cd /app 

echo -e "${color}Downloading Maven dependencie${nocolor}"
mvn clean package &>> ${log_file}
mv target/shipping-1.0.jar shipping.jar  &>> ${log_file}


echo -e "${color}Installing Mysql client${nocolor}"
yum install mysql -y &>> ${log_file}

echo -e "${color}Loading Schema${nocolor}"
mysql -h mysql-dev.sarathjakkula.cloud -uroot -pRoboShop@1 </app/schema/shipping.sql &>> ${log_file}

echo -e "${color}Copying service file${nocolor}"
cp /home/centos/DevOps/Roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> ${log_file}

echo -e "${color}Enabling systemd service${nocolor}"
systemctl daemon-reload &>> ${log_file}
systemctl enable shipping &>> ${log_file}
systemctl start shipping &>> ${log_file}
