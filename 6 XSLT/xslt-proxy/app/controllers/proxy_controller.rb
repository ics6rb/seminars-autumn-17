require 'nokogiri'
require 'open-uri'

# Контроллер запросов к первому приложению.
class ProxyController < ApplicationController
  # Перед каждым вызовом метода output у нас
  # будут вызваны методы parse_parms и prepare_url,
  # причем именно в таком порядке.
  before_action :parse_params, only: :output
  before_action :prepare_url, only: :output

  # Просто отображает форму ввода.
  def input; end

  # Отсылает запрос другому приложению и в зависимости от желания клиента
  # (которое определяется по значению параметра side):
  # 1. возвращает XML в неизменном виде;
  # 2. превращает XML в HTML на стороне сервера (средствами Ruby);
  # 3. превращает XML в HTML на стороне браузера.
  def output
    # Делаем запрос и получаем ответ от другого сервера в виде XML-документа.
    api_response = open(@url)

    # Если делать XML -> HTML на сервере.
    if @side == 'server'
      @result = xslt_transform(api_response).to_html
    # Если делать XML -> HTML в браузере.
    elsif @side == 'client-with-xslt'
      render xml: insert_browser_xslt(api_response).to_xml
    # Если вообще ничего не делать.
    else
      render xml: api_response
    end
  end

  private

  # Вспомогательные константы (freeze рекомендуется делать, чтобы получить неизменяемую строку).

  # Куда шлем запрос.
  BASE_API_URL           = 'http://localhost:3000/?format=xml'.freeze
  # Откуда берем XSLT для преобразования на стороне сервера
  # (тут нужен обычный путь, Rails.root - путь к каталгу приложения).
  XSLT_SERVER_TRANSFORM  = "#{Rails.root}/public/server_transform.xslt".freeze
  # Откуда браузер должен брать XSLT. Это подставится к localhost:3001. Именно так грузятся файлы из public.
  XSLT_BROWSER_TRANSFORM = '/browser_transform.xslt'.freeze

  # Разбираем параметры запроса.
  def parse_params
    @lower = params[:lower]
    @upper = params[:upper]
    @side = params[:side]
  end

  # Создаем url с использованием разобранных параметров запроса
  # (так как prepare_url вызывается после parse_params, @lower и @upper уже доступны).
  def prepare_url
    @url = BASE_API_URL + "&lower=#{@lower}&upper=#{@upper}"
  end

  # Преобразование XSLT на сервере (код Самарева).
  def xslt_transform(data, transform: XSLT_SERVER_TRANSFORM)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XSLT(File.read(transform))
    xslt.transform(doc)
  end

  # Чтобы преобразование XSLT на клиенте работало, надо вставить ссылку на XSLT.
  # Делается это с помощью nokogiri через ProcessingInstruction (потому что ссылка
  # на XSLT называется в XML processing instruction).
  def insert_browser_xslt(data, transform: XSLT_BROWSER_TRANSFORM)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XML::ProcessingInstruction.new(doc,
                                                    'xml-stylesheet',
                                                    'type="text/xsl" href="' + transform + '"')
    doc.root.add_previous_sibling(xslt)
    # Возвращаем doc, так как предыдущая операция возвращает не XML-документ.
    doc
  end
end
