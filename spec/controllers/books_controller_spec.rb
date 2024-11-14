require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  # Authentication setup
  before do
    sign_in user # Use Devise helper to sign in a user
  end

  describe 'GET #index' do
    let!(:book1) { create(:book, title: 'Ruby Programming') }
    let!(:book2) { create(:book, title: 'Rails Programming') }

    context 'when search is present' do
      it 'returns filtered books based on search term' do
        get :index, params: { search: 'ruby' }
        expect(assigns(:books)).to match_array([book1])
      end
    end

    context 'when search is not present' do
      it 'returns all books' do
        get :index
        expect(assigns(:books)).to match_array([book1, book2])
      end
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'responds with turbo_stream format' do
      get :index, format: :turbo_stream
      expect(response.content_type).to include('text/vnd.turbo-stream.html')
    end
  end

  describe 'GET #show' do
    it 'assigns the requested book to @book' do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end

    it 'renders the show template' do
      get :show, params: { id: book.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new book to @book' do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new book' do
        expect {
          post :create, params: { book: { title: 'New Book', author: 'Author Name', publication_year: 2001, isbn: '1557044274694' } }
        }.to change(Book, :count).by(1)
        expect(response).to redirect_to(book_path(assigns(:book)))
        expect(flash[:notice]).to eq('Book and review added successfully!')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new book and re-renders the new template' do
        expect {
          post :create, params: { book: { title: '', author: '' } }
        }.to_not change(Book, :count)
        expect(response).to render_template(:new)
      end
    end
  end
end
