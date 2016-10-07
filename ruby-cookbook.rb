# coding: utf-8
s = "order. wrong the in are words These"
s.split(/(\s+)/).reverse.join('')
s.split.reverse.join(' ')
s.split(/(\b)/).reverse.join('')
s.split(/\b/).reverse.join('')

class NumberParser
  # 捕获组需要括号
  @@number_regexps = {
    :to_i => /([+-]?[0-9]+)/,
    :to_f => /([+-]?([0-9]*\.)?[0-9]+(e[+-]?[0-9]+)?)/i,
    :oct => /([+-]?[0-7]+)/,
    :hex => /\b([+-]?(0x)?[0-9a-f]+)\b/i
  }

  def NumberParser.re(parsing_method = :to_i)
    re = @@number_regexps[parsing_method]
    raise ArgumentError, "No regexp for #{parsing_method.inspect}!" unless re
    return re
  end

  def extract(s, parsing_method = :to_i)
    numbers = []
    s.scan(NumberParser.re(parsing_method)) do |match|
      numbers << match[0].send(parsing_method)
    end
    numbers
  end
end

class Float
  def approx(other, relative_epsilon = Float::EPSILON, epsilon = Float::EPSILON)
    difference = other - self
    return true if difference.abs <= epsilon
    relative_error = (difference / (self > other ? self : other)).abs
    return relative_error <= relative_epsilon
  end
end
x

class Array
  def mean
    self.inject(0) { |sum, x| sum += x } / self.size.to_f
  end
end

def modes(array, find_all = true)
  histogram = array.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
  modes = nil
  histogram.each_pair do |item, times|
    puts "#{item}, #{times}"
    modes << item if modes && times == modes[0] and find_all
    p modes
    # modes[记录times, 后面记录items], 遇到更大的items, 更新modes[0]
    modes = [times, item] if (!modes && times>1) or (modes && times > modes[0])
    p modes
  end
  return modes ? modes[1..modes.size] : modes
end

require 'find'
Find.find('./') do |path|
  a = /([^0-9]*)([0-9]{6})([^0-9]*)/.match(path)
  puts a[1], a[2], a[3] unless a == nil
  File.rename(path, a[1]+"1"+a[3]) unless a == nil


end
