log_file="/tmp/roboshop.log"
color="\e[35m"
nocolor="\e[0m"
app_path="/app"

user_id=$(id -u)

if [ $user_id -ne 0 ]; then
    echo Script should be running with sudo
    exit 1
fi

start_check() {
    if [ $1 -eq 0 ]; then
       echo SUCCESS
    else
       echo FAILURE
       exit 1
    fi
}

app_presetup(){

    echo -e "${color}Adding User${nocolor}"
    id roboshop &>> ${log_file}

    if [ $? -eq 1 ]; then 
       useradd roboshop &>> ${log_file}
    fi
    start_check $?

    echo -e "${color}Creating application directory${nocolor}"
    rm -rf /app &>> ${log_file}
    mkdir ${app_path}
    
    start_check $?

    echo -e "${color}Downloading Catalogue content${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>> ${log_file}
    start_check $?

    echo -e "${color}Extracting content${nocolor}"
    cd ${app_path} 
    unzip /tmp/${component}.zip &>> ${log_file}
    start_check $?
}

systemd_setup() {
    echo -e "${color}Copying setup systemd service ${nocolor}"
    cp /home/centos/DevOps/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>> ${log_file}
    sed -i -e "s/roboshop_app_pwd/$roboshop_app_pwd/" /etc/systemd/system/${component}.service &>> ${log_file}
    start_check $?

    echo -e "${color}Start ${component} service${nocolor}"
    systemctl daemon-reload &>> ${log_file}
    systemctl enable ${component}  &>> ${log_file}
    systemctl start ${component} &>> ${log_file}
    start_check $?
}

nodejs() {
    echo -e "${color}Downloading Nodejs${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_file}
    start_check $?

    echo -e "${color}Installing Nodejs${nocolor}"
    yum install nodejs -y &>> ${log_file}
    start_check $?

    app_presetup

    echo -e "${color}Installing Nodejs Dependencies${nocolor}"
    cd ${app_path} 
    npm install &>> ${log_file}
    start_check $?

    systemd_setup
}


mongo_schema_setup() {
    echo -e "${color}Copying Mongo repo file${nocolor}"
    cp /home/centos/DevOps/Roboshop-shell/mongod.repo /etc/yum.repos.d/mongo.repo &>> ${log_file}
    start_check $?

    echo -e "${color}Installing Mongodb client${nocolor}"
    yum install mongodb-org-shell -y &>> ${log_file}
    start_check $?

    echo -e "${color}Load Schema${nocolor}"
    mongo --host mongodb-dev.sarathjakkula.cloud <${app_path}/schema/${component}.js &>> ${log_file}
    start_check $?
}

mysql_schema_setup() {
    echo -e "${color}Installing Mysql client${nocolor}"
    yum install mysql -y &>> ${log_file}
    start_check $?

    echo -e "${color}Loading Schema${nocolor}"
    mysql -h mysql-dev.sarathjakkula.cloud -uroot -p${mysql_root_pwd} <${app_path}/schema/${component}.sql &>> ${log_file}
    start_check $?

}

maven() {
    echo -e "${color}Installing Maven${nocolor}"
    yum install maven -y &>> ${log_file}
    start_check $?

    app_presetup 

    echo -e "${color}Downloading Maven dependencie${nocolor}"
    mvn clean package &>> ${log_file}
    mv target/${component}-1.0.jar ${component}.jar  &>> ${log_file}
    start_check $?

    mysql_schema_setup

    systemd_setup
}

golang() {
    echo -e "${color}Installing Golang${nocolor}"
    yum install golang -y &>> ${log_file}
    start_check $?

    app_presetup

    echo -e "${color}IInstalling dependencies${nocolor}"
    cd ${app_path} 
    go mod init dispatch &>> ${log_file}
    go get &>> ${log_file}
    go build &>> ${log_file}
    start_check $?

}

python3() {
    echo -e "${color}Installing Python 3${nocolor}"
    yum install python36 gcc python3-devel -y &>> ${log_file}
    start_check $?

    app_presetup

    echo -e "${color}Installing python requirements${nocolor}"
    cd ${app_path} 
    pip3.6 install -r requirements.txt &>> ${log_file}
    start_check $?

    systemd_setup
}