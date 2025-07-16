class HomeController < ApplicationController
  def index
    @stats = {
      characters_count: Character.count,
      locations_count: Location.count,
      episodes_count: Episode.count,
      status_distribution: Character.group(:status).count,
      top_species: Character.group(:species).count.sort_by { |_, count| -count }.first(5)
    }
  end
end