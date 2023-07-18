source common.sh

echo -e "${color}Downloading RabbitMq repo${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${log_file}

echo -e "${color}Configuring Repo RabbitMq${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> ${log_file}

echo -e "${color}Installing RabbitMq${nocolor}"
yum install rabbitmq-server -y &>> ${log_file}

echo -e "${color}Enabling systemd service${nocolor}"
systemctl enable rabbitmq-server &>> ${log_file}
systemctl start rabbitmq-server &>> ${log_file}

echo -e "${color}Adding RabbitMq Application user${nocolor}"
rabbitmqctl add_user roboshop roboshop123 &>> ${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${log_file}
