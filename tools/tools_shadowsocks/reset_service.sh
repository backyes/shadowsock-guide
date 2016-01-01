#!/bin/sh 

echo  "9193" > ./shadowsocksport.lock
cp  shadowsocks-2.8.2/server-multi-passwd.json.init shadowsocks-2.8.2/server-multi-passwd.json
