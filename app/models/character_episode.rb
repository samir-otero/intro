class CharacterEpisode < ApplicationRecord
  # Associations
  belongs_to :character
  belongs_to :episode

  # Validations
  validates :character_id, presence: true
  validates :episode_id, presence: true
  validates :character_id, uniqueness: { scope: :episode_id, message: "already appears in this episode" }

  # Scopes for common queries
  scope :by_character, ->(character) { where(character: character) }
  scope :by_episode, ->(episode) { where(episode: episode) }
  scope :for_season, ->(season) { joins(:episode).where('episodes.episode_code LIKE ?', "S#{season.to_s.rjust(2, '0')}%") }
  scope :chronological, -> { joins(:episode).order('episodes.episode_code') }

  # Custom methods
  def episode_code
    episode.episode_code
  end

  def character_name
    character.name
  end

  def episode_name
    episode.name
  end

  def air_date
    episode.air_date
  end

  def to_s
    "#{character.name} in #{episode.episode_code}"
  end
end