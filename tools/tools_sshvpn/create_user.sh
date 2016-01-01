#!/usr/bin

user_name=$1
user_passwd=$2

if [ -z "$user_name" -o -z "$user_passwd" ]; then 
   echo "error: user name, or user_passwd" 
   exit 1
fi

exist_name=`cut -d : -f 1 /etc/passwd | grep $1`
if [ -n "$exist_name" ]; then 
   echo "error: user exist!" 
   exit 1
fi

useradd -g sshvpn -d /home/sshvpn -s /bin/false $user_name
echo "$user_name:$user_passwd" | chpasswd 
