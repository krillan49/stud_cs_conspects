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




# С наследованием
def class_Abstract(a, b)
  this = {
    get: {
      a: -> () { a },
      b: -> () { b }
    },
    set: {
      a: -> (new_a) { a = new_a },
      b: -> (new_b) { b = new_b }
    },
    to_s: -> { "Abstract class values of a and b are: #{a} and #{b}" }
  }
end

# object = class_Abstract(10, 20)
# p object[:get][:a].()  # 10
# p object[:set][:a].(7) # 7
# p object[:get][:a].()  # 7
# p object[:to_s].()     # "Math class values of a and b are: 7 and 20"

def class_Math(a, b)
  inheritance = class_Abstract(a, b)
  this = {
    add:      -> { a + b },
    multiply: -> { a * b },
    to_a:     -> { [a, b] },
    to_s:     -> { "Math class values of a and b are: #{a} and #{b}" }
  }
  inheritance.merge(this)
end

object = class_Math(10, 20)
p object[:get][:a].()  # 10
p object[:set][:a].(7) # 7
p object[:get][:a].()  # 7
p object[:to_a].()     # [10, 20] ???? - передается из области метода class_Abstract, он должен быть лямбдой либо объектная обертка над числами ??
p object[:to_s].()     # "Math class values of a and b are: 10 and 20"




puts '                                     Кастомное прототипное наследование'

# Правильный варик:

# https://gist.github.com/metacircu1ar/63be5ae1ee26113495e95696e93144ce

# Мы использовали дефолтный руби хеш для создания наших объектов в прошлых примерах. Нам потребуется кастомизация некоторых операций, поэтому унаследуемся от Hash и переопределим и добавим некоторые операции.
# Чтобы заимплементить миксины(возможность подмешивать методы одного объекта к другому), добавим метод mixin. Так как наши методы это ключи в хеше - миксин имплементируется через обычный merge.
# Чтобы зимплементить наследование, добавим в наш объект ключ :__prototype и будем ему присваивать тот объект, от которого надо отнаследоваться. То есть если объект A наследуется от объекта B, то мы просто делаем a[:__prototype] = b. Цепь наследования может быть любой глубины - мы просто берем любое количество обектов и линкуем их через прототипы. Как будет выглядеть тогда поиск метода в нашем объекте? Мы смотрим в текущий объект. Если там есть наш метод - вызываем, иначе смотрим в :__prototype нашего объекта. И дальше вызов рекурсивно идет по цепочке пока мы не достигнем конца нашей иерархии наследования. Для того чтобы эмулировать super из ruby(который вызывает одноименный метод из наследуемого класса), мы просто добавим метод proto нашему кастомному хешу.
# Теперь у нас полноценная объектная система, которую и дальше можно расишрять если надо.

# Прототипное наследование это то же самое, что классовое наследование. Оба являются формой делегирования. Только классовое выражено статически(ты пишешь его в исходном коде и оно фиксировано), а прототипное выражено динамически(ты делаешь его во время работы программы)

class HashObject < Hash

  # переопределяем метод доступа, чтобы использовать наследование через прототип-ключ подхэша
  def [](method)
    super(method) || super(:__prototype)&.[](method)
    # если данного ключа нет в этом HashObject, то super(:__prototype)&.[](method) вызывает ключ у подхэша под ключем :__prototype
  end

  # метод чтобы осуществить прототипное наследование, через создание подхэша под ключем :__prototype в текущем хэш-объекте
  def inherit(prototype)
    # prototype - передаем хэш объект от которого хотим наследовать, тоесть добавить его свойством под ключем :__prototype в текущий хэш-объект
    self[:__prototype] = prototype
    self
  end

  # эмуляция super из ruby(который вызывает одноименный метод из наследуемого класса)
  def proto(method)
    self[:__prototype]&.[](method)
  end

  # Миксин просто через мерж 2х хэш объектов, тоесть добавляем нужный к нашему
  def mixin(object)
    self.merge!(object)
  end

end

module ArithmeticExampleClass
  def self.initialize(a, b)
    itself = HashObject.new.merge({
      add: -> { a + b },
      multiply: -> { a * b },
      set_a: ->(new_a) { a = new_a },
      set_b: ->(new_b) { b = new_b }
    })
  end
end

object = ArithmeticExampleClass.initialize(3, 4)
p object[:add].call      #=> 7
p object[:multiply].call #=> 12
object[:set_a].call(10)
object[:set_b].call(20)
p object[:add].call      #=> 30
p object[:multiply].call #=> 200


module Entity
  def self.initialize
    name = "Generic entity"
    HashObject.new.merge({
      get_name: -> { name },
      set_name: ->(new_name) { name = new_name }
    })
  end
end

module Player
  def self.initialize
    itself = HashObject.new.merge({
      # Передаем данные в метод proto, чтобы использовать метод материнского класса
      get_name: -> { itself.proto(:get_name).call + " (player)" }
    })
  end
end

module Position
  def self.initialize(x, y)
    itself = HashObject.new.merge({
      get_x: -> { x },
      get_y: -> { y },
      set_x: ->(new_x) { x = new_x },
      set_y: ->(new_y) { y = new_y }
    })
  end
end

entity = Entity.initialize
player = Player.initialize.inherit(entity)
p player[:get_name].call       #=> "Generic entity (player)"
player[:set_name].call("John")
p player[:get_name].call       #=> "John (player)"

position = Position.initialize(10, 20)
player.mixin(position)
p player[:get_x].call #=> 10
p player[:get_y].call #=> 20


player = Player.initialize
entity = Entity.initialize
position = Position.initialize(10, 20)
entity.inherit(position)
player.inherit(entity)
p player[:get_x].call #=> 10
p player[:get_y].call #=> 20












#
