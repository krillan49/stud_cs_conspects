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
class Hash

  def flattened_keys(obj = nil)
    obj = self.clone if !obj

    res = obj.map {|k, v|
      if v.class == Hash or v.class == Array
        v.map {|key, val|
          newk = k.to_s + '_' + key.to_s
          newk = newk.to_sym if k.class == Symbol && key.class == Symbol
          [newk, val]
        }
      else
        [k, v]
      end
    }.flatten

    if res.any?{|e| e.class == Hash or e.class == Array}
      flattened_keys(res.each_slice(2).to_a)
    else
      res.each_slice(2).to_a.to_h
    end
  end

end

unflat = {id: 1, info: {name: 'example'}}
p unflat.flattened_keys # {id: 1, info_name: 'example'}
unflat = {id: 1, info: {name: 'example', more_info: {count: 1}}}
p unflat.flattened_keys # {id: 1, info_name: 'example', info_more_info_count: 1}
unflat = {a: 1, 'b' => 2, info: {id: 1, 'name' => 'example'}}
p unflat.flattened_keys # {a: 1, 'b' => 2, info_id: 1, 'info_name' => 'example'}














#
