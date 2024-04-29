USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
echo " please enter Db password"
read -s mysql_root_password
if [ $USERID -ne 0]
then
    echo "please run the script with root access"
else
    echo " you are root user "
fi
VALIDATE (){
    if [ $1 -ne 0 ]
    then
        echo "$2 ..FAilure"
    else
        echo "$2 ..Success "
    fi
}
dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs "

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? " Enabling nodejs "

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs "

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
else
    echo "user expense already exists"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating new folder app"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "downloading backend file"

cd /app

rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code"

npm install &>>$LOGFILE
VALIDATE $? "Installing app"

cp /root/expenseshell-project/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copying backend service to system"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Reloading Daemon"

systemctl start backend &>>$LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing Mysql"

mysql -h db.praveenmech.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "schema loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "restarting backend"






