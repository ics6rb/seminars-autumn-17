# Контроллер, который делает всю работу в этом приложении
class XmlController < ApplicationController
  # Магия RoR - возможность вызвать какой-то метод до вызова одного
  # или нескольких методов контроллера.
  # первый параметр - какой метод вызываем
  # only значит, что вызываем ТОЛЬКО перед index.
  # Эта штука часто используется в рельсах, так что рекомендую приучаться)
  before_action :parse_params, only: :index

  # Метод, принимающий запросы от приложения 2.
  # Мы не трогаем params, потому что перед ним вызвался (из-за before_action)
  # метод parse_params, который уже все за нас распарсил и разложил
  # по нужным переменным.
  def index
    # Нашли палиндромы.
    palindromes = find_palindromes(@lower, @upper)

    # Сформировали сообщение.
    # Очень удобно делать это в виде хэша - он умеет
    # превращаться в XML с нужными названиями тегов - ключами.
    data = if palindromes.nil?
             { message: "Неверные параметры запроса (lower = #{@lower}, upper = #{@upper})" }
           else
             palindromes.map { |elem| { elem: elem, binary: elem.to_s(2) } }
           end

    # Отвечаем клиенту.
    # .to_xml - это и есть формирование XML средствами ActiveSupport.
    # Насчет обработки в RSS мне самому не очень понятно. По-хорошему, тут надо
    # делать вьюху XML, в которую впихивать данные шаблонизатором и рендерить ее
    # с параметром layout: false, то, что возвращается сейчас - не RSS.
    # С другой стороны, RSS требуется проверять только в функциональном тесте, так что хз...
    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.rss { render xml: data.to_xml }
    end
  end

  protected

  # Раскидывает параметры запроса из хэша по переменным объекта.
  # Такой код используется для удобства и сокращения кода метода
  # контроллера, реализующего основную логику обработки запроса.
  def parse_params
    @lower = params[:lower].to_i
    @upper = params[:upper].to_i
  end

  private

  # Возвращает массив всех палиндромов от нижней до верхней границы.
  # @param lower Integer нижняя граница.
  # @param upper Integer верхняя граница.
  def find_palindromes(lower, upper)
    # В случае несоответствия типов ожидаемым возвращаем nil.
    if !(lower.is_a?(Integer) && upper.is_a?(Integer))
      nil
    # В случае несоответствия значений нижней и верхней границ возвращаем nil.
    elsif lower < 0 || upper < 0
      nil
    elsif lower >= upper
      nil
    else
      # Преобразуем диапазон [lower, upper] в массив и оставляем в нем только
      # те числа, которые являются палиндромами.
      (lower..upper).to_a.select { |elem| palindrome? elem }
    end
  end

  # Проверяет, является ли число палиндромом.
  # @param x Integer число для проверки.
  # @return Bool
  def palindrome?(x)
    x.to_s(2) == x.to_s(2).reverse
  end
end
