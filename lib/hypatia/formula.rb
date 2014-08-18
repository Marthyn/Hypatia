class Formula
  attr_reader :result, :operations

  def initialize(operations)
    @operations = operations
  end

  def text
    @operations.map(&:text).join(" \n ")
  end

  def result
    @operations.last.result
  end

  def difficulty
    if @operations.length > 0
      FormulaDifficultyCalculator.new(self).difficulty
    else
      nil
    end
  end
end

class Constant
  def initialize(value)
    @value = value
  end

  def value
    if @value.is_a?(Operation)
      @value.result
    else
      @value
    end
  end
end

class Operation
  attr_reader :constant1, :constant2, :operator
  def initialize(operator, constant1, constant2)
    @operator = operator
    @constant1 = constant1
    @constant2 = constant2
  end

  def text
    "#{@constant1.value} #{@operator} #{@constant2.value}"
  end

  def result
    @constant1.value.send(@operator, @constant2.value)
  end
end
