## Library

```
git clone git://github.com/vbelov/library.git
cd library
bundle install
```

Для запуска тестов:

```
RACK_ENV=test bundle exec rake db:create
RACK_ENV=test bundle exec rake db:migrate
ruby test.rb
```

Для запуска приложения:

```
bundle exec rake db:create
ruby library.rb
```
