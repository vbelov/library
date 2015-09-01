## Library

```
git clone git://github.com/vbelov/library.git
cd library
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```

Для запуска тестов:

```
RACK_ENV=test bundle exec rake db:create
RACK_ENV=test bundle exec rake db:migrate
ruby test.rb
```

Генерация данных:
```
bundle exec rake db:seed
```

Количество генерируемых авторов и книг можно задать в файле db/seeds.rb.
На моем ноутбуке генерация 10000 авторов и 400000 книг занимает 111 секунд. Генерация 100000 авторов и 4000000 книг
занимает 2225 cекунд.

Для запуска приложения:

```
ruby library.rb
```

Приложение доступно по адресу: http://localhost:4567/
