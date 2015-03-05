[![Build Status](https://travis-ci.org/Marthyn/Hypatia.svg?branch=master)](https://travis-ci.org/Marthyn/Hypatia) 
[![Code Climate](https://codeclimate.com/github/Marthyn/Hypatia/badges/gpa.svg)](https://codeclimate.com/github/Marthyn/Hypatia)

# Hypatia

You can use this gem for calculating the difficulty of a basic mathematical operation.

This gem is part of the app [MedMath](http://www.medmath.com)

## Installation

Add this line to your application's Gemfile:

    gem 'hypatia'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hypatia

## Usage

To get the difficulty for a basic operation you have to create a **Formula**. It consists of **Operations**.
An **Operation** consists of 2 **Constants** and an **Operator**.

So for example if you want to know the difficulty of 1 + 2 you write the following code.

```ruby
operation = Operation.new(:+,
                          Constant.new(1),
                          Constant.new(2))

formula = Formula.new([operation])

difficulty = formula.difficulty

#you can get the result of the formula like this

formula.result #eq 3
```

A Constant can also contain another operation, that is if you want to chain operations in one **Formula**. Like (1 + 2) * 5. This works like this:

```ruby
operations << Operation.new(:+,
                            Constant.new(1),
                            Constant.new(2))

operations << Operation.new(:*,
                            Constant.new(operations.last),
                            Constant.new(5))

formula = Formula.new(operations)

difficulty = formula.difficulty

#you can get the result of the formula like this

formula.result #eq 15
```

More info is in the [wiki]()

## Contributing

We'd love some input on this. First of all the way difficulty is determined can be improved. The algorithm can be extended. Also maybe you're a mathematician and you see we got it all wrong with the assigning difficulty points for certain aspects of a basic operation. So feedback is more than welcome.

So if you want to contribute create a fork and pull request or just create an issue!

## Origins

During my thesis i created an adaptive medical math trainer that get's more difficult or easier over time. The code in this gem was extracted from that project.

## Team

[@marthyn](https://github.com/marthyn) developed the app/gem

[@jurre](https://github.com/jurre) reviewed the code and helped with a lot of architecture and insights

[@DefactoSoftware](https://github.com/DefactoSoftware) the company at which this was developed

