require 'rails_helper'



describe MoviesController, type: :controller do
  describe "#similar" do
    context "When the movie has a director" do 
      describe "When only one movie has that director" do
        let(:id1) {'1'}  
        let(:movie1) {instance_double('Movie', title: 'Blade Runner', director: 'Ridley Scott')}
        let(:id2) {'2'}
        let(:movie2) {instance_double('Movie', title: 'Star Wars', director: 'George Lucas')}
        let(:movies_director_hash) {{director: 'Ridley Scott', movies: [movie1]}}
        it "retrieves the director and only one movie" do 
          allow(Movie).to receive(:find).with(id1).and_return(movie1)
          expect(movie1).to receive(:movies_same_director).and_return({director: 'Ridley Scott', movies: [movie1] })
          get :similar, :id => id1
        end
        
        it 'makes the result available to the template ' do 
          allow(Movie).to receive(:find).with(id1).and_return(movie1)
          allow(movie1).to receive(:movies_same_director).and_return({director: 'Ridley Scott', movies: [movie1] })
          get :similar, :id => id1
          expect(assigns(:movies_director_hash)).to eq(director: 'Ridley Scott', movies: [movie1])

        end
        it 'selects the similar template for rendering' do
          allow(Movie).to receive(:find).with(id1).and_return(movie1)
          allow(movie1).to receive(:movies_same_director).and_return({director: 'Ridley Scott', movies: [movie1] })
          get :similar, :id => id1
          expect(response).to render_template('similar')
         end
        
      end
      describe "When multiple movies have that director" do 
        let(:id1) {'1'}  
        let(:movie1) {instance_double('Movie', title: 'Blade Runner', director: 'Ridley Scott')}
        let(:id2) {'2'}
        let(:movie2) {instance_double('Movie', title: 'Star Wars', director: 'George Lucas')}
        let(:id3) {'3'}
        let(:movie3) {instance_double('Movie', title: 'THX-1138', director: 'George Lucas')}
        let(:movies_director_hash) {{director: 'George Lucas', movies: [movie2,movie3]}}
        
        it 'retrieves the directors and multiple movies' do 
          allow(Movie).to receive(:find).with(id2).and_return(movie2)
          expect(movie2).to receive(:movies_same_director).and_return({director: 'George Lucas', movies: [movie2,movie3]})
          get :similar, :id => id2
        end
        it  'makes the result available to the template ' do 
          allow(Movie).to receive(:find).with(id2).and_return(movie2)
          allow(movie2).to receive(:movies_same_director).and_return({director: 'George Lucas', movies: [movie2,movie3] })
          get :similar, :id => id2
          expect(assigns(:movies_director_hash)).to eq(director: 'George Lucas', movies: [movie2,movie3])

        end
        it 'selects the similar template for rendering' do
          allow(Movie).to receive(:find).with(id2).and_return(movie2)
          allow(movie2).to receive(:movies_same_director).and_return({director: 'George Lucas', movies: [movie2,movie3] })
          get :similar, :id => id2
          expect(response).to render_template('similar')
        end
      end
    end
    
    context "When movie has no director" do
      let(:id1) {'1'}  
      let(:movie1) {instance_double('Movie', title: 'Alien', director: '')}
      let(:id2) {'2'}
      let(:movie2) {instance_double('Movie', title: 'Star Wars', director: 'George Lucas')}
      let(:movies_director_hash) {{director: 'Ridley Scott', movies: [movie1]}}
      it "unable to retrieve the director for that movie" do 
        allow(Movie).to receive(:find).with(id1).and_return(movie1)
        expect(movie1).to receive(:movies_same_director).and_return({director: '', movies: [] })
        get :similar, :id => id1
      end
      
      it  'sends a flash message' do 
        allow(Movie).to receive(:find).with(id1).and_return(movie1)
        allow(movie1).to receive(:movies_same_director).and_return({director: '', movies: [] })
        get :similar, :id => id1
        expect(flash[:warning]).to eq("'#{movie1.title}' has no director info")

      end
      it 'redirects to the movie page' do
        allow(Movie).to receive(:find).with(id1).and_return(movie1)
        allow(movie1).to receive(:movies_same_director).and_return({director: '', movies: [] })
        get :similar, :id => id1
        expect(response).to redirect_to(movies_path)
       end
    end
  end
end