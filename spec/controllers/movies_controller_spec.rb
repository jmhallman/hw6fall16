require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    it 'should look for invalid search terms and post a flash message for user' do
      fake_results = [double('Movie1'), double('Movie2')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => ''}
      expect(flash[:notice]).to eq("Invalid Search Terms")
    end 
    it 'should post a flash message to user notifying no movie matches' do
      post :search_tmdb, {:search_terms => 'strudxfcglh;kggljk'}
      allow(Movie).to receive(:find_in_tmdb).and_return([])
      expect(response).to redirect_to(movies_path)
      expect(flash[:notice]).to eq("No matching movies were found on TMDb")
    end
  end
  describe 'adding from TMDb' do
    it 'should post a flash message to the user if no movies were selected' do
      post :add_tmdb, {:tmdb_movies => nil}
      expect(response).to redirect_to(movies_path)
      expect(flash[:notice]).to eq("No movies selected")
    end 
    it 'should post a flash message to the user if movies are added' do
      expect(Movie).to receive(:create_from_tmdb).with("Lethal Weapon")
      post :add_tmdb, {:tmdb_movies => {"Lethal Weapon": "1"}}
      expect(response).to redirect_to(movies_path)
      expect(flash[:notice]).to eq("Movies successfully added to Rotten Potatoes")
    end 
  end
end
