class Episode < ApplicationRecord
  # Associations
  has_many :character_episodes, dependent: :destroy
  has_many :characters, through: :character_episodes

  # Get all locations featured in this episode (through characters)
  def locations
    Location.joins('JOIN characters ON characters.current_location_id = locations.id OR characters.origin_location_id = locations.id')
            .joins('JOIN character_episodes ON character_episodes.character_id = characters.id')
            .where('character_episodes.episode_id = ?', id)
            .distinct
  end

  # Validations
  validates :api_id, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :episode_code, presence: true, length: { maximum: 10 }
  validates :air_date, length: { maximum: 50 }

  # Custom validation for episode code format
  validates :episode_code, format: {
    with: /\AS\d{2}E\d{2}\z/,
    message: "must be in format S##E## (e.g., S01E01)"
  }

  # Scopes for common queries
  scope :by_season, ->(season) { where('episode_code LIKE ?', "S#{season.to_s.rjust(2, '0')}%") }
  scope :chronological, -> { order(:episode_code) }
  scope :aired_after, ->(date) { where('air_date > ?', date) }
  scope :aired_before, ->(date) { where('air_date < ?', date) }

  # Custom methods
  def season_number
    episode_code.match(/S(\d{2})/)[1].to_i
  end

  def episode_number
    episode_code.match(/E(\d{2})/)[1].to_i
  end

  def character_count
    characters.count
  end

  def main_characters
    characters.where(status: 'Alive').limit(5)
  end

  def to_s
    "#{episode_code}: #{name}"
  end
end