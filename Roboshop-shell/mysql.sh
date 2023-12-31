source common.sh

echo -e "${color}Disabling default version mysql ${nocolor}"
yum module disable mysql -y &>> ${log_file}
start_check $?

echo -e "${color}Copying repo file${nocolor}"
cp /home/centos/DevOps/Roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> ${log_file}
start_check $?

echo -e "${color}Installing Mysql community server${nocolor}"
yum install mysql-community-server -y &>> ${log_file}
start_check $?

echo -e "${color}Enabling systemd service${nocolor}"
systemctl enable mysqld &>> ${log_file}
systemctl start mysqld &>> ${log_file}
start_check $?

echo -e "${color}Settingup user pwd${nocolor}"
mysql_secure_installation --set-root-pass RoboShop@1 &>> ${log_file}
start_check $?

