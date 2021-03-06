---
---
# -*- coding: utf-8 -*-
# 3.1 创建演示应用

1. 创建新引用

___代码清单3.1: 创建一个新应用___

``` shell
# 选择4.2.0创建新应用
rails _4.2.0_ new sample_app
```


2. 编辑gemfile

___代码清单3.2: 演示应用的Gemfile___

``` ruby
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
```

3. 更新gem包

``` shell
bundle install --without production
```



4. 初始git仓库

``` shell
git init
git add -A
git commit -m "Initialize reopo"
```

5. 首次推送

``` shell
git remote add origin git@github.com:yunnan0317/app_name.git
git push -u origin --all
```

___代码清单3.3: 更改ReadMe文件 略___

# 3.2 静态页面

``` shell
# 切换到分支
git checkout master
git checkout -b static-pages
```


## 3.2.1 生成静态页面

___代码清单3.4: 生成静态页面控制器___

``` shell
# 约定控制器命名采用驼峰式
rails generate controller StaticPages home help
```

关于一些撤销操作的方法

``` shell
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
```

生成控制器时, rails自动生成了他们的路由文件.

代码清单3.4生成的控制器会自动修改路由文件, 如代码清单3.5所示.

___代码清单3.5: 静态页面控制器中home和help动作的路由 config/routes.rb___

``` ruby
Rails.application.routes.draw do
    get 'static_pages/home'
    get 'static-pages/help'
    ...
end
```


___代码清单3.6: 代码清单3.4生成的静态页面控制器 app/controllers/static\_pages\_controller.rb___


``` ruby
class StaticPagesController < ApplicationController
  def home
  end

  def help
  end
end
```


___代码清单3.7: 为"首页"生成的视图 app/views/static\_pages/home.html.erb___

``` html+erb
<h1>StaticPages</h1>
<p>Find me in app/views/static_pages/home.html.erb</p>
```


___代码清单3.8: 为"帮助"页面生成的视图 app/views/static\_pages/help.html.erb___

``` html+erb
<h1>StaticPages#help</h1>
<p>Find me in app/views/static_pages/help.html.erb</p>
```


## 3.2.2 修改静态页面中的内容

___代码清单3.9: 修改首页的HTML app/views/static\_pages/home.html.erb___

___代码清单3.10: 修改帮助页面的HTML app/views/static\_pages/help.html.erb___


# 3.3 开始测试

什么时候测试

1. 和应用代码相比, 如果测试代码特别简短, 倾向优先编写测试;

2. 如果对想实现的功能不是特别清楚, 倾向于先编写应用代码, 然后再编写测试, 改进实现的方法;

3. 安全是头等大事, 保险起见, 要为安全相关的功能先编写测试;

4. 只要发现一个问题, 就编写测试重现这种问题, 以避免回归, 然后再编写应用代码修正问题;

5. 尽量不为以后可能修改的代码(例如HTML结构的细节)编写测试;

6. 重构之前要编写测试, 集中测试容易出错的代码.

在实际开发中, 根据上述方针, 我们一般先编写控制器和模型测试, 然后再编写集成测试(测试模型, 视图和控制器结合在一起时的表现). 如果应用代码很容易出错/经常变动(例如视图), 我们就完全不测试.

## 3.3.1 第一个测试

rails在生成控制器的时候就已经生成了一个测试, 可以从这个测试出发.

___代码清单3.11: 为静态页面控制器生成的测试 test/controllers/static\_pages\_controller\_test.rb___

``` ruby
require 'test\_helper'
class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_reponse :success
  end

  test "should get help" do
    get :help
    assert_reponse :success
  end
end
```


___代码清单3.12: 测试 略___

## 3.3.2 遇红

TDD流程是先编写一个失败测试, 通过修改代码使测试通过, 按需重构. 也就是"遇红 => 变绿 => 重构"的循环.

在控制器测试中加入如下代码

___代码清单3.13: about页面的测试 test/controllers/static\_pages\_test.rb___


``` ruby
require 'test_helper'
class StaticPagesControllerTest < ActionController::TestCase

  test "should get home" do
    get :home
    assert_reponse :success
  end

  test "should get help" do
    get :help
    assert_reponse :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end
end
```

由于没有生成about页面的控制器, 因此这个测试会失败(遇红).

___代码清单3.14: 测试 略___

## 3.3.3 变绿

上节中失败测试的错误消息:

___代码清单3.15: 测试错误消息___

``` shell
bundle exec rake test

# ActionController::UrlGenerationError:
# No route matches {:action=>"about", :controller=>"static_pages"}
```



可见是缺少路由规则. 添加一个路由规则

___代码清单3.16: 添加about路由 config/routes.rb___


``` ruby
Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  ...
end
```


继续测试, 仍无法通过, 不过错误消息变了.

___代码清单3.17: 测试错误消息(二)___

``` shell
bundle exec rake test

# AbstractController::ActionNotFound:
# The action 'about' could not be found for StaticPagesController

```


___代码清单3.18: 在静态控制器页面中添加about动作 app/controllers/static\_pages\_controller.rb___

显然是控制器中缺少about动作, 在控制器中编写这个动作.

``` ruby
class StaticPagesController < ApplicationController

  def home
  end

  def hlep
  end

  def about
  end

end
```


测试依然失败, 不过消息又变了.

``` shell
# ActionView::MissingTemplate: Missing template static_pages/about
```

这是由于缺少模板(视图)引起的, 新建一个视图, 保存在app/views/static_pages, 命名为about.html.erb

___代码清单3.19: about页面的内容 app/views/static\_pages/about.html.erb___

``` html+erb
<h1>About</h1>
<p>
    The <a href="http://www.railstutorial.org/"><em>Ruby on Rails
    Tutorial</em></a> is a
    <a href="http://www.railstutorial.org/book">book</a> and
    <a href="http://screencasts.railstutorial.org/">screencast series</a>
    to teach web develop with
    <a href="http://rubyonrails.org/">Ruby on Rails</a>.
    This is the sample application for the tutorial.
</p>
```


运行测试, 应该可以通过.

___代码清单3.20: 测试 略___

## 3.3.4 重构

# 3.4 有点动态的页面

根据所在页面不同, 显示不同标题, 采用TDD.

___表3.2: 演示应用中基本上是静态内容的页面___

页面|URL|基本标题|变动部分
--|--|--|--
首页|/static\_pages/home|"Ruby on Rails Tutorial Sample App"|"Home"
帮助|/static\_pages/help|"Ruby on Rails Tutorial Sample App"|"Help"
关于|/static\_pages/about||"About"

## 3.4.1 测试标题(遇红)

___代码清单3.21: 一般网页的HTML结构___


``` html
<!DOCTYPE html>
<html>
  <head>
    <title>Greeting</title>
  </head>
  <body>
    <p>Hello, world!</p>
  </body>
</html>
```


在static\_pages\_controller\_test中进行标题测试(遇红)

___代码清单3.22: 加入标题测试后的今天页面控制器测试 test/controllers/static\_pages\_controller\_test.rb___

``` ruby
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
```

___代码清单3.23: 测试 略___

## 3.4.2 添加页面标题(变绿)

以home页面为例,help和about界面也是同样的.

___代码清单3.24: 具有完整HTML结构的Home页面 app/views/static\_pages/home.html.erb___

``` html+erb
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
```

___代码清单3.25: 具有完整HTML结构的Help页面 app/views/static\_pages/help.html.erb___

___代码清单3.26: 具有完整HTML结构的About页面 app/views/static\_pages/about.html.erb___

___代码清单3.27: 测试 略___

## 3.4.3 布局和嵌入式Ruby(重构)

重构的必要性
1. 页面的标题几乎是一模一样, 每个标题中都有个"Ruby on Rails Tutorial Sample App";
2. 整个HTML结构在每个页面都重复地出现了.

以home页面为例, 其他页面也相似.

常用方法provide, 接受一个名称和内容, 把这个内容记录下来. 在视图中使用, yield方法(需要传入名称)调用.

___代码清单3.28: 标题中使用erb的Home视图 app/views/static\_pages/home.html.erb___

``` html+erb
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
```

___代码清单3.29: 测试 略___

___代码清单3.30: 标题中使用erb的Help视图 app/views/static\_pages/help.html.erb___

___代码清单3.31: 标题中使用erb的About视图 app/views/static\_pages/about.html.erb___

抽出相同结构构成模板, 写入布局文件. layout可以和其他view通过provide相互传递常量, 无参数的yield方法表示把每个页面的内容插入布局中.

___代码清单3.32: 演示应用的网站布局 app/vies/layouts/application.html.erb___

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

___代码清单3.33: 去除完成的HTML结构后的首页 app/views/static\_pages/home.html.erb___

    <% provide(:title, "Home") %>
    <h1>Sample App</h1>
    <p>This is the home pages for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.</p>

___代码清单3.34: 去除完成的HTML结构后的Help页面 app/views/static\_pages/help.html.erb___

___代码清单3.35: 去除完成的HTML结构后的About页面 app/views/static\_pages/about.html.erb___

___代码清单3.36: 测试 略___

## 3.4.4 设置根路由

将home设置为根路由

___代码清单3.37: 把根路由指向Home config/routes.rb___

    Rails.applicationController.routes.draw do
      root 'static_pages#home'
      get 'static_pages/help'
      get 'static_pages/about'
    end

# 3.5 小结

* 使用provide方法可以定义常量,(需要传入名称与值), 调用时使用yield方法(需要传入名称)
* provide方法可以在一般页面与布局页面传递
* Rails的布局定义页面公用的结构, 可以去除冗余, 布局中使用不带参数的yield方法表示把每个页面的内容插入布局中
* 本章中的布局文件可以作为模板
* 需要记录Rails的一些撤销方法
* 在config/routes.rb文件中定义了新路由

# 3.6 练习

1. 加入通用标题的控制器测试

___代码清单3.38: 使用了通用标题的静态页面控制器测试 test/controllers/static\_pages\_controller\_test.rb___

        class StaticPagesControllerTest < ActionController::TestCase
        # setup在每个测试运行前执行
          def setup
            @base_title = "Ruby on Rails Tutorial Sample App"
          end

          test "should get home" do
            get :home
            assert_response :success
            # #{@base_title}是字符串的差值, 只有在双引号中才能使用
            assert_select "title", "Help | #{@base_title}"
          end
          ...
        end

2. 新建联系页面

___代码清单3.39: contact页面内容 略___

# 3.7 高级测试技术


# 4.1 导言, 第一个辅助方法

___代码清单4.1: 演示应用的网站布局 app/views/layouts/application.html.erb 与代码清单3.32相同___

_代码清单4.2: 定义full\_title 方法 app/helpers/application\_helper.rb_

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

_代码清单4.3: 使用full\_title辅助方法的网站布局 app/views/layouts/application.html.erb_

    <!DOCTYPE html>
    <html>
        <head>
            <title><%= full_title(yield(:title)) %></title>
            <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true %>
            <%= javascript_include_tag 'application', 'data-turlinks-track' => true %>
            <%= csrf_meta_tags %>
        </head>
        <body>
            <%= yield %>
        </body>
    </html>

同时, 我们可以在首页中删除首页的page\_title: Home, 这样在首页只显示base\_title.

同样的需要对标题测试修改, 保证测试通过.

_代码清单4.4: 修改首页的标题测试 test/controllers/static\_pages\_controllers\_test.rb_

    require 'test_helper'

    class StaticPagesControllerTest < ActionController::TestCase
      test "should get home" do
        get :home
        assert_response :success
        assert_select "title", "Ruby on Rails Tutorial Sample App"
      end

      test "should get help" do
        get :help
        assert_response :success
        assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
      end

      test "should get about" do
        get :about
        assert_response :success
        assert_select "title", "About | Ruby on Rails Tutorial Sample App"
      end
    end

运行测试, 无法通过, 因为还没有删除首页的Home.

_代码清单4.5: 测试 RED_

_代码清单4.6: 没定义页面标题的首页视图 app/views/static\_pages/home.html.erb_

    <h1>Sample App</h1>
    <p>
        This is the home page for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.
    </p>

_代码清单4.7 测试 通过_


# 4.2 字符串和方法

_代码清单4.8: 添加一些irb配置 ~/.irbrc_

    IRB.conf[:PROMPT_MODE] = :SIMPLE
    IRB.conf[:AUTO_INDENT_MODE] = false

# 4.2.1 注释

# 4.2.2 字符串

# 4.2.3 对象和消息传送

# 4.2.4 定义方法

# 4.2.5 回顾标题的辅助方法

_代码清单4.9: 注释full\_title方法_

    module ApplicationHelper
      # 根据所在页面返回完整的标题
      # 定义方法
      def full_title(page_title = '')
        # 变量赋值
        base_title = "Ruby on Rails Tutorial Sample App"
        # 布尔测试
        if page_title.empty?
          # 隐式返回值
          base_title
        else
          # 字符串差值
          "#{page_title} | #{base_title}"
        end
      end
    end

# 4.3 其他数据类型

# 4.3.1 数组和值域

# 4.3.2 块

# 4.3.3 Hash和Symbol

_代码清单4.10: Hash 嵌套_

# 4.3.4 重温引入css的代码

    # 调用方法时可以省略括号; Hash如果为最后一个参数, 可以省略花括号
    stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true

    # 恢复括号, 不能写成data-turbolinks-track: true, symbol中不能有连字符
    # 只能写成字符串形式, 事实上传入了两个参数
    stylesheet_link_tag('application', {media: 'all', 'data-turbolinks-track' => true})

_代码清单4.11: 引入CSS的代码生成的HTML_

# 4.4 Ruby类

# 4.4.1 构造方法

# 4.4.2 类的继承

# 4.4.3 修改内置的类

# 4.4.4 控制器类

# 4.4.5 用户类

# 4.5 小结

# 4.5.1 读完本章学到了什么


# 5.1 添加一些结构

# 5.1.1 网站导航

为了保证IE的兼容性, 在布局文件的<head>标签中加入.

    <!--[if lt IE 9>
      <script src="//sdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js"></script>
    <![endif]-->

_代码清单5.1: 添加一些机构后的网站布局文件 app/views/layouts/application.html.erb_

    <!DOCTYPE html>
    <html>
        <head>
            <title><%= full_title(yield(:title)) %></title>
            <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true %>
            <%= javascript_include_tag 'application', 'data-turbolinks-track' =? true %>
            <%= csrf_meta_tags %>
            <!--[if lt IE 9]>
                <script src="//cdnjs.clouflare.com/ajax/libs/html5shiv/r29/html5.min.js">
                </script>
            <![endif]-->
        </head>
        <body>
            <header class="navbar navbar-fixed-top navbar-inverse">
                <div class="contrainer"">
                    <%= link_to "sample app", '#', id: "logo" %>
                    <nav>
                        <ul class="nav navbar-nav pull-right">
                            <li><%= link_to "Home", '#' %></li>
                            <li><%= link_to "Hlep", '#' %></li>
                            <li><%= link_to "Log in", '#' %></li>
                        </ul>
                    </nav>
                </div>
            </header>
            <div class="contrainer">
                <%= yield %>
            </div>
        </body>
    </html>



在首页中加入按钮, div标签的CSS类jumbotron在Bootstrap中有特殊的意义, 注册按钮的btn, btn-lg和btn-primary也是一样.

_代码清单5.2: 首页视图, 包含一个到注册页面的链接 app/views/static\_pages/home.html.erb_

    <div class="center jumbotron">
      <h1>Welcome to the Sample App</h1>
      <h2>
        This is the home page for the <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a> sample application.
      </h2>
      <%= link_to "Sign up now!", '#', class: "btn btn-lg btn-primary" %>
    </div>
    <%= link_to image_tag("rails.png", alt: "Rails log"), 'http://rubyonrails.org/' %>

## 5.1.2 引入Bootstrap和自定义的CSS

_代码清单5.3: 将bootstrap-sass-3.2.0.0添加到gemfile中_

    source 'https://rubygems.org'

    gem 'rails', '4.2.0'
    gem 'bootstrap-sass', '3.2.0.0'
    ...

在`app/assets/stylesheets/`新建一个SCSS文件, 用custom.css.scss命名.

_代码清单5.4: 添加Bootstrap的CSS app/assets/stylesheets/custom.css.scss_

_代码清单5.5: 添加全站使用的CSS app/assets/stylesheets/custom.css.scss_

_代码清单5.6: 添加一些精美的文字排版样式 app/asserts/stylesheets/custom.css.scss_

_代码清单5.7: 添加网站LOGO的样式 app/assets/stylesheets/custom.css.scss_

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


## 5.1.3 局部视图

为了简化layout, 可以考虑把保证IE兼容性的HTML shim和header部分的放到局部视图中

_代码清单5.8: 把HTML shim和header部分的放到局部视图后的网站布局 app/views/layouts/application.html.erb_

    <!DOCTYPE html>
    <html>
        <head>
            <title><%= full_title(yield(:title)) %></title>
            <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true %>
            <%= javascript_include_tag 'application', 'data-turbolinks-track' =? true %>
            <%= csrf_meta_tags %>
            <%= render 'layouts/shim' %>
        </head>
        <body>
            render 'layouts/header'
            <div class="contrainer">
                <%= yield %>
            </div>
        </body>
    </html>


_代码清单5.9: HTML shim局部视图 app/views/layouts/\_shim.html.erb_

    <!--[if lt IE 9]>
        <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js">
        </script>
    <![endif]-->


_代码清单5.10: header的局部视图 app/views/layouts/\_header.html.erb_

    <header class="navbar navbar-fixed-top navbar-inverse">
        <div class="container">
            <%= link_to "sample app", '#', id: "logo" %>
            <nav>
                <ul class="nav navbar-nav pull-right">
                    <li><%= link_to "Home", '#' %></li>
                    <li><%= link_to "Help", '#' %></li>
                    <li><%= link_to "Log in", '#' %></li>
                </ul>
            </nav>
        </div>
    </header>

_代码清单5.11: 网站底部的局部视图 app/views/layouts/\_footer.html.erb_

    <footer class="footer">
        <small>
            The <a href="http://www.railstutorial.org/">Ruby On Rails Tutorial</a>
            by <a href="http://www.michaelhartl.com/">Michael Hartl</a>
        </small>
        <nav>
            <ul>
                <li><%= link_to "About", '#' %></li>
                <li><%= link_to "Contact", '#' %></li>
                <li><a href="http://news.railstutorial.org">News</a></li>
            </ul>
        </nav>
    </footer>

_代码清单5.12: 添加底部局部视图后的网站布局 app/views/layouts/application.html.erb_

    <!DOCTYPE html>
    <html>
        <head>
            <title><%= full_title(yield(:title)) %></title>
            <%= stylesheet_link_tag "application", media: "all", "data-turbolinks-track" => true %>
            <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
            <%= csrf_meta_tags %>
            <%= render 'layouts/shim' %>
        </head>
        <body>
            <%= render 'layouts/header' %>
            <div class="container">
                <%= yield %>
                <%= render 'layouts/footer' %>
            </div>
        </body>
    </html>


_代码清单5.13: 添加footer的CSS app/assets/stylesheets/custom.css.scss_

    ...
    /* footer */

    footer {
      margin-top: 45px;
      padding-top: 5px;
      border-top: 1px solid #eaeaea;
      color: #777;
    }

    footer a {
      color: #555;
    }

    footer a:hover {
      color: #222;
    }

    footer small {
      float: left;
    }

    footer ul {
      float: right;
      list-style: none;
    }

    footer ul li {
      float: left;
      margin-left: 15px;
    }

# 5.2 Sass和Aseet Pipeline

# 5.2.1 Asset Pipeline

# 5.2.2 Sass

_代码清单5.15: 使用嵌套和变量改写后的SCSS文件 app/asserts/stylesheets/custom.css.scss_

    @import "bootstrap-prockets";
    @import "bootstrap";

    /* mixins, variables, etc. */

    $gray-medium-light: #eaeaea

    /* universal */

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
      text-align: center;
      h1 {
        margin-bottom: 10px;
      }
    }

    /* typrography */

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
      font-weight: normal;
      color: $gray-light;
    }

    p {
      font-size: 1.1em;
      line-weight: 1.7em;
    }

    /* header */

    #logo {
      float: left;
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
      color: $gray-medium-light;
      a {
        color: $gray;
        &:hover {
          color: $gray-darker
        }
      }
      small {
        float: left;
      }
      ul {
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

_表5.1 网站链接中的路由和URL地址之间的映射关系_

页面|URL|具名路由
--|--|--
Home|/|root\_path
About|/about|about\_path
Help|/help|help\_path
Contact|/contact|contact\_path
Sign up|/signup|signup\_path
Log in|/login|login\_path


## 5.3.1 Contact页面

添加Contact页面, TDD. 首先编写测试."

_代码清单5.16: Contact页面的测试 test/controllers/static\_pages\_controllers\_test.rb_

    require 'test_helper'

    class StaticPagesControllerTest < ActionController::TestCase

      test "should get home" do
        get :home
        assert_reponse :success
        assert_select "title", "Ruby on Rails Tutorial Sample App"
      end

      test "should get help" do
        get :help
        assert_reponse :success
        assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
      end
    end

    test "should get about" do
      get :about
      assert_reponse :success
      assert_select "title", "About | Ruby on Rails Tutorial Sample App"
    end

    test "should get contact" do
      get :contact
      assert_reponse :success
      assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
    end


_代码清单5.17 测试 略 RED_

根据错误提示, 建立Contact路由

_代码清单5.18: 添加Contact页面的路由 config/routes.rb_


    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'static_pages/help'
      get 'static_pages/about'
      get 'static_pages/contact'
    end

_代码清单5.19: 添加Contact页面的动作 app/controllers/static\_pages\_controller.rb_

    class StaticPagesController < ApplicationController
      ...

      def contact
      end
    end

_代码清单5.20: Contact页面的视图 app/views/static_pages/contact.html.erb_

    <% provide(:title, 'Contact') %>
    <h1>Contact</h1>
    <p>Contact the Ruby on Rails Tutorial about the sample app at the
        <a href="http://www.railstutorial.org/#contact">contact page</a>.
    </p>

现在测试可以通过了.

_代码清单5.21: 测试 略_

## 5.3.2 Rails路由

以根路由为例, 对于具名路由, 可以使用"控制器名称#动作名称"定义

    root 'static_pages#home'

这样就创建了两个具名路由: root\_path和root\_url. 二者的区别是后者是, 后者是完整的URL中. 只有重定向需要使用\_url形式, 其他均使用\_path形式.


同样的原理, 可以为每个页面定义具名路由

    get 'help' => 'static_pages#help'

_代码清单5.22: 静态页面的路由 config/routes/rb_

    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#help'
      get 'contact' => 'static_pages#contact'
    end

这样就可以在布局文件中使用具名路由.

## 5.3.3 使用具名路由

_代码清单5.23: 在header中使用具名路由 app/views/layouts/\_header.html.erb_

    <header class="navbar navbar-fixed-top navbar-inverse">
        <div class="container">
            <%= link_to "sample app", root_path, id: "log" %>
            <nav>
                <ul class="nav navbar-nav pull-right">
                    <li><%= link_to "Home", root_path %></li>
                    <li><%= link_to "Help", help_path %></li>
                    <li><%= link_to "Log in", '#' %></li>
                </ul>
            </nav>
        </div>
    </header>

_代码清单5.24: 在footer中使用具名路由 app/views/layouts/\_footer.html.erb_

    <footer class="footer">
        <small>
            The <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
            by <a href="http://www.michelhartl.com/">Michael Hartl</a>
        </small>
        <nav>
            <ul>
                <li><%= link_to "About", about_path %></li>
                <li><%= link_to "Contact", contact_path %></li>
                <li><a href="http://news.railstutorial.org/"></a>News</li>
            </ul>
        </nav>
    </footer>

## 5.3.4 布局中的链接测试(集成测试)

1. 访问根路由(首页)
2. 确认使用正确的模板渲染
3. 检查指向首页, "帮助"页面, "关于"页面和"联系"页面的地址是否正确"

_代码清单5.25: 测试布局中的链接 test/integration/site\_layout\_test.rb_

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

_表5.2: assert\_select的一些用法_

代码|匹配的HTML
--|--
assert\_select "div"|`<div>foobar</div>`
assert\_select "div", "foobar"|`<div>foobar</div>`
assert\_select "div.nav"|`<div class="nav">foobar</div>`
assert\_select "div#profile"|`<div id="profile">foobar</div>`
assert\_select "div[name=yo]"|`<div name="yo">hey</div>`
assert\_select "a[href=?]", '/', count: 1 |` <a href="/">foo</a>`
assert\_select "a[href=?]", '/', text: "foo"|` <a href="/">foo</a>`


_代码清单5.26: 测试 略_

_代码清单5.27: 测试 略_


# 5.4 用户注册

## 5.4.1 用户控制器

新建用户控制器, 控制器为大写复数

_代码清单5.28: 生成用户控制器(包含new动作)_

    rails generate controller Users new

_代码清单5.29: 用户控制器测试 略_

_代码清单5.30: 默认生成的用户控制器, 包含new动作 app/controllers/users\_controller.rb_

    class UserController < ApplicationController

      def new
      end

    end

_代码清单5.31: 默认生成的new动作视图 app/views/users/new.html.erb_

    <h1>User#new<h1>
    <p>Find me in app/views/users/new.html.erb</p>

_代码清单5.32: 新建用户页面的测试 test/controllers/users\_controller\_test.rb_

    require 'test_helper'

    class UsersControllerTest < ActionController::TestCase
      test "should get new" do
        get :new
        assert_response :success
      end
    end

## 5.4.2 "注册"页面的URL

_代码清单5.33: sign up页面的路由 config/routes.rb_

    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#about'
      get 'contact' => 'static_pages#contact'
      get 'signup' => 'users#new'
    end

_代码清单5.34: 使用按钮链接到signup页面 app/views/static\_pages/home.html.erb_

    <div class="center jumbotron">
        <h1>Welcome to the Sample App</h1>

        <h2>
            This is the home page for the <a href="http://www.railstutorial.org">Ruby on Rails Tutorial</a> sample application.
        </h2>

        <%= link_to "Sign up now!", signup_path, class: "btn btn-lg btn-primary"%>
    </div>

    <%= link_to image_tag("rails.png", alt: "Rails logo"), 'http://rubyonrails.org' %>

_代码清单5.35: signup页面的临时视图 app/views/users/new.html.erb_

    <% provide(:title, 'Sign up') %>
    <h1>Sign up</h1>
    <p>This will be a signup page for new users.</p>

# 5.5 小结

## 5.1.1 读完本章学到了什么

* 使用HTML5可以定义一个包括LOGO, header, footer, 和body内容的网站布局
* 为了使用起来方便, 可以使用Rails局部视图把部分结构放到单独的文件中
* 在CSS中可以使用class和ID编写样式
* Bootstrap框架能快速实现设计精美的网站
* 使用Sass和Asset Pipeline能去除CSS中的重复, 还能打包静态文件, 提高在生产环境中的使用效率
* 在Rails中可以自己定义路由规则, 得到具名路由
* 继承测试能高效模拟浏览器中的点击操作

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

    module SessionsHelper
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

    module SessionsHelper
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

      # 返回当前登陆的用户(如果有的话)
      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end

      # 如果用户已登陆, 返回true, 否则返回false
      def logged_in?
        !current_user.nil?
      end

      # 退出当前用户
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
        # 访问登陆页面
        get login_path
        # 发送登陆信息
        post login_path, session: { email: @user.email, password: 'password'}
        # 测试是否登陆成功
        assert is_logged_in?
        # 测试是否重定向到用户页面
        assert_redirected_to @user
        # 访问重定向后的页面
        follow_redirect!
        # 测试是否渲染用户页面模板
        assert_template 'users/show'
        # 测试用户页面中是否有登陆按钮
        assert_select "a[href=?]", login_path, count: 0
        # 测试用户页面中是否有退出按钮
        assert_select "a[href=?]", logout_path
        # 测试用户页面是否有转向用户设置的页面
        assert_select "a[href=?]", user_path(@user)
        # 登出当前用户
        delete logout_path
        # 测试是否登出
        assert_not is_logged_in?
        # 测试是否重定向到首页
        assert_redirected_to root_url
        # 访问重定向页面
        follow_redirect!
        # 测试是否有登陆按钮
        assert_select "a[href=?]", login_path
        # 测试是否有登出按钮
        assert_select "a[href=?]", logout_path, count: 0
        # 测试是否有用户设置按钮
        assert_select "a[href=?]", user_path(@user), count: 0
      end
    end

# 8.4 记住我

cookie方法实现的持久会话有被会话劫持的风险. 可以按照下列方式实现持久会话:

1. 生成随机字符串, 当做记忆令牌
2. 把这个随机令牌存入浏览器的cookie中, 并把过期时间设置为未来的某个日期
3. 在数据库中存储令牌的摘要
4. 在浏览器的cookie中存储加密后的用户ID
5. 如果cookie中有用户的ID, 就用这个ID在数据库中查找用户, 并检查cookie中的记忆令牌和数据库中的hash摘要是否匹配.

首先需要在用户模型中加入存储令牌摘要的列.

     rails generate migration add_remember_digest_to_users remember_digest:srting

运行`bundle exec rake db:migrate`.

对于令牌的生成, 可以用Ruby标准库中的SecureRandom模块的urlsafe_base64方法. 这个方法返回长度为22的随机字符串, 包含字符A-Z, a-z, 0-9, -和_. 我们可以定义一个`new_token`方法, 和digest方法一样, `new_token`方法也不需要用户对象, 所以也定义为类方法.

    class User < ActiveRecord::Base
      before_save { self.email = email.downcase }
      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i
      validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
      has_secure_password
      validates :password, length: { minimum: 6 }

      # 返回制定字符串的hash摘要
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end

      # 返回一个随机令牌
      def User.new_token
        SecureRandom.urlsafe_base64
      end
    end

对于密码, 有一个虚拟属性password和数据库中的password\_digest, 其中password属性由has\_secure\_password方法自动创建. 而自己创建的remember\_token属性, 可以使用attr\_accessor创建一个可访问的属性.

    class User < ActiveRecord::Base
      # 创建可以访问的属性
      attr_accessor :remember_token

      before_save { self.email = email.downcase }
      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i
      validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
      has_secure_password
      validates :password, length: { minimum: 6 }

      # 返回制定字符串的hash摘要
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end

      # 返回一个随机令牌
      def User.new_token
        SecureRandom.urlsafe_base64
      end

      # 为了持久会话, 在数据库中记住用户
      def remember
        self.remember_token = User.new_token
        update_attributes(:remember_digest, User.digest(remember_token))
      end
    end

## 8.4.2 记录登陆时的状态
定义了user.remember方法后, 可以创建持久会话了, 方法是把加密后的用户ID和记忆令牌作为持久cookie存入浏览器. 为此要使用cookies方法, 这个方法和session方法一样, 可以视为一个hash. 一个cookie有两部分信息, value和expires.

    class User < ActiveRecord::Base
      # 创建可以访问的属性
      attr_accessor :remember_token

      before_save { self.email = email.downcase }
      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i
      validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
      has_secure_password
      validates :password, length: { minimum: 6 }

      # 返回制定字符串的hash摘要
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end

      # 返回一个随机令牌
      def User.new_token
        SecureRandom.urlsafe_base64
      end

      # 为了持久会话, 在数据库中记住用户
      def remember
        self.remember_token = User.new_token
        update_attributes(:remember_digest, User.digest(remember_token))
      end

      # 如果指定的令牌和摘要匹配, 返回true
      def authenticate?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
      end
    end

在创建用户后, 自动登陆并记住登陆状态

    class SessionsController < ApplicationController
      def new
      end

      def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
          log_in user
          # 使用SessionHepler中的remember方法记住用户
          remember user
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

和登陆功能一样, 上面的代码把震中的工作交给SessionsHelper方法完成.

    module SessionsHelper
      # 登入指定的用户
      def log_in(user)
        session[:user_id] = user.id
      end

      # 在持久会话中记住用户
      def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end

      # 返回当前登陆的用户(如果有的话)
      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end

      # 如果用户已登陆, 返回true, 否则返回false
      def logged_in?
        !current_user.nil?
      end

      # 退出当前用户
      def log_out
        # 从session中删除用户
        session.delete(:user_id)
        # 清空current_user
        @current_user = nil
      end
    end

截止到目前位置, current\_user只能处理临时用户. 更新current\_user

        module SessionsHelper
      # 登入指定的用户
      def log_in(user)
        session[:user_id] = user.id
      end

      # 在持久会话中记住用户
      def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end

      # 返回当前登陆的用户(如果有的话)
      def current_user
        if (user_id = session[:user_id])
          @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
          if user && user.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end
      end

      # 如果用户已登陆, 返回true, 否则返回false
      def logged_in?
        !current_user.nil?
      end

      # 退出当前用户
      def log_out
        # 从session中删除用户
        session.delete(:user_id)
        # 清空current_user
        @current_user = nil
      end
    end

## 忘记用户

除非cookie过期, 现在无法退出用户. 在用户模型中加入forget方法

    class User < ActiveRecord::Base
      # 创建可以访问的属性
      attr_accessor :remember_token

      before_save { self.email = email.downcase }
      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i
      validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
      has_secure_password
      validates :password, length: { minimum: 6 }

      # 返回制定字符串的hash摘要
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end

      # 返回一个随机令牌
      def User.new_token
        SecureRandom.urlsafe_base64
      end

      # 为了持久会话, 在数据库中记住用户
      def remember
        self.remember_token = User.new_token
        update_attributes(:remember_digest, User.digest(remember_token))
      end

      # 如果指定的令牌和摘要匹配, 返回true
      def authenticate?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
      end

      # 忘记用户
      def forget
       update_attribute(:remember_digest, nil)
      end
    end

然后就可以定义forger辅助方法, 忘记持久会话, 最后在log_out辅助方法中调用forget


    module SessionsHelper
      # 登入指定的用户
      def log_in(user)
        session[:user_id] = user.id
      end

      # 在持久会话中记住用户
      def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end

      # 返回当前登陆的用户(如果有的话)
      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end

      # 如果用户已登陆, 返回true, 否则返回false
      def logged_in?
        !current_user.nil?
      end

      # 忘记持久会话
      def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
      end

      # 退出当前用户
      def log_out
        # 从session中删除用户
        session.delete(:user_id)
        # 清空current_user
        @current_user = nil
      end
    end

## 8.4.4 两个小问题

1. 如果用户打开多个窗口, 在其中一个已经退出, 再在另外一个窗口中点击退出链接会导致会话错误.
2. 用户在不同浏览器中永久登陆, 如果用户在一个浏览器中退出, 而另外一个没有退出, 因为此时user.remember_digest已经变成了nil. 而在另外一个浏览器中, 用户ID没有被删除, 会执行`user.authenticated?(cookeis[:remember_token])`表达式, `BCrypt::Password.new(remember_digest).is_password?(remember_token)`会抛出异常.

可以先在集成测试中重现这两个问题.

    require 'test_helper'
    class UsersLoginTest < ActionDispatch::IntegrationTest
      ...
      test "login with valid information followed by logout" do
        get login_path
        post login_path, session: { email: @user.email, password: 'password' }
        assert is_logged_in?
        assert_redirected_to @user
        follow_redirect!
        assert_template 'user/show'
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)
        delete logout_path
        assert_not is_logged_in?
        assert_redirected_to root_url
        # 模拟用户在另一个窗口中减低退出按钮
        delete logout_path
        follow_redirect!
        assert_select "a[href=?]", login_path,
        assert_select "a[href=?]", logout_path, count: 0
        assert_select "a[href=?]", user_path(@user), count: 0
      end
    end
第二个`delete logout_path`会抛出异常, 因为没有当前用户, 导致测试组件无法通过. 在应用代码中, 只需在`logged_in?`返回true时才调用`log_out`即可

    class SessionsController < ApplicationController
      ...
      def destroy
        log_out if logged_in?
        redirect_to root_url
      end
    end

第二个问题设计到两种不同浏览器, 直接模拟有困难, 可以直接在用户模型层测试. 只需创建一个没有`remember_digest`的用户, 在调用`authenticated?`方法.

    require 'test_helper'
    class UserTest <ActiveSupport::TestCase
      def setup
        @user = User.new(name: "Example User", email: "user2example.com", password: "foobar", password_confirmation: "foobar")
      end
      ...
      test "authenticate? should return false for a user with nil digest" do
        assert_not @user.authenticated?('')
      end
    end

更新authenticated?方法, 处理没有摘要的请款

    class User < ActiveRecord::Base
      ...
      # 如果制定的令牌和摘要匹配, 返回true
      def authenticated?(remember_token)
        return false is remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
      end
    end

## 8.4.5 记住我复选框

在登陆表单中添加记住我复选框

    <% provide(:title, "Log in") %>
    <h1>Log in</h1>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(:session, url: login_path) do |f| %>
              <%= f.label :email %>
              <%= f.text_field :email %>

              <%= f.label :password %>
              <%= f.password_field :password %>

              <%= f.label :remember_me, class: "checkbox inline" do %>
                <%= f.check_box :remember_me %>
                <span>Remember me on this computer</span>
              <% end %>
              <%= f.submit "Log in", class: "btn btn-primary" %>
            <% end %>

            <p>New user? <%= link_to "Sign up now!", signup_path %></p>
        </div>
    </div>

添加一些css样式

    ...
    /* forms */
    ...
    .checkbox {
      margin-top: -10px;
      margin-bottom: 10px;
      span {
        margin-left: 20px;
        fort-weight: normal;
      }
    }

    #session_remember_me {
      width: auto;
      margin-left: 0;
    }

处理提交的"记住我"复选框

    class SessionController < ApplicationController
      def new
      end

      def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticated(params[:session][:password])
          log_in user
          # 检测是否需要记住我
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_to user
        else
        end
      end
      def destroy
        log_out if logged_in?
        redirect_to root_url
      end
    end

## 8.4.6 记住登陆状态功能的测试

在之前的测试中, 登入用户使用post方法发送有效的session hash, 为了避免重复, 编写一个测试辅助方法, 名为`log_in_as`

    EVN['RAILS_ENV'] ||= 'test'
    ...
    class ActiveSupport::TestCase
      firtures :all

      # 如果用户已经登陆, 返回true
      def is_logged_in?
        !session[:user_id].nil
      end

      # 登入测试用户
      def log_in_as(user, options = {})
        password = options[:password] || 'password'
        remember = options[:remember_me] || '1'
        if integration_test?
          post login_path, session { email: user.email, password: password, remember_me: remember_me }
        else
          session[:user_id] = user.id
        end
      end

      private

      # 在集成测试中返回true
        def integration_test?
          defined?(post_via_redirect)
        end
    end

接下来就可以写测试了

    require 'test_helper'

    class UsersLoginTest < ActionDispatch::IntegrationTest

      def setup
        @user = user(:michael)
      end

      ...

      test "login with remember" do
        log_in_as(@user, remember_me: '1')
        # 测试中cookies不能使用symbel key, 只能使用字符串
        assert_not_nil cookies['remember_token']
      end

      test "login without remembering" do
        log_in_as(@user, remember_me: '0')
        assert_nil cookies['remember_token']
      end
    end

前面已经确认了持久会话可以正常使用, 但是`current_user`方法的相关分支完全没有测试. 针对这种情况, 可以在未测试代码中抛出异常, 如果测试没有覆盖, 则能通过.

    module SessionHelper
      ...
      # 返回cookie中记忆令牌对应的用户
      def current_user
        if (user_id = session[:user_id])
          @current_user ||= User.find_by(id: user_id)
        elsif
          raise # 测试没有覆盖, 没有抛出异常, 可以通过
          user = User.find_by(id: user_id)
          if user && user.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end
      end
      ...
    end

加入对`current_user`方法的测试

    require 'test_helper'

    class SessionsHelperTest < ActionView::TestCase
      def setup
        @user = user(:michael)
        remember(@user)
      end

      test 'current_user return right user when session is nil' do
        assert_equal @user, current_user
        assert is_logged_in?
      end

      test "current_user returns nil when remember digest is wrong" do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        assert_nil current_user
      end
    end

# 8.5 小结

# 8.5.1 学到了什么

* Rails可以使用临时cookie和持久cookie维护页面之间的状态
* 登陆表单的目的是创建新会话, 登入用户
* flash.now方法用于在重新渲染的页面中闪现消息
* 在测试中重现问题可以使用TDD
* 使用session方法可以安全的在浏览器中存储用户ID, 创建临时会话
* 可以根据登陆状态修改功能, 例如布局中显示的链接
* 集成测试可以检查路由, 数据库更新和对布局的修改
* 为了实现持久会话, 我们为每个用户省城了记忆令牌和对应的记忆摘要
* 使用cookies方法可以在浏览器的cookie中存储一个永久记忆令牌, 实现持久会话
* 登陆状态取决于有没有当前用户, 而当前用户通过临时会话中的用户ID或持久会话中唯一的记忆令牌获取
* 退出功能通过删除会话中的用户ID和浏览器中的持久cookie实现
* 三元操作符是编写简单if-else语句的简介方式

# 8.6 练习

1. 对于下列代码中两种不同定义类方法的方式, 进行测试.

    class User < ActiveRecord::Base

     ...

     # 返回i制定字符的哈希摘要
     def self.digest(string)
       cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine:MIN_COST : BCrypt::Engine.cost
       BCrypt::Password.create(string, cost: cost)
     end


      # 返回一个随机令牌
      def self.token
        Secure.urlsafe_base64
      end

      ...

    end

方法二:

    class User < ActiveRecord

     ...

     class << self
       # 返回指定字符串的hash摘要
       def digest(string)
         cost = ActiveRecord::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
         BCrypt::Password.create(string, cost: cost)
       end

       # 返回一个随机令牌
       def new_token
         SecureRandom.urlsafe_base64
       end
     end

     ...
    end


2. 在之前说过, 集成测试中无法获取`remember_token`虚拟属性. 但是可以使用assigns方法获取. 该方法要求变量为实例变量.

   class SessionsController < ApplicationController

     def new
     end

     def create
       @user = User.find_by(:email: params[:session][:email].downcase)
       if @user && @user.authenticate(params[:session][:password])
         login @user
         params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
         redirect_to @user
       else
         flash.now[:danger] = 'Invalid email/password combination'
         render 'new'
       end
     end

     def destroy
       log_out if logged_in?
       redirect_to root_url
     end
   end

接下来可以重构测试

    require 'test_helper'

    class UsersLoginTest < ActionDispatch::IntegrationTest

      def setup
        @user = Users(:michael)
      end

      ...

      test "login with remembering" do
        log_in_as(@user, remember_me: '1')
        assert_equal assign(:user).remember_digest, cookies[remember_token]
      end

      test "login without remembering" do
        log_in_as(@user, remember_me: '0')
        assert_nil cookies['remember_token']
      end
           ...

    end

# 9.1 更新用户
## 9.1.1 编辑表单

  首先来编写edit动作: 从数据库中读取相应的用户, 用户ID可以从params[:id]获取.

  _代码清单9.1: 用户控制器的edit动作 app/controller/users\_controller.rb_

    class UsersController < ApplicationController

      def show
        @user = User.find(params[:id])
      end

      def new
        @user = Users.new
      end

      def create
        @user = User.new(user_params)
        if @user.save
          log_in @user
          flash[:success] = "Welcome to the Sample App"
          redirect_to @user
        else
          render 'new'
        end
      end

      # 创建edit方法, 用来编辑用户
      def edit
        @user = User.find(params[:id])
      end

      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end



创建edit页面



_代码清单9.2: 用户编辑页面视图 app/views/users/edit.html.erb_

    <% proveide(:title, "Edit user") %>
    <h1>Update your profile</h1>

    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(@user) do |f| %>
              <%= render 'shared/error_messages' %>

              <%= f.label :name %>
              <%= f.text_field :name, class: 'form-control' %>

            <%= f.label :email %>
            <%= f.text_field :email, class: 'form-control' %>

            <%= f.label :password %>
            <%= f.password_field :password, class: 'form-control' %>

            <%= f.label :password_confirmation, "Confirmation" %>
            <%= f.password_field :password_confirmation, class: 'form-control' %>
            <%= f.submit "Save changes", class: "btn btn-primary" %>
            <%end%>

            <div class="gravatar_edit">
                <%= gravatar_for @user %>
                <a href="http://gravatar.com/emails" target="_blank">change</a>
            </div>
        </div>
    </div>

修改Gravatar头像的链接用到了target="\_blank". 目的是在新窗口或选项卡中打开这个网页, 链接到第三方网站时一般都会这么做.

用户编辑页面与用户创建页面都用了form\_for表单, 那么Rails如何知道创建新用户要发送POST请求, 而编辑页面用户时要发送PATCH请求? 通过Active Record提供的new\_record?方法检测是新创建用户还是已经存在于数据库中.

最后把导航中指向编辑用户页面的链接换成真实的地址.

_代码清单9.4: 在网站布局中设置"Settings"链接的地址 app/views/layouts/\_headder.html.erb_

    <header class="navbar navbar-firxed-top navbar-inverse">
        <div class="container">
            <%= link_to "sample app", root_path, id: "log" %>
            <nav>
                <ul class="nav navbar-nav pull-right">
                    <li><%= link_to "Home", root_path %></li>
                    <li><%= link_to "Help", help_path %></li>
                    <%if loggend_in?%>
                    <li class="dorpdown">
                        <a href="#" class="dropdown-toggle" date-toggle="dropdown">Account <b class="caret"></b></a>
                        <ul class="dorpdown-menu">
                            <li><%= link_to "Profile", current_user %></li>
                            <li><%= link_to "Seetings", edit_user_path(current_user) %></li>
                            <li class="divider"></li>
                            <li>
                                <%= <link rel="stylesheet" href="url" type="text/css" media="screen" />_to "Log out", logout_path, method: "delete" %>
                            </li>
                        </ul>
                    </li>
                    <%else%>
                    <li><%= link_to "Log in", login_path %>
                    <%end%>
                </ul>
            </nav>
        </div>
    </header>

## 9.1.2 编辑失败

编辑失败和注册失败方法差不多. 先定义update动作, 把提交的params哈希传给update\_attributes方法, 如果提交的数据无效, 更新操作返回false, 由else分支处理, 重新渲染编辑页面.

_代码清单9.5: update动作初始版本 app/controller/user\_controller.rb_

    class UsersController < Applicationcontroller
      def show
        @user = User.find(params[:id])
      end

      def new
        @user = User.new
      end

      def createp
        @user = User.new(user_params)
        if @user.save
          log_in @user
          flash[:success] = "Welcome to the Sample App!"
          redirect_to @user
        else
          render 'new'
        end
      end
      def edit
        @user = User.find(params[:id])
      end
      def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          #处理更新成功情况
        else
          render 'edit'
        end
      end
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end

## 9.1.3 编辑失败的测试

表单已经可以使用, 现在要编写集成测试捕获回归. 先生成一个集成测试文件:`rails generate integration_test Users_edit`. 之后编写编辑失败的测试.

_代码清单9.6: 编辑失败的测试 test/integration/users\_edit\_test_

    require 'test_helper'
    class UsersEditTest < ActionDispatch::IntegrationTest
      def setup
        @user = user(:michael)
      end

      test "unsucessful edit" do
        get edit_user_path(@user)
        patch User_path(@user), user: { name: '',
                                        email: 'foo@invalid',
                                        password: 'foo',
                                        password_confirmation: 'bar'
                                      }
        assert_template 'users/edit'
      end
    end

## 9.1.4 编辑成功(使用TDD)

_代码清单9.8: 编辑成功的测试 test/integration/users\_edit\_test.rb_

    require 'test_helper'
    class UsersEditTest < ActionDispatch::IntegrationTest

      def setup
        @user = user(:michael)
      end

      ...
      test "successful edit" do
        # 进入@user编辑页面
        get edit_user_path(@user)
        name = "Foo Bar"
        email = "foo@bar.com"
        # 直接给发送patch给@user地址
        patch user_path(@user), user: {
                                       name: name,
                                       email: email,
                                       password: "",
                                       password_confirmation: ""}
        assert_not flash.empty?
        assert_redirected_to @user
        @user.reload
        assert_equal @user.name, name
        assert_equal @user.email, email
      end
    end

要使代码清单9.8中的测试通过, 可以参照最终版的create动作.

_代码清单9.9: 用户控制器的update动作 app/models/user.rb_

    class UsersController < ApplicationController
      ...
      def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          flash[:success] = "Profile updated"
          redirect_to @user
        else
          render 'edit'
        end
      end
      ...
    end

测试无法通过, 因为密码长度验证失败, 为了让测试通过, 要在密码为空时特殊处理最短长度验证, 方法是把allow\_black: true传递给validates方法.

_代码清单9.10: 更新时允许密码为空 app/models/user.rb_

    class User < ActiveRecord::Base
      before_save { self.email = email.downcase }
      validates :name, presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence: true, length: { maximum: 255 }
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
      has_secure_password
      validates :password, length: { minimum: 6}, allow_blank: true
      ...
    end

# 9.2 权限系统

截止到目前为止, 任何人都能进行edit和update操作, 登陆后的用户可以更新其他用户的资料. 两种情况, 未登录用户(9.2.1节处理), 登陆用户(9.2.2节处理)

## 9.2.1 必须先登陆

对于未登录用户, 访问需要权限的功能时自动转向到登陆页面

_代码清单9.12: 添加logged\_in\_user事前过滤器 app/controller/user\_controller_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:edit, :update]
      ...
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, password_confirmation)
        end
        # 事前过滤器
        # 确保用户已经登陆
        def logged_in_user
          unless logged_in?
            flash[:danger] = "Please log in."
            redirect_to login_url
          end
        end
    end

因为已经要求先登入用户, 因此代码清单9.8中的测试需要更新.

_代码清单9.14: 登入测试用户 test/integration/user\_edit\_test.rb_

    require 'test_helper'
    class UsersEditTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:michael)
      end
      test "unsuccessful edit" do
        log_in_as(@user)
        get edit_user_path(@user)
        ...
      end
      test "successful edit" do
        log_in_as(@user)
        get edit_user_path(@user)
        ...
      end
    end

可以通过测试, 但是对事前过滤器的测试还没有完成, 即使把安全防护去掉, 测试也能通过.

_代码清单9.16: 注释掉是恰恰你过滤其, 测试安全防护措施 app/controller/users\_controller.rb_

    class UsersController < ApplicationController
      # before_action :logged_in_user, only: [:edit, :update]
      ...
    end

测试仍然能够通过. 改进UsersController的测试

_代码清单9.17: 测试edit和update动作是受保护的 test/controllers/users\_controller\_test.rb_

    require 'test_helper'

    class UsersControllerTest < ActionController::TestCase
      def setup
        @user = users(:michael)
      end

      test "should get new" do
        get :new
        assert_response :success
      end

      test "should redirect edit when not logged in" do
        get :edit, id: @user
        assert_redirected_to login_url
      end

      test "should redirect update when not logged in" do
        patch :update, id: @user, user: { name: @user.name, email: @user.email}
        assert_redirected_to login_url
      end
    end


注意get和patch的参数: `get :edit, id: @user`和`patch :update, id: @user, user: { name: @user.name, email: @user.email }`. 这里使用了一个rails的约定: 指定`id: @user`时, rails会自动使用`@user.id`, 在patch方法中还需要指定一个user哈希, 这样路由才能正常运行.

去掉事前过滤器后, 测试可以通过.

_代码清单9.18: 去掉事前过滤器的注释 略_

_代码清单9.19: 运行测试 略_

## 9.2.2 用户只能编辑自己的资料

需要第二个用户, 在fixture中加入第二个用户.

_代码清单9.20: 在固件文件中添加第二个用户 test/fixtures/users/yml_

    michael:
      name: Michael Example
      email: michael@example.com
      password_digest: <%= User.digest('password') %>

    archer:
      name: Sterling Archer
      email: duchess@example.gov
      password_digest: <%= User.digest('password) %>

我们可以先编写测试

_代码清单9.21: 尝试编辑其他用户资料的测试 test/controllers/users\_controller\_test.rb_

    require 'test_helper'
    class UsersControllerTest < ActionController::TestCase
      def setup
        @user = users(:michael)
        @other_user = users(:archer)
      end

      test "should get new" do
        get :new
        assert_response :success
      end

      test "should redirect edit when not logged in" do
        # 使用get方法, 获得:edit地址, 同时把@usere的id传递给get
        get :edit, id: @user
        assert_redirected_to login_url
      end

      test "should redirect update when not logged in" do
        patch :update, id: @user, user: { name: @user.name, email: @user.email}
        assert_redirected_to login_url
      end

      test "should redirect edit when logged in as wrong user" do
        log_in_as @other_user
        get :edit, id: @user
        assert_redirected_to root_url
      end

      test "should redirect update when logged in as wrong user" do
        log_in_as(@other_user)
        patch :update, id: @user, user: { name: @user.name, email: @user.email}
        assert_redirected_to root_url
      end
    end

需要定义一个correct\_user方法, 在事前过滤器中调用这个方法, 同时可以把@user变量赋值加入correct\_user方法中, 所以可以把edit和update动作中的@user语句删掉.

_代码清单9.22: 保护edit和update动作的correct_user事前过滤器 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:edit, :update]
      before_action :correct_user, only: [:edit, :update]
      ...
      def edit
      end
      def update
        if @user.update_attrbutes(user_params)
          flash[:success] = "Profile updated"
          redirect_to @user
        else
          render 'edit'
        end
      end
      ...
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
        # 事前过滤器
        # 确保用户已经登陆
        def logged_in_user
          unless logged_in?
            flash[:danger] = "Please log in"
            redirect_to login_url
          end
        end
        # 确保是正确用户
        def correct_user
          @user = User.find(params[:id])
          redirect_to(root_url) unless @user == current_user
        end
    end

现在测试组件应该可以通过

_代码清单9.23 运行测试 略_

可以重构一下9.22中的确保是正确用户的重定向语句, 把`unless @user == current_user`改成语义稍微明确一点的`unless current_user?(@user)`. 这就要求在helper中定义这个方法.

_代码清单9.24: current\_user?方法 app/helpers/sessions_helper.rb_

    module SessionsHleper
      # 登入制定用户
      def log_in(user)
        session[:user_id] = user.id
      end
      # 在持久会话中记住用户
      def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end
      # 如果指定用户是当前用户, 返回true
      def current_user?(user)
        user == current_user
      end
    end

这样可以得到最终满意的版本.

_代码清单9.25: correct\_user最中版本_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:edit, :update]
      before_action :correct_user, only: [:edit, :update]
      ...
      def edit
      end
      def update
        if @user.update_attributes(user_params)
          falsh[:success] = "Profile updated"
          redirect_to @user
        else
          render 'edit'
        end
      end
      ...
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
        # 事前过滤器
        # 确保用户已经登陆
        def logged_in_user
          unless logged_in?
            flash[:danger] = "Please log in"
            redirect_to login_url
          end
        end
        # 确保是正确用户
        def correct_user
          @user = User.find(params[:id])
          redirect_to(root_url) unless current_user?(@user)
        end
    end

## 9.2.3 友好的转向

假设用户想访问资料页面而又未登录, 登陆后会转到`user/1`页面, 而不是`user/1/edit`页面, 本节解决这个问题. 测试比较简单, 可以先写测试.

_代码清单9.26: 测试友好的转向 test/integration/users\_edit\_test.rb_

    require 'test_helper'
    class UserEditTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:michael)
      end
      ...
      test "successful edit with friendly forwarding" do
        get edit_user_path(@user)
        log_in_as(@user)
        assert_redirected_to edit_user_path(@user)
        name = "Foo Bar"
        email = "foo@bar.com"
        patch user_path(@user), user: { name: name,
                                        email: email,
                                        password: "foobar",
                                        password_confirmation: "foobar" }
        # 测试flash信息
        assert_not flash.empty?
        # 测试转向
        assert_redirect_to @user
        # 重新载入用户
        @user.reload
        assert_equal @user.name, name
        assert_equal @user.email, email
      end
    end

要实现友好转向, 首先需要在某个地方存储页面地址, 登陆后再转到地址.

_代码清单9.27: 实现友好转向 app/helpers/sessions\_helper.rb_

    module SessionHelper
      ...
      # 重定向到存储的地址, 或者默认的地址
      def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        # 为了确保安全, 转向后删除存储的地址
        session.delete(:fowarding_url)
      end
      # 存储以后需要获取的地址
      def store_location
        # 只有get请求中才存储, 这么做, 当未登录用户提交表单时, 不会存储转向地址.
        session[:forwarding_url] = request.url if request.get?
      end
    end

现在可以把store\_location添加logged\_in\_user事前过滤器中.

_代码清单9.28: 把store\_loaction添加到logged\_in\_user事前过滤器中 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:edit, :update]
      before_action :correct_user, only: [:edit, :update]
      ...
      def edit
      end
      ...
      private
        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
        # 事前过滤器
        # 确保用户已登陆
        def logged_in_user
          unless logged_in_user
            # 存储用户登陆前的请求地址
            store_location
            flash[:danger] = "Please log in"
            redirect_to login_url
          end
        end

        # 确保是正确用户
        def correct_user
          @user = User.find(params[:id])
          redirect_to(root_url) unless current_user?(@user)
        end
    end

在create动作中调用redirect\_back\_or方法.

_代码清单9.29: 加入友好转向后的create动作, app/controllers/sessions\_controller.rb_

    class SessionsController < ApplicationController
      ...
      def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or user
        else
          flash.now[:danger] = 'Invalid email/password combination'
          render 'new'
        end
      end
      ...
    end

之后可以通过测试组件

_代码清单9.30: 测试 略_

# 9.3 列出所有用户

添加一个新的session\_crontoller动作, index, 用来显示所有用户.

## 9.3.1 用户列表

首先要实现一个安全机制, 目前单个用户资料开放给了所有访问者, 现在要限制用户列表页面, 只让已经登陆的用户查看, 减少未注册用户能查看到的信息量. 首先编写一个简单的测试, 确认应用会正确的重定向到index动作.

_代码清单9.31: 测试index动作的重定向 test/controllers/users\_contrller\_test.rb_

    require 'test_helper'
    class UsersControllerTest < ActionController::TestCase
      def setup
        @user = users(:michael)
        @other_user = users(:archer)
      end
      test "should redirect index when not logged in" do
        get :index
        assert_redirected_to login_url
      end
      ...
    end

接下来可以定义index动作, 并把它加入被logged\_in\_user事前过滤器的保护动作中

_代码清单9.32: 访问index动作要先登陆 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update]
      before_action :correct_user, only: [:edit, :update]
      def index
      end
      def show
        @user = User.find(params[:id])
      end
      ...
    end

创建index视图

_代码清单9.34: index视图 app/views/users/index.html.erb_

    <% provide(:title, 'All users') %>
    <h1>All Users</h1>
    <ul class="users">
        <% @users.each do |user| %>
            <li>
                <%= gravatar_for user, size: 50 %>
                <%= link_to user.name, user %>
            </li>
        <%end%>
    </ul>

添加一些css样式

_代码清单9.35: 用户列表页面CSS app/assets/stylesheets/custom.css.scss_

    ...
    /* Users index */
    .users {
      list-style: none;
      margin: 0;
      li {
         overflow: auto;
         padding: 10px 0;
         border-bottom: 1px solid $gray-lighter;
      }
    }

最后还要把header导航中用户列表的连接地址换成users_path

_代码清单9.36: 添加用户列表页面的链接地址 app/views/layouts/\_header.html.erb_

    <header class="navbar navbar-fixed-top navbar-inverse">
        <div class="container">
            <%= link_to "sample app", root_path, id: "logo" %>
                <nav>
                    <ul class="nav navbar-nav pull-right">
                        <li><%= link_to "Home", root_path %></li>
                        <li><%= link_to "Help", help_path %></li>
                        <%if logged_in? %>
                            <li><%= link_to "Users", users_path %></li>
                            <li class="dropdown">
                                <a href="#", class="dropdown-toggle" data-toggle="dropdown">Account <b class="caret"></b></a>
                                <ul class="dropdown-menu">
                                    <li><%= link_to "Profile", current_user %></li>
                                    <li><%= link_to "Seetings", edit_user_path(current) %></li>
                                    <li class="divider"></li>
                                    <li>
                                        <%= link_to "Log out", logout_path, method: "delete" %>
                                    </li>
                                </ul>
                            </li>
                        <%else%>
                            <li><%= link_to "Log in", login_path %></li>
                        <%end%>
                    </ul>
                </nav>
        </div>
    </header>

可以通过测试

_代码清单9.37: 测试 略_

## 9.3.2 示例用户

添加一些示例用户, 可以使用faker gem.

_代码清单9.38: 在Gemfile中加入faker_

    source 'https://ruby.taobao.org'
    gem 'rails', '4.2.0'
    gem 'bcrypt', '3.1.7'
    gem 'faker', '1.4.2'
    ....

_代码清单9.39: 向数据库中添加示例用户的Rake任务 db/seeds.rb_

    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")

    99.times do |n|
      name = Faker:Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      # create!方法与create一样, 只是遇到无效数据后会跑出异常, 而不是返回false, 这么做出现错误时不会静默, 有利于调试.
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

首先还原数据库`bundle exec rake db:migrate:reset`. 然后添加示例用户`bundle exec rake db:seed`.

## 9.3.3 分页

目前看来所有用户全在一个页面显示, 要实现分页可以使用一个叫做will\_paginate的工具. 为此要使用will\_paginate和bootstrap-will\_paginate这两个gem.

_代码清单9.40: 在Gemfile中加入will\_paginate_

    source 'https://ruby.taobao.org'
    gem 'rails', '4.2.0'
    gem 'bcrypt', '3.1.7'
    gem 'faker', '1.4.2'
    gem 'will_paginate', '3.0.7'
    gem 'bootstrap-will_paginate', '0.0.10'
    ...

执行`bundle install`安装. 为了实现分页, 要在indexi视图中加入一些代码, 告诉rails分页显示用户, 并且要把index动作中的User.all换成知道如何分页的方法, 我们先在视图中加入特殊的will\_paginatea方法.

_代码清单9.41: 在index视图中加入分页 app/views/users/index.html.erb_

    <%provide(:title, 'All users')%>
    <h1>All users</h1>
    <%= will_paginate %>
    <ul class="users">
        <%@users.each do |user|%>
            <li>
                <%= gravatar_for user, size: 50 %>
                <%= link_to user.name, user %>
            </li>
        <%end%>
    </ul>
    <%= will_paginate %>

will\_paginate方法会在用户视图中自动寻找名为@users的对象, 然后显示一个分页导航链接. 现在视图还不能正确显示分页, 因为@users的值是通过User.all方法获取的, 而will\_paginate方法需要调用paginate方法才能分页. paginate方法可以接受一个hash参数, :page键的值指定显示第几页. User.paginate方法根据:page的值, 一次取回一组用户(默认为30), 如果:page的值为nil, paginate会显示第一页. 按照paginate的使用方法, 修改用户控制器.

_代码清单9.42; 在index动作中分页取回用户 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update]
      ...
      def index
        @users = User.paginate(page: params[:page])
      end
      ...
    end

# 9.3.4 用户列表页面的测试

首先需要在fixture中创建更多用户用来测试分页情况.

_代码清单9.43: 在fixtures中再创建30个用户 test/fixtures/users.yml_

    michael:
      name: Michael Example
      email: michael@example.com
      pssword_digest: <%= User.digest('password') %>
    archer:
      name: Sterling Archer
      email: duchess@example.gov
      password_digest: <%= User.digest('password') %>
    lana:
      name: Lana Kane
      email: hands|@example.gov
      password_digest: <%= User.digest('password') %>
    mallory:
      name: Mallory Archer
      email: boss@example.gov
      password_digest: <%= User.digest('password') %>
    <%30.times do |n|%>
    user_<%= n %>:
      name: <%= "User #{n}" %>
      email: <%= "user-#{n}@example.com" %>
      password_digest: <%= Users.digest('password') %>
    <%end%>

创建了用户以后, 可以编写测试了. 首先生成所需的测试文件`rails generate integration_test users_index`.

_代码清单9.44: 用户列表及分页的测试 test/integration/users\_index\_test.rb_

    require 'test_helper'
    class UserIndexTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:michael)
      end
      test "index including pagination" do
        log_in_as(@user)
        get users_path
        assert_template 'users/index'
        assert_select 'div.pagination'
        User.paginate(page: 1).each do |user|
          assert_select 'a[href=?]', user_path(user), text: user.name
        end
      end
    end

最后进行测试.

_代码清单9.45: 测试 略_

## 9.3.5 使用布局视图重构

用户列表已经可以实现分页了, rails提供了一些很巧妙的方法, 可以精简视图的结构. 重构的第一步把*代码清单9.41*中的li换成render方法调用.

_代码清单9.46: 重构用户列表视图的第一步 app/views/users/index.html.erb_

    <%provide(:title,'All users')%>
    <h1>All users</h1>
    <%= will_paginate %>
    <ul class="users">
        <%@users.each do |user|%>
          <%= render user %>
        <%end%>
    </ul>
    <%= will_paginate %>

在上述代码中, render的参数不再是制定局部视图的字符串, 而是代表User类的变量user. 此时, rails会自动寻找一个名为\_user.html.erb的局部视图. 我们要手动闯将这个视图, 然后写入下面的内容.

_代码清单9.47: 显示单个用户的局部视图 app/views/users/\_user.html.erb_

    <li>
        <%= gravatar_for user, size:50 %>
        <%= link_to user.name, user%>
    </li>

这个改进不错, 但是可以做的更好, 直接把@users传给render, 如下所示.

_代码清单9.48: 完全重构后的用户列表视图 app/views/users/index.html.erb_

    <%provide(:title, 'All users')%>
    <h1>All users</h1>
    <%= will_paginate %>
    <ul class="users">
        <%= render @users %>
    </ul>
    <%= will_paginate %>

rails会把@users当做一个User对象列表, 传递给render方法后, rails会自动遍历这个列表, 然后使用局部视图\_user.html.erb渲染每个对象. 最后进行测试确保测试组件仍能通过.

_代码清单9.49: 测试 略_

# 9.4 删除用户

用户列表完成了, 符合REST架构的用户资源只剩最后一个--destroy动作. 首先添加删除用户链接, 然后编写destroy动作, 完成删除操作. 不过首先要创建管理员级别的用户, 并授权这些用户执行删除动作.

## 9.4.1 管理员

需要给UserModel添加一个名为admin的属性来标示用户是否有管理员权限, admin属性的类型为boolean. `rails generate migration add_admin_to_users admin:boolean`.

_代码清单9.50: 向用户模型中添加admin属性的迁移 db/migrate/[timestamp]\_add\_admin\_to\_users.rb_

    class AddAdminToUsers < ActiveRecord::Migration
      def change
        add_column :users, :admin, :boolean, default: false
      end
    end

像往常一样执行迁移`bundle exec rake db:migrate`. rails能自动识别admin属性的类型为boolean, 自动生成admin?方法. 最后需要修改生成的示例用户代码, 把第一个用户设为管理员, 如下所示.

_代码清单9.51: 在生成示例用户的代码中把第一个用户设为管理员 db/seeds.rb_

    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

然后重置数据库`bundle exec rake db:migrate:rest`, 重新创建示例用户`bundle exec rake db:seed`

健壮参数再探

在上例中, 初始化hash参数指定了admin: true, 用户对象是暴露在网络中的, 如果请求中提供初始化参数, 恶意用户会发送`patch /users/17?admin=1`这样就把17号用户设置为管理员. 这是一个严重的潜在安全隐患. 因此, 必须只允许通过请求传入可安全编辑的属性, 如同7.3.2节说过的那样. 千万不要把admin加入user_params中!!

## 9.4.2 destroy动作

在用户列表的每个用户后面加入一个删除链接, 只有管理员才能看到这个链接, 也之有管理员能够执行删除操作. 首先来实现视图.

_代码清单9.52: 删除用户的链接(只有管理员才能看到) app/views/users/\_user.html.erb_

    <li>
        <%= gravatar_for user, size: 50 %>
        <%= link_to user.name, user %>
        <%if current_user.admin? && !current_user?(user)%>
          | <%= link_to "delete", user, mithod: :delete, data: { confirm: "You sure?"} %>
        <%end%>
    </li>

浏览器无法发送DELETE请求, rails通过JavaScript模拟, 如果用户禁止了JavaScript, 那么删除用户的链接无法使用, 为了支持没有启用JavaScript的浏览器, 可以使用一个发送POST请求的表单来模拟DELETE请求(自己寻找资料).

在用户控制器中加入destroy动作. 在destroy动作中, 先找到要删除的用户, 然后使用ActiveRecord提供的destroy方法将其删除. 此外, 要删除用户, 必须是登录以后, 所以在logged\_in\_user事前过滤器中加入了:destroy.

_代码清单9.53: 添加destroy动作 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
      before_action :correct_user, only: [:edit, :update]
      ...
      def destroy
        User.find(paramsp[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
      end
      ...
    end

理论上只有管理员可以看到删除用户链接, 但是存在一个安全漏洞, 攻击者可以在命令行中发送, 删除网站中的任何用户, 为了解决这个问题, 限制destroy动作只有管理员可以访问.

_代码清单9.54: 限制只有管理员才能访问destroy动作的事前过滤器 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
      before_action :correct_user, only: [:edit, :update]
      before_action :admin_user, only: :destroy
      ...
      private
      ...
      # 确保是管理员
      def admin_user
        redirect_to(root_url) unless current_user.admin?
      end
    end

## 9.4.3 删除用户的测试

像删除用户这样危险的操作, 事前编写测试. 先要把fixtures中的一个用户设为管理员.

_代码清单9.55: 把一个用户固件设为管理员 test/fixtures/users.yml_

    michael:
      name: Michael Example
      email: michael@example.com
      password_digest: <%= User.digest('password') %>
      admin: true
    archer:
      name: Sterling Archer
      email: duchess@example.gov
      password_digest: <%= User.digest('password') %>
    lana:
      name: Lana Kane
      email: hands@example.gov
      password_digest: <%= User.digest('password') %>
    mallory:
      name: Mallory Archer
      email: boss@wxample.gov
      password_digest: <%= User.digest('password') %>
    <% 30.times do |b| %>
    user_<%= n %>
      name: <%= "User #{n}" %>
      email: <%= "user-#{n}@example.com "%>
      password_digest: <%= User.digest('password') %>
    <% end%>

按照9.2.1节的做法, 我们会把限制访问动作的测试放在用户控制器测试文件中, 使用delete方法直接想destroy动作发送DELETE请求, 检查两种情况:

1. 没登陆的用户会重定向到登陆页面
2. 已经登陆的用户, 不是管理员, 会重定向到首页.

_代码清单9.56: 测试只有管理员能访问的动作 test/controllers/users\_controller\_test.rb_

    require 'test_helper'
    class UsersControllerTest < ActionController::TestCase
      def setup
        @user = users(:michael)
        @other_user = users(:archer)
      end
      ...
      test "should redirect destroy when not logged in" do
        assert_no_difference 'User.count' do
          delete :destroy, id: @user
        end
        assert_redirected_to login_url
      end
      test "should redirect destroy when logged in as a non-admin" do
        log_in_as(@other_user)
        assert_no_difference 'User.count' do
          delete :destroy, id: @user
        end
        assert_redirected_to root_url
      end
    end

上面的测试完成了未授权用户的删除测试. 另外还要确认管理员点击删除连接后能够删除用户, 因此删除链接是在index页面, 因此将这个测试添加到index测试中.

_代码清单9.57: 删除链接和删除用户操作的集成测试 test/integration/users\_index\_test.rb_

    require 'test_helper'
    class UsersIndexTest < ActionDispatch::IntegrationTest
      def setup
        @admin = users(:michael)
        @non_admin = users(:archer)
      end
      test "index as admin including pagination and delete links" do
        log_in_as(@admin)
        get users_path
        assert_template 'users/index'
        assert_select 'div.pagination'
        first_page_of_users = User.paginate(page: 1)
        first_page_of_users.each do |user|
          assert_select 'a[href=?]', user_path(user), text: user.nmae
          unless user == @admin
            assert_select 'a[href=?]', user_path(user), test: 'delete', method: :delete
          end
        end
        assert_difference 'User.count', -1 do
          delete user_apth(@non_admin)
        end
      end
      test "index as non-admin" do
        log_in_as(@non_admin)
        get users_path
        assert_select 'a', text: 'delete', count: 0
      end
    end

最后进行测试

_代码清单9.58: 测试 略_

# 9.5 小结

从数据库取出用户的时候由于生产环境和本地环境的不同, 可能影响其顺序. 对于用户列表来说问题不大, 如果对于微博而言, 就是很大的影响, 这个问题将在11.1.4节解决.

## 9.5.1 读完本章学到了什么

* 可以使用编辑表单修改用户的资料, 这个表单向update动作发送PATCH请求
* 为了诶生通过web修改信息的安全性, 必须使用"健壮参数"
* 事前过滤器是在控制器动作前执行方法的标准方式
* 我们使用事前过滤器实现了权限系统
* 针对权限系统的测试既使用了底层命令直接向控制器动作发送适当的HTTP请求, 也使用了高层的集成测试
* 友好转向会在用户登陆后重定向到之前想访问的页面
* 用户列表页面列出了所有用户, 而且一页只显示一部分用户
* rails使用标准的文件db/seeds.rb向数据库中添加示例数据, 这个操作使用`rake db:seed`任务完成
* `render @users`会自动调用\_user.heml.erb局部视图, 渲染集合中的各个用户
* 在用户模型中添加admin布尔值属性后, 会自动创建user.admin?布尔值方法
* 管理员点击删除链接可以删除用户, 点击删除连接后会向用户控制器的destroy动作发起DELETE请求
* 在固件中可以使用嵌入式ruby创建大量测试用户

# 9.6 练习


# 10.1 账户激活

实现步骤:

1. 用户开始处于"未激活"状态

2. 用户注册后, 生成一个activation_token和对应的activation_digest

3. 把activation_digest存储在数据库中(activation_token只是一个临时属性, 不存储在数据库中), 然后发送一个包含activation_token和user email的链接

4. 用户点击这个连接后, 使用user email查找用户, 并且对比token和digest.

5. 如果token和digest匹配, 就把状态由"未激活"改为"激活"

|查找方式|字符串|摘要|认证|
|------|---|----|----|
|email|password|password_digest|authenticate(password)|
|id|remember_token|remember_digest|authenticate?(:remember, token)|
|email|activation_token|activation_digest|authenticate?(:activation, token)|
|email|reset_token|reset_digest|authenticate?(:reset, token)|

## 10.1.1 资源

和session一样, 可以把"账户激活"看做一个资源, 不过这个资源不对应模型, 相关的数据(activation_digest和activation)存储在User Model中. 需要通过标准的REST URL处理账户激活邮件, 激活链接会改变用户的状态, 所以在edit动作中处理. 首先生成控制器

    rails generate controller AccountActivations

我们需要使用下面这个方法生成一个URL, 放在激活邮件中

    edit_account_activation_url(activation_token, ...)

为此我们要为edit动作设定一个具名路由, 高亮代码显示

_代码清单10.1: 添加账户激活所需的资源路由 config/routest.rb_

    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#about'
      get 'contact' => 'static_pages#contact'
      get 'signup' => 'users#new'
      get 'login' => 'sessions#new'
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
      resources :users
      resources :account_activation, only: [:edit]
    end

和remember\_me相同, 公开令牌, 在数据库中存储摘要. 这么做可以使用`user.activation_token`获得token, 使用`user.authenticated?(:activation, token)`进行用户认证. 同时还要定义一个返回boolean的方法, 用来检查用户激活状态`if user.activated?`

|users||
|--|--|
|id|integer|
|name|string|
|email|string|
|created\_at|datetime|
|updated\_at|datetime|
|password\_digest|string|
|remember\_digest|string|
|admin|boolean|
|activation\_digest|string|
|activated|boolean|
|activated_at|datetime|

添加需要的三个属性

    rails generate migration add_activation_to_users activation_digest:string activated:boolean activated_at:datetime

和admin一样, 需要把activated属性默认设置为false

_代码清单10.2: 添加账户激活所需属性的迁移 db/migrate/[timestamp]\_add\_activation\_users.rb_

    class AddActivationToUsers < ActivaRecord::Migration
      def change
        add_column :users, :activation_digest, :string
        add_column :users, :activated, :boolean, default: false
        add_column :users, :activated_at, :datetime
      end
    end

执行迁移`bundle exec rake db:migration`

每个新注册的用户都需要激活, 应该在创建用户对象前分配激活令牌和摘要. 之前在存储email前会使用before\_save回调, 类似的, 可以使用before\_create回调, 按照下面的方式定义:

    before_create :create_activation_digest

与之前的before\_save调用不同, 上树代码采用方法引用. Rails会自动寻找一个名为create\_activation\_digest的方法, 在创建用户之前调用. 方法引用是推荐, 后面会重before\_save. 而create\_activation\_digest方法只会在用户模型中使用, 没有必要公开, 可以用private实现.

_代码清单10.3: 在用户模型中添加账户激活相关的代码 app/models/user.rb_

    class User < ActiveRecord::Migration
      attr_accessor :remember_token, :activation_token
      before_save :downcase_email
      before_create :create_activation_digest
      validates :name, presence: true, length: { maximum: 50 }
      ...
      private
        # 将email地址转换成小写
        def downcase_email
          self.email = email.downcase
        end

        # 创建并赋值激活令牌和摘要
        def create_activation_digest
          self.activation_token = User.new_token
          self.activation_digest = User.digest(activation_token)
        end
    end

还需要修改seeds文件

_代码清单10.4 激活种子数据中的用户 db/seeds.rb_

    User.create!(name: "Examole User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true,
                 activated:boolean true,
                 activated_at:datetime: Time.zone.now)
    99.times do |n|
        name = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        User.create!(name: name,
                     emails: email,
                     password: password,
                     password_confirmation: password,
                     activated:true,
                     activated_at: Time.zone.now)
    end

 _代码清单10.5: 激活固件中的用户 test/fixtures/users.yml_

    michael:
      name: Michael Example
      email: michael@example.com
      password_digest: <%= User.digest('password') %>
      admin: true
      activated: true
      activated_at: <%= Time.zone.now %>

    archer:
      name: Sterling Archer
      email: duchess@example.gov
      password_digest: <%= User.digest('password') %>
      activated: true
      activated_at: <%= Time.zone.now %>

    lana:
      name: Lana Kane
      email: hands@example.gov
      password_digest: <%= User.digest('password') %>
      activated: true
      activated_at: <%= Time.zone.now %>

    mallory:
      name: Mallory Archer
      email: boss@example.gov
      password_digest: <%= User.digest('password') %>
      activated: true
      activated_at: <%= Time.zone.now %>

    <% 30.times do |n| %>
    user_<%= n %>
      name: <%= "User #{n}" %>
      email: <%= "user-#{n}@example.com" %>
      password_digest: <%= User.digest('password') %>
      activated: true
      activated_at: <%= Time.zone.now %>
    <% end %>

## 10.1.2 邮件程序

创建邮件程序, 生成了account\_activation和password\_reset程序.

    rails generate mailer UserMailer account_activation password_reset

此外还生程了两个视图模板, 一个用于HTML邮件, 另一个用于纯文本文件.

_代码清单10.6: 生成的账户激活邮件视图, 纯文本格式 app/views/user\_mailer/account\_activation.text.erb_

    <h1>UserMailer#account_activation</h1>

    <p>
        <%= @greeting %>, find me in app/views/user_mailer/account_activation.html.erb
    </p>

生成的邮件程序

_代码清单10.8: 生成的UserMailer app/mailers/user\_mailer.rb_

    class UserMailer < ActionMailer::Base
      default form: "from@example.com"

      def account_activation
        # 传递给邮件视图中的实例变量
        @greeting = "Hi"

        mail to: "to@example.org"
      end

      def password_reset
        # 传递给邮件视图中的实例变量
        @greeting = "Hi"

        mail to: "to@example.org"
      end
    end

为了发送激活邮件, 需要是用户对象的实例变量, 以便在视图中使用, 然后把邮件发送给user.email. mail法方法可以几首subject参数, 以便制定邮件的主题.

_代码清单10.9: 发送账户激活链接 app/mailer/user\_mailer.rb_

    class UserMailer <actionMailer::Base
      default from: "noreply@example.com"

      def account_activation(user)
        # 需要在视图中使用的用户对象的实例变量
        @user = user
        mail to: user.email, subject: "Account Activation"
      end

      def password_reset
        @greeting = "Hi"

        mail to: "to@example.org"
      end
    end

接下来要在视图中添加一个欢迎消息, 以及一个激活链接. 计划使用email地址来查找用户, 然后用激活令牌认证用户, 所以连接重应包含email地址和令牌, 因为把"账户激活"视为一个资源, 可以把令牌作为参数传给具名路由

    edit_account_activation_url(@user.activation_token, ...)

我们已经知道edit\_user\_url(user)生成地址为:

    http://www.example.com/users/1/edit

那么, 激活账户链接应该是

    http://www.example.com/account_activations/[activation_token]/edit

其中的activation\_token是使用new\_token方法生成的base64字符串, 可安全的在URL中使用. 这个值的作用和/user/1/edit中的用户ID一样, 在AccountActivationsController的edit动作中可以通过params[:id]来获取.

为了包含电子邮件地址, 需要使用"查询参数"(query parameter), query parameter在URL中的问号后面, 使用键值对形式指定:

    account_activations/[activation_token]/edit?email=foo%40example.com

email中的@符号被转移了, 这样URL才是有效的. 在Rails中定义query parameter的方法是把一个hash传递给具名路由:

    edit_account_action_url(@user.activation_token, email: @user.email)

这种发放rails会自动转义特殊字符, 并且在controller中反转义, 通过params[:email]可以获取电子邮件地址.

了解了这些之后就可以编辑邮件视图了.

_代码清单10.10: 账户激活邮件的纯文本视图 app/views/user\_mailer/account\_activation.text.erb_

    Hi <%= @user.name %>
    Welcome to the Sample App! Click on the link below to activate your account:
    <%= edit_account_activation_url(@user.activation_token, email: @user.email) %>

_代码清单10.11: 账户激活的HTML视图 app/views/user\_mailer/account\_activation.html.erb_

    <h1>Sample App</h1>
    <p>Hi <%= @user.name %>,</p>
    <p>Welcome to the Sample App! Click on the link below to activate your account:</p>
    <%= link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email) %>

为了看到邮件效果, 可以使用邮件预览功能, rails提供了一些特殊的URL用来预览邮件. 首先要在应用的开发环境中添加设置.

_代码清单10.12: 开发环境中的邮件设置 config/enviroments/development.rb_

    Rails.application.configure do
      ...
      config.action_mailer.raise_delivery_errors = true
      config.action_mailer.delivery_method = :test
      host = 'example.com'
      config.action_mailer.default_url_options = { host: host }
      ...
    end

主机的地址'example.com'应是开发环境的主机地址, 例如下面的云端IDE和本地服务器:

    host = 'rails-tutorial-c9-mhartl.c9.io' # 云端IDE
    host = 'localhost:3000' # 本地主机

重启rails服务器使配置生效. 接下来修改邮件程序的预览文件, 生成邮件时已经自动生成了这个文件.

_代码清单10.13: 生成的邮件预览程序 test/mailer/previews/user\_mailer\_preview.rb_

    # preview all email at http://localhost:3000/rails/mailers/user_mailer
    class
      # Preview this email at
      # http://localhost:3000/rails/mailers/user_mailer/account_activation
      # 最初生成的邮件预览程序, account_activation方法缺少参数传入.
      def account_activation
        UserMailer.account_activation
      end

      # Preview this email at
      # http://localhost:3000/rails/mailers/user_mailer/password_reset
      def password_reset
        UserMailer.password_reset
      end
    end

UserMailer中的account\_activation方法需要一个有效的用户作为参数, 把开发书库中的第一个用户赋值给它, 然后作为参数传递给UserMailer.account\_activation.

_代码清单10.14: 预览账户激活邮件所需的方法 test/mailers/previews/user\_mailer\_preview.rb_

    # Preview all emails at http://localhost:3000/rails/mailers/user_mailer
    class UserMailerPreview < ActionMailer::Preview
      def account_activation
        user = User.first
        # 新生成一个token只是用来预览, 因此预览页面内的地址并不是真正有效的.
        user.activation_token = User.new_token
        UserMailer.account_activation(user)
      end
        ...
    end

最后编写测试, 确认邮件内容

_代码清单10.15: Rails生成的UserMailer测试 test/mailers/user\_mailer\_test.rb_

    require 'test_helper'
    class UserMailerTest < ActionMailer::TestCase
      test "account_activation" do
        mail = UserMailer.account_activation
        assert_equal "Account activation", mail.subject
        assert_equal ["to@examole.org"], mail.to
        assert_equal ["from@example.com"], mail.from
        assert_match "Hi", mail.body.encoded
      end
      test "password_reset" do
        mail = UserMailer.password.reset
        assert_equal "Password reset", mail.subject
        assert_equal ["to@example.org"], mail.to
        assert_equal ["from@example.com"], mail.form
        assert_match "Hi", mail.body.encoded
      end
    end

代码清单10.15中使用了强大的assert_match方法, 这个方法既可以匹配字符串, 也可以匹配正则表达式.

    assert_match 'foo', 'foobar' # true
    assert_match 'baz', 'foobar' # false
    assert_match /\w+/, 'foobar' # true
    assert_match /\w+/, '$#@!^&' # false

_代码清单10.16: 测试现在这个邮件程序 test/mailers/user\_mailer\_test.rb_

    require 'test_helper'
    class UserMailerTest < ActionMailer::TestCase
      test "account_activation" do
        user = users(:michael)
        user.activation_token = User.new_token
        mail = UserMailer.account_activation(user)
        assert_equal "Account activation", mail.subject
        assert_equal [user.email], mail.to
        assert_equal ["noreply@example.com"], mail.from
        assert_match user.name, mail.body.encoded
        assert_match user.activation_token, mail.body.encoded
        # CGI:escape()方法用来转义
        assert_match CGI::escape(user.email), mail.body.encoded
    end

在这个测试中为fixture指定了activation_token, 而fixture中没有虚拟属性. 为了让测试通过, 需要修改测试环境配置.

_代码清单10.17: 设定测试环境的主机地址 config/enviroments/test.rb_

    Rails.application.configure do
      ...
      config.action_mailer.delivery_method = :test
      config.action_mailer.default_url_options = { host: 'example.com' }
      ...
    end

现在可以通过了

_代码清单10.18: 测试 略_

记下来可以把邮件程序添加到应用中, 只需要在Model::User#create中添加几行.

_代码清单10.19: 在注册过程中添加账户激活 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      ...
      def create
        @user = User.new(user_params)
        if @user.save
          UserMailer.account_activation(@user).deliver_now
          flash[:info] = "Please check your email to activate your account"
          redirect_to root_url
        else
          render 'new'
        end
      end
      ...
    end

现在注册后重新定向到root_url而不是users/show, 并且不会自动登陆, 所以测试不会通过.

_代码清单10.20: 临时注释掉失败的测试 test/integration/users\_signup\_test.rb_

   require 'test_helper'
   class UsersSignupTest < ActionDispatch::IntegrationTest
     test "invalida signup information" do
       get signup_path
       assert_no_difference 'User.count' do
         post users_path, user: { name: "",
                                  email: "user@invalid",
                                  password: "foo",
                                  password_confirmation: "bar"}
       end
       assert_template 'users/new'
       assert_select 'div#error_explanation'
       assert_select 'div.field_with_errors'
     end
     test "valid signup information" do
       get signup_path
       assert_difference 'User.count' 1 do
         post_via_redirect users_path, user: { name: "Example User",
                                               email: "user@example.com",
                                               password: "password",
                                               password_confirmation: "password"}
       end
       # 暂时先注释掉测试代码
       # assert_template 'users/show'
       # assert is_logged_in?
     end
   end

现在注册后会转向root_url, 并且会生成一封邮件, 在开发环境中并不会真发送邮件, 不过能在服务器日志中看到.

_代码清单10.21: 在服务器日志中看到的账户激活邮件_

    Sent mail to michael@michaelhartl.com (931.6ms)
    Date: Wed, 03 Sep 2014 19:47:18 +0000
    ....

## 103.1.3 激活账户

完成了邮件后, 要编写AccountActivationsController中的edit动作, 激活账户. 上节说过, activation_token和email可以从params[:id]和params[:email]获取. 参照密码和记忆令牌实现方式, 计划这样查找和认证用户:

    user = User.find_by(email: params[:email])
    # 缺少一个判断条件
    if user  user.authenticated?(:activation, params[:id])

代码中的authenticated?()方法和现在的还有差别, 现在的authenticated?方法是专门用来认证remember_token的.

    # 如果指定的令牌和摘要匹配, 返回true
    def authenticated?(remember_token)
      return false if remember_digest.nil?
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

重构这个方法, 使用途更广

_代码清单10.22: 用途更广的authenticated?方法 app/models/user.rb_

   class User < ActiveRecord::Base
     ...
     # 如果指定的令牌和摘要匹配, 返回true
     def autheticated?(attribute, token)
       digest = send("#{attribute}_digest")
       return false if digest.nil?
       BCrypt::Password.new(digest).is_password?(token)
     end
     ...
   end

_代码清单10.23: 测试 略_

测试失败, 原因是remember_me还是使用以前的authenticated?发放.

_代码清单10.24: 在current\_user中使用修改后的authenticated?发放 app/helpers/session\_helper.rb_

    module SessionsHelper
      ...
      # 返回当前已登陆的用户(如果有的话)
      def current_user
        if (user_id = session[:user_id])
          @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
          user = User.find_by(id: user_id)
          if user && user.authenticated?(:remember, cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end
      end
      ...
    end

_代码清单10.25: 在UserTest中使用修改后的authenticated?方法 test/models/user\_test.rb_

    require 'test_helper'
    class UersTest < ActiveSupport::TestCase
      def setup
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
      end
      ...
      test "authenticate? should return false for a user with nil digest" do
        assert_not @user.authenticated?(:remember, '')
      end
    end

修改后测试可以通过

_代码清单10.26: 测试 略_

有了重构后的authenticated?方法, 现在可以编写edit动作了.

_代码清单10.27: 在edit动作中激活账户 app/controllers/account\_activation\_controller.rb_

    class AccountActivationsController < ApplicationController
      def edit
        user = User.find_by(email: params[:email])
        if user && !user.acitvated? && user.authencated?(:activation, params[:id])
          user.update_attribute(:activated, true)
          user.update_attribute(:activated_at, Time.zone.now)
          log_in user
          flash[:success] = "Account activated!"
          redirect_to user
        else
          flash[:danger] = "Invalid activation link"
          redirect_to root
        end
      end
    end

然后将服务器日志里的url复制到浏览器中, 就可以激活对应账户了. 注意邮件预览中的url并不是真正的激活url.

现在激活账户还没有实际效果, 因为还没有修改登陆方式.

_代码清单10.28: 禁止未激活的用户登陆 app/controllers/session\_controller.rb_

    class SessionsController < ApplicationController
      def new
      end
      def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
          if user.activated?
            log_in user
            params[:session][:remember_me] == '1' ? remember(user) : forget(user)
            redirect_back_or user
          else
            message = "Account not activated"
            message += "Check your email for the activation link."
            flash[:warning] = message
            redirect_to root_url
          end
        else
          flash.now[:danger] = 'Invalid email/password combination'
          render 'new'
        end
      end
      def destroy
        log_out if logged_in?
        redirect_to root_url
      end
    end

## 10.1.4 测试和重构

本节为账户激活功能添加一些测试, 并将这些测试加入注册测试中.

_代码清单10.29: 在用户注册的测试文件中添加账户激活的测试 test/integration/users\_signup\_test.rb_

    require 'test_helper'
    class UsersSignupTest < ActionDispatch::IntegrationTest
      def setup
        # ActionMailer::Base.deliveries用来存放已发送邮件数目
        # 提前清空发送数目, 以便后面测试
        ActionMailer::Base.deliveries.clear
      end

      test "invalid signup information" do
        get signup_path
        assert_no_difference 'User.count' do
          post users_path, user: { name: "",
                                   email: "user@invalid",
                                   password: "foo",
                                   password_confirmation: "bar" }
        end
        assert_template 'users/new'
        assert_select 'div#error_explanation'
        assert_select 'div.field_with_errors'
      end
      test "valid signup information with account activation" do
        get signup_path
        assert_difference 'User.count', 1 do
          post users_path, user: { name: "Example User",
                                   email: "user@example.com",
                                   password: "password",
                                   password_confirmation: "password" }
        end
        assert_equal 1, ActionMailer::Base.deliveries.size
        # assigns用来获取相应动作中的实例变量.
        user = assigns(:user)
        assert_not user.activated?
        # 尝试在激活前登陆
        log_in_as(user)
        assert_not is_logged_in?
        # 激活令牌无效
        get edit_account_activation_path("invalid token")
        assert_not is_logged_in?
        # 令牌有效, 电子邮件无效
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        assert_not is_logged_in?
        # 激活令牌有效
        get edit_account_activation_path(user.activation_token, email: user.email)
        assert user.reload.activation?
        follow_redirect!
        assert_template 'users/shwo'
        assert is_logged_in?
      end
    end

_代码清单10.30: 测试 略_

有了测试后, 就可以做一下重构: 把处理用户的代码从控制器中移出, 放入模型, 我们会定义一个activate方法, 用来更新用户激活的属性; 还要定义一个send\_activation\_email方法, 发送激活邮件.

_代码清单10.31: 在用户模型中添加账户激活相关的方法 app/model/user.rb_

    class User < ActiveRecord::Base
      ...
      # 激活账户
      def activate
        update_attribute(:activated, true)
        update_attribute(:actvated_at, Time.zone.now)
      end

      # 发送激活邮件
      def send_activation_email
        UserMailer.account_activation(self).deliver_now
      end

      private
      ...
    end

_代码清单10.32: 通过用户模型对象发送邮件 app/controller/users\_controller.rb_

    class UsersController < ApplicationController
      def create
        @user = User.new(user_params)
        if @user.save
          @user.send_activation_email
          flash[:info] = "Please check your email to activate your account."
          redirect_to root_url
        else
          render 'new'
        end
      end
      ...
    end

_代码清单10.33: 通过用户模型对象激活账户 app/controllers/account\_activations\_controller.rb_

    class AccountActivationsController < ApplicationController
      def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
          user.activate
          log_in user
          flash[:success] = "Account activated!"
          redirect_to user
        else
          flash[:danger] = "Invalid activation link"
          redirect_to root_url
        end
      end
    end

# 10.2 密码重设

密码重置过程:
1. 在登陆表单中添加"forgot password"链接.

2. "forgot password"转向一个表单, 要求提交email, 之后向这个地址发送一封包含密码重置链接的邮件.

3. 密码重置链接会转向一个表单, 这个表单含有重置密码以及密码确认.

主要步骤:

1. 用户请求重设密码时, 使用提交的电子邮件地址查找用户;

2. 如果数据库中有这个电子邮件地址, 生成一个重设令牌和对应的摘要;

3. 把重设摘要保存在数据库中, 然后给用户发送一封邮件, 其中一个包含重设令牌和用户电子邮件地址的链接;

4. 用户点击这个链接后, 使用电子邮件地址查找用户, 然后对比令牌和摘要;

5. 如果匹配, 显示重设密码的表单

## 10.2.1 资源

和账户激活一样, 重设密码也看做一个资源, 首先要为资源生成控制器:

    rails generate controller PasswordResets new edit --no-test-framework

注意, 我们不需要控制器测试(使用集成测试), 所以没有生成测试框架.

我们需要两个表单, 一个请求重设表单, 一个修改用户模型中的密码, 所以要为new, create, edit和update四个动作制定路由.

_代码清单10.35: 添加"密码重设"资源的路由 config/routes.rb_

    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#about'
      get 'contact' => 'static_pages#contact'
      get 'signup' => 'user#new'
      get 'login' => 'sessions#new'
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
      resources :users
      resources :account_activations, only: [:edit]
      resources :password_resets, only: [:new, :create, :edit, :update]
    end


HTTP请求|URL|动作|具名路由
--|--|--|--
GET|/password\_reset/new|new|new\_password\_reset\_path
POST|/password\_resets|create|password\_reset\_path
GET|/password\_resets/\<token\>/edit|edit|edit\_password\_reset\_path(token)
PATCH|/password_resets/\<token\>|update|password\_reset\_path(token)

_代码清单10.36: 添加打开忘记密码表单的链接 app/views/sessions/new.html.erb_

    <% provide(:title, "Log in") %>
    <h1>Log in</h1>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(:session, url: login_path) do |f| %>

              <%= f.label :email %>
              <%= f.text_field :email, class: 'form-control' %>

              <%= f.label :password %>
              <%= link_to "(forgot password)", new_password_reset_path %>
              <%= f.password_field :passsword, class: 'form-control' %>

              <%= f.label :remember_me, class: "checkbox inline" do %>
                <%= f.check_box :remember_me %>
                <span>Remember me on this computer</span>
              <% end %>

              <%= f.submit "Log in", class: "btn btn-primary" %>
            <% end %>
            <p>New user? <%= link_to "Sign up now!", signup_path %></p>
        </div>
    </div>

密码所需的数据模型和账户激活的类似, 需要一个虚拟的重设令牌属性, 在密码重设邮件中使用, 一个重设摘要属性, 用来取回用户. 同时计划让重设链接几小时后失效, 因此需要记录邮件发送时间.

|user||
|--|--|
id|integer
name|string
email|string
created\_at|datetime
updated\_at|datetime
password\_digest|string
remember\_digest|string
admin|boolean
activation\_digest|string
activated|boolean
activated\_at|datetime
reset\_digest|string
reset\_sent\_at|datetime

添加这两个属性的迁移

    rails generate migration add_reset_to_users reset_digest:string reset_sent_at:datetiem
    bundle exec rake db:migrate

## 10.2.2 控制器和表单

password\_reset和session一样, 都是没有模型的资源, 因此表单可以参考登陆表单.

_代码清单10.37: 登陆表单的代码 app/views/sessions/new.html.erb 略_

_代码清单10.38: 请求重设密码页面的视图 app/views/password\_reset/new.html.erb_

    <% provide(:title, "Forgot password") %>
    <h1>Forgot password</h1>
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(:password_set, url: password_resets_path) do |f| %>
              <%= f.label :email %>
              <%= f.text_field :email, class: 'form-control' %>

              <%= f.submit "Submit", class: "btn btn-primary" %>
            <% end %>
        </div>
    </div>

提交后通过电子邮件查找用户, 更新这个用户的reset\_token, reset\_digest和reset\_sent\_at属性, 然后重定向到根地址,
并显示一个闪现消息. 如果提交的消息无效, 重新渲染这个页面, 并且显示一个flash.now消息. 根据要求可以写出create代码.

_代码清单10.39: PasswordResetController的create动作 app/controllers/password\_resets\_controller.rb_

    class PasswordResetsController
      def new
      end
      def create
        @user = User.find_by(email: params[:password_reset][:email].downcase)
        if @user
          @user.create_reset_digest
          @user.send_password_reset_email
          flash[:info] = "Email sent with password reset instructions"
          redirect_to root_url
        else
          flash.now[:danger] = "Email address not found"
          render 'new'
        end
      end

      def edit
      end
    end

上述代码调用了create\_reset\_digest方法, 需要在用户模型中定义.

_代码清单10.40: 在用户模型中添加重设密码所需的方法 app/models/user.rb_

    class User < ActiveRecord::Base
      attr_accessor :remember_token, :activation_token, :reset_token
      before_save :downcase_email
      before_create :create_activation_digest
      ...
      # 激活账户
      def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
      end

      # 发送激活邮件
      def send_activation_email
        UserMailer.account_activation(self).deliver_now
      end

      # 设置密码重设相关的属性
      def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
      end

      # 发送密码重设邮件
      def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
      end

      private

        # 把电子邮件地址转成小写
        def downcase_email
          self.email = email.downcase
        end

        # 创建并赋值激活令牌和摘要
        def create_activation_digest
          self.activation_token = User.new_token
          self.activation_digest = User.digest(activation_token)
        end
    end

## 10.2.3 邮件程序

上段代码中发送密码重设邮件的代码为

    UserMailer.password_reset(self).deliver_now

这个方法和用户激活的邮件程序基本一样. 我们首先在UserMailer中定义password_reset方法, 然后编写邮件视图.

_代码清单10.41: 发送密码重设链接 app/mailers/user\_mailer.rb_

    class UserMailer < ActionMailer::Base
      default from: "noreply@example.com"

      def account_activation(user)
        @user = user
        mail to: user.email, subject: "Account activation"
      end

      def password_reset(user)
        @user = user
        mail to: user.email, subject: "Password reset"
      end
    end

_代码清单10.42: 密码重设邮件的纯文本视图 app/views/user\_mailer/password\_reset.text.erb_

    To reset your password click the link below:

    <%= edit_password_reset_url(@user.reset_token, email: @user.email) %>

    This link will expire in two hours.

    If you did not request your password to be reset, please ignore this email and your password will stay as it is.

_代码清单10.43: 密码重设邮件的HTML视图 app/views/user\_mailer/password\_reset.html.erb_

    <h1>Password reset</h1>

    <p>To reset your password click the link below:</p>

    <%= link_to "Reset password", edit_password_reset_url(@user.reset_token, email: @user.email) %>

    <p>This link will expire in two hours.</p>

    <p>
        If you did not request your password to be reset, please ignore this email and your password will stay as it is.
    </p>

和账户激活一样, 也可一预览邮件.

_代码清单10.44: 预览密码重设邮件所需的方法 test/mailers/previews/user\_mailer\_preview.rb_

    # Preview all emails at http://localhost:3000/rails/mailers/user_mailer/
    class UserMailerPreview < ActionMailer::Preview

      # Preview this email at
      # http://localhost:3000/rails/mailers/user_mailer/account_activation

      def account_activation
        user = User.first
        user.activation_token = User.new_token
        UserMailer.account_activation(user)
      end

      # Preview this email at
      # http://localhost:3000/rails/mailers/user_mailer/password_reset
      def password_reset
        user = User.first
        user.reset_token = User.new_token
        UserMailer.password_reset(user)
      end
    end

然后就可以预览密码重设邮件了. 同样的, 参照激活邮件程序的测试, 编写密码重设邮件程序的测试. 注意我们要创建密码重设令牌, 以便在视图中使用.
这一点和激活令牌不一样, 激活令牌使用before\_create回调创建, 但是密码重设令牌只会在用户成功提交"Forget Password"表单后创建, 在集成测试
中很容易创建密码重设令牌(代码清单10.52), 但在邮件程序的测试中必须手动创建.

_代码清单10.45: 添加密码重设邮件程序的测试 test/mailers/user\_mailer\_test.rb_

    require 'test_helper'

    class UserMailerTest < ActionMailer::TestCase

      test "account_activation" do
        user = user(:michael)
        user.activation_token = User.new_token
        mail = UserMailer.account_activation(user)
        assert_equal "Account activation", mail.subject
        assert_equal [user.email], mail.to
        assert_equal ["noreply@example.com"], mail.from
        assert_match user.name, mail.body.encoded
        assert_match user.activation_token, mail.body.encoded
        assert_match CGI::escape(user.email), mail.body.encoded
      end

      test "password_reset" do
        user = users(:michael)
        user.reset_token = User.new_token
        mail = UserMailer.password_reset(user)
        assert_equal "Password reset", mail.subject
        # 放在数组中
        assert_equal [user.email], mail.to
        # 放在数组中
        assert_equal ["noreply@example.com"], mail.from
        assert_match user.name, mail.body.encoded
        assert_match user.reset_token, mail.body.encoded
        assert_match CGI::escape(user.email), mail.body.encoded
      end
    end

_代码清单10.46: 测试 略_

## 10.2.4 重设密码

为了让下面这样形式的链接生效, 编写一个表单, 重设密码.

    http://exmaple.com/password_resets/[reset_token]/edit?email=foo%40bar.com

这个表单和编辑用户资料表单有一些类似, 只不过需要更新密码和密码确认字段, 处理起来更为复杂, 因为我们希望通过
电子邮件查找用户, 也就是说, 在edit和update动作中都需要使用邮件地址. 在edit动作中可以轻易获取邮件地址, 因为
链接中有. 可是提交表单后, 邮件地址就没有了, 为了解决这个问题, 我们可以使用一个"hidden\_field\_tag"

_代码清单10.48: 重设密码的表单 app/views/password\_resets/edit.html.erb_

    <% provide(:title, 'Reset password') %>

    <h1>Reset password</h1>

    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(@user, url: password_reset_path(params[:id])) do |f| %>
              <%= render 'shared/error_message' %>

              <%= hidden_field_tag :email, @user.email %>

              <%= f.label :password %>
              <%= f.password_field :password, class: 'form-control' %>

              <%= f.label :password_confirmation %>
              <%= f.password_field :password_confirmation, class: 'form-control' %>

              <%= f.submit "Update password", class: "btn btn-primary" %>
            <% end %>
        </div>
    </div>

'注意, 使用的是

    hidden_field_tag :email, @user.email

而不是

    f.hidden_field :email, @user.email

因为在重设密码链接中, 邮件地址在params[:email]中, 如果使用后者, 就会把邮件地址放在params[:user][:email]中.

为了正确渲染表单, 需要在PasswordResetsController的edit控制器中定义@user变量. 和账户激活一样, 我们要找到params[:email]
中对应的用户, 确认这个用户已经激活, 然后用authenticated?方法认证params[:id]中的令牌. 因为edit和update动作中都要使用@user,
所以我们要把用查找用户和认定令牌写入一个事前过滤器中.

_代码清单10.49: 重设密码的edit动作 app/controllers/password\_resets\_controller.rb_

    class PasswordResetController < ApplicationController
      before_action :get_user, only:[:edit, :update]
      brfore_action :valid_user, only: [:edit, :update]
      ...
      def edit
      end

      private
        def get_user
          @user = User.find_by(email: params[:email])
        end

        #确保是有效用户
        def valid_user
          unless (@user && @user.activated? &&
                  @user.authenticated?(:reset, params[:id]))
            redirect_to root_url
          end
        end
    end

edit动作对应的update动作要考虑四种情况:

1. 密码重设超时失效

2. 重设成功

3. 密码无效导致的重设失败

4. 密码和密码确认为空值是导致的重设失败(此时看起来像是成功了)

因为这个表单会修改ActiveRecord模型, 所以我们可以使用共用的局部视图渲染错误消息. 密码和密码确认都为空值的情况比较特殊, 因为用户
模型的验证允许出现这种情况, 所以要特别处理, 显示一个闪现消息.

_代码清单10.50: 重设密码的update动作 app/controllers/password\_resets\_controller.rb_

    class PasswordResetsController < ApplicationController
      before_action :get_user, only: [:edit, :update]
      before_action :valid_user, only: [:edit, :update]
      before_action :check_expiration,only: [:edit, :update]

      def new
      end

      def create
        @user = User.find_by(email: params[:password_reset][:email.downcase])
        if @user
          @user.create_reset_digest
          @user.send_password_reset_email
          flash[:info]  = "Email sent with password reset instructions"
          redirect_to root_url
        else
          flash.now[:danger] = "Email address not found"
          render 'new'
        end
      end

      def edit
      end

      def update
        if both_passwords_blank?
          flash.now[:danger] = "Password/confirmation can't be blank"
          render 'edit'
        elsif @user.update_attributes(user_params)
          log_in @user
          flash[:success] = "Password has been reset."
          redirect_to @user
        else
          render 'edit'
        end
      end

      provate

        def user_params
          params.requre(:user).permit(:password, :password_confirmation)
        end

        # 如果密码和密码确认都为空, 返回true
        def both_passwords_blank?
          params[:user][:password].blank? &&
          params[:user][:password_confirmation].blank?
        end

        # 事前过滤器

        def get_user
          @user = User.find_by(email: params[:email])
        end

        # 确保是有效用户
        def valid_user
          unless (@user && @user.activated? &&
                  @user.authenticated?(:reset, params[:id]))
            redirect_to root_url
          end
        end

        # 检查重设令牌是否过期
        def check_expiration
          if @user.passwor_reset_expired?
            flash[:danger] = "Password reset has expired."
            redirect_to new_password_reset_url
          end
        end
    end

我们把密码重设是否超时交给用户模型:

    @user.password_reset_expired?

所以要在用户模型中定义password\_reset\_expired?方法.

_代码清单10.51: 在用户模型中定义password\_reset\_expired?方法 app/models/user.rb_

    class User < ActiveRecord::Base
      ...
      # 若果密码重设超时失效了, 返回true
      def password_reset_expired?
        reset_sent_at < 2.houres.ago
      end
      private
        ...
    end

## 10.2.5 测试

编写一个继承测试覆盖两个分支: 重设失败和重设工程.

    rails generate integration_test password_resets

首先访问"Forgot Password"表单, 分别提交有效和无效的电子邮件地址, 电子邮件有效时要创建密码重设令牌, 并且发送重设邮件.
然后访问邮件中的链接, 分别提交无效和有效的密码, 验证各自的表现是否正确.

_代码清单10.52: 密码重设的集成测试 test/integration/password\_resets\_test.rb_

    require 'test_helper'

    class PasswordResetsTest < ActionDispatch::IntegrationTest
      def setup
        # 清空发送邮件计数器, 用于后面测试是否发送成功
        ActionMailer::Base.deliveries.clear
        @user = users(:michael)
      end
      test "password resets" do
        get new_password_reset_path
        assert_template 'password_resets/new'

        # 电子邮件地址无效
        post password_resets_path, password_reset: { email: "" }
        assert_nor flash.empty?
        assert_template 'password_resets/new'

        # 电子邮件地址有效
        post password_resets_path, password_reset: { email: @user.email }
        assert_not_equal @user.reset_digest, @user.reload.reset_digest
        assert_equal 1, ActionMailer::Base.deliveries.size
        assert_not flash.empty?
        assert_redirect_to root_url

        # 密码重设表单
        user = assigns(:user)

        # 电子邮件地址错误
        get edit_password_reset_path(user.reset_token, email: "")
        assert_redirected_to root_url

        # 用户未激活
        user.toggle!(activated)
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_redirected_to root_url
        user.toggle!(:activated)

        # 电子邮件正确, 令牌不对
        get edit_password_reset_path('wrong token', email: user.email)
        assert_redirected_to root_url

        # 电子邮件地址正确, 令牌正确
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_template 'password_resets/edit'
        assert_select "input[name=email][type=hidden][value=?]", user.email

        # 密码和密码确认不匹配
        patch password_reset_path(user.reset_token),
              email: user.email,
              user: { password: "foobaz",
                      password_confirmation: "barquux" }
        assert_select 'div#error_exaplanation'

        # 密码和密码确认都为空值
        patch password_reset_path(user.reset_token),
              email: user.email,
              user: { password: " ",
                      password_confirmation: " " }
        assert_not flash.empty?
        assert_template 'password_resets/edit'

        # 密码和密码确认有效
        patch password_reset_path(user.reset_token),
              email: user.email,
              user: { password: ""}
        assert is_logged_in?
        assert_not flash.empty?
        assert_redirected_to user
      end
    end

对于input标签的测试

    assert_select "input[name=email][type=hidden][value=?]", user.email

这行代码的意思是, 页面中又name属性, 类型(隐藏)和电子邮件地址都正确的input标签

    <input id="email" name="email" type="hidden" value="michael@example.com" />

_代码清单10.53: 测试 略_

# 10.3 在生产环境中发送邮件

后补

# 10.4 小结

本章实现了"注册-登陆-退出"机制.

## 10.4.1 读完本章学到了什么

* 和会话一样, 账户激活虽然没有对应的ActiveRecord对象, 但也可以看做一个资源

* Rails可以生成ActionMailer动作和视图, 用于发送邮件

* ActionMailer支持纯文本邮件和HTML邮件

* 和普通的动作和视图一样, 在邮件程序的视图中也可以使用邮件程序动作中的实例变量

* 和会话,账户激活一样, 密码重设虽然没有对应的ActiveRecord对象, 但也可以看做一个资源

* 账户激活和密码重设都使用生成的令牌创建唯一的URL, 分别用于激活账户和重设密码

* 邮件程序的测试和集成测试对确认邮件程序的表现都有用

* 在生产环境中可以使用SendGrid发送电子邮件

# 10.5 练习

1. 填写代码清单10.55中缺少的代码, 为代码清单10.50中的密码重设超时失效分支编写集成测试(用到了response.body, 用来获取返回页面中的HTML).
检查是否过期有很多方法, 上述代码使用的方法是检查响应主题中是否包含单词expired(不区分大小写).

_代码清单10.55: 测试密码重设超时失效 test/integration/password\_resets\_test.rb_

    require 'test_helper'

    class PasswordResetsTest < ActionDispatch::IntegrationTest

      def setup
        ActionMailer::Base.deliveries.clear
        @user = user(:michael)
      end

      ...

      test "expired token" do
        get new_password_reset_path
        post password_resets_path, password_reset: { email: @user.email }

        @user = assign(:user)
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        path password_reset_path(@user.reset_token),
             email: @user.email,
             user: { password: "foobar"
                     password_confirmation: "foobar" }
        assert_response :redirect
        follow_redirect!
        assert_match /expired/i, response.body
      end
    end

2. 现在, 用户列表页面会显示所有用户, 而且各用户还可以通过/users/:id查看. 更合理的做法是只显示已激活的用户. 填写代码清单10.56中
缺少的代码, 实现这一需求(代码中使用了ActiveRecord提供的where方法). 附加题: 为/users和/users/:id编写集成测试.

_代码清单10.56: 只显示一ing激活的用户代码模板 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController

      ...

      def index
        @users = User.where(activated: true).paginate(page: params[:page])
      end

      def show
        @user = User.find(params[:id])
        redirect_to root_url and return unless @user
      end

      ...

    end

3. 在代码清单10.40中, activate和create\_reset\_digest方法中调用了两次update\_attribute方法, 每次调用都要单独执行一个数据库事物,
填写代码清单10.57中缺少的代码, 把这两个update\_attribute调用换成一个update\_columns, 这样之和数据库交互一次.

_代码清单10.57: 使用update\_columns的代码模板_

    class User < ActiveRecord::Base
      attr_accessor :remember_token, :activation_token, :reset_token
      before_save :downcase_email
      before_create :create_activation_digest

      ...

      # 激活账户
      def activate
        update_columns(activated: true, activated_at: Time.zone.now)
      end

      # 发送激活邮件
      def send_activation_email
        UserMailer.account_activation(self).deliver_now
      end

      # 设置密码重设相关的属性
      def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.new_token,
                       reset_sent_at: Time.zone.now)
      end

      # 发送密码重设邮件
      def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
      end
    end

# 10.6 证明超时失效的比较算是

后补

# 11.1 微博模型

新建一个分支

    git checkout master
    git checkout -b user-microposts

## 11.1.1 基本模型

微博模型需要两个属性: content, user_id

|micorposts||
|--|--|
id|integer
content|text
user_id|integer
created_at|datetime
updated_at|datetime

使用generate命令生成模型

    rails generate model Micropost content:text user:references

因为我们会按照发布时间的倒序查询某个用户发布的所有微博, 为了减少时间开销, 在迁移文件中为user_id和created_at创建索引.

_代码清单11.1: 微博模型的迁移文件, 还创建了索引 db/migrate/[timestamp]\_create\_microposts.rb_

    class CreateMicroposts < ActiveRecord::Migration
      def change
        create_table :microposts do |t|
          t.text :content
          t.references :user, index: true

          t.timestamps null: false
        end
        add_index :microposts, [:user_id, :created_at]
      end
    end

在创建迁移文件时使用了references类型, 会自动添加user_id列及其索引, 把用户和微博关联起来.

## 11.1.2 微博模型的数据验证

_代码清单11.2: 测试微博是否有效 test/models/micropost\_test.rb_

    require 'test_helper'
    class MicropostTest < ActiveSupport::TestCase
      def setup
        @user = users(:michael)
        # 这行代码不符合常规做法
        @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
      end

      test "should be valid" do
        assert @micropost.valid?
      end

      test "user id should be present" do
        @micropost.user_id = nil
        assert_not @micropost.valid?
      end
    end

进行测试

_代码清单11.3: 测试 略 RED_

添加user\_in存在性验证, 使测试能够通过.

_代码清单11.4: 微博模user\_id属性的验证 app/models/micropost.rb_

    class Micropost < ActiveRecord::Base
      belongs_to :user
      validates :user, presence: true
    end

进行测试

_代码清单11.5: 测试 略 GREEN_

_代码清单11.6: 测试微博模型的验证 test/models/micropost\_test.rb_

    require 'test_helper'
    class MicropostTest < ActiveSupport::TestCase
      def setup
        @user = users(:michael)
        @micropost = @user.microposts.build(content: "Lorem ipsum")
      end

      test "should be valid" do
        assert @micropost.valid?
      end


      test " user id should be present" do
        @micropost。user_id = nil
        assert_not @micropost.valid?
      end

      test "content should be present" do
        @micropost.content = " "
        assert_not @micropost.valid?
      end

      test "content should be at most 140 characters" do
        @micropost.content = "a" * 141
        assert_not @micropost.valid?
      end
    end

_代码清单11.7: 微博模型的验证 app/models/micropost.rb_

    class Micropost < ActiveRecord::Base
      belongs_to :user
      validates :user_id, presence: true
      validates :content, presence: true, length: { maximum: 140 }
    end

_代码清单11.8: 测试 略_

## 11.1.3 用户和微博之间的关联

_代码清单11.9： 微博belongs\_to用户_

    class Micropost < ActiveRecord::Base
      belongs_to :user
      validates :user_id, presence: true
      validates :content, presence: true, length { maximum: 140 }
    end

_代码清单11.10: 用户has\_many微博 app/models/user.rb_
    class User < ActiveRecord::Base
      has_many :microposts
      ...
    end

_代码清单11.11: 使用正确的方式创建微博对象 /test/models/micropost\_test.rb_
    require 'test_helper'
    class MicropostTest < ActiveSupport
      def setup
        @user = users(:michael)
        @micropost = @user.microposts.build(content: "Lorem ipsum")
      end
      ...
    end

_代码清单11.12: 测试 略_

## 11.1.4 改进微博模型

实现特定顺序取回用户微博, 实现微博隶属用户, 如果用户注销, 自动删除所有该用户的微博. 采用测试驱动开发.
_代码清单11.13: 测试微博的排序 test/models/micropost\_test_

    require 'test_helper'
    class MicropostTest < ActiveSupport::TestCase
      ...

      test "order should be most recent first" do
        assert_equal Micropost.first, microposts(:most_recent)
      end
    end

上面代码要使用fixtures, 因此要先定义

_代码清单11.14: 微博固件 test/fixtures/microposts.yml_

    orange:
      content: "I just aet an orange!"
      created_at: <%= 10.minutes.ago %>
    tau_manifesto:
      content: "Check out the @ tauday sige by @mhartl: http://tauday.com"
      created_at: <%= 3.years.ago %>
    cat_video:
      content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk"
      created_at: <%= 2.hours.ago %>
    most_recent:
      content: "Writing a short test"
      created_at: <%= Time.zone.now %>

这样测试还是不能够通过, 为了使测试通过. 要用default\_scope进行排序

_代码清单11.16: 使用default\_scope排序微博 app/models/micropost.rb_

    class Micropost < ActiveRecord::Base
      belongs_to :user
      default_scope -> { order(created_at: :desc) }
      validates :user_id, presence: true
      validates :content, presence: true, length: { maximum: 140 }
    end

上面代码中default\_scope语句使用了"->", 匿名函数.(重新看看)

_代码清单11.17: 测试 略_

接下来实现删除用户时, 也要把该用户发布的微博也删除.

_代码清单11.18: 确保用户的微博在删除用户的同时也被删除 app/models/user.rb_

    class User < ActiveRecord::Base
      has_many :mircoposts, dependent: :destroy
      ...
    end

进行测试

_代码清单11.19: 测试dependent: :destroy test/models/user\_test.rb_

    require 'test_helper'
    class UserTest < ActiveSupport::TestCase
      def setup
        @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")
      end
      ...
      test "associated microposts should be destroyed" do
        @user.save
        @user.micropost.create!(content: "Lorem ipsum")
        assert_difference 'Micropost.count', -1 do
          @user.destroy
        end
      end
    end

_代码清单11.20: 测试 略_

# 11.2 显示微博
## 11.2.1 渲染微博

要使用视图, 先生成控制器

    rails generate controller Microposts

_代码清单11.21: 渲染单篇微博的局部视图 app/views/microposts/\_micropost.html.erb_

    <li id="micropost-<%= micropost.id %>">
      <%= link_to gravatar_for(micropost.user, size: 50>, micropost.user %>
      <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
      <span class="content"><%= micropost.content %></span>
      <span class="timestamp>
        Posted <%= time_ago_in_words(micropost.created_at) %> ago.
      </span>
    </li>

对于显示多条微博, 需要使用分页will\_paginate, 用户分页时

    <%= will_paginate %>

这是因为will\_paginate假定已经存在一个名为@users的实力变量, 而现在要对微博分页. 应该把@microposts传递给will\_paginate方法.

    <%= will_paginate @microposts %>

同时要在控制器的show动作当中定义@micropost变量

_代码清单11.22: 在用户控制器的show动作中定义@microposts变量 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      ...
      def show
        @user = User.find(params[:id])
        @microposts = @user.miroposts.paginate(page: params[:page])
      end
      ...
    end

最后, 还要显示微博数量, 可以用`user.microposts.count`方法实现, 和paginate一样, count方法也可以在关联上使用. count的计数过程不是把所有的微博都从数据库中读取出来, 而是在数据库层计算, 让数据库统计制定的user\_id拥有多少微博.( 所有数据库都会对这种操作做性能优化, 如果统计数量仍然是应用的性能瓶颈, 可以使用"计数缓存"进一步提速.)

现在可以把微博添加到资料页面了.

_代码清单11.23: 在用户资料页面中加入微博 app/views/users/show.html.erb_

    <% provide(:title, @user.name) %>
    <div class="row">
        <aside class="col-md-4">
            <section class="user_info">
                <h1>
                    <%= gravatar_for @user %>
                    <%= @user.name %>
                </h1>
            </section>
        </aside>
        <div class="col-md-8">
            <% if @user.microposts.any? %>
                <h3>Microposts (<%= @user.microposts.count %>)</h3>
                <ol class="microposts">
                    <%= render @microposts %>
                </ol>
                <%= will_paginate @microposts %>
            <% end %>
        </div>
    </div>

由于用户中现在没有微博, 所以用户资料页面无法显示.

## 11.2.2 显示微博

添加示例微博

_代码清单11.24: 添加示例微博 db/seeds/rb_

    ...
    users = User.oreder(:created_at).take(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end

把种子数据写入开发数据库

    bundle exec rake db:migrate:reset
    bundle exec rake db:seed

重启开发服务器, 然后为微博添加一下样式

_代码清单11.25: 微博的样式(包含本章所有要使用的CSS) app/assets/stylesheets/custom.css.scss_

    ...
    /* microposts */
    .micropsts {
      list-sytle: none;
      padding: 0;
      li {
        padding: 10px 0;
        border-top: 1px solid #e8e8e8;
        }
      .user {
        margin-top: 5em;
        padding-top: 0;
        }
      .content {
        display: block;
        margin-left: 60px;
        img {
          display: block;
          padding: 5px 0;
          }
        }
      .timestamp {
        color: $gray-light;
        display: block;
        margin-left: 60px;
        }
      .gravatar {
        float: left;
        margin-right: 10px;
        margin-top: 5px;
        }
      }
    aside {
      testarea {
        height: 100px;
        margin-bottom: 5px;
        }
      }
    span.picture {
      margin-top: 10px;
      input {
        border: 0;
        }
      }

## 11.2.3 资料页面中微博的测试

先生成资料页面的集成测试

    rails generate integration_test users_profile

为了测试页面中有微博, 要把微博firture和用户关联, 使用

    orange:
      content: "I just ate an orange!"
      created_at: <%= 10.minutes.ago %>
      user: michael

修改后的微博fixture

_代码清单11.26: 添加关联用户后的微博固件 test/fixtures/microposts.yml_

    orange:
      content: "I just ate an orange!"
      created_at: <%= 10.minutes.ago %>
      user: michael

    tau_minafesto:
      content: "Check out the @tauday site by @mhartl: http://tauday.com"
      created_at: <%= 3.years.ago %>
      user: michael

    cat_video:
      content: "Sad cats are sad: http://youtu.be?PKffm2uI4dk"
      created_at: <%= 2.hours.ago %>
      user: michael

    most_recent:
      content: "Writing a short test"
      created_at: <%= Time.zone.now %>
      user: michael

    <% 30.times do |n| %>
    micropost_<%= n %>:
      content: <%= Faker::Lorem.sentence(5) %>
      created_at: <%= 42.days.ago %>
      user: michael
    <% end %>

测试数据准备好了, 测试: 访问资料页面, 检查页面标题, 用户名字, Gravatar头像, 微博数量和分页显示的微博.
"
_代码清单11.27: 用户资料页面的测试 test/integration/users\_profile\_test.rb_

    require 'test_helper'
    class UsersProfileTest < ActionDispatch::IntegrationTest
      include ApplicationHelper
      def setup
        @user = users(:michael)
      end
      test "profile display" do
        get user_path(@user)
        assert_template 'users/show'
        assert_select 'title', full_title(@user.name)
        assert_select 'h1', hext: @user.name
        assert_select 'h1>img.gravatar'
        assert_match @user.microposts.count.to_s, response.body
        assert_select 'div.pagination'
        @user.microposts.paginate(page: 1).each do |micropost|
          assert_match micropost.content, response.body
        end
      end
    end

_代码清单11.28: 测试 略_

# 11.3 微博相关的操作

接下来实现网页发布微博, 以及在网页中删除微博的功能.

注意: 微博资源相关的页面不通过微博控制器实现, 而是通过资料页面和首页实现, 因此微博控制器不需要new和edit动作, 只需要create和destroy动作.

_代码清单11.29: 微博资源的路由设置 config/routes.rb_

    Rails.application.routes.draw do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_page#about'
      get 'contact' => 'static_page#contact'
      get 'signup' => 'users#new'
      get 'login' => 'sessions#new'
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
      resources :users
      resources :account_activations, only: [:edit]
      resources :password_resets, only: [:new, :create, :edit, :update]
      resources :microposts, only: [:create, :destroy]
    end

## 11.3.1 访问限制

若想访问create和destroy动作, 用户要先登陆.

_代码清单11.30: 微博控制器的访问限制测试 test/controllers/microposts\_controller\_test.rb_

    require 'test_helper'
    class MicropostsControllerTest < ActionController::TestCase
      def setup
        @micropost = microposts(:orange)
      end

      test "should redirect create when not logged in" do
        assert_no_difference 'Micropost.count' do
          post :create, micropost: { content: "Lorem ipsum" }
        end
        assert_redirected_to login_url
      end

      test "should redirect destroy when not logged in" do
        assert_no_difference 'Micropost.count' do
          delete :destroy, id: @micropost
        end
        assert_redirected_to login_url
      end
    end

之前我们曾经定义过一个事前过滤器logged\_in\_user, 要求访问edit等动作前用户要先登陆. 当时只需要在用户控制器中使用, 但是现在要在微博控制器中也使用, 所以把它转义到ApplicationController中.

_代码清单11.31: 把logged\_in\_user方法移到ApplicationController中 app/controllers/application\_controller.rb_

    class ApplicationController < ActionController::Base
      protectrom_forgery with: :exception
      include SessionsHelper

      private
        # 确保用户已经登陆
        def logged_in_user
          unless logged_in?
            store_location
            flash[:danger] = "Please log in"
            redirect_to login_url
          end
        end
    end

同时要把用户控制器的logged\_in\_user方法删掉. 现在我们可以在微博控制器中添加create动作和destroy动作, 并使用事前过滤器限制访问.

_代码清单11.32: 限制访问微博控制器的动作 app/controllers/microposts\_controller.rb_

    class MicropostsController < ApplicationController
      before_action :logged_in_user, only: [:create, :destroy]

      def create
      end

      def destroy
      end
    end

现在测试组件应该能通过了

_代码清单11.33: 测试 略_

## 11.3.2 创建微博

表单不放再单独的页面/microposts/new中, 而是在网站的首页.
先来编写微博控制器的create动作(与用户控制器的create动作类似), 主要区别是: 创建微博时, 要使用用户和微博的关联关系构建微博对象.
注意micropost_params中的简装参数, 只允许通过Web修改微博的content属性

_代码清单11.34: 微博控制器的create动作 app/controllers/microposts\_controller.rb_

    class MicropostsController < ApplicationController
      before_action :logged_in_user, only: [:create, :destroy]

      def create
        @micropost = current_user.microposts.bulid(micropost_params)
        if @micropost.save
          falsh[:success] = "Micropost created!"
          redirect_to root_url
        else
          render 'static_pages/home'
        end
      end

      def destroy
      end

      private
        def micropost_params
          params.require(:micropost).permit(:content)
        end
    end

编写创建微博所需的表单

_代码清单11.35: 在首页加入创建微博的表单 app/views/ststic\_pages/home.html.erb_

    <% if logged_in? %>
        <div class="row">
            <aside class="col-md-4">
                <section class="user_info">
                    <%= render 'shared/user_info' %>
                </section>
                <section class="micropost_form">
                    <%= render 'shared/micropost_form' %>
                </section>
            </aside>
        </div>
    <% else %>
        <div class="center jumbotron">
            <h1>Welcome to the Sample App</h1>

            <h2>
                this is the home page for the
                <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
                sample application
            </h2>

            <%= link_to "sign up now!", signup_path, class: "btn btn-lg btn-primary" %>
        </div>

        <%= link_to image_tag("rails.png", alt: "Rails logo"), 'http://rubyonrails.org/' %>
    <% end %>

上述代码中用到了\_user\_info.html.erb局部视图, \_micripost\_form.html.erb局部视图. 一一完成.

_代码清单11.36: 用户信息侧边栏局部视图 app/views/shared/\_user\_info.html.erb_

    <%= link_to gravatar_for(current_user, size: 50), current_user %>
    <h1><%= current_user.name %></h1>
    <span><%= link_to "view my profile", current_user %></span>
    <span><%= pluralize(current_user.microposts.count, "micropost") %></span>

第七章中用到过pluralize方法, 显示成"1 micropost", "2 microposts"等.

_代码清单11.37: 微博创建表单局部视图 app/views/shared/\_micropost\_form.html.erb_

    <%= form_for(@micropost) do |f| %>
        <%= render 'shared/error_messages', object: f.object %>
        <div class="field">
            <%= f.text_area :content, placeholder: "Compose new micropost..." %>
        </div>
        <%= f.submit "Post", class: "btn btn-primary" %>
    <% end %>

还需要做两件事, 上述代码才能使用. 一是通过关联定义@micropost变量. 二是重写error\_messages局部视图.

_代码清单11.38: 在home动作中定义@micropost实例变量 app/controllers/static\_pages\_controller.rb_

    class StaticPagesController < ApplicationController
      def home
        @micropost = current_user.microposts.build if logged_in?
      end

      def help
      end

      def about
      end

      def contact
      end

    end

_代码清单11.39: 能使用其他对象的错误消息局部视图 app/views/shared/\_error\_message.html.erb_

    <% if object.errors.any? %>
        <div id="error_explanation">
            <div class="alert alert-danger">
                The form contains <%= pluralize(object.errors.count, "error") %>.
            </div>
            <ul>
                <% object.errors.full_messages.each do |msg| %>
                    <li><%= msg %></li>
                <% end %>
            </ul>
        </div>
    <% end %>

_代码清单11.40 测试 无法通过_

接下来修改错误消息局部视图的渲染方式, 包括: 用户视图, 重设密码视图, 编辑用户视图

_代码清单11.41: 修改用户注册表单中渲染错误消息局部视图的方式 app/views/users/new.html.erb_

    <% provide(:title, 'Sign up') %>
    <h1>Sign up</h1>

    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(@user) do |f| %>
            <%= render 'shared/error_messages', object: f.object %>

            <%= f.label :name %>
            <%= f.text_field :name, class: 'form-control' %>

            <%= f.label :email %>
            <%= f.text_field :email, class: 'form-control' %>

            <%= f.label :password %>
            <%= f.password_field :password, class: 'form-control' %>

            <%= f.label :password_confirmation, "Confirmation" %>
            <%= f.password_field :password_confirmation, class: 'form-control' %>

            <%= f.submib "Create my account", class: 'btn btn-primary' %>
            <% end %>
        </div>
    </div>

_代码清单11.42: 修改遍历用户表单中渲染错误消息局部视图的方式 app/views/users/edit.html.erb_

    <% provide(:title, "Edit user") %>
    <h1>Update your profile</h1>

    <div class="row">
        <div class="col-md-6 col-md-offset-3"">
            <%= form_for(@user) do |f| %>
            <%= render 'shared/error_messages', object: f.object %>

            <%= f.label :name %>
            <%= f.text_field :name, class: 'form-control' %>

            <%= f.label :email %>
            <%= f.text_field :email, class: 'form-control' %>

            <%= f.label :password %>
            <%= f.password_field :password, class: 'form-control' %>

            <%= f.label :password_confirmation, "Confirmation" %>
            <%= f.password_field :password_confirmation, class: 'form-control' %>

            <%= f.submit "Save changes", class: 'btn btn-primary' %>
            <% end %>
            <div class="gravatar_edit">
                <%= gravatar_for @user %>
                <a href="http:/gravatar.com/emails">change</a>
            </div>
        </div>
    </div>

_代码清单11.43: 修改密码重设表单中渲染错误消息局部视图的方式 app/views/password\_resets/edit.html.erb_

    <% provide(:title, 'Reset password') %>
    <h1>Password reset</h1>

    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <%= form_for(@user, url: password_reset_path(params[:id])) do |f| %>

            <%= render 'shared/error_messages', object: f.object %>

            <%= hidden_field_tag :email, @user.email %>

            <%= f.label :password %>
            <%= f.password_field :password, class: 'form-control' %>

            <%= f.label :password_confirmation, "Confirmation" %>
            <%= f.password_field :password_confirmation, class: 'form-control' %>

            <%= f.submit "Update password", class: "btn btn-primary" %>
            <% end %>
        </div>
    </div>

## 11.3.3 动态流原型

实现在首页显示一个含有当前登入用户的微博列表(动态流).'

_代码清单11.44: 微博动态流的初步实现 app/models/users.rb_

    class User < ActiveRecord::Base
      ...
      # 实现动态流原型
      # 完整的实现参见第12章
      def feed
        Micropost.where("user_id = ?", id)
      end

      private
        ...

    end

代码`Micropost.where("user_id = ?", id)`中的问号确保id值在传入底层的SQL查询语句之前做了适当的转义, 避免"SQL注入(SQL injection)"这样严重的安全隐患.
这里用到的id属性是个整数, 实际没有什么危险, 但是在SQL语句中引入变量之前做转义是个好习惯.

实际上上述代码和下面是等效的

    def feed
      microposts
    end

之所以使用上面的性质, 因为它能更好的服务于12章的完整动态流.

要获取动态流, 可以在home动作中定义一个@feed\_items实例变量, 分页获取当前用户的微博.

_代码清单11.45: 在home动作中定义一个实例变量, 获取动态流 app/controlers/static\_pages\_controller.rb_

    class StaticPagesController < ApplicationController
      def home
        if logged_in?
          @micropost = current_user.microposts.build
          @feed_items = current_user.feed.paginate(page: prarams[:page])
        end
      end

      def help
      end

      def about
      end

      def contact
      end
    end

_代码清单11.46: 动态流局部视图 app/views/shared/\_feed.html.erb_

    <% if @feed_items.any? %>
    <ol class="microposts">
        <%= render @feed_items %>
    </ol>
    <%= will_paginate @feed_items %>
    <% end %>

代码`<%= render @feed_items %>`中@feed\_items中的元素都是Micropost类的实例, 因此Rails会在对应则资源视图文件夹中寻找正确的局部视图(代码清单11.21).

最后在首页加入动态流

_代码清单11.47: 在首页加入动态流 app/views/static\_pages/home.html.erb_

    <% if logged_in? %>
    <div class="row">
        <aside class="col-md-4">
            <section class="user_info">
                <%= render 'shared/user_info' %>
            </section>
            <section class="micropost_form">
                <%= render 'shared/micropost_form' %>
            </section>
        </aside>
        <div class="clo-md-8">
            <h3>Micropost Feed</h3>
            <%= redner 'shared/feed' %>
        </div>
    </div>
    <% else %>
    ...
    <% end %>

一切都可以运行了, 不过如果发布微博失败, 首页还需要@feed\_items的实例变量, 因此如果提交失败就把@feed\_item初始化为空数组.'

_代码清单11.48: 在create动作中定义@feed_items实例变量, 值为空 app/controller/microposts\_controller.rb_

    class MicropostsController < ApplicationController
      before_action :logged_in_user, only: [:create, :destroy]

      def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
          flash[:success] = "Micropost created!"
          redirect_to root_url
        else
          @feed_items =[]
          render 'static_pages/home'
        end
      end

      def destroy
      end

      private
        def micropost_params
          params.require(:micropost).permit(:content)
        end
    end

## 11.3.4 删除微博

微博资源的最后一个功能, 删除. 只有微博发布人才能删除. 首先在是图中插入删除链接.

_代码清单11.49: 在微博局部视图中添加删除链接 app/views/microposts/\_micropost.html.erb_

    <li id="<%= micropost.id %>">
        <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
        <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
        <span class="content"><%= micropost.content %></span>
        <span class="timestamp">
            Posted <%= time_ago_in_words(micropost.created_at) %> ago.
            <% if current_user?(micropost.user) %>
              <%= link_to "delete", micropost, method: delete, data: { confirm: "You sure?"} %>
            <% end %>
        </span>
    </li>

编写MicropostContrller中的destroy动作, 把查找微博的操作放在correct_user事前过滤器中, 确保当前用户确实拥有指定ID的微博

_代码清单11.50: MicropostsController的destroy动作 app/controolers/microposts\_controller.rb_

    class MicropostsController < ApplicationController
      before_action :logged_in_user, only: [:create, :destroy]
      before_action :correct_user, only: :destroy
      ...
      def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
      end

      private
        def micropost_params
          params.require(:micropost).permit(:content)
        end

        def correct_user
          @micropost = current_user.microposts.find_by(:id: params[:id])
          redirect_to root_url if @micropost.nil?
        end
    end

注意, 在destroy中重定向的地址是: `request.referrer || root_url`. request.referrer和实现友好转向时使用的request.url关系紧密,
表示前一个URL(这里是首页).

## 11.3.4 微博的测试

编写一个微博控制器测试, 检查权限限制; 一个集成测试, 检查整个操作流程.

_代码清单11.51: 添加几个由不同用户发布的微博 test/fixtures/microposts.yml_

    ...
    ants:
      content: "Oh, is that what you want? Because that's how you get ants!"
      created_at: <%= 2.years.ago %>
      user: archer

    zone:
      content: "Danger zone!"
      created_at: <%= 3.days.ago %>
      user: archer

    tone:
      content: "I'm sorry. Your words made sense, but your sarcastic tone did not."
      created_at: <%= 10.minutes.ago %>
      user: lana

    van:
      content: "Dude, this van's, like, rolling probable cause."
      created_at: <%= 4.hours.ago %>
      user: lana

然后就可以编写控制器测试了.

_代码清单11.52: 测试用户不能删除其他用户的微博 test/controllers/microposts\_controller\_test.rb_

    require 'test_helper'
    class MicropostsControllerTest < ActionController:TestCase
      def setup
        @micropost = microposts(:orange)
      end

      test "should redirect create when not logged in" do
        assert_no_difference 'Micropost.count' do
          post :create, micropost: { content: "Lorem ipsum" }
        end
        asssert_redirected_to login_url
      end

      test "should redirect destroy when not logged in" do
        assert_no_difference 'Micropost.count' do
          delete :destroy, id: @micropost
        end
        assert_redirected_to login_url
      end

      test "should redirect destroy for wrong micropost" do
        log_in_as(users(:michael))
        micropost = microposts(:ants)
        assert_no_difference 'Micropost.count' do
          delete :destroy, id: micropost
        end
        assert_redirected_to root_url
      end
    end

最后编写一个集成测试:

1. 登陆
2. 检查是否有分页链接
3. 提交有效微博检查数量
4. 提交无效微博检查数量
5. 删除微博检查数量
6. 访问另一个用户的资料页面, 检查是否有删除链接

成测试文件`rails generate integration_test microposts_interface`.

_代码清单11.53: 微博资源界面的继承测试 test/ingtegration/microposts\_interface\_test.rb_

    require 'test_helper'
    class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:michael)
      end

      test "micropost interface" do
        # 登录用户
        log_in_as(@user)
        get root_path
        # 测试是否有分页标签
        assert_select 'div.pagination'
        # 无效提交, 微博数量不会改变
        assert_no_difference 'Micropost.count' do
          post microposts_path, micropost: { content: "" }
        end
        # 测试是否有报错的标签
        assert_select 'div#error_explanation'
        # 有效提交, 微博数量增加1
        content = "This micropost really ties the room together"
        assert_difference 'Micropost.count', 1 do
          post microposts_path, micropost: { content: content }
        end
        # 测试发布微博后重定向
        assert_redirected_to root_url
        # 跟随重定向
        follow_redirect!
        # 测试body中含有发布的微博内容
        assert_match content, response.body
        # 删除一篇微博
        assert_select 'a', text: 'delete'
        first_microposts = @user.microposts.paginate(page: 1).first
        # 测试删除微博
        assert_difference 'Micropost.count', -1 do
          delete micropost_path(first_micropost)
        end
        # 访问另一个用户的资料页面
        get user_path(users(:archer))
        assert_select 'a', text: 'delete', count: 0
      end
    end

最后进行测试

_代码清单11.54: 测试 略_

# 11.4 微博中的图片
## 11.4.1 基本的图片上传功能

我们要使用CarrierWave处理图片. 添加gem

_代码清单11.55: 在Gemfile中添加CarrierWave_

    source 'http://rubygems.org'

    gem 'rails', '4.2.0'
    gem 'bcrypt', '3.1.7'
    gem 'faker', '1.4.2'
    # 图片上传
    gem 'carrierwave', '0.10.0'
    # 调整图片尺寸
    gem 'mini_magick', '3.8.0'
    # 在生产环境中上传图片
    gem 'fog', '1.23.0'
    gem 'will_paginate', '3.0.7'
    gem 'boostrap-will_paginate', '0.0.10'
    ...

执行`bundle install`. CarrierWave含有一个Rails生成器, 用于生成图片上传程序, 我们要创造一个名为picture的上传程序`rails generate uploader Picture`.

CarrierWaver上传的图片应该对应于ActiveRecord模型中的一个属性, 这个属性只需存储图片的文件名字符串.

|micropost|
|--------|--|
|id|integer|
|content|text|
|user\_id|integer|
|created\_at|datetime|
|updated\_at|datetime|
|picture|string|

添加picture属性到微博模型中

    rails generate migration add_picture_to_microposts picture:string
    bundle exec rake db:migrate

告诉CarrierWave把图片和模型关联起来的方式是使用mount\_uploader. 第一个参数是属性的符号形式, 第二个参数是上传程序的类名. `mount_uploader :picture, PictureUploader`. 把上传程序添加到微博模型.

_代码清单11.56: 在微博模型中添加图片上传程序 app/models/micropost.rb_

    class Micropost < ActiveRecord::Base
      belongs_to :user
      default_scope -> { order(created_at: :desc) }
      mount_uploader :picture, PictureUploader
      validates :user_id, presence: true
      validates :content, presence: true, length: { maximum: 140 }
    end

为了在首页添加图片上传功能, 我们需要在发布微博的表单中添加一个file\_field标签.

_代码清单11.57: 在发布微博的表单中添加图片上传按钮 app/views/shared/\_micropost\_form.html.erb_

    <%= form_for(@micropost, html: {multipar: true}) do |f| %>
      <%= render 'shared/error_messages', object: f.object %>
      <div class="field">
          <%= f.text_area :content, placeholder: "Compose new micropost..." %>
      </div>
      <%= f.submit "Post", class: "btn btn-primary" %>
      <span class="picture">
          <%= f.flie_field :picture%>
      </span>
    <% end %>

form\_for中指定了html: { multipart: true }参数. 为了支持文件上传, 必须指定. 最后把picture属性添加到可以通过Web修改的属性.

_代码清单11.58: 把picture添加到允许修改的属性列表中 app/controllers/microposts\_controller.rb_

    class MicropostsController < ApplicationController
      before_action :logged_in_user, only: [:create, :destroy]
      before_action :correct_user, only: :destroy
      ...
      private
        def micropost_params
          params.require(:micropost).permit(:content, :picture)
        end

        def correct_user
          @micropost = current_user.microposts.find_by(id: params[:id])
          redirect_to root_url if @micropost.nil?
        end
    end

上传图片后, 微博局部视图中可以使用image\_tag辅助方法渲染. 注意, 使用了picture?布尔值方法, 不过没有图片, 就不会显示img标签. 这个方法由CarrierWave自动创建, 方法名根据保存图片文件名的属性而定.

_代码清单11.59: 在微博中显示图片 app/view/microposts/\_micropost.html.erb_

    <li id="micropost-<%= micropost.id %>">
        <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
        <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
        <span class="content">
            <%= micropost.content %>
            <%= image_tag micropost.picture.url if micropost.picture? %>
        </span>
        <span class="timestamp">
            Posted <%= time_ago_in_words(micropost.created_at) %> ago.
            <% if cureent_user?(micropost.user) %>
              <%= link_to "delete , micropost, method: delete, data: { confirm: "You sure?" }%>
            <% end %>
        </span>
    </li>


## 11.4.2

添加验证, 限制图片的大小和类型, 同时在服务器端和客户端添加验证.

对图片类型的限制在CarrierWave的上传程序中设置, 要限制图片的扩展名(.png, .gif)

_代码清单11.60: 限制可上传的图片类型 app/uploaders/picture\_uploader.rb_

    class PictureUploader < CarrierWave::Uploader::Base
      storeage :file

      # Override the directory where uploaded files will be store.
      # This is a sensible default for uploaders that are meant to be mounted:
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      # 添加一个白名单, 制定允许上传的图片类型
      def extension_white_list
        %w(jpg jpeg gif png)
      end
    end

图片的大小限制在微博模型中设定, Rails没有为文件大小提供现成的验证方法, 需要自定义, 命名为picture\_size, 调用定义方法使用validate而不是validates.

    class Micropost < ActiveRecord::Base
      belongs_to :user
      default_scope -> { order(created_at: :desc) }
      mount_uploader :picture, PictureUploader
      validates :user_id, presence: true
      validates :content, presence: true, length: { maximum: 140 }
      validate :picture_size

      private
        def picture_size
          if picture.size > 5.megabytes
            errors.add(:picture, "should be less than 5MB")
          end
        end
    end

在客户端检查上传的图片. 首先在file\_field方法中使用accept限制图片格式(有效格式使用MIME类型指定). 然后编写JavaScript(更确切额说是jQuery代码)来限制大小.

_代码清单11.62: 使用jQuery检查文件大小 app/views/shared/\_micropost\_form.html.erb_

    <%= form_for(@micropost, html: { multipart: true }) do |f| %>
    <%= render 'shared/error_messages', object: f.object %>
    <div class="field">
        <%= f.text_area :content, placeholder: "Compost new micropost..." %>
    </div>
    <%= f.submit "Post", class: "btn btn-primary" %>
    <span class="picture">
        <%= f.field :picture, accept: 'image/jpeg, image/gif, image/png' %>
    </span>
    <% end %>

    <script type="text/javascript">
     $('#micropost_picture').bind('change', function(){
         size_in_megabytes = this.files[0].size/1024/1024;
         if (size_in_megabytes > 5) {
             alert('Maximum file size is 5MB. Please choose a smaller file.');
         }
     });
    </script>

## 11.4.3 调整图片尺寸

注意, 如果要在开发环境和生产环境中ImageMagick的安装. 然后要在CarrierWave中引入MiniMagick为ImageMagick提供的接口, 还要调用一个调整尺寸的方法.

_代码清单11.63: 配置图片上传程序, 调整图片的尺寸 app/uploaders/picture\_uploader.rb_

    class PictureUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick
      process resize_to_limit: [400, 400]

      storage :file

      # Override the directory where uploaded files will be stored.
      # This is a sensible default for uploaders that are meant to be mounted:
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mount_as}/#{model.id}"
      end

      # 添加一个白名单, 指定允许上传的图片类型
      def extension_white_list
        %w(jpg jpeg gif png)
      end
    end

## 11.4.4 在生产环境中上传图片

略

# 11.5 小结

* 和用户一样, 微博也是一种资源, 而且有对应的ActiveRecord模型;
* Rails支持多键索引;
* 我们可以分别在用户和微博模型中使用has\_many和belongs\_to方法实现一个用户有多篇微博的模型;
* has\_many/belongs\_to会创建喝多方法, 通过关联创建对象;
* user.microposts.build(...)创建一个微博对象, 兵自动把这个微博和用户关联起来;
* Rails支持使用default\_scope制定默认排序方式;
* 作用域方法的参数是匿名函数;
* 加入dependent: :destroy参数后, 删除对象时也回把关联的微博删除;
* 分页和数量统计都可以通过关联调用, 这样写出的代码很简洁;
* 在固件中可以创建关联;
* 可以向Rails局部视图中传入变量;
* 查询ActiveRecord模型时可以使用where方法;
* 通过关联创建和销毁对象有安全保障;
* 可以使用CarrierWave上传图片及调整图片尺寸.


# 11.6 练习

1. 重构首页视图, 把if-else语句两个分支分别放到单独的局部视图中.
2. 为侧边栏中的微博数量编写测试(还要检查使用了正确的单复数形式).
3. 为图片上传程序编写测试.

# 12.1 关系模型

## 12.1.1 数据模型带来的问题及解决方法

首先需要明确的是我们要使用has\_many辅助方法. 可以肯定的是不能之间对关注的用户使用has\_many方法, 这样会造成逻辑的混乱. 如果把所有关注的用户copy到当前用户下建立一个following表, 为了能够使用has\_many提供的各种方法, 就需要把整个用户模型都copy过来, 数据库冗余太多. has\_many提供了一个through功能, 通过一个中间层,实现对另外一张表上的各种功能.

用户在关注\取消关注另一个用户时, 实际上创建和销毁的是两个用户之间的"关系". 因此, 用户可以有多个关系, 而通过关系可以找到following和followers. 而这个关系实际上是一个中间层, 用来存储全局的关系, 要得到单个用户的followers\_id和following\_id需要查找这个关系库.
同时, 需要注意的是, 微博的关注实际上是一种非对称的关系, A关注了B, B可以不关注A. 如果A关注了B, 而B没有关注A, 这种关系对于A来说的称为"主动关系", 对于B来说称为"被动关系".

这个全局的关系表命名为relationship, 对应模型Relationship. 包含属性

|relationship|
|--|--|
id|integer
follower_id|integer
followed_id|integer
created_at|datetime
updated_at|datetime

首先生成模型

    rails generate model Relationship follower_id:integer followed_id:integer

为了查找更为快速, 建立索引

_代码清单12.1: 在relationships表中添加索引 db/migrate/[timestamp]\_create\_relationships.rb_

    class CreateRelationships < ActiveRecord::Migration
      def change
        create_table :relationships do |t|
          t.integer :follower_id
          t.integer :followed_id

          t.timestamps null: false
        end

        add_index :relationships, :follower_id
        add_index :relationships, :followed_id
        add_index :relationships, [:follower_id, :followed_id], unique: true
      end
    end

在上面的代码中还设置了一个"多键索引", 确保(follower\_id, followed\_id)组合是唯一的, 避免多次关注同一用户. 代码清单6.28中也有保持电子邮件地址唯一的索引. 在12.1.4中用户界面也会防止多次关注同一用户. 添加多键索引后, 如果用户视图创建重复关系就会跑出异常.

执行迁移

    bundle exec rake db:migrate

## 12.1.2 用户和"关系"模型之间的关联

和创建微博时一样, 我们要通过关联创建关系

    user.active_relationships.build(followed_id: ...)

在users和microposts的关联时使用:

    class User < ActiveRecord::Base
      has_many :micropost
      ...
    end

    class Micropost < ActiveRecord::Base
      belongs_to :user
      ...
    end

这时rails会自动寻找关联, 首先使用classify方法把has\_many的参数转换为类名(例如"foo\_bars"会转换为"FooBar"), 默认情况下, rails会寻找名为<class>\_id的外键(<class>是类名的小写形式). 现在的情况是类名为Relationship, 而我们想写成`has_many :active_relationship`, 同时使用的外键为follower\_id.

_代码清单12.2: 实现"主动关系"中的has\_many关联 app/models/user.rb_

    class User < ActiveRecord::Base
      has_many :microposts, dependent: :destroy
      has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
      ...
    end

_代码清单12.3: 在"关系"模型中添加belongs\_to关联 app/models/relationship.rb_

    class Relationship < ActiveRecord::Base
      belongs_to :follower, class_name: "User"
      belongs_to :followed, class_name: "User"
    end

_表12.1: 用户和"主动关系"关联后得到的方法_

方法|作用
--|--
active\_relationships.follower | 获取关注我的用户
active\_relationships.followed | 获取我关注的用户
user.active\_relationships.create(followed\_id: user.id) | 创建user发起的主动关系
user.active\_relationships.create!(followed\_id: user.id) | 创建user发起的主动关系(失败时抛出异常)
user.active\_relationships.build(followed\_id: user.id) | 构建user发起的主动关系对象


## 12.1.3 数据验证

在关系模型中添加一些验证.

_代码清单12.4: 测试关系模型中的验证 test/models/relationshi\_test.rb_

    require 'test_require'
    class RelationshipTest < ActiveSupport::TestCase
      def setup
        @relationship = Relationship.new(follower_id: 1, followed: 2)
      end

      test "should be valid" do
        assert @relationship.valid?
      end

      test "should require a follower_id" do
        @relationship.follower_id = nil
        assert_not @relationship.valid?
      end

      test "should require a followed_id" do
        @relationship.followed_id = nil
        assert_not @relationship.valid?
      end
    end

_代码清单12.5: 在关系模型中添加验证 app/models/relationship.rb_

    class Relationship < ActiveRecord::Base
      belongs_to :follower, class_name: "User"
      belongs_to :followed, class_name: "User"
      validates :follower_id, presence: true
      validates :followed_id, presence: true
    end

生成的关系固件违背了迁移(代码清单12.1)中的唯一性约束, 这一点和生成的用户固件(代码清单6.29)一样, 和以前一样(代码清单6.30)也需要删除自动生成的固件.

_代码清单12.6: 删除"关系"固件 test/fixtures/relationshis.yml_

    # empty

_代码清单12.7: 测试 略_

## 12.1.4 我关注的用户

本节获取我关注的用户, 使用has\_many :through关联: 用户通过关系模型关注了多个用户. 默认情况下, 在has\_many :through关联中, Rails会寻找关联名单复数形式对应的外键. 例如, 在`has_many :followeds, through: :active_relationships`中, 关联名为followeds, Rails会自动变为单数形式followed, 会在relationship表中获取一个由followed\_id组成的集合. 但是写成user.followeds语法上有点说不通, 因此会使用user.following. 这就需要定制关联方法: 使用source参数指定following数组由followed\_id组成.

_代码清单12.8: 在用户模型中添加following关联 app/models/user.rb_

    class User < ActiveRecord::Base
      has_many :microposts, dependent: :destroy
      has_many :active_relationship, class_name: "Relationshi", foreign_key: "follower_id", dependent: :destroy
      has_many :following, through: active_relationships, source: :followed
      ...
    end

定义了关联后, 就可以利用ActiveRecord和数组的功能. 例如

    user.following.include?(other_user)
    user.following.find(other_user)

很多情况下可以把following当成数组来用, Rails会使用特定的方式处理following, 所以`following.include?(other_user)`看起来好像先从数据库把所有我关注的用户从数据库中去除, 然后再调用include?, 其实Rails会直接在数据层执行相关操作.

为了处理关注用户的操作, 我们还需要定义两个辅助方法: follow和unfollow. 还需要定义following?, 检查一个用户是否关注了另一个用户.

先写一个测试: 调用following?方法确认某个用户没有关注另一个用户, 然后调用follow方法关注这个用户, 再用following?方法确认关注成功, 最后调用unfollow方法取消关注, 并再次确认.

_代码清单12.9: 测试关注用户相关的几个辅助方法 test/models/user\_test.rb_

    require 'test_helper'
    class UserTest < ActiveSupport::TestCase
      ...
      test "should follow and unfollow a user" do
        michael = users(:michael)
        archer = users(:archer)
        assert_not michael.following?(archer)
        michael.follow(archer)
        assert michael.following?(archer)
        michael.unfollow(archer)
        assert_not michael.following?(archer)
      end
    end

上面测试中使用的follow, unfollow, following?方法还未定义

_代码清单12.10: 定义关注用户相关的几个辅助方法 app/models/user.rb_

    class User < ActiveRecord::Base
      ...
      def feed
        ...
      end

      # 关注另一个用户
      def follow(other_user)
        active_relationships.create(followed_id: other_user.id)
      end

      # 取消关注另一个用户
      def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
      end

      # 如果当前用户关注了指定的用户, 返回true
      def following?(other_user)
        following.include?(other_user)
      end

      private
        ...
    end

这下测试可以通过了

_代码清单12.11: 测试 略_

## 12.1.5 关注我的人

本节定义passive\_relationships(也就是user.followers方法), 可以参照active\_relationships的实现方法.

_代码清单12.12: 使用"被动关系"实现user.followers app/models/user.rb_

    class User < ActiveRecord::Base
      has_many :microposts, dependent: :destroy
      has_many :avtive_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
      has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
      has_many :following, through: :active_relationships, sources: :followed
      has_many :followers, through: :passive_relationships, sources: :follower
      ...
    end

接下来测试这个模型

_代码清单12.13: 测试followers关联 test/models/user\_test.rb_

    require 'test_helper'
    class UserTest < ActiveSupport::TestCase

      ...

      test "should follow and unfollow a user" do
        michael = users(:michael)
        archer = users(:archer)
        assert_not michael.following?(archer)
        michael.follow(archer)
        assert michael.following?(archer)
        assert archer.followers.include?(michael)
        michael.unfollow(archer)
        assert_not michael.following?(archer)
        assert_not archer.followers.include?(michael)
      end
    end

最后可以进行测试.

# 12.2 关注用户的网页界面

## 12.2.1 示例数据

添加一些用户相互关注的关系, 第一个用户关注第3-51个用户, 让第4-41个用户关注第一个用户.

_代码清单12.14: 在种子数据中添加关系相关的数据 db/seeds.rb_

    # Users
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)

    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   activated: true,
                   activated_at: Time.zone.now)
    end

    # Micropost
    users = User.order(:created_at).take(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end

    # Following relationships
    users = User.all
    user = users.first
    following = users[2..50]
    followers = users[3..40]
    following.each { |followed| user.follow(followed) }
    followers.each { |follower| follower.follow(user) }

之后可以执行迁移

    bundle exec rake db:migrate:reset
    bundle exec rake db:seed

# 12.2.2 数量统计和关注表单

在资料页面显示我关注的人和关注我的人的数量, 分配链接到专门的用户列表, 然后添加关注和取消关注的表单.

先创建路由

_代码清单12.15: 在用户控制器中添加following和followers两个动作 config/routes.rb_

    Rails.application.routes.draw do
      root 'stativ_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#about'
      get 'contact' => 'static_pages#contact'
      get 'signup' => 'users#new'
      get 'login' => 'sessions#new'
      post 'login' => 'session#create'
      delete 'logout' => 'session#destroy'
      resources :users do
        # member方法所创建的方法包含用户ID, 如果用collection方法, URL中没有ID
        member do
          get :following, :followers
        end
      end
      resources :account_activations, only: [:edit]
      resources :password_resets, only: [:new, :create, :edit, :update]
      resources :microposts, only: [:create, :destroy]
    end

代码清单12.15中生成的路由如下表所示

_表12.2: 代码清单12.15中设置的规则生成的REST路由_

http请求|url|动作|具名路由
--|--|--|--
GET|/users/1/following|following|following_user_path(1)
GET|/users/1/followers|followers|followers_user_path(1)

设置好了路由之后, 就可以编写数量统计的视图.

_代码清单12.16: 显示数量统计的局部视图 app/views/shared/\_stats.html.erb_

    <% @user ||= current_user %>
    <div class="stats">
        <a href="<%= following_user_path(@user) %>">
            <strong id="following" class="stat">
                <%= @user.following.count %>
            </strong>
            following
        </a>
        <a href="<%= followers_user_path(@user) %>">
            <strong id="followers" class="stat">
                <%= @user.followers.count %>
            </strong>
            followers
        </a>
    </div>

注意到两个统计项都给了CSS ID, 目的是为了Ajax准备的, 因为Ajax要通过唯一的ID获取页面中的元素.

把局部视图加入首页.

_代码清单12.17: 在首页显示数量统计 app/views/static\_pages/home.html.erb_

    <% if logged_in? %>
    <div class="row">
        <aside class="col-md-4">
            <section>
                <%= render 'shared/user_info' %>
            </section>
            <section>
                <%= redner 'shared/stats' %>
            </section>
            <section class="micropost_form">
                <%= render 'shared/micropost_form' %>
            </section>
        </aside>
        <div class="col-md-8">
            <h3>Micropost Feed</h3>
            <%= render 'shared/feed' %>
        </div>
    </div>
    <% else %>
       ...
    <% end %>

添加一些SCSS代码, 美化数量统计.

_代码清单12.18: 首页侧边栏的SCSS样式 app/assets/sytlesheets/cuntom.css.scss_

    ...
    /* sidebar */
    ...
    .gravatar {
      float: left;
      matgin-right: 10px;
    }

    .gravatar_edit {
      margin-top: 15px;
    }

    .stats {
      overflow: auto;
      margin-top: 0;
      padding: 0;
      a {
        float: left;
        padding: 0 10px;
        border-left: 1px solid $gray-lighter;
        color: gray;
        &:first-child {
          padding-left: 0;
          border: 0;
        }
        &:hover {
          text-decoration: none;
          color: blue;
        }
      }
      strong {
        desplay: block;
      }
    }

    .user_avatars {
      overflow: auto;
      margin-top: 10px;
      .gravatar {
        margin: 1px 1px;
      }
      a {
        padding: 0;
      }
    }

    .user.follow {
      padding: 0;
    }

    /* forms */
    ...

稍后再把数量统计局部视图天价到用户资料页面中, 先来编写关注和取消关注按钮的局部视图.

_代码清单12.19: 显示关注或取消关注表单的局部视图 app/views/users/\_follow\_form.html.erb_

    <% unless current_user?(@user) %>
    <div id="follow_form">
        <% if current_user.following?(@user) %>
            <%= render 'unfollow' %>
        <% else %>
            <%= render 'follow' %>
        <% end %>
    </div>
    <% end %>

接下来编写unfollow和follow局部视图.

_代码清单12.20: 添加关系资源的路由设置 config/routes.rb_

    Rails.application.routes.draew do
      root 'static_pages#home'
      get 'help' => 'static_pages#help'
      get 'about' => 'static_pages#about'
      get 'contact' => 'static_pages#contact'
      get 'signup' => 'users#new'
      get 'login' => 'sessions#new'
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
      resources :users do
        memeber do
          get :following, :followers
        end
      end
      resources :account_activations, only: [:edit]
      resources :password_resets, only: [:new, :create, :edit, :update]
      resources :microposts, only: [:create, :destroy]
      resources :relationships, only: [:create,  :destroy]
    end

_代码清单12.21: 关注用户的表单 app/views/users/\_follow.html.erb_

    <%= form_for(current_user.active_relationships.build) do |f| %>
        <div><%= hidden_field_tag :followed_id, @user.id %></div>
        <%= f.submit "Follow", class: "btn btn-primary" %>
    <% end %>

_代码清单12.22: 取消关注用户的表单 app/views/users/\_unfollow.html.erb_

    <%= form_for(current_user.active_relationships.find_by(followed_id: @user.id), html: { method: :delete }) do |f| %>
        <%= f.submit "Unfollow", class: "btn" %>
    <% end %>

_代码清单12.23: 在用户字啊聊页面加入关注表单和数量统计 app/views/users/show.html.erb_

    <% provide(:title, @user.name) %>
    <div class="row">
        <aside class="col-md-4"">
            <section>
                <h1>
                    <%= gravatar_for @user %>
                    <%= @user.name %>
                </h1>
            </section>
            <section>
                <%= render 'shared/stats' %>
            </section>
        </aside>
        <div class="col-md-8">
            <%= render 'follow_form' if logged_in? %>
            <% if @user.microposts.any? %>
              <h3>Microposts (<%= @user.microposts.count %>)</h3>
              <ol class="microposts">
                  <%= render @microposts %>
              </ol>
              <%= will_paginate @microposts %>
            <% end %>
        </div>
    </div>


# 12.2.3 我关注的用户和关注我的用户的列表页面

还是采用TDD, 先编写测试."

_代码清单12.24: 我关注的用户和关注我的用户的列表页面的访问限制测试 test/controllers/users\_controller\_test.rb_

    require 'test_helper'
    class UsersControllerTest < ActionController::TestCase
      def setup
        @user = users(:michael)
        @other_user = users(:archer)
      end
      ...
      test "should redirect following when not logged in" do
        get :following, id: @user
        assert_redirected_to login_url
      end

      test "should redirect followers when not logged in" do
        get :followers, id: @user
        assert_redirected_to login_url
      end
    end

我们要在用户控制器中添加两个动作, 按照代码清单12.15的路由设置中, 这两个动作应该命名为following和followers, 他们需要完成的任务:

1. 设置页面的标题
2. 查找用户
3. 获取@user.followed_users或@user.followers(需要分页显示)
4. 渲染页面

_代码清单12.25: following和followers动作 app/controllers/users\_controller.rb_

    class UsersController < ApplicationController
      before_action :logged_in_user. only: [:index, :edit, :update, :destroy, :following, :followers]
      ...
      def followers
        @title = "Followers"
        @user = User.find(params[:id])
        @users = @user.followers.paginate(page: params[:page])
        render 'show_follow'
      end


      private
      ...
    end

这两个方法的最后一行渲染页面的Ruby显得很怪异, 因为按照Rails的约定, 每个动作最后都会渲染对应的视图(根据动作名查找对应的视图, 例如show动作最后会渲染show.html.erb). 而代码清单12.25中的两个动作都显式调用了render方法, 渲染一个名为show_follow的视图, 这时因为两个动作甬道的erb代码差不多.

_代码清单12.26: 渲染我关注的用户列表页面和关注我的用户列表页面的show\_follow视图 app/views/users/show\_follow.html.erb_

    <% provide(:title, @title) %>
    <div class="row">
        <aside class="col-md-4">
            <section class="user_info">
                <%= gravatar_for @user %>
                <h1><%= @user.name %></h1>
                <span><%= link_to "view my profile", @user %></span>
                <span><b>Microposts:</b> <%= @user.micriposts.count %></span>
            </section>
            <section class="stats">
                <%= render 'shared/stats' %>
                <% if @users.any? %>
                  <div class="user_avatars">
                      <% @users.each do |user| %>
                          <%= link_to gravatar_for(user, size: 30), user %>
                      <% end %>
                  </div>
                <% end %>
            </section>
        </aside>
        <div class="col-md-8">
            <h3><%= @title %></h3>
            <% if @users.any? %>
              <ul class="users follow">
                  <%= redner @users %>
              </ul>
              <%= will_pagenate %>
            <% end %>
        </div>
    </div>

注意在代码清单12.25和代码清单12.26中并未出现当前用户, 所以这两个链接对其他用户也可以用.
接下来编写一些集成测试, 确认表现正确. 我们计划确认显示的数量正确, 而且页面中指向正确的URL的链接.
首先生成一个集成测试文件:

    rails generate integration_test following

接着准备一些测试数据. 在11.2.3节使用下面的代码把微博和用户关联:

    orange:
      content: "I just ate an orange!"
      created_at: <%= 10.minutes.ago %>
      user: michael

注意没有使用user\_id: 1, 而是使用user: michael. 因此采用同样的方式编写关系固件.

_代码清单12.27: 关系固件 test/fixtures/relationships.yml_

    one:
      follower: michael
      followed: lana

    two:
      follower: michael
      followed: mallory
    three:
      follower: lana
      followed: michael
    four:
      follower: archer
      followed: michael

接下来可以编写测试了'

_代码清单12.28: 测试我关注的用户列表页面和关注我的用户列表页面 test/integration/following\_test.rb_

    require 'test_helper'
    class FollowingTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:michael)
        log_in_as(@user)
      end

      test "following page" do
        get following_user_path(@user)
        assert_not @user.following.empty?
        assert_match @user.following.count.to_s, response.body
        @user.following.each do |user|
          assert_select "a[href=?]", user_path(user)
        end
      end

      test "followed page" do
        get followers_user_path(@user)
        assert_not @user.followers.empty?
        assert_match @user.followers.count.to_s, response.body
        @user.followers.each do |user|
          assert_select "a[href=?]", user_path(user)
        end
      end
    end

注意在测试中有`assert_not @user.following.empty?`, 如果不加入这个断言, 下面代码没有意义:

    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end

测试应该可以通过

_代码清单12.29: 测试 略_

# 12.2.4 关注按钮的常规实现方式

视图已经创建好了, 下面让关注和曲线关注按钮其作用. 首先建立一个控制器.

    rails generate controller Relationships

TDD先确认安全, 首先测试访问控制器前先登陆, 未登录访问时数据库中关系数量不会变化.

_代码清单12.30: RelationshipsController基本的访问限制测试 test/controllers/relationships\_controller\_test.rb_

    require 'test_helper'
    class RelationshipsControllerTest < ActionController::TestCase
      test "create should require logged-in user" do
        assert_no_difference 'Relationship.count' do
          post :create
        end
        assert_redirected_to login_url
      end

      test "destroy should require logged-in user" do
        assert_no_difference 'Relationship.count' do
          delete :destroy, id: relationships(:one)
        end
        assert_redirected_to login_url
      end
    end

在RelationshipsController中添加logged\_in\_user事前过滤器后, 这个测试就能通过.

_代码清单12.31: RelationshipsController的访问限制 app/controllers/relationships\_controller.rb_

    class RelationshipsController < ApplicationController
      before_action :logged_in_user

      def create
      end

      def destroy
      end
    end

为了让按钮起作用, 我们需要找到表单中的followed\_id字段对应的用户, 然后在调用的代码清单12.10中定义的follow或者unfollow方法.

_代码清单12.32: RelationshipsController的代码 app/controllers/relationships\_controller.rb_

    class RelationshipsController < ApplicationController
      before_action :logged_in_user

      def create
        user = User.find(params[:followed_id])
        current_user.follow(user)
        redirect_to user
      end

      def destroy
        user = Relationshi.find(params[:id]).followed
        current_user.unfollow(user)
        redirect_to user
      end
    end

# 12.2.5关注按钮的Ajax实现方式

在RelationshipController中两个动作最后都转向了用户资料页面, 多了一次转向. 使用Ajax解决.

_代码清单12.33: 使用Ajax处理关注用户的表单 app/views/users/\_follow.html.erb_

    <%= form_for(current_user.active_relationships.build(followed_id: @user.id), remote: true) do |f| %>
        <div><%= hidden_field_tag :followed_id, @user.id %></div>
        <%= f.submit "Follow", class: "btn btn-primary" %>
    <% end %>

_代码清单12.34: 使用Ajax处理取消关注用户的表单 app/views/users/\_unfollow.html.erb_

    <%= form_for(current_user.active_relationships.find_by(followed_id: @user.id), html: { method: :delete }, remote: true) do |f| %>
        <%= f.submit "Unfollow", class: "btn" %>
    <% end %>

上述代码和以前的代码只是增加了`remote: true`这个属性, 它告诉Rails这个表单可以使用JavaScript处理. Rails遵从使用了"unobtrusive JavaScript"原则(非侵入式JS), 没有直接在视图中写入JavaSript代码, 而是使用了一个简单的HTML属性, 为了让RelationshipController相应Ajax请求, 要使用respond\_to方法, 根据请求的类型生成合适的响应. respond\_to方法会根据不同请求返回不同的代码块.>

_代码清单12.35: 在RelationshipsController中相应Ajax请求 app/controllers/relationships\_controller.rb_


    class  RelationshipsController < ApplicationController
      before_action :logged_in_user

      def create
        @user = User.find(params[:foolowed_id])
        current_user.follow(@user)
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
      end

      def destroy
        @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |format|
          format.html { redirect_to @user }
          format.js
        end
      end
    end

如果要上述代码在浏览器不支持JavaScript的情况下也能正常运行, 需要配置一个选项.

_代码清单12.36: 添加优雅降级所需的配置 config/application.rb_

    require File.expand_path('../boot', __FILE__)
    ...
    module SampleApp
      class Application < Rails::Application
        ...
        # 在处理Ajax的表单中添加真伪令牌
        config.action_view.embed_authenticaty_token_in_remote_forms = true
      end
    end

如果是Ajax请求, Rails会自动调用文件名和动作名一样的js.erb文件.  Rails自动提供了jQuery库的辅助函数, 可以通过DOM(Document Object Model, 文档对象模型).

jQuery库提供很多处理DOM的方法, 我们会用到两个方法:

1. 通过ID获取DOM元素使用`$`
2. html方法, 使用指定内容修改元素中的HTML

此外, 还用到了escape\_javascript方法, 在JavaScript写入HTML代码必须使用这个方法对HTML进行转义

_代码清单12.37: 创建关系的JS-ERb代码 app/views/relationships/create.js.erb_

    $("#follow_form").html("<%= escape_javascript(render('users/unfollow')) %>")
    $("#followers").html('<%= @user.followers.count %>')

_代码清单12.38: 销毁关系的JS-ERb代码 app/views/relationships/destroy.js.erb_

    $("#follow_form").html("<%= escape_javascript(render('users/follow')) %>")
    $("#followers").html('<%= @user.followes.count %>')

实际上第一行代码是把代码清单12.19中的id="follow\_form"的标签中的html替换为渲染users/follow或者users/unfollow.

# 12.2.6 关注功能的测试

为了测试respond\_to对于JavaScrit的相应, 使用xhr方法(XmlHttpRequest)发起Ajax请求.

_代码清单12.39: 测试关注和取消关注按钮 test/integration/following\_test.rb_

    require 'test_helper'

    class FollowingTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:michael)
        @other = users(:archer)
        log_in_as(@user)
      end
      ...
      test "should follow a user the standard way" do
        assert_difference '@user.following.count', 1 do
          post relationships_path, followed_id: @other.id
        end
      end

      test "should follow a user the Ajax" do
        assert_difference '@user.following.count', 1 do
          xhr :post, relationships_path, followed_id: @othter.id
        end
      end

      test "should unfollow a user the standard way" do
        @user.follow(@other)
        relationship = @user.active_relationships.find_by(followed_id: @other.id)
        assert_difference '@user.following.count', -1 do
          delete relationship_path(relationship)
        end
      end

      test "should unfollow a user with Ajax" do
        @user.follow(@other)
        relationship = @user.active_relationships.find_by(followed_id: @other.id)
        assert_difference '@user.following.count', -1 do
          xhr :delete, relationship_path(relationship)
        end
      end
    end

测试组件应该可以通过

_代码清单12.40: 测试 略_

# 12.3 动态流

## 12.3.1 目的和策略

目的: 显示自己和当前关注用户发布的微博.

实现方法不是一下就能得出的, 但是测试方法很明确, 采用TDD.

_代码清单12.41: 测试动态流 test/models/user\_test.rb_

    require 'test_helper'

    class UserTest < ActiveSupport::TestCase
      ...

      test "feed should have the right post" do
        michael = users(:michael)
        archer = users(:archer)
        lana = users(:lana)
        # 关注的用户发布的微博
        lana.microposts.each do |post_following|
          assert michael.feed.include?(post_following)
        end
        # 自己的微博
        michael.microposts.each do |post_self|
          assert michael.feed.include?(post_self)
        end
        # 未关注用户的微博
        archer.microposts.each do |post_unfollowed|
          assert_not michael.feed.include?(post_unfollowed)
        end
      end
    end

_代码清单12.42: 测试 略(red)_
## 12.3.2 初步实现动态流

之前只需要查询自己微博时, 使用

    Micropost.where("user_id = ?", id)

现在要面对情况更为复杂

    Micropost.where("user_id in (?) OR user_id = ?", following_ids, id)

从上面的查询条件可以看出, 我们需要生成一个数组following_ids, 其元素是关注用户的ID. 可以使用map方法(Enumerable).

插入一点ruby知识

    # 原始代码
    [1, 2, 3, 4].map{ |i| i.to_s }
    => ["1", "2", "3", "4"]

    # 等价于, 实际上是把to_s转换成一个proc传递给了map
    [1, 2, 3, 4].map(&:to_s)
    => ["1", "2", "3", "4"]

    # 在此基础上可调用join
    [1, 2, 3, 4].map(&:to_s).jon(', ')
    => "1, 2, 3, 4"

参照上面的方法, 可以在user.following中的每个元素调用id方法, 得到一个用户数组的ID

    User.first.following.map(&:id)
    => [4, 5, 6, ......]

因为上面的用法太普遍了, ActiveRecord已经默认提供了

    # 上述方法等效于
    User.first.following_ids
    => [4, 5, 6, ......]

上面的following\_ids是根据has\_many :following关联合成的, 我们只需在关联名后面加上\_ids就可以了.

_代码清单12.43: 初步实现的动态流 app/models/user.rb_

    class User < ActiveRecord::Base
      ...
      # 如果密码重设失效了, 返回true
      def passowrd_reset_expired?
        reset_sent_at < 2.hours.ago
      end

      # 返回用户的动态流
      def feed
        Micropost.where("user_id in (?) OR user_id = ?", following_ids, id)
      end

      # 关注另一个用户
      def following(other_user)
        active_relationships.create(followed_id: other_user.id)
      end

      ...
    end

现在测试应该可以通过了

_代码清单12.44 测试 略_

# 12.3.3 子查询

上节动态流中的following\_ids是在ActiveRecord中实现, 需要读取到内存中, 影响到性能. 本届要在数据库层查找关注用户的ID

_代码清单12.45: 在获取动态流的where方法中使用hash app/models/user.rb_

    class User < ActiveRecord::Base
      ...
      # 返回用户的动态流
      def feed
        Micropost.where("user_id IN (:following_ids) OR user_id = :user_id", following_ids: following_ids, user_id: user)
      end
      ...
    end

我们把feed方法做了等效. 接下来在数据库层查询following\_ids.

_代码清单12.46: 动态流的最终实现 app/models/user.rb_

    class User < ActiveRecord::Base
      ...
      # 返回用户的动态流
      def feed
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
      end
      ...
    end

_代码清单12.47: 测试 略_

最后要做的是在首页显示完成的动态流

_代码清单12.48: home动作中分页显示的动态流 app/controllers/static\_pages\_controller.rb_

    class StaticPagesController < ApplicationController

      def home
        if logged_in?
          @micropost = current_user.microposts.build
          @feed_items = current_user.feed.paginate(page: prams[:page])
        end
      end
    end

结束.

# 12.4 小结

## 12.4.1 后续学习资源

* 本书的配套饰品
* RailsCases
* Tealeaf Academy
* Thinkful
* RailsApps
* Code School
* 书籍:  Beginning Ruby, The Well-Grounded Rubyist, Eloquent Ruby, The Ruby Way. Agile Web Development with Rails, The Rails 4 Way, Rails 4 in action.

## 12.4.2 读完本章血倒了什么

* 使用has\_many :through可以实现数据模型之间的复杂关系
* has\_many方法有很多可选的参数, 可用来制定对象的类名和外键名
* 使用has\_many和has\_many :through, 并且指定合适类名和外键名, 可以实现主动关系和被动关系
* Rails支持嵌套路由
* where方法可以创建灵活且强大的数据库查询
* Rails支持使用底层SQL查询数据库

# 12.5 练习

1. 编写测试, 检查首页和资料页面显示的数量统计. 提示: 写入代码清单11.27的测试文件中. (想一想为什么没有单独测试首页显示的数量统计)

2. 编写测试, 检查首页正确显示了动态流的第一页. 使用CGI.escapeHTML转义HTML. (想一想原因)
