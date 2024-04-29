#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
echo " please enter DB password "
read -s mysql_root_password

VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo "$2..FAILURE"
    else
    echo "$2 ..SUCCESS"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "please run the script with root access"
    else
    echo "you are root user "
fi
dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql server"

# mysql_secure_installation --set-root-pass ExpenseApp@1
# VALIDATE $? "Setting up root password"

mysql -h db.praveenmech.online -uroot -p${mysql_root_password} -e 'show databases;' &>>LOGFILE

if [ echo $? -ne 0 ]
then
mysql_secure_installation --set-root-pass ${mysql_root_password}
VALIDATE $? " mysql password setup "
else
    echo " MySQL Root password is already setup ...SKIPPING "
fi


