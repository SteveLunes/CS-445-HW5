require 'rails_helper'

describe MoviesController, type: :controller do
  describe '#similar' do
    before :each do
      @id1 = '1'
      @id2 = '2'
      @id3 = '3'
      @director1 = 'The Unknown Director'
      @director2 = nil
      @director3 = nil
      @movie1 = double('movie1')
      @movie2 = double('movie2')
      @movie3 = double('movie3', :title => 'Alien')
      @results = [@movie1, @movie2]
    end
    context 'When movie record has a director' do
      describe 'When searching for movie the same director' do
        it 'calls the find method to retrieve the movie' do
          expect(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
        end
        it 'calls the director getter on the movie' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          expect(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
          expect(assigns(:director)).to eq(@director1)
        end
        it 'makes retrieved director available' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
          expect(assigns(:director)).to eq(@director1)
        end
        it 'calls the model method to find similar movies' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          expect(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
        end
        it 'selects the Same Director template for rendering' do
           allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
           allow(@movie1).to receive(:director).and_return(@director1)
           allow(@movie1).to receive(:find_with_same_director).and_return(@results)
           get :similar, :id => @id1
           expect(response).to render_template('similar')
           #get :similar, :id => @id1
        end
        it 'makes the results available to the template' do
          allow(Movie).to receive(:find).with(@id1).and_return(@movie1)
          allow(@movie1).to receive(:director).and_return(@director1)
          allow(@movie1).to receive(:find_with_same_director).and_return(@results)
          get :similar, :id => @id1
          expect(assigns(:movies)).to eq(@results)
        end
      end
    end
    context 'When movie record has no director' do
      describe 'When searching for movie with same director' do
        it 'Checks to see if director has no value' do
         # allow_message_expectations_on_nil
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          expect(@director3).to be_blank
          allow(@movie3).to receive(:title)
          get :similar, :id => @id3
         # expect(assigns(:director)).to be_nil
        end
=begin
        it 'makes the director available' do
         # allow_message_expectations_on_nil
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          allow(@director3).to be_blank
          get :similiar, :id =>@id3
         # expect(assigns(:director)).to be_nil
        end
=end
        it 'Sets a flash message' do
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          get :similar, :id => @id3
          expect(flash[:warning]).to eq("'#{@movie3.title}' has no director info")
        end
        it 'Redirects to the movies page' do
          allow(Movie).to receive(:find).with(@id3).and_return(@movie3)
          allow(@movie3).to receive(:director).and_return(@director3)
          allow(@movie3).to receive(:title)
          get :similar, :id => @id3
          expect(response).to redirect_to(movies_path)
        end
      end
    end
  end
  describe 'GET index' do

    it 'should render the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'should assign instance variable for title header' do
      get :index, { sort: 'title'}
      expect(assigns(:title_header)).to eql('hilite')
    end

    it 'should assign instance variable for release_date header' do
      get :index, { sort: 'release_date'}
      expect(assigns(:date_header)).to eql('hilite')
    end
  end

  describe 'GET new' do

    it 'should render the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    let!(:movie) {FactoryBot.create(:movie)}
    it 'creates a new movie' do
      expect {post :create, movie: FactoryBot.attributes_for(:movie)
      }.to change { Movie.count }.by(1)
    end

    it 'redirects to the movie index page' do
      post :create, movie: FactoryBot.attributes_for(:movie)
      expect(response).to redirect_to(movies_url)
    end
  end

  describe 'GET #show' do
    let!(:movie) { FactoryBot.create(:movie) }
    before(:each) do
      get :show, id: movie.id
    end

    it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie)
    end

    it 'should render the show template' do
      expect(response).to render_template('show')
    end
  end

  describe 'GET #edit' do
    let!(:movie) { FactoryBot.create(:movie) }
    before do
      get :edit, id: movie.id
    end

    it 'should find the movie' do
      expect(assigns(:movie)).to eql(movie)
    end

    it 'should render the edit template' do
      expect(response).to render_template('edit')
    end
  end

  describe 'PUT #update' do
    let(:movie1) { FactoryBot.create(:movie) }
    before(:each) do
      put :update, id: movie1.id, movie: FactoryBot.attributes_for(:movie, title: 'Updated')
    end

    it 'updates an existing movie' do
      movie1.reload
      expect(movie1.title).to eql('Updated')
    end

    it 'redirects to the movie page' do
      expect(response).to redirect_to(movie_path(movie1))
    end
  end
end
