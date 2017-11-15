require 'rails_helper'

describe Movie, type: :model do
  describe '#find_with_same_director' do
      describe 'When searching for the same director' do
        before :each do
            @director1 = 'The Unknown Director'
            @movie1 = double('movie1')
            @movie2 = double('movie2')
            @results = [@movie1, @movie2]
        end
    end
    it 'calls the Movie where' do
       expect(Movie).to receive(:where).with(:director => @director1).and_return(@results)
       Movie.new(:director => @director1).find_with_same_director
    end
    it 'returns the results to the controller' do
        allow(Movie).to receive(:where).with(:director => @director1).and_return(@results)
        expect(Movie.new(:director => @director1).find_with_same_director).to eq(@results)
    end
    end
end