source common.sh

echo -e "${color}Disabling default version mysql ${nocolor}"
yum module disable mysql -y &>> ${log_file}

echo -e "${color}Copying repo file${nocolor}"
cp /home/centos/Roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> ${log_file}

echo -e "${color}Installing Mysql community server${nocolor}"
yum install mysql-community-server -y &>> ${log_file}

echo -e "${color}Enabling systemd service${nocolor}"
systemctl enable mysqld &>> ${log_file}
systemctl start mysqld &>> ${log_file}
  
echo -e "${color}Settingup user pwd${nocolor}"
mysql_secure_installation --set-root-pass RoboShop@1 &>> ${log_file}


