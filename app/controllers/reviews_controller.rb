class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:index, :edit, :update, :destroy]
  def new
    @book = Book.find(params[:book_id])
    @review = @book.reviews.build(review_params)
  end

  def index
    @reviews = @user.reviews
  end
  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.build(review_params)

    if @review.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @book, notice: "Review was successfully added." }
      end
    else
      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
    @user = current_user
  end
  def update
    binding.pry
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to user_reviews_path(@user), notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    redirect_to user_reviews_path(@user), notice: 'Review was successfully deleted.'

  end

  private

  def set_user
    @user = current_user
  end
  def review_params
    params.require(:review).permit(:content, :rating, :user_id)
  end
end
