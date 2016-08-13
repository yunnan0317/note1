# Ruby标准库

## Abbrev 返回一组没有奇异的缩写

    require 'abbrev'

可以直接调用类方法

    Abbrev.abbrev(['ruby', 'rails'])

可以在字符串数组上直接调用

    %w{ ruby rails }.abbrev

也可以传入一个参数来匹配

    %w{ ruby rails }.abbrev{/^.u/}


## Base64

    require 'base64'

类方法

编码|解码
--|--
encode649(bin)|decode64(str)
strict_encode64(bin)|strict_decode64(str)
urlsafe_encode64(bin, padding: true)|urlsafe_decode64(str)

## Benchmark 测量报告Ruby code时间

    require 'benchmark'


## BigDecimal 提供更精确的十进制数

属于类

    require 'bigdecimal'

Float, Integer, String可以使用`to_d`方法转换为BigDecimal

### BigMath 提供函数以及常用数



    require 'bigdimimal/math'
    include BigMath

## CGI

## CMath 提供三角函数, 超越函数, 复数计算的库

属于模块

    require 'cmath'

## CSV
