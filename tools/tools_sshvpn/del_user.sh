#!/usr/bin

user_name=$1

if [ -z "$user_name" ]; then 
   echo "error: user name" 
   exit 1
fi

exist_name=`cut -d : -f 1 /etc/passwd | grep $1`
if [ -z "$exist_name" ]; then 
   echo "error: user non exist!" 
   exit 1
fi

userdel $user_name
