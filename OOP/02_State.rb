puts '                                      Состояние объекта (state)'

# Состояние объекта (state) - это совокупность значений всех характеристик объектва в данный момент. Понятие состояния это фича объектно-ориентированных языков

class Car
  def initialize # Конструкор задает состояние объекта по умолчанию(значение переменных экземпляра)
    @state = :closed
  end

  def open # Метод меняющий состояние объектов(меняет значение переменной класса для объекта)
    @state = :open
  end

  def how_are_you # Метод сообщающий о состоянии объектов
    puts "My state is #{@state}"
  end
end

car = Car.new
car.how_are_you #=> My state is closed
car.open # Меняем состояние объекта car при помощи метода меняющего значение переменной класса для этого объекта
car.how_are_you #=> My state is open



puts '                                           Еще пример'

# Изменение состояния объекта(значений переменных класса для объектов) при помощи методов
class Airplane
	attr_reader :model, :altitude  #(altitude - высота)
  attr_accessor :speed

	def initialize(model)
		@model = model
		@altitude = 0
		@speed = 0
	end

	def fly
		@speed = 800
		@altitude = 10000
	end

	def land
		@speed = 0
		@altitude = 0
	end

  def moving?
		@speed > 0
	end
end

plane1 = Airplane.new('Boing-777') # Самолет1 создан
puts "Model #{plane1.model}, speed #{plane1.speed}, alt #{plane1.altitude}" #=> Model Boing-777, speed 0, alt 0
puts "Plane is moving? #{plane1.moving?}" #=> false

plane1.fly # Самолет1 летит
puts "Model #{plane1.model}, speed #{plane1.speed}, alt #{plane1.altitude}" #=> Model Boing-777, speed 800, alt 10000
puts "Plane is moving? #{plane1.moving?}" #=> true

plane1.land # Самолет1 сел
puts "Model #{plane1.model}, speed #{plane1.speed}, alt #{plane1.altitude}" #=> Model Boing-777, speed 0, alt 0
puts "Plane is moving? #{plane1.moving?}" #=> false


# Конвеерное создание объектов при помощи массивов и выведение методов класса с помощью циклов
models = ['Airbus-320', 'Boing-777', 'IL-86']
planes = [] # массив для хранения объектов(самолетов)

100.times do # Создаем 100 самолетов
	model = models[rand(0..2)]
	plane = Airplane.new(model)

	plane.fly if rand(2) == 1 # Запускаем рандомные самолеты
  plane.speed = 500 if plane.model == 'IL-86' && plane.altitude > 0 # Можно задавать другие параметры неким типам объектов

	planes << plane # Помещаем объекты в массив
end

planes.each do |plane| # Выводим данные о самолетах через массив объектов
	puts "Model #{plane.model}, speed #{plane.speed}, alt #{plane.altitude}. Plane is moving? #{plane.moving?}"
end
















#
