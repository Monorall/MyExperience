class Node

  attr_accessor :parent, :code, :children

  def initialize(code, parent)
    @code = code
    @parent = parent
    @children = []
  end
end

def get_grade(key, code)
  div = 10**key.digits.count.pred
  sum = 0
  while div > 0
    sum += ((key / div) % 10 - (code / div) % 10).abs
    div /= 10
  end
  sum
end

def get_level(node)
  level = -1
  until node.nil?
    level += 1
    node = node.parent
  end
  level
end

def print_solution
  puts "Затраченное время #{((Time.new - @start_time) * 1000).round(2)} миллисекунд"
  exit(0)
end

def is_exclude?(node, new_code)
  return true if @excludes.include?(new_code)

  until node.nil?
    return true if new_code == node.code
    node = node.parent
  end
  false
end

def success(node)
  stack = []
  until node.nil?
    stack.push(node.code)
    node = node.parent
  end
  old_best_length = nil
  old_best_length = @best.length unless @best.nil?
  @best = stack if @best.nil? || @best.length > stack.length
  puts "[#{Time.new.strftime('%H:%M:%S')}] Код найден с путем #{@best.length} #{stack.reverse}" if old_best_length == nil || @best.length < old_best_length
  if @teory_best == @best.length
    puts "Нашли лучший теоретический результат"
    print_solution
  end
end

def search(node, key)
  if node.code == key
    success(node)
    return nil
  end
  current_level = get_level(node)
  if @excludes.include?(node.code) || current_level > 10 * key.digits.count || (!@best.nil? && current_level >= @best.length)
    return nil
  end

  div = 10**key.digits.count.pred
  while div != 0
    num = (node.code / div) % 10
    @new_code = node.code + div
    node.children.append(Node.new(@new_code, node)) if num != 9 && !is_exclude?(node, @new_code)
    @new_code = node.code - div
    node.children.append(Node.new(@new_code, node)) if num != 0 && !is_exclude?(node, @new_code)
    div /= 10
  end

  node.children = node.children.sort_by {|n| get_grade(key, n.code)}

  node.children.each do |elem|
    search(elem, key)
  end
  node.children = nil
end

puts 'Введите начальное значение'
#start_code = gets.to_i
start_code = 77

puts 'Введите ключ (конечное значение)'
#key = gets.to_i
key = 99

puts 'Введите исключения'
#@excludes = gets.to_i # todo: fix it. i need more excludes
@excludes = [87, 78]
@best = nil
@teory_best = get_grade(start_code, key) + 1

root = Node.new(start_code, nil)

@start_time = Time.new
puts "[#{@start_time.strftime('%H:%M:%S')}] Начало поиска"
search(root, key)

puts "[#{Time.new.strftime('%H:%M:%S')}] Теоретический лучший не нашли результат. Конец поиска"
print_solution
