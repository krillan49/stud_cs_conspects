# Сходство классов с замыканиями
# у тебя есть класс, в нем есть инстанс переменные. Сделаем то же самое на функциях.
# Создаем функцию конструктор initizlize. В нее передаем аргументы. Затем возвращаем хеш таблицу - ключи в ней имена методов, значения - лямбды которые имплементят методы. Заместо инстанс переменных у нас значения, созданные в скоупе initialize и видимые в лямбдах которые ниже в хеш таблице


def initialize(a, b)
  {
    add: -> { a + b },
    multiply: -> { a * b }
  }
end

puts "Enter the first number:"
num1 = gets.chomp.to_f

puts "Enter the second number:"
num2 = gets.chomp.to_f

# Create the hash with lambdas
object = initialize(num1, num2)

# Call some "methods"
puts "Addition result: #{object[:add].call}"
puts "Multiplication result: #{object[:multiply].call}"



# Теперь введем локальное состояние, через замыкания, как замену мутабельных инстанс переменных - сделаем сеттеры

def initialize(a, b)
  {
    add: -> { a + b },
    multiply: -> { a * b },
    set_a: -> (new_a) { a = new_a },
    set_b: -> (new_b) { b = new_b }
  }
end

puts "Enter the first number:"
num1 = gets.chomp.to_f

puts "Enter the second number:"
num2 = gets.chomp.to_f

# Create the hash with lambdas
object = initialize(num1, num2)

# Call some "methods"
puts "Addition result: #{object[:add].call}"
puts "Multiplication result: #{object[:multiply].call}"

# Now change the values of a and b
object[:set_a].call(10)
object[:set_b].call(20)

puts "Addition result: #{object[:add].call}"
puts "Multiplication result: #{object[:multiply].call}"


# тут мы изменили значения переменных a,b которые находятся в области видимости конструктора, и потом позвав add/multiply лямбды отработали с новыми значениями














#
