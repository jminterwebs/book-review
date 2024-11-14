class ReviewsController < ApplicationController

  def new
    @book = Book.find(params[:book_id])
    @review = @book.reviews.build(review_params)
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


  private
  def review_params
    params.require(:review).permit(:content, :rating, :user_id)
  end
end
