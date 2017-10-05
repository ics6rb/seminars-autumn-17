# Попробуем ввести массив десятичных чисел с клавиатуры через пробел

if $PROGRAM_NAME == __FILE__
  array = gets.chomp.split.map {|x| x.to_s.to_i}
  p array
end
