class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]


  def index
    def index
      @books = if params[:search].present?
                 Book.where('UPPER(title) LIKE ? OR UPPER(author) LIKE ?', "%#{params[:search].upcase}%", "%#{params[:search].upcase}%").page(params[:page]).per(15)
               else
                 Book.page(params[:page]).per(15)
               end

      respond_to do |format|
        format.html # standard HTML response (renders full page)
        format.turbo_stream # Turbo response (renders only the books list)
      end
    end
  end

  def show
    @book = Book.find(params[:id])
    @review = @book.reviews.build  # This initializes an empty Review object
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
