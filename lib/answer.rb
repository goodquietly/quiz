class Answer
  attr_reader :text

  def initialize(params)
    @text = params[:text]
    @right = params[:right]
  end

  def right?
    @right
  end

  def to_s
    text
  end
end
