# 一. 使用rvm安装与管理ruby
为了把所有的ruby版本都能够纳入rvm的同一管理, 因此首先要安装的就是rvm.

1. rvm安装ruby

    使用命令`rvm install 版本号`来安装指定版本的ruby

2. rvm管理ruby

    查看当前已安装ruby版本, 使用`rvm list`命令, 使用`rvm list known`可以查看当前可安装版本.

    使用命令`rvm use 版本号`来切换到相应版本号的ruby.

    也可以使用命令`rvm use 版本号 --default`来设定默认的版本.

    如果要使用系统中的ruby版本, 使用`rvm use system`来实现.需要注意的是, 系统自带的ruby虽然可以使用rvm管理,但是无法建立gemset, 为了把其纳入rvm的管理, 需要使用命令`rvm automount`将其加载到rvm中.

3. gemset

    不同的ruby版本可能对应一组不同的gem集合, rvm可以gemset来管理相应的集合, 避免出现兼容性问题. 用`rvm gemset create 软件名-版本号`来创建一个gemset, 然后使用`rmv 版本号@gemset名称`来绑定指定版本的ruby与这一组gemset.

# 二. 利用gems管理包
1. gems安装与卸载包

    用命令`gem install 软件名称 -v 软件版本`来安装指定名称和版本的gem包. 同样可以利用`gem uninstall 软件名称 -v 软件版本`来卸载制定名称和版本的包.

2. gems管理包

    可以用命令`gem list`来查看当前已安装的包.