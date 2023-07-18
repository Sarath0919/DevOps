source common.sh

echo -e "${color}Installing Redis Repo${nocolor}"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${log_file}

echo -e "${color}Enable Redis 6 version${nocolor}"
yum module enable redis:remi-6.2 -y &>> ${log_file}

echo -e "${color}Install Redis${nocolor}"
yum install redis -y  &>> ${log_file}

echo -e "${color}Changing Listner${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0" /etc/redis.conf /etc/redis/redis.conf &>> ${log_file}

echo -e "${color}Enabling systemd service${nocolor}"
systemctl enable redis  &>> ${log_file}
systemctl start redis &>> ${log_file}