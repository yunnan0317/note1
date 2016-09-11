# -e表示执行后续代码
ruby -e 'puts "hello world"' > ~/note/tmp/

# -n表示循环读取, 并把读取的内容放入$_全局变量中
ruby -ne 'puts $_ if $_ =~ /foot/' /usr/share/dict/words

ruby -ne 'puts $_ if $_ =~ /andre/' /etc/passwd/ /ect/group

# -p表示对$_做处理并将其打印输出(此功能于-n相同), 并额外提供每次循环结束时将$_打印.
ruby -pe '$_ = "#" + $_' ruby_script.rb > ruby_script.rb
ruby -pe '$_ = "#" + $_' ruby_script.rb > ruby_script.rb
