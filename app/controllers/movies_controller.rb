class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def ordered_title
  #   @movies = Movie.all.order(:title)
  #   render :template => 'movies/index'
  # end

  def index
    @movies = Movie.all.order(params[:sort])
    @title_header = 'hilite' if params[:sort] == 'title'
    @release_date_header = 'hilite' if params[:sort] == 'release_date'

    @all_ratings = Movie.get_all_ratings

    if params[:ratings]
      @checked_ratings = params[:ratings].keys
      session[:ratings] = @checked_ratings
      @movies = Movie.where(rating: @checked_ratings)
    else
      @checked_ratings = @all_ratings
      if session[:ratings]
        @checked_ratings = session[:ratings]
        @movies = Movie.where(rating: @checked_ratings)
      else
        @movies = Movie.all.order(params[:sort])
        @selected_ratings = @all_ratings
      end
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
