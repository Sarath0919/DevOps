source common.sh
component="payment"

roboshop_app_pwd=$1

if [-z "$roboshop_app_pwd"]; then
    echo  password is required
    exit 1
fi
python3