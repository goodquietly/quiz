require 'timeout'
require_relative 'lib/question'
require_relative 'lib/answer'
require_relative 'lib/quiz'

puts "\nВикторина\n"

current_path = File.dirname(__FILE__)
file_name = current_path + '/data/questions.xml'

quiz = Quiz.read_questions_from_xml(file_name)

until quiz.finished?

  puts quiz.current_question

  begin
    user_index = Timeout.timeout(quiz.current_question_time) { STDIN.gets.to_i }
  rescue Timeout::Error
    puts 'Время вышло!'
  end

  if quiz.answer_is_correct(user_index)
    quiz.collect_points
    puts 'Верно!'
  else
    puts "Неверно. Верный ответ #{quiz.current_question_answer}"
  end

  quiz.next_question!
end

puts quiz.result
