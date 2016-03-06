# -*- coding: utf-8 -*-
# 3.1 创建演示应用

1. 创建新引用

        # 选择4.2.0创建新应用
        rails _4.2.0_ new sample_app

2. 编辑gemfile

        srouce 'https://ruby.taobao.org/'
        gem 'rails', '4.2.0'
        gem 'sass-rails', '5.0.0.beta1'
        gem 'uglifier', '2.5.3'
        gem 'coffee-rails', '4.1.0'
        gem 'jquery-rails', '4.0.0.beta2'
        gem 'turbolinks', '2.3.0'
        gem 'jbuilder', '2.2.3'
        gem 'sdoc', '0.4.0', group: :doc
        group :development, :test do
          gem 'squlite3', '1.3.9'
          gem 'byebug', '3.4.0'
          gem 'web-console', '2.0.0.beta3'
          gem 'spring', '1.1.3'
        end
        group :test do
          gem 'minitest-reporters', '1.0.5'
          gem 'mini_backstrace', '0.1.3'
          gem 'guard-minitest', '2.3.1'
        end
        group :production do
          gem 'pg', '0.17.1'
          gem 'rails_12factor', '0.0.2'
        end

3. 更新gem包

        bundle install --without production

4. 初始git仓库

        git init
        git add -A
        git commit -m "Initialize reopo"

5. 首次推送
  
        git remote add origin git@github.com:yunnan0317/app_name.git
        git push -u origin --all

# 3.2 静态页面

        # 切换到分支
        git checkout master
        git checkout -b static-pages

## 3.2.1 生成静态页面

        # 约定控制器命名采用驼峰式
        rails generate controller StaticPages home help
        # 推送到static-pages分支
        git add -A
        git commit -m "Add a Static Pages controller"
        git push -u origin static-pages
        # 如果生成错误的控制器, 可以撤销.
        rails destroy controller StaticPages home help
        # 同样的, 错误的模型也可以撤销.
        rails generate model User name:string email:string
        rails destroy model User
        # 再同样, 错误的数据迁移可以撤销
        bundle exec rake db:migrate
        bundle exec rake db:rollback
        bundle exec rake db:migrate VERSION=0

生成控制器时, rails自动生成了他们的路由文件.
## 3.2.2 修改静态页面中的内容
# 3.3 开始测试

什么时候测试

1. 和应用代码相比, 如果测试代码特别剪短, 倾向优先编写测试;

2. 如果对想实现的功能不是特别清楚, 倾向于先编写应用代码, 然后再编写测试, 改进实现的方法;

3. 安全是头等大事, 保险起见, 要为安全相关的功能先编写测试;

4. 只要发现一个问题, 就编写测试重现这种问题, 以避免回归, 然后再编写应用代码修正问题;

5. 尽量不为以后可能修改的代码(例如HTML结构的细节)编写测试;

6. 重构之前要编写测试, 集中测试容易出错的代码.

在实际开发中, 根据上述方针, 我们一般先编写控制器和模型测试, 然后再编写集成测试(测试模型, 视图和控制器结合在一起时的表现). 如果应用代码很容易出错/经常变动(例如视图), 我们就完全不测试.

## 3.3.1 第一个测试

rails在生成控制器的时候就已经生成了一个测试, 可以从这个测试出发.

## 3.3.2 遇红

TDD流程是先编写一个失败测试, 通过修改代码使测试通过, 按需重构. 也就是"遇红 => 变绿 => 重构"的循环.

在控制器测试中加入如下代码

    require 'test_helper'
    class StaticPagesControllerTest < ActionController::TestCase
      ...
      test "should get about" do
        get :about
        assert_response :success
      end
    end

由于没有生成about页面的控制器, 因此这个测试会失败(遇红).

## 3.3.3 变绿

上节中失败测试的错误消息:

    ActionController::UrlGenerationError:
    No route matches {:action=>"about", :controller=>"static_pages"}

可见是缺少路由规则. 添加一个路由规则

    Rails.application.routes.draw do
      ...
      get 'static_pages/about'
      ...
    end

继续测试, 仍无法通过, 不过错误消息变了.

    AbstractController::ActionNotFound:
    The action 'about' could not be found for StaticPagesController

显然是控制器中缺少about动作, 在控制器中编写这个动作.

    class StaticPagesController < ApplicationController
      ...
      def about
      end
      ...
    end

测试依然失败, 不过消息又变了.

    ActionView::MissingTemplate: Missing template static_pages/about


这时由于缺少模板(视图)引起的, 新建一个视图, 保存在app/views/static_pages, 命名为about.html.erb

运行测试, 通过.

## 3.3.4 重构

# 3.4 有点动态的页面

## 3.4.1 测试标题(遇红)

一般网页的HTML结构

    <!DOCTYPE html>
    <html>
      <head>
        <title>Greeting</title>
      </head>
      <body>
        <p>Hello, world!</p>
      </body>
    </html>

在static_pages_controller_test中进行标题测试(遇红)

    require 'test_helper'
    class StaticPagesControllerTest < ActionController::TestCase
       test "should get home" do
         ...
         assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
       end
       test "should get help" do
         ...
         assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
       end
       test "should get about" do
         ...
         assert_select "title", "About | Ruby on Rails Tutorial Sample App"
       end
    end

## 3.4.2 添加页面标题(变绿)

以home页面为例,help和about界面也是同样的.

    <!DOCTYPE html>
    <html>
      <head>
        <title>Home | Ruby on Rails Tutorial Sample App</title>
      </head>
      <body>
        <h1>Sample App</h1>
        <p>
          This is the home pages for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.
        </p>
      </body>
    </html>


## 3.4.3 布局和嵌入式Ruby(重构)

重构的必要性
1. 页面的标题几乎是一模一样, 每个标题中都有个"Ruby on Rails Tutorial Sample App";
2. 整个HTML结构在每个页面都重复地出现了.

以home页面为例, 其他页面也相似.

    <% provide(:title, "Home") %>
    <!DOCTYPE html>
    <html>
      <head>
        <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
      </head>
      <body>
        <h1>Sample App</h1>
        <p>This is the home page for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.</p>
      </body>
    </html>

抽出相同结构构成模板.

    <!DOCTYPE html>
    <html>
      <head>
        <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
        <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolink-track' => true %>
        <%= javascript_include_tag 'application', 'data-turbolink-track' => true %>
        <%= csrf_meat_tags %>
      </head>
      <body>
        <%= yield %>
      </body>
    </html>

stylesheet\_link\_tag用于引入样式表, 而javascript\_include\_tag用于引入JavaScript文件, csrf\_meta\_tag用于避免"跨站请求伪造"(Corss-Site Requset Forgery).

相应的, 页面文件中不需要完整的HTML结构, 做出相应调整(仍以Home页面为例).

    <% provide(:title, "Home") %>
    <h1>Sample App</h1>
    <p>This is the home pages for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.</p>

## 3.4.4 设置根路由

将home设置为根路由

    Rails.applicationController.routes.draw do
      root 'static_pages#home'
      get 'static_pages/help'
      get 'static_pages/about'
    end

# 3.5 小结
# 3.6 练习

1. 加入通用标题的控制器测试

        class StaticPagesControllerTest < ActionController::TestCase
          def setup
            @base_title = "Ruby on Rails Tutorial Sample App"
          end
          testCase "should get home" do
            get :home
            assert_response :success
            assert_select "title", "Help | #{@base_title}"
          end
          ...
        end

2. 新建联系页面

# 3.7 高级测试技术

# 4.1 导言, 第一个辅助方法

app/helpers/application_helper.rb

    module ApplicationHelper
      # 根据所在页面返回完整的标题
      def full_title(page_title = '')
        base_title = "Ruby on Rails Tutorial Sample App"
        if page_title.empty?
          base_title
        else
          "#{page_title} | #{base_title}"
        end
      end
    end

这样的话需要简化布局.

    <title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
改成

    <title><%= full_title(yield(:title)) %></title>

# 5.1 添加一些结构
# 5.1.1 网站导航

为了保证IE的兼容性, 在布局文件的<head>标签中加入.

    <!--[if lt IE 9>
      <script src="//sdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js"></script>
    <![endif]-->

同时, 加入导航栏

    <body>
      <header class="navbar navbar-fixed-top navbar-inverse">
        <div class="container">
          <%= link_to "sample app", '#', id: "logo" %>
          <nav>
            <ul class="nav navbar-nav pull-right">
              <li><%= link_to "Home", '#' %></li>
              <li><%= link_to "Help", '#' %></li>
              <li><%= link_to "Login", '#' %></li>
            </ul>
          </nav>
        </div>
      </header>
      <div class="container">
        <%= yield %>
      </div>
    </body>

在首页中加入按钮

    <div class="center jumbotron">
      <h1>Welcome to the Sample App</h1>
      <h2>
        This is the home page for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.
      </h2>
      <%= link_to "Sign up now!", '#', class: "btn btn-lg btn-primary" %>
    </div>
    <%= link_to image_tag("rails.png", alt: "Rails log"), 'http://rubyonrails.org/' %>

## 5.1.2 引入Bootstrap和自定义的CSS

将bootstrap-sass-3.2.0.0添加到gemfile中

新建一个SCSS文件, 用custom.css.scss命名.

    @import "/bootstrap_home_path/bootstrap-sprockets";
    @import "/bootstrap_home_path/bootstrap";
    /* mixins, variables, etc. */
    $gray-medium-light: #eaeaea;
    /* universal 全局布局 */
    html {
      overflow-y: scroll;
    }
    body {
      padding-top: 60px;
    }
    section {
      overflow: auto;
    }
    textarea {
      resize: vertical;
    }
    .center {
      test-align: center;
      h1 {
        margin-bottom: 10px;
      }
    }
    /* typography */
    h1, h2, h3, h4, h5, h6 {
      line-height: 1;
    }
    h1 {
      font-size: 3em;
      letter-spacing: -2px;
      margin-bottom: 30px;
      text-align: center;
    }
    h2 {
      font-size: 1.2em;
      letter-spacing: -1px;
      margin-bottom: 30px;
      text-align: center;
      font-weight:normal;
      color: $gray-light;
    }
    p {
      font-size: 1.1em;
      line-height: 1.7em;
    }
    /* header */
    #logo {
      float:left;
      margin-right: 10px;
      font-size: 1.7em;
      color: white;
      text-transform: uppercase;
      letter-spacing: -1px;
      padding-top: 9px;
      font-weight: bold;
      &:hover {
        color: white;
        text-decoration: none;
      }
    }
    /* footer */
    footer {
      margin-top: 45px;
      padding-top: 5px;
      border-top: 1px solid $gray-medium-light;
      color: $gray-light;
      a {
        color: $gray;
        &:hover {
          color: $gray-darker;
        }
      }
      small {
        float: right;
        list-style: none;
        li {
          float: left;
          margin-left: 15px;
        }
      }
    }

# 5.3 布局中的链接

对于链接, 可以使用硬编码链接

    <a href="/static_pages/about">About</a>

Rails习惯使用具名路由制定链接地址

    <%= link_to "About", about_path %>

## 5.3.1 Contact页面
## 5.3.2 Rails路由

对于根路由, 可以使用"控制器名称#动作名称"定义

    root 'static_pages#home'

同样的原理, 可以为每个页面定义具名路由

    get 'help' => 'static_pages#help'

这样就可以在布局文件中使用具名路由.

## 5.3.3 使用具名路由

## 5.3.4 布局中的链接测试(集成测试)

1. 访问根路由(首页)
2. 确认使用正确的模板渲染
3. 检查指向首页, "帮助"页面, "关于"页面和"联系"页面的地址是否正确

        require 'test_helper'
        class SiteLayoutTest < ActionDispatch::IntegrationTest
          test "layout links" do
            get root_path
            asserttemplate 'static_pages/home'
            assert_select "a[href=?]", root_path, count:2
            assert_select "a[href=?]", help_path
            assert_select "a[href=?]", about_path
            assert_select "a[href=?]", contact_path
          end
        end

# 5.4 用户注册

## 5.4.1 用户控制器

新建用户控制器, 控制器为大写复数

    rails generate controller Users new

用户控制器测试


## 5.4.2 "注册"页面的URL

新建用户分配具名路由

    get 'signup' => 'users#new'

# 5.6 练习
1. 将css改写为scss
2. 在集成测试中使用get方法访问"注册"页面, 确认这个页面有正确的标题.
3. 测试辅助方法(在测试辅助文件中引入应用的辅助方法)

# 6.1 用户模型

新建分支

    git checkout -b modeling-users

## 6.1.1 数据库迁移

生成用户模型, 模型为大写单数, 控制器为大写复数

    rails generate model User name:string email:string

会自动生成迁移文件, 使用rake进行迁移, 使用db:rollback回滚

    bundle exec rake db:migrate

## 6.1.2 模型文件
## 6.1.3 创建用户对象
## 6.1.4 查找用户对象
## 6.1.5 更新用户对象
# 6.2 用户数据验证

## 6.2.1 有效性测试

模型验证是TDD的绝佳时机. 编写用户模型测试

    require 'test_helper'
    class UserTest < ActiveSupport::TestCase
      def setup
        @user = User.new(name: "Example User", email: "user@example.com")
      end
      test "should be valid" do
        assert @user.valid?
      end
    end

## 6.2.2 存在性测试

在测试中加入

    test "name should be present" do
      @user.name = "   "
      assert_not @user.valid?
    end

更改model/user来使验证通过

    class User < ActiveRecord::Base
      validates :name, presence: true
    end

同样的更改email

## 6.2.3 长度验证

添加长度验证测试

    test "name should not be too long" do
      @user.name = "a" * 51
      assert_not @user.valid?
    end
    test "email should not be too long" do
      @user.email = "a" * 256
      assert_not @user.valid?
    end

更改model/user来使验证通过

    class User < ActiveRecord::Base
      validates :name, presence: true, length: { maximum: 50}
      validates :email, presence: true, length: { maximum: 255}
    end

## 6.2.4 格式验证

增加email格式验证测试

    test "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.commit USER@foo.COM A_US@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"
      end
    end

更改model/user通过测试

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[z-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: {with: VALID_EMAIL_REGEX}

## 6.2.5 唯一性验证

加入email唯一性测试

    test "email addresses should be unique" do
      duplicate_user = @user.dup
      @user.save
      assert_not duplicate_user.valid?
    end

model/user中加入唯一性验证已通过测试

    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

测试唯一性不区分大小写

    test "email addresses should be unique" do
      duplicate_user = @user.dup
      duplicate_user.email = @user.email.upcase
      @user.save
      assert_not duplicate_user.valid?
    end

再次更改model/user来再次通过验证

    valadates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

但是存在一个问题, Active Record中的唯一性无法保证数据库中的唯一性, 为了解决这个问题, 在数据库中为email建立索引, 然后为索引加上唯一性限制.

    rails generate migration add_index_to_users_email

实现唯一性的数据迁移没有事先定义好的模板, 需要手动迁移

    calss AddIndexToUsersEmail < ActiveRecord::Migration
      def change
        add_index :users, :email, unique:true
      end
    end

然后迁移数据库

    bundle exec rake db:mirate

迁移会自动生成test/fixtrue可能会影响测试, 可以将内容注释掉.

有些数据库适配器的索引区分大小写, 为了保证电子邮件的唯一性, 统一使用小写形式, 使用"回调"(callback, 在Active Record对象生命周期的特定时刻调用), 我们此刻要用的是before_save(初步实现, 8.4会使用常用的"方法引用"定义回调).

    before_save { self.email = self.email.downcase }

# 6.3 添加安全密码

## 6.3.1 计算密码哈希值

rails中的安全密码机制由has_secure_password实现, 要求对应模型中有个名为password_digest的属性, 添加这个属性

     rails generate migration add_password_digest_to_users password_digest:string

生成这个migration会自动生成完整的迁移, 只需要

    bundle exec rake db:migrate

has\_secure\_password使用bcrypt哈希算法计算密码摘要, 为了在演示中使用bcrypt, 要把bcrypt gem添加到gemfile中.

## 6.3.2 用户有安全的密码

在用户模型中加入`has_scure_password`方法, 但是无法通过测试, 这时因为测试中却少`passwor`和`password_confirmation`这两个虚拟属性, 加入这两个属性后通过测试.

## 6.3.3 最短密码长度

加入最短密码测试

    test "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a" * 5
      assert_not @user.valid?
    end

在用户模型中加入`validate :password, length: { minimum: 6 }`, 测试通过.

## 6.3.4 创建并认证用户
# 6.4 小结

## 6.4.1 读完本章学到了什么

# 6.5 练习
1. 为上文的把电子邮件地址转换为小写编写测试(使用reload从数据库中读取)
2. 使用downcase!直接修改email来使数据库中确实使用小写保存, 进行测试
3. 避免出现连续点号, TDD.

# 7.1 显示用户的信息

## 7.1.1 调试信息和Rails环境

Rails内置的debug方法和params变量可以在各个页面显示一些对开发有用的帮助信息.

    <!DOCTYPE html>
    <html>
      ...
      <body>
        <%= render 'layouts/header' %>
        <div>
          <%= yield %>
          <%= render 'layouts/footer' %>
          # 添加调试器代码
          <%= debug(params) if Rails.env.development? %>
        </div>
      </body>
    </html>

加入调试器的美化样式

     @import "bootstrap-sprockets";
     @import "bootstrap";
     /* mixins, variables, etc. */
     $gray-medium-light: #eaeaea;
     @mixin box_sizing {
       -moz-box-sizing: border-box;
       -webkit-box-sizing: border-box;
       box-sizing: border-box;
     }
     ...
     /* miscellaneous */
     .debug_dump {
       clear: both;
       float: left;
       width: 100%;
       margin-top: 45px;
       @include box_sizing;
     }


## 7.1.2 用户资源

Rails遵从REST架构, 把数据视为资源可以创建, 显示, 更新和删除. Create => POST, Review => GET, Update => PATCH, Delete => DELETE, 对应HTTP标准中的操作.

为了告诉Rails资源的位置, 需要在路由文件中添加代码. resources :users不仅让对应路由可以访问, 还为用户资源提供了符合REST架构的所有动作.

    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#about'
      get 'contact' => 'static_pages#contact'
      get 'signup' => 'users#new'
      # 添加资源
      resources :users
    end

新建一个`show.html.erb`中就可以显示相关的页面.

     # 临时用户资料页面
     <%= @user.name %>, <%= @user.email %>

实例变量@user如何获得呢, 需要控制器从Users类中查询并赋值给@user

    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])
      end
      def new
      end
    end

 这样就也可以正常显示了.

## 7.1.3 调试器

Rails 4.2可以使用byebug gem来获取调试信息.

     class UsersController < ApplicationController
       def show
         @user =User.find(params[:id])
         # 添加代码使用byebug
         debugger
       end
     end

在访问/users/1时, 会在Rails服务器中的输出中显示byebug提示符, 可以调试.

## 7.1.4 Gravatar头像和侧边栏

为了显示头像, 先定义个gravatar_for的辅助方法, 返回指定用户的Gravatar头像, 然后在用户资料页面中调用这个辅助方法, 显示用户头像

    <% provide(:title, @user.name) %>
    <h1>
      <%= gravatar_for @user %>
      <%= @user.name %>
    </h1>

辅助方法的定义

    moule UsersHelper
      # 返回指定用户的Gravatar头像
      def gravatar_for(user)
        # MD5
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
        image_tag(gravatar_rul, alt: user.name, class: "gravatar")
      end
    end

在show动作的视图中添加一个左侧边栏来显示头像和用户名

    <% provide(:title, @user.name)%>
    <div>
      <aside class="col-md-4">
        <section class="user_info">
          <h1>
            <%= gravatar_for @user %>
            <%= user.name %>
          </h1>
        </section>
      </aside>
    </div>

为侧边栏添加样式

    /* sidebar */
    aside {
      section.user_info {
        margin-top: 20px;
      }
      section {
        padding: 10px 0;
        margin-top: 20px;
        &:first-child {
          border: 0;
          padding-top: 0;
        }
        span {
          display: block;
          margin-bottom: 3px;
          line-height: 1;
        }
        h1 {
          font-size: 1.4em;
          text-align: left;
          letter-spacing: -1px;
          margin-bottom: 3px;
          margin-top: 0px;
        }
      }
    }
    .gravatar {
      float: left;
      margin-right: 10px;
    }
    .gravatar_edit {
      margin-top: 15px;
    }

# 7.2　注册表单

更新资源可以使用update_attributes方法, 删除所有用户数据, 最简单的方法是使用db:migrate:reset命令

## 7.2.1 使用form_forgery

在用户控制器中添加

    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])
      end
      def new
        # 创建新用户, 并将其赋值给@user
        @user = User.new
      end
    end

在注册页面中添加表单

    <% provide(:title, @user.name) %>
    <h1>Sign up</h1>
    <div class="row">
      <div class="col-md-6 col-md-offset-3">
        <% form_for(@user) do |f| %>
          <%= f.label :name %>
          <%= f.text_field :name %>
          
          <%= f.label :email %>
          <%= f.text_field :email %>
          
          <%= f.label :passowrd %>
          <%= f.text_field :password %>
          
          <%= f.label :password_confirmation, "Confirmation" %>
          <%= f.text_field :password_confirmation %>
          
          <%= f.submit "Create my account", class: "btn btn-primary" %>
        <% end%>
      </div>
    </div>

注册表单的样式

    ...
    /* forms */
    input, textarea, select, .uneditable-input {
      border: 1px solid #bbb;
      width: 100%;
      margin-bottom: 15px;
      @include box-sizing;
    }
    input {
      height: auto !important;
    }

## 7.2.2 注册表单的HTML

# 7.3 注册失败

上一节中的页面不会显示错误消息, 注册失败没有提示. 这一节解决这个问题.

# 7.3.1 可正常使用的表单

        class UsersController < ApplicationController
          def show
            @user = User.find(params[:id])
          end
          def new
            @user=User.new
          end
          def create
            @user = User.new(params[:user]) # 不是最终实现方式
            if @user.save
              # 处理注册成功的方法
            else
              render 'new'
            end
          end
        end

这段代码可以工作, 但是存在安全性隐患, 使用params[:user]一次性更新@user的参数是不安全的.

# 7.3.2 健壮参数

把上节的代码稍作修改, 使其有健壮参数

    class UsersController < ApplicationController
      ...
      def create
        @user = User.new(user_params)
        if @user.save
          # 处理注册成功的方法
        else
          render 'new'
        end
      end
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end

# 7.3.3 注册失败的错误消息

    <% provide(:title, 'Sign up' %>
    <h1>Sign up</h1>
    <div class="row">
      <div class="col-md6 col-md-offset-3">
        <%= form_for(@user) do |f| %>
          # 渲染错误信息局部视图
          <%= render 'shared/error_messages' %>
          
          <%= f.label :name %>
          <%= f.text_field :name, class: 'form-control' %>
            
          <%= f.label :email %>
          <%= f.text_field :email, class: 'form-control' %>
          
          <%= f.label :password %>
          <%= f.text_field :password, class: 'form-control' %>
        
          <%= f.label :password_confirmation %>
          <%= f.text_field :passowrd_confirmation, class: 'form-control' %>
          <%= f.submit "Create my account", class: "btn btn-primary" %>
        <%= end %>
      </div>
    </div>

这里涉及到一个约定, 如果局部视图要在多个控制器中使用(上面的error_message), 则把它存在专门的shared/文件夹中. 局部视图的具体代码如下

     <% if @user.errors.any? %>
       <div id="error_explanation">
         <div class="alert alert-danger">
           The form contains <%= pluralize(@user.errors.count, "error") %>
         </div>
         <ul>
         <% @user.errors.full_message.each do |msg| %>
           <li><%= msg %></li>
         <% end %>
         </ul>
       </div>
     <% end %>

pluralize方法是用来保证单复数正确的方法. 调整一下错误消息的样式

    ...
    /* forms */
    ...
    #error_explanation {
      color: red;
      ul {
        color: red;
        margin: 0 0 30px 0;
      }
    }
    .field_with_errors {
      @extend .has-error;
      .form-control {
        color: $state-danger-text;
      }
    }

## 7.3.4 注册失败的测试

新建集成测试

    rails generate integration_test users_signup

测试内容

    require 'test_helper'
    class UsersSignupTest < ActionDispatch::IntegrationTest
      test "invalid signup information" do
        get signup_path
        assert_no_difference 'User.count' do
          post users_path, user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        end
        assert_template 'users/new'
      end
    end

注意assert\_no\_difference方法, 接受一个参数User.count, 取出当前用户数量, 之后执行代码块中的代码, 再检查User.count, 与之前取出的进行比较. assert_template测试注册失败后转向的template是否正确.

# 7.4 注册成功

## 7.4.1 完整的注册表单

现在要把控制器中注释的代码替换成可以执行的代码.

    class UsersController < ApplicationController
      ...
      def create
        @user = User.new(user_params)
        if @user.save
          redirect_to @users
        else
          render 'new'
        end
      end
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end

## 7.4.2 闪现消息

    
    class UsersController < ApplicationController
      ...
      def create
        @user = User.new(user_params)
        if @user.save
          # 加入闪现消息
          flash[:success] = "Welcome to the Sample App!"
          redirect_to @users
        else
          render 'new'
        end
      end
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end
如何在全部页面中闪现消息, 在模板中加入

    <% flash.each do |message_type, message| %>
      <div class="alert alert-<%= message_type %>"><%= message %></div>
    <% end %>

## 7.4.3 首次注册

## 7.4.4 注册成功的测试

    require 'test_helper'
    class UsersSignupTest < ActionDispatch::IntegrationTest
      ...
      test "valid signup information" do
        get signup_path
        name = "Example User"
        email = "user@example.com"
        password = "password"
        assert_difference "User.count", 1 do
          post_via_redirect users_path, user: {
            name: name,
            email:email,
            password: password,
            passowrd_confirmation: password
          }
        end
        assert_template 'users/show'
      end
    end

# 7.5 专业部署方案

# 7.6 小结

* Rails通过debug方法显示一些有用的调试信息
* Sass混入定义一组CSS规则, 可以多次使用
* Rails默认提供了三个标准环境: development, test, production
* 可以通过标准的REST URL和用户资源交互
* Gravatar提供了一种便捷的方法显示用户头像
* form_for方法用于创建与ActiveRecord交互的表单
* 注册失败后显示注册页面, 而且会显示由ActiveRecord自动生成的错误消息
* Rails提供了flash作为显示临时消息的标准方式
* 注册成功会在数据库中创建一个用户记录, 并会重定向到用户资料页面, 并显示一个欢迎消息
* 集成测试可以检查表单提交的表现, 并能捕获回归
* 可以配置在生产环境中使用SSL加密通信, 可以使用Unicorn提升性能.

# 7.7 练习

1. 重构gravatar_for方法, 使其能接受可选的size参数, 可以在视图中使用类似`gravatar_for user, size: 50`这样的代码.

2. 编写测试检查错误消息

3. 编写测试检查闪现消息

4. 使用content_tag辅助方法来简化错误消息代码

# 8.1 会话

  HTTP协议没有状态, 每个请求都是独立的事物, 无法使用之前请求中的信息. 所以在HTTP协议中无法在两个页面记住用户的身份. 需要用户登陆的应用都需要使用"会话"(session). 会话是两台电脑之间版永久性链接. 可以把会话看成符合REST架构的资源(与用户资源不同).

## 8.1.1 会话控制器

  登陆和退出功能由会话控制器中的相应动作处理, 登陆表单在new动作中处理, 登陆的过程是create动作发送POST请求, 退出则是destroy动作发送DELETE请求.
  首先, 要生成会话控制器

      rails generate controller Sessions new

  添加会话控制器的路由

        Rails.application.routes.draw do
          ...
          get 'login' => 'sessions#new'
          post 'login' => 'sessions#create'
          delete 'logout' => 'sessions#destroy'
        end

## 8.1.2 登陆表单

  定义好控制器和路由之后, 要编写新的会话视图, 也就是登陆表单.
  如果提交的登陆信息无效, 需要重新渲染登陆页面, 并显示一个错误消息. 与7.3.3节的错误消息不同, 那些消息是由ActiveRecord提供的, 而session不是ActiveRecord对象, 因此要使用flash渲染登陆时的错误消息.
  signup表单中使用`form_for`作为参数, 并且把用户实例变量@user传给`form_for`
      <%= form_for(@user) do |f| %>
        ...
      <% end %>

  login表单不同于signup表单, 因为session不是模型,`form_for(@user)`的作用是让表单向/users发起POST请求, 对于会话来说, 我们需要指明资源的名字以及影响的URL: `form_for(:session, url: login_path)`

    <% provide(:title, "Log in" %>
    <h1>Log in</h1>
    <div class="row">
      <div class="col-md-6 col-md-offset-3">
        <%= form_for(:session, url: login_path) do |f| %>
          <%= f.label :email %>
          <%= f.text_field :email %>
          <%= f.label :password %>
          <%= f.password_field :password %>
          <%= f.submit "Log in", class: "btn btn-primary" %>
        <% end %>
        <p>New user? <%= link_to "Sign up now!", signup_path %></p>
      </div>
    </div>

## 8.1.3 查找并认证用户

  和signup表单类似, login表单所提交的参数是一个嵌套hash, 具体而言, params包含了这些内容: `{ session: { password: "foobar", email: "user@exapmle"} }`

    class SessionsController < ApplicationController
      # 填写表单时的动作
      def new
      end
      # 提交表单时的动作
      def create
        user = User.find_by(email: params[:sessions][:email].downcase)
        if user && user.authenticate(params[:sessions][password])
          # 登陆之后动作
        else
          # 创建一个错误消息
          render 'new'
        end
      end
      # 退出时的动作
      def destroy
      end
    end

## 8.1.4 渲染闪现消息

  在signup模型验证中, 错误消息闪现关联在某个ActiveRecord对象上, 因为会话不是ActiveRecord模型, 不能使用这种方式了.

    class SessionsController < ApplicationController
      # 填写表单时的动作
      def new
      end
      # 提交表单时的动作
      def create
        user = User.find_by(email: params[:sessions][:email].downcase)
        if user && user.authenticate(params[:sessions][password])
          # 登陆之后动作
        else
          # falsh.now用于渲染当前页面的闪现信息
          flash.now[:danger] = "Invalid email/password combination"
          render 'new'
        end
      end
      # 退出时的动作
      def destroy
      end

    end

## 8.1.5 测试闪现消息

    rails generate integration_test user_login

基本测试步骤:

1. 访问登陆页面
2. 确认正确渲染了登陆表单
3. 提交无效的params哈希, 向登陆页面发起post请求
4. 确认重新渲染了登陆表单, 而且显示了一个闪现消息
5. 访问其他页面
6. 当前页面无闪现消息

        class UsersLoginTest < ActionDispatch::IntegrationTest
          test "login with invalid information" do
            get login_path
            assert_template 'sessions/new'
            post login_path, session: { email: "", password: "" }
            assert_template 'sessions/new'
            assert_not flash.empty?
            get root_path
            assert flash.empty?
          end
        end

# 8.2 登陆

在生成session控制器的时候, rails会自动生成一个辅助方法文件, 叫做SessionsHelper. 其中的辅助方法可以自动在引入rails视图, 如果在控制器基类ApplicationController中引入session辅助方法, 可以在控制器中使用辅助方法.

    class ApplicationController < ActionController::Base
      protext_from_forgery with: :exception
      # 引入session辅助方法
      include SessionsHelper
    end

## 8.2.1 log_in方法

    module SessionsHelper
      # 登入指定用户
      def log_in(user)
        session[:user_id] = user.id
      end
    end

session创建的临时cookie会自动加密, 所以上面的代码是安全的, 攻击者无法使用会话中的, 不过只有session方法创建的临时cookie是这样的, cookies方法创建的久cookie则有可能会受到"会话劫持".

使用log_in方法完成会话控制器中的create动作, 完成登入用户, 然后重定向到用户资料页面.

    class SessionsController < ApplicationController
       def new
       end

       def create
         user = User.find_by(email: params[:session][:email].downcase)
         if user && user.authenticate(params[:session][:password])
           log_in user
           redirect_to user
         else
           flash.now[:danger] = 'Invalid email/password combination'
           render 'new'
         end
       end

       def destroy
       end
    end

## 8.2.2 当前用户

目前已经把用户的ID安全的存储在临时会话中, 可以在后续请求中读取出来, 邀请已一个current_user的方法, 从数据库中取出用户ID对应的用户.
注意不能使用find方法, 因为如果用户ID不存在, find方法会抛出异常. 使用find_by方法不会跑出异常, 会返回nil

    module SesionsHelper
      # 登入指定用户
      def log_in(user)
        session[:user_id] = user.id
      end

      # 返回当前登陆的用户(如果有的话)
      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end

## 8.2.3 修改布局中的链接

首先需要定义logged_in?方法, 返回布尔值.

    module SesionsHelper
      # 登入指定用户
      def log_in(user)
        session[:user_id] = user.id
      end

      # 返回当前登陆的用户(如果有的话)
      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end

      # 如果用户已登陆, 返回true, 否则返回false
      def logged_in?
        !current_user.nil?
      end
    end

定义好了logged_in?方法后, 就可以修改布局中的链接了

    <header class="navbar navbar-fixed-top navbar-inverse">
        <div class="container">
            <%= link_to "sample app", root_path, id: "logo" %>
            <nav>
                <ul calss="nav navbar-nav pull-right">
                    <li><%= link_to "Home", root_path %></li>
                    <li><%= link_to "Help", help_path %></li>
                    <% if logged_in? %>
                      <li><%= link_to "Users", '#' %></li>
                      <li class="dropdown">
                          <a href="#" class="dropdown-toggle" data-toggle="dropdown">Account <b class="caret"></b>
                          </a>
                          <ul>
                              <li><%= link_to "Profile", current_user %></li>
                              <li><%= link_to "Settings", '#' %></li>
                              <li class="divider"></li>
                              <li>
                                  <%= link_to "Log out", logout_path, method: "delete" %>
                              </li>
                          </ul>
                      </li>
                    <% else %>
                      <li>
                          <%= link_to "Log in", login_path %>
                      </li>
                    <% end %>
                </ul>
            </nav>
        </div>
    </header>

为了实现下拉菜单效果, 需要引入Bootstrap JavaScript库. 注意要在引入bootstrap前引入jquery和jquery_ujs.

    //= require jquery
    //= require jquery_ujs
    //= require bootstrap
    //= require turbolinks
    //= require_tree .

## 8.2.4 测试布局中的变化

本节要测试登陆成功后布局的变化, 具体要求为:

1. 访问登陆页面
2. 通过post请求发送有效的登陆信息
3. 确认登陆链接消失了
4. 确认出现了退出链接
5. 确认出现了资料页面链接

要实现这样的测试, 在数据库中必须有一个用户, Rails默认使用fixtrue来实现这种需求, fixtrue是一种组织数据的方式, 这些数据会载入测试数据库.
密码叉腰使用bcrypt生成(通过`has_secure_pasword`方法), 所以固件中也使用这种方法生成. 可以查看安全密码的源码, 得到生成摘要的方法:`BCrypt::Password.create(string, cost: cost)`. 其中, string是要计算hash值的字符, cost是耗时因子. 耗时因子越大, hash值被破解的难度越大. 但在测试中, 希望digest方法执行越快越好, 因此安全密码的源码中还有这么一行: `cost = ActiveModel::SecurePassword.mini_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost`

定义fixtrue中使用的digest方法

    class User < ActiveRecord
      before_save { self.email = email.downcase }
      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX }
                        uniqueness: { case_sensitive: false }
      has_secure_password
      validates :password, length: { minimum: 6 }

      # 返回指定字符串的hash摘要
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
    end

测试用户登陆所需的fixtrue

    michael:
      name: Michael Example
      email: michael@example.com
      password_digest: <%= User.digest('password') %>

在创建了有效的fixtrue以后, 可以使用`user = users(:michael)`来获取这个用户. 虽然定义了`has_secure_password`需要的`password_digest`属性, 但有时需要密码的原始值, 但是在fixtrue中无法实现, 如果尝试添加password属性, Rails会提示数据库中没有这个列, 所以我们约定固件中所有用户的密码都一样, 即`password`. 接下来就可以编写测试了, 先测试使用有效信息登陆的情况.

    require 'test_helper'
    class UsersLoginTest < ActionDispatch::IntegrationTest

      def setup
        # 获取fixtrue中的测试用户信息
        @users = users(:michael)
      end

      ...

      test "login with valid information" do
        # 访问登陆页面
        get login_path
        # 使用fixtrue中的测试用户信息登陆
        post login_path, session: { email: @user.email, password: 'password' }
        # 测试登陆成功后是否转向用户页面
        assert_redirected_to @users
        # 访问重定向页面
        follow_redirect!
        # 测试是否渲染用户页面
        assert_template 'users/show'
        # 测试当前页面没有登陆链接
        assert_select "a[href=?]", login_path, count:0
        # 测试当前页面含有登出链接
        assert_select "a[href=?]", logout_path
        # 测试当前页面含有用户页面链接
        assert_select "a[href=?]", user_path(@user)
      end
    end

## 8.2.5 注册后直接登陆

之前的注册页面成功后没有登陆, 现在要实现注册后直接登陆的功能, 只需在用户控制器的create动作中调用log_in方法.

    class UsersController < ApplicationController
      def show
        @user = User.find(params[:id])
      end

      def new
        @user = User.new
      end

      def create
        @user = User.new(user_params)
        if @user.save
          # 注册成功后自动登陆
          log_in @user
          flash[:success] = "Welcome to the Sample App!"
          redirect_to @user
        else
          render 'new'
        end
      end

      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end

为了测试这个功能, 可以在test_helper中加入测试辅助方法`is_logged_in?`来测试

    ENV['RAILS_ENV'] ||= 'test'
    ...
    class ActiveSupport::TestCase
      firtures :all

      # 如果用户已登陆, 返回true
      def is_logged_in?
        !session[:user_id].nil?
      end
    end

然后, 可以在注册成功的测试中加入对用户是否登陆的测试

    require 'test_helper'

    class UserSignTest < ActionDispatch::IntegrationTest
      ...
      test "valid signup information" do
        # 访问注册页面
        get signup_path
        # 测试发送注册信息后已注册用户数量是否变化
        assert_difference 'User.count', 1 do
          post_via_redirect user_path, user: {
            name: "Example User",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password"
          }
        end
        # 测试注册成功后是否转向用户页面
        assert_template 'users/show'
        # 测试是否已经自动登陆
        assert is_logged_in?
      end
    end

# 8.3 退出
首先编写辅助方法log_out

    module SessionsHelper
      # 登入指定的用户
      def log_in(user)
        session[:user_id] = user.id
      end

      ...

      def log_out
        # 从session中删除用户
        session.delete(:user_id)
        # 清空current_user
        @current_user = nil
      end
    end

销毁会话, 退出用户

    class SessionsController < ApplicationController
      def new
      end

      def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
          log_in user
          redirect_to user
        else
          falsh.now[:danger] = 'Invalid email/password combination'
          render 'new'
        end
      end

      def destroy
        # 登出用户
        log_out
        # 重定向至根地址
        redirect_to root_url
      end
    end

加入测试退出的内容

    require 'test_helper'

    class UsersLoginTest < ActionDispatch::IntegrationTest

      ...

      test "login with valid information followed by logout" do
        get login_path
        post login_path, session: { email: @user.email, password: 'password'}
        assert is_logged_in?
        assert_redirected_to @user
        follow_redirect!
        assert_template 'users/show'
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)
        delete logout_path
        assert_not is_logged_in?
        assert_redirected_to root_url
        follow_redirect!
        assert_select "a[href=?]", login_path
        assert_select "a[href=?]", logout_path, count: 0
        assert_select "a[href=?]", user_path(@usere), count: 0
      end
    end
# 8.4 记住我
