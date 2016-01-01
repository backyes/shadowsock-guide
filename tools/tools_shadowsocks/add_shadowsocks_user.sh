#!/bin/sh

set -x 

passwd=$1
comment=$2

script_dir=$(cd "$(dirname "$0")"; pwd)
echo $script_dir

if [ -z "$passwd" -o -z "$comment" ]; then 
   echo "usage: sh add_shadowsocks_user.sh <passwd> <commment>"
   exit 1
fi

shadowsocks_dir="$script_dir/shadowsocks-2.8.2"
shadowsocks_bin="$shadowsocks_dir/shadowsocks/server.py"
shadowsocks_config="$shadowsocks_dir/server-multi-passwd.json"
port_file="$script_dir/shadowsocksport.lock"
if [ ! -f "$port_file" ]; then 
   echo "no port.lock, set start port in port.lock"
   exit 1 
fi
output_configuration="$script_dir/output_config.conf"

start_port=`cat $port_file`

exist_user=`cat $shadowsocks_config | grep -e $comment`
if [ -n "$exist_user" ]; then 
   echo "add failed: user exist!" 
   exit 1 
fi 

port=$(($start_port+1))
#add passwd
sed -i "/\"9193\": \"shadowsocks\"/i\ \ \ \ \ \ \ \ \""$port"\": \""$passwd"\"," $shadowsocks_config
#add comments
sed -i "/\"9193\": \"comments_shadowsocks\"/i\ \ \ \ \ \ \ \ \""$port"\": \""$comment"\"," $shadowsocks_config

echo $port > $port_file
echo "server ip:" `ifconfig venet0:0 | grep "inet addr" |awk '{print $2}' | sed 's/addr://g'`  > $output_configuration
echo "port:" $port >> $output_configuration
echo "passwd:" $passwd  >> $output_configuration
echo "comment/user:" $comment >> $output_configuration
 


server_pid=`ps uxa | grep shadowsocks/server.py | grep -v grep | awk '{print $2}'`
if [ -n "$server_pid" ]; then 
   echo "to kil server !"
   kill -9 $server_pid 
fi 

echo "re-run shadowsocks"
python $shadowsocks_bin -c $shadowsocks_config

