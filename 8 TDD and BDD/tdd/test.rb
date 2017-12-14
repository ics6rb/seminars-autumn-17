# Тесты приложения. В качестве middleware используется Rack.

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'json'
require 'rack/test'

require_relative './app'

# Чтобы не писать в каждом тестовом классе подключение примеси
# и чтобы каждый раз не определять метод app, необходимый Rack при тестировании,
# создадим базовый класс тестов и будем от него наследоваться.
class BaseTest < Minitest::Test
  # Подключает примеси Rack, которые делают доступными
  # методы get, post и т.д., а также геттер last_response.
  include Rack::Test::Methods

  # Метод, который говорит Rack, какое приложение запускается.
  def app
    Sinatra::Application
  end
end

# Тестируем наличие маршрутов.
class AppRoutesTest < BaseTest
  # Проверяем, что страница / доступна и возвращает 200.
  def test_index_success
    get '/'
    assert last_response.ok?
  end

  # Проверяем, что страница /add доступна и возвращает 200.
  def test_add_success
    get '/add'
    assert last_response.ok?
  end
end

# Тестируем корневой маршрут.
class TestIndex < BaseTest
  # Проверяем, что он возвращает JSON.
  def test_response_content_type
    get '/'
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
  end

  # Проверяем, что тело ответа такое, как мы хотим.
  def test_response_body
    get '/'
    assert last_response.ok?
    # Важное замечание - в хэшах мы используем в качестве ключа экземпляры класса
    # Symbol (то есть константная строка). При преобразовании хэша в JSON эти Symbol'ы
    # кастуются в строки, т.к. в JSON есть только строка по типу "фффф".
    # Ruby-модуль JSON при преобразовании из JSON в Ruby-хэш всегда кастует "фффф"
    # в Ruby-СТРОКУ, не важно, ключ это в JSON-объекте или значение!
    # При этом в Ruby :a != 'a', поэтому чтобы добиться равенства хэшей,
    # мы выуждены писать expected (стоящий слева) не как это положено в Ruby,
    # а так, как он будет возвращен парсером.
    assert_equal({'message' => 'Hello!'}, JSON.parse(last_response.body))
  end
end

# Тестируем маршрут, который складывает числа.
class TestAdd < BaseTest
  # Проверяем, что он возвращает JSON.
  def test_response_content_type
    get '/add'
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
  end

  # Проверяем, что он правильно работает на правильных данных.
  def test_calculation
    get '/add', a: 10, b: 12
    assert last_response.ok?

    body = JSON.parse(last_response.body)

    assert_includes body, 'answer'
    assert_equal 10 + 12, body['answer']
  end

  # Проверяем, что он не упадет, если ему дать половину параметров, которые он ожидает.
  def test_half_params
    get '/add', a: 100
    assert last_response.ok?
    assert_equal({}, JSON.parse(last_response.body))
  end

  def test_wrong_params_values
    get '/add', a: '[100, 200, 500]', b: 10
    assert last_response.ok?
    assert_equal({}, JSON.parse(last_response.body))
  end

  # Проверяем, что он не упадет, если названия параметров будут правильными, а значения - нет.
  def test_wrong_params_type
    get '/add', a: [100, 200, 500], b: 10
    assert last_response.ok?
    assert_equal({}, JSON.parse(last_response.body))
  end

  # Проверяем, что он не упадет, если ему дать параметры с неправильными значениями.
  def test_wrong_param_names
    get '/add', wrong: '1488'
    assert last_response.ok?
    assert_equal({}, JSON.parse(last_response.body))
  end
end
