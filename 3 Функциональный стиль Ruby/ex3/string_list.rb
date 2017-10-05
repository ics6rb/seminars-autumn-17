# Вводим последовательность строк из терминала, пока не
# найден конец файла.

# Конец файла - EOF. В Windows Ctrl + Z, в unix Ctrl + D.

if $PROGRAM_NAME == __FILE__
  first_array = []
  second_array = []

  while line = gets
    first_array << line.chomp!
  end

  STDIN.each_line do |line|
    second_array << line
  end

  p first_array
  p second_array
end