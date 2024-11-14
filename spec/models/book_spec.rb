require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { build(:book) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(book).to be_valid
    end

    it 'is not valid without a title' do
      book.title = nil
      expect(book).to_not be_valid
      expect(book.errors[:title]).to include("can't be blank")
    end

    it 'is not valid without an author' do
      book.author = nil
      expect(book).to_not be_valid
      expect(book.errors[:author]).to include("can't be blank")
    end

    it 'is not valid without a publication year' do
      book.publication_year = nil
      expect(book).to_not be_valid
      expect(book.errors[:publication_year]).to include("can't be blank")
    end

    it 'is not valid without an isbn' do
      book.isbn = nil
      expect(book).to_not be_valid
      expect(book.errors[:isbn]).to include("can't be blank")
    end

    it 'is not valid with a duplicate isbn' do
      create(:book, isbn: '4690911637844')
      book.isbn = '4690911637844'
      expect(book).to_not be_valid
      expect(book.errors[:isbn]).to include("has already been taken")
    end

    it 'is not valid with an incorrect isbn format (ISBN-10)' do
      book.isbn = '123456789Q'
      expect(book).to_not be_valid
      expect(book.errors[:isbn]).to include('is not a valid ISBN number')
    end

    it 'is valid with a correct isbn format (ISBN-10)' do
      book.isbn = '0306406152'
      expect(book).to be_valid
    end

    it 'is not valid with an incorrect isbn format (ISBN-13)' do
      book.isbn = '123456789012'
      expect(book).to_not be_valid
      expect(book.errors[:isbn]).to include('is not a valid ISBN number')
    end

    it 'is valid with a correct isbn format (ISBN-13)' do
      book.isbn = '9780306406157'
      expect(book).to be_valid
    end
  end

  describe 'associations' do
    it 'has many reviews' do
      expect(Book.reflect_on_association(:reviews).macro).to eq(:has_many)
    end

    it 'destroys associated reviews when destroyed' do
      book.save
      review = create(:review, book: book)
      expect { book.destroy }.to change { Review.count }.by(-1)
    end
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for reviews' do
      book_with_reviews = build(:book, reviews_attributes: [{ content: 'Great book', rating: 5 }])
      expect(book_with_reviews.reviews.first).to be_a_new(Review)
    end
  end
end
