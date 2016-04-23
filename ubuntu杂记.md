为了折腾shadowsock自动启动, 研究一下ubuntu的启动机制.

1. 添加一个开机启动的脚本. 首先将脚本复制或者软连接到/etc/init.d/目录下, 然后用`update-rc.d filename defaults NN`命令. 其中filename表示要启动脚本的文件名, NN为启动顺序. 值得注意的有两点: 一是如果脚本要用到网络, NN则需要设置一个较大的数值(如98), 二是脚本中的shell命令需要用绝对地址.

为了把shadowsocks加入启动服务, 首先编写了一个shadowsocks.sh文件, 内容为启动服务的代码`sslocal -s 23.83.231.233 -8387 -l 1080 -k 6312139 -t 600`, 但是出现了无法重启关机的情况. 原来是没有指定停止服务的方法, 网上抄了一段

    #!/bin/sh
    start(){
      /usr/local/bin/sslocal -s 23.83.231.233 -p 8387 -l 1080 -k 6312139 -t 600
    }

    stop(){
      ssserver -d stop
    }
    case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    reload)
        stop
        start
        ;;
    *)
        echo "usage: $0 {start | reload |stop}"
        exit 1
        ;;
    esac


恢复正常.

2. 直接用编辑器编辑/etc/rc.local文件


想查看一下现在使用的什么桌面`update-alternatives --display x-session-manager`
