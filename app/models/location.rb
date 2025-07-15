class Location < ApplicationRecord
  # Associations
  has_many :origin_characters, class_name: 'Character', foreign_key: 'origin_location_id', dependent: :nullify
  has_many :current_characters, class_name: 'Character', foreign_key: 'current_location_id', dependent: :nullify

  # Convenience method to get all characters associated with this location
  def all_characters
    Character.where('origin_location_id = ? OR current_location_id = ?', id, id).distinct
  end

  # Get episodes that feature characters from this location
  def episodes
    Episode.joins(character_episodes: :character)
           .where('characters.origin_location_id = ? OR characters.current_location_id = ?', id, id)
           .distinct
  end

  # Validations
  validates :api_id, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :type, length: { maximum: 100 }
  validates :dimension, length: { maximum: 255 }

  # Scopes for common queries
  scope :planets, -> { where(type: 'Planet') }
  scope :dimensions, -> { where(type: 'Dimension') }
  scope :by_type, ->(type) { where(type: type) }
  scope :by_dimension, ->(dimension) { where(dimension: dimension) }

  # Custom methods
  def resident_count
    current_characters.count
  end

  def origin_count
    origin_characters.count
  end

  def total_character_count
    all_characters.count
  end

  def to_s
    name
  end
end