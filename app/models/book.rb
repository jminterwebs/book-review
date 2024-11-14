class Book < ApplicationRecord

  validates :title, presence: true
  validates :author, presence: true
  validates :publication_year, presence: true
  validates :isbn, presence: true
  validate :isbn_format



  private
  def isbn_format
    unless valid_isbn?(isbn)
      errors.add(:isbn, 'is not a valid ISBN number')
    end
  end

  def valid_isbn?(isbn)
    # Check for ISBN-10 and ISBN-13
    isbn_regex = /^(?:\d{9}[\dX]|\d{13})$/
    return false unless isbn.match?(isbn_regex)

    # Check ISBN-10 checksum
    if isbn.length == 10
      return valid_isbn10?(isbn)
    end

    # Check ISBN-13 checksum
    if isbn.length == 13
      return valid_isbn13?(isbn)
    end

    false
  end

  def valid_isbn10?(isbn)
    digits = isbn.chars.map { |c| c == 'X' ? 10 : c.to_i }
    return false if digits.length != 10
    checksum = digits.each_with_index.sum { |digit, i| digit * (10 - i) }
    checksum % 11 == 0
  end

  def valid_isbn13?(isbn)
    digits = isbn.chars.map(&:to_i)
    return false if digits.length != 13
    checksum = digits.each_with_index.sum { |digit, i| digit * (i.even? ? 1 : 3) }
    checksum % 10 == 0
  end
end
