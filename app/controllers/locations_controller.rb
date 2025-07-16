class LocationsController < ApplicationController
  before_action :set_location, only: [:show]
  before_action :set_filter_options, only: [:index]

  def index
    @locations = Location.all
    @total_locations = Location.count

    # Search functionality
    if params[:search].present?
      @locations = @locations.where("name ILIKE ?", "%#{params[:search]}%")
    end

    # Filter by location type
    if params[:location_type].present?
      @locations = @locations.where(location_type: params[:location_type])
    end

    # Include associated models to avoid N+1 queries
    @locations = @locations.includes(:current_characters, :origin_characters)

    @locations = @locations.page(params[:page]).per(12)
  end

  def show
    # @location is set by before_action
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def set_filter_options
    @location_types = Location.distinct.pluck(:location_type).compact.sort.map { |t| [t, t] }
  end

  def page_number
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end