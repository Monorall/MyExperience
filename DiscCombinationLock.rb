class Node

  attr_accessor :parent, :code, :children

  def initialize(code, parent)
    @code = code
    @parent = parent
    @children = []
  end
end

def get_level(node)
  level = -1
  until node.nil?
    level += 1
    node = node.parent
  end
  level
end

def print_solution(stack)
  puts "Затраченное время #{((@end_time - @start_time) / 60.0).round(2)} минут"
  puts "Решение [#{stack.length}]:"
  puts stack.pop until stack.empty?
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
  old_best_length = 0
  old_best_length = @best.length unless @best.nil?
  @best = stack if @best.nil? || @best.length > stack.length
  puts "[#{Time.new.strftime('%H:%M:%S')}] Код найден с путем #{@best.length} #{stack.reverse}" if @best.length < old_best_length

end

def search(node, key)
  if node.code == key
    success(node)
    return nil
  end
  current_level = get_level(node)
  if @excludes.include?(node.code) || node.code.zero? || current_level > 10 * key.digits.count || (!@best.nil? && current_level + 1 > @best.length)
    return nil
  end

  div = 10**key.digits.count.pred
  while div != 0
    num = (node.code / div) % 10
    if key > node.code
      @new_code = node.code + div
      node.children.append(Node.new(@new_code, node)) if num != 9 && !is_exclude?(node, @new_code)
    else
      @new_code = node.code - div
      node.children.append(Node.new(@new_code, node)) if num != 0 && !is_exclude?(node, @new_code)
    end
    div /= 10
  end
  node.children.each do |elem|
    success(elem) if elem.code == key
  end
  node.children.each do |elem|
    search(elem, key)
  end
  node.children = nil
end

puts 'Введите начальное значение'
#start_code = gets.to_i
start_code = 123

puts 'Введите ключ (конечное значение)'
#key = gets.to_i
key = 789

puts 'Введите исключения'
#@excludes = gets.to_i # todo: fix it. i need more excludes
@excludes = [555]
@best = nil

root = Node.new(start_code, nil)

@start_time = Time.new
puts "[#{@start_time.strftime('%H:%M:%S')}] Начало поиска"
search(root, key)
@end_time = Time.new
puts "[#{@end_time.strftime('%H:%M:%S')}] Конец поиска"
print_solution(@best)
