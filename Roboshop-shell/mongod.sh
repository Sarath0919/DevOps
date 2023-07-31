source common.sh
component="mongodb"

echo -e "${color}Copying Repo file${nocolor}"
cp /home/centos/DevOps/Roboshop-shell/mongod.repo /etc/yum.repos.d/mongo.repo
start_check $?

echo -e "${color}Installing mongod server${nocolor}"
yum install mongodb-org -y &>> ${log_file}
start_check $?

echo -e "${color}Enabling mongod and starting${nocolor}"
systemctl enable mongod &>> ${log_file}
systemctl start mongod &>> ${log_file}
start_check $?

echo -e "${color}Changing listner${nocolor}"
cd /
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf &>> ${log_file}
start_check $?

echo -e "${color}Restarting server${nocolor}"
systemctl restart mongod &>> ${log_file}
start_check $?