require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:review) { create(:review, book: book, user: user) }

  # Authentication setup
  before do
    sign_in user # Use Devise helper to sign in a user
  end

  describe 'GET #new' do
    it 'assigns a new review to @review' do
      get :new, params: { book_id: book.id, review: { content: "Good Book", rating: 5, user_id: user.id } }, format: :turbo_stream
      # Debugging: Check if @review is a new Review instance
      expect(assigns(:review)).to be_a_new(Review)
    end

    it 'assigns the requested book to @book' do
      get :new, params: { book_id: book.id, review: { content: "Good Book", rating: 5, user_id: user.id } }, format: :turbo_stream
      # Debugging: Check if the book was assigned correctly
      expect(assigns(:book)).to eq(book)
    end
  end

  describe 'GET #index' do
    it 'assigns the user reviews to @reviews' do
      get :index, params: { user_id: user.id }
      expect(assigns(:reviews)).to eq(user.reviews)
    end

    it 'renders the index template' do
      get :index, params: { user_id: user.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new review and redirects to the book page' do
        expect {
          post :create, params: { book_id: book.id, review: { content: 'Great book!', rating: 5, user_id: user.id } }
        }.to change(Review, :count).by(1)
        expect(response).to redirect_to(book_path(book))
        expect(flash[:notice]).to eq('Review was successfully added.')
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested review to @review' do
      get :edit, params: { id: review.id }
      expect(assigns(:review)).to eq(review)
    end

    it 'assigns the current user to @user' do
      get :edit, params: { id: review.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: review.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the review and redirects to the user reviews path' do
        put :update, params: { id: review.id, review: { content: 'Updated review content', rating: 4 } }
        review.reload
        expect(review.content).to eq('Updated review content')
        expect(response).to redirect_to(user_reviews_path(user))
        expect(flash[:notice]).to eq('Review was successfully updated.')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the review and redirects to user reviews path' do
      review_to_delete = create(:review, user: user, book: book)
      expect {
        delete :destroy, params: { id: review_to_delete.id }
      }.to change(Review, :count).by(-1)
      expect(response).to redirect_to(user_reviews_path(user))
      expect(flash[:notice]).to eq('Review was successfully deleted.')
    end
  end
end
