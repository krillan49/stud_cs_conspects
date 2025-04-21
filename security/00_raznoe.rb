# https://pentest-tools.com/    - инструменты для проверки сайта на безопасность
# URL Fuzzer                    - инструмент c pentest-tools.com для проверки сайта на скрытые директории, например с разрабьотческими инструментами, которые ктото забыл удалить



puts '                                       SQL - инъекции'

# Например URL каких-то страниц сайта могут передавать на сервер параметры через GET-запрос и если передача в БД никак не защищена, то можно сделать SQL-инекцию:

# Например страница
# http://some.com/index.php

# Может предполагать передачу, например айдишника
# http://some.com/index.php?id=1

# На сервере она стыкуется со строкой с SQL синтаксисом, не использующим никакую защиту, например
"SELECT name FROM users WHERE id = "

# Мы можем сделать разные SQL-инъекции просто передав ее в параметры URL
# http://some.com/index.php?id=1+UNION+SELECT+password+FROM+users"        - пароли
# http://some.com/index.php?id=1+UNION+SELECT+1,2,VERSION()"              - узнать версию БД

# В итоге получится запрос
"SELECT name FROM users WHERE id = 1 UNION SELECT password FROM users"















#
