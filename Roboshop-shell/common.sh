log_file="/tmp/roboshop.log"
color="\e[35m"
nocolor="\e[0m"
app_path="/app"

app_presetup(){

    echo -e "${color}Adding User${nocolor}"
    useradd roboshop

    echo -e "${color}Creating application directory${nocolor}"
    rm -rf /app &>> ${log_file}
    mkdir ${app_path} 

    echo -e "${color}Downloading Catalogue content${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>> ${log_file}

    echo -e "${color}Extracting content${nocolor}"
    cd ${app_path} 
    unzip /tmp/${component}.zip &>> ${log_file}
}

systemd_setup() {
    echo -e "${color}Copying setup systemd service ${nocolor}"
    cp /home/centos/DevOps/Roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>> ${log_file}

    echo -e "${color}Start ${component} service${nocolor}"
    systemctl daemon-reload &>> ${log_file}
    systemctl enable ${component}  &>> ${log_file}
    systemctl start ${component} &>> ${log_file}
}

nodejs() {
    echo -e "${color}Downloading Nodejs${nocolor}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_file}

    echo -e "${color}Installing Nodejs${nocolor}"
    yum install nodejs -y &>> ${log_file}

    app_presetup

    echo -e "${color}Installing Nodejs Dependencies${nocolor}"
    cd ${app_path} 
    npm install &>> ${log_file}

    systemd_setup
}


mongo_schema_setup() {
    echo -e "${color}Copying Mongo repo file${nocolor}"
    cp /home/centos/DevOps/Roboshop-shell/mongod.repo /etc/yum.repos.d/mongo.repo &>> ${log_file}

    echo -e "${color}Installing Mongodb client${nocolor}"
    yum install mongodb-org-shell -y &>> ${log_file}

    echo -e "${color}Load Schema${nocolor}"
    mongo --host mongodb-dev.sarathjakkula.cloud <${app_path}/schema/${component}.js &>> ${log_file}
}

mysql_schema_setup() {
    echo -e "${color}Installing Mysql client${nocolor}"
    yum install mysql -y &>> ${log_file}

    echo -e "${color}Loading Schema${nocolor}"
    mysql -h mysql-dev.sarathjakkula.cloud -uroot -pRoboShop@1 <${app_path}/schema/${component}.sql &>> ${log_file}

}

maven() {
    echo -e "${color}Installing Maven${nocolor}"
    yum install maven -y &>> ${log_file}

    app_presetup 

    echo -e "${color}Downloading Maven dependencie${nocolor}"
    mvn clean package &>> ${log_file}
    mv target/${component}-1.0.jar ${component}.jar  &>> ${log_file}

    mysql_schema_setup

    systemd_setup
}

golang() {
    echo -e "${color}Installing Golang${nocolor}"
    yum install golang -y &>> ${log_file}

    app_presetup

    echo -e "${color}IInstalling dependencies${nocolor}"
    cd ${app_path} 
    go mod init dispatch &>> ${log_file}
    go get &>> ${log_file}
    go build &>> ${log_file}

}

python3() {
    echo -e "${color}Installing Python 3${nocolor}"
    yum install python36 gcc python3-devel -y &>> ${log_file}

    app_presetup

    echo -e "${color}Installing python requirements${nocolor}"
    cd ${app_path} 
    pip3.6 install -r requirements.txt &>> ${log_file}

    systemd_setup
}