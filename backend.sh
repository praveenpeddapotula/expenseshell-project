USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
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
}
dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs "

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? " Enabling nodejs "

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs "


