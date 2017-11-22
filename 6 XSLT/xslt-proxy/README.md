# Приложение 2 XSLT-PROXY

Работает с клиентом, получает данные от приложения 1.

## Измененные файлы

        app/controllers/proxy_controller.rb - вся логика работы.
        
        Подключение bootstrap в файлах:
        Gemfile
        app/assets/javascripts/application.js
        app/assets/stylesheets/load_bootstrap.scss
        
        app/views/layouts/application.html.erb - добавление элементов bootstrap в общую разметку.
        
        app/views/proxy/input.html.erb - форма ввода.
        app/views/proxy/output.html.erb - вывод результата преобразования на сервере.
        
        config/environments/development.rb - сделали так, чтобы работала статика.
        
        config/routes.rb - добавили корневой маршрут.
        
        public/server_transform.xslt - XSLT, используемый при преобразовании на стороне
                                       сервера с помощью nokogiri.
        public/browser_transform.xslt - XSLT, используемый при преобразовании на стороне
                                        браузера (его пишем в XML, чтобы браузер его подсосал).
                                        
        .rubocop.yml - некоторые проверки рубокопа можно отключать или изменять!