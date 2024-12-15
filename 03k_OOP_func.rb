puts '                                     Сходство классов с замыканиями'

# Есть класс, с его инстанс переменные можно реализовать кастомно, при помощии функций

# Функция-конструктор constructor, в нее передаем аргументы:
def constructor(a, b)
  # Возвращаем хеш таблицу / объект. Ключи хэша - имена методов, значения - лямбды, которые имплементят методы. Заместо инстанс переменных у нас переменные, созданные в области видимости функции constructor (тут переданные в нее параметры), потому они будут видимы и использоваться в лямбдах-значениях (замыкания):
  {
    add: -> { a + b },
    multiply: -> { a * b },
    # Введем локальное состояние, через замыкания, как замену мутабельных инстанс переменных:
    # сделаем геттеры:
    get_a: -> () { a },
    get_b: -> () { b },
    # сделаем сеттеры:
    set_a: -> (new_a) { a = new_a },
    set_b: -> (new_b) { b = new_b }
  }
end

# Создаем объект нашего класса - хэш таблицу, которую вернет метод constructor, передадим в него значения для "инстанс" переменных
object = constructor(6, 10)

# Вызовем методы использующие инстанс переменные:
p object[:get_a].call     #=> 6
p object[:get_b].call     #=> 10
p object[:add].call       #=> 16
p object[:multiply].call  #=> 60

# При помощи сеттеров изменим значения "инстанс" переменных a и b, которые находятся в области видимости конструктора,  тоесть изменим состояние объекта с использованием замыкания:
object[:set_a].call(10)
object[:set_b].call(20)
p object[:get_a].call     #=> 10
p object[:get_b].call     #=> 20
p object[:add].call       #=> 30
p object[:multiply].call  #=> 200



puts '                                     Кастомное прототипное наследование'

# https://gist.github.com/metacircu1ar/63be5ae1ee26113495e95696e93144ce
# https://dev.to/metacircu1ar/implementing-simple-object-system-from-scratch-in-ruby-4h7h

# Прототипное наследование - это то же самое, что классовое наследование. Оба являются формой делегирования. Только классовое выражено статически(ты пишешь его в исходном коде и оно фиксировано), а прототипное выражено динамически(ты делаешь его во время работы программы), ?? тоесть в прототипном наследовании, одни объекты наследуют от других ??


# Чтобы зимплементить наследование, добавим в наш объект ключ :__prototype и будем ему присваивать тот объект, от которого будем наследовать. То есть, если объект A наследуется от объекта B, то мы просто делаем a[:__prototype] = b, соответсвенно прототипное наследование это вложение объекта у которого наследуем в текущий объект. Цепь наследования может быть любой глубины - мы просто берем любое количество обектов и линкуем их через прототипы.
# Поиск метода в нашем объекте тогда будет таким: проверяется в текущем объекте, eсли там есть этот метод - вызываем, если нет смотрим в :__prototype нашего объекта и соответсвенно в объекте от которого наследуем и дальше вызов рекурсивно идет по цепочке пока достигнет конца иерархии наследования.
# Для того чтобы эмулировать super из ruby(который вызывает одноименный метод из наследуемого класса), мы просто добавим метод proto нашему кастомному хешу.

# Так получится полноценная объектная система, которую и дальше можно расишрять если надо.

# Потребуется кастомизация некоторых операций, поэтому унаследуемся от Hash и переопределим и добавим некоторые операции.
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

  # Чтобы заимплементить миксины(возможность подмешивать методы одного объекта к другому), добавим метод mixin. Так как наши методы - это ключи в хеше, то миксин имплементируется через обычный merge 2х хэш объектов, тоесть добавляем нужный к нашему
  def mixin(object)
    self.merge!(object)
  end

  # добавим некоторую форму метапрограммирования в нашу объектную систему. Мы будем использовать метапрограммирование для динамического создания методов для наших объектов. Тут создадим версию attr_accessor-метода Ruby, который генерирует сеттеры и геттеры для атрибутов:
  def attr_accessor(*attributes)
    attributes.each do |attr|
      state = nil
      self.merge!({
        "get_#{attr}".to_sym => -> { state },
        "set_#{attr}".to_sym => ->(new_value) { state = new_value }
      })
    end
  end

end


# 1. Вызов методов:
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


# 2. Наследование и миксины:
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

player = Player.initialize
entity = Entity.initialize
position = Position.initialize(10, 20)
entity.inherit(position)
player.inherit(entity)
p player[:get_x].call #=> 10
p player[:get_y].call #=> 20

position = Position.initialize(10, 20)
player.mixin(position)
p player[:get_x].call #=> 10
p player[:get_y].call #=> 20


# 3. Пример использования attr_accessor
player = Player.initialize
player.attr_accessor(:health, :strength)
player[:set_health].call(100)   # Set health to 100.
player[:set_strength].call(50)  # Set strength to 50.
p player[:get_health].call   #=> 100
p player[:get_strength].call #=> 50

# 3a. Вариант аксессора в самом классе:
class HashObject < Hash
  # ...
  def attr_accessor(**attributes)
    attributes.each do |var, value|
      state = value
      self.merge!({
        "get_#{var}".to_sym => -> { state },
        "set_#{var}".to_sym => ->(new_value) { state = new_value }
      })
    end
  end
end

module Player
  def self.initialize(**attributes)
    itself = HashObject.new.merge({
      get_name: -> { itself.proto(:get_name).call + " (player)" }
    })
    itself.attr_accessor(**attributes)
    itself
  end
end

player = Player.initialize(health: 20, strength: 5)
p player[:get_health].call     #=> 20
p player[:get_strength].call   #=> 5
player[:set_health].call(100)     # Set health to 100.
player[:set_strength].call(50)    # Set strength to 50.
p player[:get_health].call     #=> 100
p player[:get_strength].call   #=> 50

# 3b. Вариант аксессора который наследуется прототипно:
class HashObject < Hash
  # ...
  def attr_accessor(attributes)
    attributes.each do |var, value|
      state = value
      self.merge!({
        "get_#{var}".to_sym => -> { state },
        "set_#{var}".to_sym => ->(new_value) { state = new_value }
      })
    end
  end
end

module Entity
  def self.initialize(**attributes)
    itself = HashObject.new.merge({
      attr_accessor: ->(attr=attributes) { itself.attr_accessor(attr) }
      # значение по умолчанию для передачи атрибутов из области видимости данного класса, а из другого передадутся через call
    })
  end
end

module Entity2
  def self.initialize(**attributes)
    itself = HashObject.new.merge({
      attr_accessor: ->(attr=attributes) { itself.attr_accessor(attr) }
    })
  end
end

module Player
  def self.initialize(**attributes)
    itself = HashObject.new.merge({
      attr_accessor: ->(attr=attributes) { itself.proto(:attr_accessor).call(attr) }
      # передаем аргументы в материнский attr_accessor-лямду через call
      # тут тоже сделаем значение по умолчание и переменную, чтоб и от этого класса можно было наследовать
    })
  end
end

entity = Entity.initialize
entity2 = Entity2.initialize.inherit(entity)
player = Player.initialize(health: 20, strength: 5).inherit(entity2)
player[:attr_accessor].call       # activate attr_accessor
p player[:get_health].call      #=> 20
p player[:get_strength].call    #=> 5
player[:set_health].call(100)     # Set health to 100.
player[:set_strength].call(50)    # Set strength to 50.
p player[:get_health].call      #=> 100
p player[:get_strength].call    #=> 50












#
