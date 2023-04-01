
# mak/compacter.rb

# Warning, this is primitive and doesn't take into account
# javascript multiline strings...


def compact_css(path)

  File.readlines(path).each do |l|
    l = l.chop.lstrip
    next if l.length < 1
    puts l
  end
end

def compact_js(path)

  File.readlines(path).each do |l|
    l = l.chop.lstrip
    next if l.length < 1
    next if l[0, 2] === '//'
    puts l
  end
end

def compact(path)

  case path
  when /\.css/ then compact_css(path)
  else compact_js(path)
  end
end

compact(ARGV.first)

