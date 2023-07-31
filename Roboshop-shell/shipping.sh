source common.sh
component="shipping"

mysql_root_pwd=$1

if [-z "$mysql_root_pwd"]; then
    echo Mysql password is required
    exit 1
fi

maven
