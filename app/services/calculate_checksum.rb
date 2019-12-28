# based on Luhn algorithm (https://en.wikipedia.org/wiki/Luhn_algorithm)
# for supporting non-digit input, we simply use the byte value of each char as code point
# so instead of '1' becoming the digit 1, it becomes 0x31 (49), while 'A' becomes 0x41 (65) and 'a' becomes 0x61 (141)
# We calculate and use the digit sum mod 10 for each code point which results in a checksum between 0 and 9.
class CalculateChecksum
  def call(code)
    return 0 if code.blank?

    digits = digits(code.to_s)
    weighted_digits = weight_digits(digits)
    sum_digits(weighted_digits)
  end

  def digits(code)
    digit_sums = code.reverse.bytes.map { |number| digit_sum(number) }
    digit_sums.map { |number| number % 10 }
  end

  def digit_sum(number)
    number.to_s.chars.map(&:to_i).reduce(:+)
  end

  def sum_digits(weighted_digits)
    weighted_digits.reduce(:+) % 10
  end

  def weight_digits(digits)
    digits.each_with_index.map { |digit, index| index.even? ? double_digit(digit) : digit }
  end

  def double_digit(digit)
    digit_sum(digit * 2)
  end
end
