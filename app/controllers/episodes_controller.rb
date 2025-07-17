class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show]

  def index
    @episodes = Episode.all
    @total_episodes = Episode.count

    # Search functionality
    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      @episodes = @episodes.where("LOWER(name) LIKE ? OR LOWER(episode_code) LIKE ?", term, term)
    end


    # Include associated models to avoid N+1 queries
    @episodes = @episodes.includes(:characters)

    # Order by episode code for better organization
    @episodes = @episodes.order(:episode_code)

    @episodes = @episodes.page(params[:page]).per(12)
  end

  def show
    # @episode is set by before_action
  end

  private

  def set_episode
    @episode = Episode.find(params[:id])
  end

  def page_number
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end