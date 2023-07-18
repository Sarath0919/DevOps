source common.sh

echo -e "${color}Installing Python 3${nocolor}"
yum install python36 gcc python3-devel -y &>> ${log_file}

echo -e "${color}Adding appliaction user${nocolor}"
useradd roboshop &>> ${log_file}

echo -e "${color}Creating application directory${nocolor}"
rm -rf /app &>> ${log_file}
mkdir /app 

echo -e "${color}Downloading Payment content${nocolor}"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>> ${log_file}

echo -e "${color}Unzippiing content${nocolor}"
cd /app 
unzip /tmp/payment.zip &>> ${log_file}

echo -e "${color}Installing python requirements${nocolor}"
cd /app 
pip3.6 install -r requirements.txt &>> ${log_file}

echo -e "${color}Copying service files${nocolor}"
cp /home/centos/Devops/Roboshop-shell/payment.service /etc/systemd/system/payment.service &>> ${log_file}

echo -e "${color}Enabling systemd service${nocolor}"
systemctl daemon-reload &>> ${log_file}
systemctl enable payment &>> ${log_file}
systemctl start payment &>> ${log_file}