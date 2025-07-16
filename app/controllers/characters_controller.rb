class CharactersController < ApplicationController
  before_action :set_character, only: [:show]
  before_action :set_filter_options, only: [:index]

  def index
    @characters = Character.all
    @total_characters = Character.count

    # Search functionality
    if params[:search].present?
      @characters = @characters.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Filter by status
    if params[:status].present?
      @characters = @characters.where(status: params[:status])
    end

    # Filter by species
    if params[:species].present?
      @characters = @characters.where(species: params[:species])
    end

    # Filter by location (for hierarchical navigation)
    if params[:location].present?
      @characters = @characters.where(current_location_id: params[:location])
    end

    # Filter by origin location
    if params[:origin_location].present?
      @characters = @characters.where(origin_location_id: params[:origin_location])
    end

    # Include associated models to avoid N+1 queries
    @characters = @characters.includes(:origin_location, :current_location, :character_episodes)

    @characters = @characters.page(params[:page]).per(12)
  end

  def show
    # @character is set by before_action
  end

  private

  def set_character
    @character = Character.find(params[:id])
  end

  def set_filter_options
    @species_options = Character.distinct.pluck(:species).compact.sort.map { |s| [s, s] }
  end

  def page_number
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end
