# 一. 安装
# 二. 设置
1. 全局设置

        # 设置用户名
        git config --global user.name "yunnan"
        # 设置邮箱地址
        git config --global user.email yunnan03172gmail.com
        # 设置编辑器
        git config --global core.editor "emacs -w"
        # 设置co为checkout的简写
        git config --global alias.co checkout
        # 设置br为branch的简写
        git config --global alias.br branch
        # 查看配置信息
        git config --global list

2. 创建ssh密钥

    a. 生成本地密钥

    密钥`id_dsa`和公约`id_pub`存放在`~/.ssh/`文件夹中, 如果不存在，使用下面的代码创建

        ssh-keygen -t rsa -C "yunnan0317@gmail.com"

    b. 在github中添加公钥
    
    登陆github账户, 进入Accout Seetings => SSH key => Add SSH key.
    c. 测试key是否正常

        ssh -T git@github

    d. 修改本地ssh remote url

        # 查看remote url
        git remote -v
	    # 设置remote url
        git remote set-url origin git@github.com:account_name/app_name.git

3. 在github上新建repo

4. 添加远程仓库

        git remote add origin git@github.com:yunnan0317/app_name.git
        git push -u origin --all


# 三. git常用命令

    # 创建并切换到分支
    git checkout -b branch_name
    # 切换分支
    git checkout branch_name
    # 把branch_name合并到当前分支
    git merge branch_name
    # 删除分支
    git branch -D branch_name
    # 放弃file_name的修改
    git checkout --file_name
    # 放弃工作区所有修改
    git checkout .
    # 删除文件file_name
    git rm file_name
    # 只从git删除, 保留在文件夹中
    git rm --cache file_name
    # 恢复某一次提交
    git revert $id
    # 回复上一次的提交状态
    git reset --hard
    # 撤销最后一次提交
    git commit --ammend