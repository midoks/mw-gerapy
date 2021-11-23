# mw-gerapy
集成gerapy,管理爬虫


# 安装

```
curl https://raw.githubusercontent.com/midoks/mw-gerapy/main/scripts/install.sh | sh
```

# Debug

```
cd /www/server/mdserver-web/ && python3 /www/server/mdserver-web/plugins/gerapy/index.py start
```


# linux升级sqlite3
```
wget http://www.sqlite.org/2019/sqlite-autoconf-3280000.tar.gz

tar zxvf sqlite-autoconf-3280000.tar.gz -C /usr/src/
cd /usr/src/sqlite-autoconf-3280000/ && ./configure --prefix=/usr/local/sqlite && make && make install


mv /usr/bin/sqlite3 /usr/bin/sqlite3_old && cd /usr/local/sqlite/bin/ && ln -s sqlite3 /usr/bin/sqlite3


vim /etc/profile
export LD_LIBRARY_PATH="/usr/local/sqlite/lib"
source /etc/profile

```
