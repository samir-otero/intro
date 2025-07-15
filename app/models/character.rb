class Character < ApplicationRecord
  # Associations
  belongs_to :origin_location, class_name: 'Location', optional: true
  belongs_to :current_location, class_name: 'Location', optional: true

  has_many :character_episodes, dependent: :destroy
  has_many :episodes, through: :character_episodes

  # Get characters from the same origin location
  def origin_neighbors
    return Character.none unless origin_location
    origin_location.origin_characters.where.not(id: id)
  end

  # Get characters from the same current location
  def current_neighbors
    return Character.none unless current_location
    current_location.current_characters.where.not(id: id)
  end

  # Validations
  validates :api_id, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :status, inclusion: { in: %w[Alive Dead unknown] }
  validates :species, length: { maximum: 100 }
  validates :gender, length: { maximum: 20 }
  validates :image_url, length: { maximum: 500 }
  validates :image_url, format: {
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "must be a valid URL"
  }, allow_blank: true

  # Scopes for common queries
  scope :alive, -> { where(status: 'Alive') }
  scope :dead, -> { where(status: 'Dead') }
  scope :unknown_status, -> { where(status: 'unknown') }
  scope :by_species, ->(species) { where(species: species) }
  scope :by_gender, ->(gender) { where(gender: gender) }
  scope :by_status, ->(status) { where(status: status) }
  scope :from_location, ->(location) { where(current_location: location) }
  scope :originated_from, ->(location) { where(origin_location: location) }
  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  # Custom methods
  def episode_count
    episodes.count
  end

  def first_appearance
    episodes.order(:episode_code).first
  end

  def last_appearance
    episodes.order(:episode_code).last
  end

  def is_main_character?
    episode_count >= 10 # Arbitrary threshold for "main" character
  end

  def same_species_characters
    Character.by_species(species).where.not(id: id)
  end

  def moved_locations?
    origin_location != current_location
  end

  def status_color
    case status
    when 'Alive' then 'green'
    when 'Dead' then 'red'
    when 'unknown' then 'gray'
    end
  end

  def to_s
    name
  end
end