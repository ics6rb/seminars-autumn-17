# Здесь идет работа с пользовательским вводом

require_relative './src'

if $PROGRAM_NAME == __FILE__
  print 'Введите число от 0 до 9: '

  # Читаем пользовательский ввод
  input = gets
  p 'Ввели', input

  # Чтобы убрать ненужные \n или \r\n, вызываем chomp
  number = input.chomp.to_s.to_i
  puts 'Убрали \r\n', number

  # Фишки Ruby - красивая проверка диапазона.
  if number.between? 0, 9
    puts 'Результат операции: ', square(number)
  else
    puts 'Неверный формат числа'
  end
end
