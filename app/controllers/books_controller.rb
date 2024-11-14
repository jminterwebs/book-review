class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @books = Book.all

  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews
  end

  def new
    @book = Book.new
    @book.reviews.build  # Initialize a review for the book
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Book and review added successfully!'
    else
      render :new
    end
  end


  def edit

  end

  def update

  end

  def destroy

  end

  private

  def book_params
    params.require(:book).permit(
      :title, :author, :publication_year, :isbn,
      reviews_attributes: [:rating, :content, :user_id]
    )
  end
end
