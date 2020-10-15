#! /bin/bash
echo -e "开始安装redis服务\n"
 
download_url=http://download.redis.io/releases/redis-4.0.2.tar.gz
file_name=${download_url##*/}
file_dir=${file_name%.tar.gz*}
 
cd /usr/local/src
 
if [ ! -f "/usr/local/src/${file_name}" ];then
    echo -e "包不存在 下载： "${download_url}
    wget ${download_url}
fi
 
tar -zxvf ${file_name}
 
rm -rf /usr/local/redis
mv ${file_dir} /usr/local/redis
 
cd /usr/local/redis && make && make install
 
echo -e "配置初始化脚本\n"
 
\cp /usr/local/redis/utils/redis_init_script /etc/init.d/redis
 
echo -e "创建目录/etc/redis\n"
 
if [ ! -d "/etc/redis" ]; then
    mkdir /etc/redis
fi
 
echo -e "创建目录/var/redis/6379\n"
 
if [ ! -d "/var/redis/6379" ]; then
    mkdir -p /var/redis/6379
fi
 
echo -e "复制配置文件到/etc/redis/6379.conf\n"
 
\cp /usr/local/redis/redis.conf /etc/redis/6379.conf
 
 
echo "daemonize yes" >> /etc/redis/6379.conf
echo "bind 0.0.0.0" >> /etc/redis/6379.conf
echo "pidfile /var/run/redis_6379.pid" >> /etc/redis/6379.conf
echo "port 6379" >> /etc/redis/6379.conf
echo "dir /var/redis/6379" >> /etc/redis/6379.conf
 
#echo "杀死旧redis进程\n"
#ps -ef|grep redis|grep -v grep|cut -c 9-15|xargs kill -9
#rm -rf /var/run/redis_6379.pid
 
echo -e "启动 /etc/init.d/redis start|stop"
/etc/init.d/redis start
