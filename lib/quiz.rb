require 'rexml/document'

class Quiz
  def self.read_questions_from_xml(file_name)
    file = File.new(file_name, 'r:utf-8')
    doc = REXML::Document.new(file)
    file.close

    questions = []

    doc.elements.each('questions/question') do |questions_element|
      time = questions_element.attributes['seconds'].to_i
      price_per_answer = questions_element.attributes['points'].to_i
      text_question = ''
      variants_answer = []

      questions_element.elements.each do |question_element|
        case question_element.name
        when 'text'
          text_question = question_element.text
        when 'variants'
          question_element.elements.each do |variant|
            variants_answer << Answer.new(text: variant.text, right: variant.attributes.key?('right'))
          end
        end
      end

      questions << Question.new(text_question, time, price_per_answer, variants_answer)
    end

    new(questions)
  end

  attr_reader :current_question, :questions

  def initialize(questions)
    @questions = questions.shuffle
    @current_question_index = 0
    @points = []
  end

  def finished?
    current_question.nil?
  end

  def next_question!
    @current_question_index += 1
  end

  def current_question
    @questions[@current_question_index]
  end

  def result
    <<~RESULT

      Количество верных ответов - #{count_the_number_of_answers} из #{@questions.size}
      Набранное количество баллов - #{calculate_the_score}
    RESULT
  end

  def collect_points
    @points << current_question.points
  end

  def current_question_time
    current_question.time
  end

  def current_question_answer
    current_question.right_answer
  end

  def answer_is_correct(user_index)
    current_question.correctly_answered?(user_index)
  end

  def calculate_the_score
    @points.sum
  end

  def count_the_number_of_answers
    @points.size
  end
end
