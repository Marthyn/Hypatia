require "spec_helper"

describe FormulaDifficultyCalculator do
  OPERATORS = [:+, :-, :/, :*]
  let(:difficulty_calculator) { FormulaDifficultyCalculator.new(double) }

  describe "#compute_difficulty" do
    let(:operation1) do
      Operation.new(OPERATORS.sample,
                    Constant.new(rand(50)),
                    Constant.new(rand(50)))
    end
    let(:operation2) do
      Operation.new(OPERATORS.sample,
                    Constant.new(operation1),
                    Constant.new(rand(20)))
    end
    let(:formula) { Formula.new([operation1, operation2]) }

    it "returns an integer higher than zero" do
      expect(FormulaDifficultyCalculator.new(formula).difficulty).to be > 0
    end
  end

  describe "#compute_subtraction_difficulty" do
    it "20 - 10 is easier than 64 - 19" do
      calculator_a = SubtractionOperationDifficultyCalculator.new(
                       [2, 5], [1, 5]
                     )
      calculator_b = SubtractionOperationDifficultyCalculator.new(
                       [6, 4], [1, 8]
                     )
      difficulty_a = calculator_a.compute_difficulty
      difficulty_b = calculator_b.compute_difficulty

      expect(difficulty_a).to be < difficulty_b
    end
  end

  describe "#compute_addition_difficulty" do
    it "5 + 15 is easier than 13 + 29" do
      calculator_a = AdditionOperationDifficultyCalculator.new(
                       [5], [1, 5]
                     )
      calculator_b = AdditionOperationDifficultyCalculator.new(
                       [1, 3], [2, 9]
                     )
      difficulty_a = calculator_a.compute_difficulty
      difficulty_b = calculator_b.compute_difficulty

      expect(difficulty_a).to be < difficulty_b
    end
  end

  describe "#compute_multiplication_difficulty" do
    it "10 * 1 is easier than 23 * 11" do
      calculator_a = MultiplicationOperationDifficultyCalculator.new(
                       [1, 0], [1]
                     )
      calculator_b = MultiplicationOperationDifficultyCalculator.new(
                       [2, 3], [1, 1]
                     )
      difficulty_a = calculator_a.compute_difficulty
      difficulty_b = calculator_b.compute_difficulty

      expect(difficulty_a).to be < difficulty_b
    end
  end

  describe "#compute_division" do
    it "10 / 10 is easier than 19 / 3" do
      calculator_a = DivisionOperationDifficultyCalculator.new(
                       [1, 0], [1, 0]
                     )
      calculator_b = DivisionOperationDifficultyCalculator.new(
                       [1, 9], [3]
                     )
      difficulty_a = calculator_a.compute_difficulty
      difficulty_b = calculator_b.compute_difficulty

      expect(difficulty_a).to be < difficulty_b
    end
  end
end
