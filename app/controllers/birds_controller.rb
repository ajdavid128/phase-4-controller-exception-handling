class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  # This logic/abstraction allows for error handling based on our use of the .find method in the the find_bird private method. 

  # The find_bird method will return an Active Record "not found" exception as opposed to retuning "nil" with the .find_by method

  # We also consolidated our conditional if/else logic into the private mthod render_not_found_response which handles the return of the Active Record Not Found exception. By doing this we are able to eliminate the use of if/else and tie this method to the rescue_from inclusion on line 2. This allows any of our paths with the potential to return the Active Record Not Found exception to be "rescued" with a error handling JSON return statement 

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create(bird_params)
    render json: bird, status: :created
  end

  # GET /birds/:id
  def show
      bird = find_bird
      render json: bird
  end

  # PATCH /birds/:id
  def update
      bird = find_bird
      bird.update(bird_params)
      render json: bird
  end

  # PATCH /birds/:id/like
  def increment_likes
      bird = find_bird
      bird.update(likes: bird.likes + 1)
      render json: bird
  end

  # DELETE /birds/:id
  def destroy
      bird = find_bird
      bird.destroy
      head :no_content
  end

  private

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

  def find_bird
    Bird.find(params[:id])
  end

end
