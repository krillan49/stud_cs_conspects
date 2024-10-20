puts '                                             Рекурсия'

# Рекурсия - функция вызывает сама себя, чтобы получить некий промежуточный результат

# Рекурсивная реализация не имеет изменяемого состояния как итеративная, но у нее есть проблема с потреблением памяти.

# Факториал 5 = 5 * 4 * 3 * 2 * 1
# Факториал 4 =     4 * 3 * 2 * 1
# Соответсвенно Факториал 5 = 5 * Факториал 4
# Факториал n = n * Факториал n-1
def factorial(n)
  puts "x = #{n}"
  if n == 1
    return n
  else
    return n * factorial(n - 1) # вызывается таже функция но с новым значением, соответвенно вернет значение этот внутренний вызов функции сюда во внешний вызов и так на каждом новом круге вовнутрь.
  end
end
p factorial(5) #=> 120
# puts:
# x = 5
# x = 4
# x = 3
# x = 2
# x = 1



puts '                                          Примеры и решения'

# 4 kyu Hash.flattened_keys
# https://www.codewars.com/kata/521a849a05dd182a09000043
def flattened_keys(obj)
  obj = obj.map do |k, v|
    if v.class == Hash || v.class == Array
      v.map { |key, val| [k.class == Symbol && key.class == Symbol ? "#{k}_#{key}".to_sym : "#{k}_#{key}", val] }
    else
      [k, v]
    end
  end.flatten

  if obj.any?{|e| e.class == Hash || e.class == Array}
    flattened_keys(obj.each_slice(2).to_a)
  else
    obj.each_slice(2).to_h
  end
end

obj = {a: 1, 'b' => 2, info: {id: 1, 'name' => 'example', more_info: {count: 1}}}
p flattened_keys(obj) #=> {:a=>1, "b"=>2, :info_id=>1, "info_name"=>"example", :info_more_info_count=>1}














#
