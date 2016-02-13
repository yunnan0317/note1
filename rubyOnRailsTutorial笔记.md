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