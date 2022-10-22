class Question
  attr_reader :time, :points, :variants_answer

  def initialize(text, time, points, variants_answer)
    @text = text
    @time = time
    @points = points
    @variants_answer = variants_answer.shuffle
  end

  def to_s
    <<~SHOW

      Время на вопрос - #{@time} сек.
      Баллов за ответ - #{@points}

      Внимание вопрос:
      #{@text}

      #{show_variants_answer}
    SHOW
  end

  def show_variants_answer
    variants_answer.map.with_index(1) do |variant, index|
      "#{index}. #{variant}"
    end.join("\n")
  end

  def right_answer
    variants_answer.find(&:right?)
  end

  def correctly_answered?(index)
    return false if index.nil? || index < 1

    answer = variants_answer[index - 1]

    return false if answer.nil?

    answer.right?
  end
end
