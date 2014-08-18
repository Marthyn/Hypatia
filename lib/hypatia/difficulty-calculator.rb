class FormulaDifficultyCalculator
  def initialize(formula)
    @formula = formula
  end

  def difficulty
    difficulty = 0
    @formula.operations.each do |operation|
      constant1, constant2 = get_constants(operation)
      difficulty = difficulty +
                   build_operation_difficulty_calculator(operation.operator,
                                                         constant1,
                                                         constant2)
    end
    difficulty
  end

  private

  def build_operation_difficulty_calculator(operator, numbers1, numbers2)
    klass = case operator
            when :+ then AdditionOperationDifficultyCalculator
            when :* then MultiplicationOperationDifficultyCalculator
            when :/ then DivisionOperationDifficultyCalculator
            when :- then SubtractionOperationDifficultyCalculator
    end
    klass.new(numbers1, numbers2).compute_difficulty
  end

  def get_constants(operation)
    constants = []
    constants << to_int_array(operation.constant1.value.to_i)
    constants << to_int_array(operation.constant2.value.to_i)
  end

  def to_int_array(integer)
    result_array = []
    while integer > 0
      result_array.unshift integer % 10
      integer /= 10
    end
    result_array
  end
end

class OperationDifficultyCalculator
  attr_reader :difficulty
  def initialize(numbers1, numbers2)
    @numbers1 = numbers1
    @numbers2 = numbers2
    @difficulty = 0
  end
end

class SubtractionOperationDifficultyCalculator <
      OperationDifficultyCalculator
  DIFFICULTIES = {
    digit_zero: 1,    # difference of zero and any digit
    same_digits: 1,    # difference of same values digits
    even_even: 2,    # difference of even digits
    odd_odd: 2,    # difference of odd digits
    even_odd: 3,    # difference of even and odd digits
    borrow: 2,    # doing a borrow
    twodigit_digit: 4 # difference of two-digit number and digit
  }

  def compute_difficulty
    if @numbers1.length < @numbers2.length
      @difficulty += DIFFICULTIES[:borrow]
    end
    @numbers1.reverse.each_with_index do | a , index |
      b = @numbers2.reverse[index]
      case
      when a == nil || b == nil
        @difficulty += DIFFICULTIES[:digit_zero]
      when a == 0 || b == 0
        if a == 0
          @difficulty += DIFFICULTIES[:borrow]
        end
        @difficulty += DIFFICULTIES[:digit_zero]
      when a == b
        @difficulty += DIFFICULTIES[:same_digits]
      when a < b
        @difficulty += DIFFICULTIES[:borrow]
      else
        @difficulty += DIFFICULTIES[:even_odd]
      end
    end
    @difficulty
  end
end

class DivisionOperationDifficultyCalculator <
      OperationDifficultyCalculator
  DIFFICULTIES = {
    digit_zero: 0,
    digit_one: 1,
    digit_two: 2,
    digit_other: 3
  }

  def compute_difficulty
    @numbers1.reverse.each_with_index do | _ , index |
      b = @numbers2.reverse[index]
      case b
      when 0
        @difficulty += DIFFICULTIES[:digit_zero]
      when 1
        @difficulty += DIFFICULTIES[:digit_one]
      when 2
        @difficulty += DIFFICULTIES[:digit_two]
      else
        @difficulty += DIFFICULTIES[:digit_other]
      end
    end
    @difficulty = @difficulty * @numbers2.length
  end
end

class MultiplicationOperationDifficultyCalculator <
      OperationDifficultyCalculator
  DIFFICULTIES = {
    digit_zero: 0,
    digit_one: 1,
    digit_two: 2,
    digit_other: 3
  }

  def compute_difficulty
    if @numbers1.length >= @numbers2.length
      compare(@numbers1, @numbers2)
    else
      compare(@numbers2, @numbers1)
    end
    @difficulty
  end

  private

  def compare(numbersa, numbersb)
    numbersa.reverse.each_with_index do | a , index |
      b = numbersb.reverse[index]
      @difficulty = add_multiplication_difficulties(a)
      @difficulty = add_multiplication_difficulties(b)
    end
  end

  def add_multiplication_difficulties(number)
    case number
    when 0 || nil
      @difficulty += DIFFICULTIES[:digit_zero]
    when 1
      @difficulty += DIFFICULTIES[:digit_one]
    when 2
      @difficulty += DIFFICULTIES[:digit_two]
    else
      @difficulty += DIFFICULTIES[:digit_other]
    end
  end
end

class AdditionOperationDifficultyCalculator < OperationDifficultyCalculator
  DIFFICULTIES = {
    digit_zero: 0,   # any digit added to zero
    under_ten: 3,   # sum of even digits
    ten: 2,   # sum of odd digits   # sum of even and odd digits
    above_ten: 4    # difficulty of carry (for remembering and then adding)
  }

  def compute_difficulty
    if @numbers1.length >= @numbers2.length
      compare(@numbers1, @numbers2)
    else
      compare(@numbers2, @numbers1)
    end
    @difficulty
  end

  def compare(numbersa, numbersb)
    numbersa.reverse.each_with_index do |a , index|
      b = numbersb.reverse[index]
      case
      when a == nil || b == nil
        @difficulty += DIFFICULTIES[:digit_zero]
      when a == 0 || b == 0
        @difficulty += DIFFICULTIES[:digit_zero]
      when (a + b) == 10
        @difficulty += DIFFICULTIES[:ten]
      when (a + b) > 10
        @difficulty += DIFFICULTIES[:above_ten]
      else
        @difficulty += DIFFICULTIES[:under_ten]
      end
    end
  end
end
