require 'rails_helper'

describe Movie, type: :model do
  describe '#movies_same_director' do
    context 'single movie with that director' do 
      let(:movie1) {Movie.new(director: 'Ridley Scott')}
      it 'finds director in only one movie' do 
        allow(movie1).to receive(:director).and_return('Ridley Scott')
        allow(Movie).to receive(:where).with(director: 'Ridley Scott').and_return([movie1])
        expect(movie1.movies_same_director).to eq({director: 'Ridley Scott', movies: [movie1]})
      end
      
    end
    context 'multiple movies with that director'do 
      let(:movie2) {Movie.new(director: 'George Lucas')}
      let(:movie3) {Movie.new(director: 'George Lucas')}
      it 'finds director in multiple movies' do 
        allow(movie2).to receive(:director).and_return('George Lucas')
        allow(Movie).to receive(:where).with(director: 'George Lucas').and_return([movie2,movie3])
        expect(movie2.movies_same_director).to eq({director: 'George Lucas', movies: [movie2,movie3]})
      end
    end
    context 'movie has no director'do 
      let(:movie4) {Movie.new(director: '')}
      it 'doesnt displays a movie' do 
        allow(movie4).to receive(:director).and_return('')
        allow(Movie).to receive(:where).with(director:'').and_return([movie4])
        expect(movie4.movies_same_director).to eq(nil)
      end
      
    end
  end
  
  describe 'All ratings are checked' do
    it 'Checks all rating'do
      expect(Movie.all_ratings).to match(%w(G PG PG-13 NC-17 R))
    end
  end

end
