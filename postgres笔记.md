# 安装

    sudo apt-get install postgresql


# 启动服务

    sudo systemctl start postgresql

# 开机自动启动服务

    sudo systemctl enable postgresql

# 添加新用户和数据库

## 方法一

    # 假设当前用户为dbuser
    # 切换到数据库管理员的Unix账号
    sudo su postgres
    # 登录数据库控制台
    psql
    # 为postgres用户设置密码
    \password postgres
    # 创建数据库用户dbuser, 设置密码
    CREATE USER dbuser WITH PASSWORD 'password';
    # 创建用户数据库userdatabase, 指定所有者为dbuser
    CREATE DATABSE exampledb OWNER dbuser;
    # 将所有权限赋给dbser;
    GRANT ALL PRIVILEGES ON DATABSE exampledb to dbuser;

## 方法二

    # 创建数据库用户dbuser, 并指定其为超级用户
    sudo -u postgres createuser --superuser dbuser
    # 登录数据库控制台, 设置dbuser密码
    sudo -u posgres psql
    \password dbuser
    \q
    # 创建数据库exampledb, 指定所有者为dbuser
    sudo -u postgres createdb -0 dbuser exampledb


# 启动contrib


    # 使用管理员账户在相应的表中开启extension
    sudo -u postgres psql -d dbname
    CREATE EXTENSION cube;
    \q
