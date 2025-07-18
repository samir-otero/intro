# Rick and Morty API Seed Script
# This script pulls data from 3 sources: Characters, Locations, and Episodes

require 'net/http'
require 'json'
require 'uri'
require 'faker'

class RickAndMortySeeder
  BASE_URL = 'https://rickandmortyapi.com/api'

  def initialize
    @locations_cache = {}
    @characters_created = 0
    @locations_created = 0
    @episodes_created = 0
    @character_episodes_created = 0
  end

  def seed_all
    puts "🚀 Starting Rick and Morty database seeding..."
    puts "📡 Connecting to Rick and Morty API..."

    # Clear existing data
    clear_existing_data

    # Seed in order: Locations first, then Characters, then Episodes, then relationships
    seed_locations
    seed_characters
    seed_episodes
    create_character_episode_relationships

    # Add some Faker data for additional variety
    add_faker_data

    print_summary
    puts "✅ Seeding completed successfully!"
  end

  private

  def clear_existing_data
    puts "🧹 Clearing existing data..."
    CharacterEpisode.destroy_all
    Character.destroy_all
    Location.destroy_all
    Episode.destroy_all
    puts "✅ Database cleared"
  end

  # DATA SOURCE 1: LOCATIONS
  def seed_locations
    puts "\n📍 Seeding locations from API..."

    page = 1
    loop do
      response = fetch_api_data("location", page: page)
      break unless response && response['results']

      response['results'].each do |location_data|
        create_location(location_data)
      end

      # Check if there's a next page
      break unless response['info']['next']
      page += 1
    end

    puts "✅ Created #{@locations_created} locations"
  end

  # DATA SOURCE 2: CHARACTERS
  def seed_characters
    puts "\n👥 Seeding characters from API..."

    page = 1
    loop do
      response = fetch_api_data("character", page: page)
      break unless response && response['results']

      response['results'].each do |character_data|
        create_character(character_data)
      end

      # Check if there's a next page
      break unless response['info']['next']
      page += 1
    end

    puts "✅ Created #{@characters_created} characters"
  end

  # DATA SOURCE 3: EPISODES
  def seed_episodes
    puts "\n📺 Seeding episodes from API..."

    page = 1
    loop do
      response = fetch_api_data("episode", page: page)
      break unless response && response['results']

      response['results'].each do |episode_data|
        create_episode(episode_data)
      end

      # Check if there's a next page
      break unless response['info']['next']
      page += 1
    end

    puts "✅ Created #{@episodes_created} episodes"
  end

  def create_location(location_data)
    location = Location.create!(
      api_id: location_data['id'],
      name: location_data['name'],
      location_type: location_data['type'],
      dimension: location_data['dimension']
    )

    # Cache location for character creation
    @locations_cache[location_data['url']] = location
    @locations_created += 1

    print "." if @locations_created % 10 == 0
  rescue ActiveRecord::RecordInvalid => e
    puts "❌ Failed to create location #{location_data['name']}: #{e.message}"
  end

  def create_character(character_data)
    # Find or create origin location
    origin_location = find_or_create_location_from_url(character_data['origin']['url'])
    current_location = find_or_create_location_from_url(character_data['location']['url'])

    character = Character.create!(
      api_id: character_data['id'],
      name: character_data['name'],
      status: character_data['status'],
      species: character_data['species'],
      gender: character_data['gender'],
      image_url: character_data['image'],
      origin_location: origin_location,
      current_location: current_location
    )

    @characters_created += 1
    print "." if @characters_created % 25 == 0

  rescue ActiveRecord::RecordInvalid => e
    puts "❌ Failed to create character #{character_data['name']}: #{e.message}"
  end

  def create_episode(episode_data)
    episode = Episode.create!(
      api_id: episode_data['id'],
      name: episode_data['name'],
      air_date: episode_data['air_date'],
      episode_code: episode_data['episode']
    )

    @episodes_created += 1
    print "." if @episodes_created % 5 == 0

  rescue ActiveRecord::RecordInvalid => e
    puts "❌ Failed to create episode #{episode_data['name']}: #{e.message}"
  end

  def create_character_episode_relationships
    puts "\n🔗 Creating character-episode relationships..."

    # Go through each episode and create relationships
    Episode.find_each do |episode|
      # Fetch episode data again to get character URLs
      episode_data = fetch_api_data("episode/#{episode.api_id}")
      next unless episode_data && episode_data['characters']

      episode_data['characters'].each do |character_url|
        character_id = extract_id_from_url(character_url)
        character = Character.find_by(api_id: character_id)

        if character
          CharacterEpisode.create!(
            character: character,
            episode: episode
          )
          @character_episodes_created += 1
        end
      end

      print "." if episode.id % 5 == 0
    end

    puts "\n✅ Created #{@character_episodes_created} character-episode relationships"
  end

  # ADDITIONAL DATA SOURCE: FAKER GEM
  def add_faker_data
    puts "\n🎲 Adding faker data for variety..."

    # Create some fictional locations using Faker
    5.times do
      Location.create!(
        api_id: (1000 + rand(9000)), # Use high numbers to avoid conflicts
        name: "#{Faker::Space.planet} (#{Faker::Alphanumeric.alphanumeric(number: 5)})",
        location_type: ['Planet', 'Dimension', 'Space Station', 'Microverse'].sample,  # Changed from 'type'
        dimension: "Dimension #{Faker::Alphanumeric.alphanumeric(number: 6)}"
      )
    end

    # Create some fictional characters
    earth_location = Location.find_by(name: 'Earth (C-137)') || Location.first

    10.times do
      Character.create!(
        api_id: (1000 + rand(9000)),
        name: Faker::Name.name,
        status: ['Alive', 'Dead', 'unknown'].sample,
        species: ['Human', 'Alien', 'Robot', 'Mythical being'].sample,
        gender: ['Male', 'Female', 'Genderless', 'unknown'].sample,
        image_url: "https://via.placeholder.com/300x300.png?text=#{Faker::Name.first_name}",
        origin_location: earth_location,
        current_location: Location.order('RANDOM()').first
      )
    end

    puts "✅ Added faker data: 5 locations, 10 characters"
  end

  def find_or_create_location_from_url(url)
    return nil if url.blank? || url == 'unknown'

    # Check cache first
    return @locations_cache[url] if @locations_cache[url]

    # Extract ID from URL and find existing location
    location_id = extract_id_from_url(url)
    location = Location.find_by(api_id: location_id)

    # If not found, fetch from API and create
    unless location
      location_data = fetch_api_data("location/#{location_id}")
      if location_data
        location = create_location(location_data)
      end
    end

    @locations_cache[url] = location if location
    location
  end

  def extract_id_from_url(url)
    url.split('/').last.to_i
  end

  def fetch_api_data(endpoint, params = {})
    uri = URI("#{BASE_URL}/#{endpoint}")

    # Add query parameters if provided
    if params.any?
      uri.query = URI.encode_www_form(params)
    end

    begin
      response = Net::HTTP.get_response(uri)

      if response.code == '200'
        JSON.parse(response.body)
      else
        puts "❌ API request failed: #{response.code} - #{response.message}"
        puts "   URL: #{uri}"
        nil
      end
    rescue StandardError => e
      puts "❌ Network error: #{e.message}"
      puts "   URL: #{uri}"
      nil
    end
  end

  def print_summary
    puts "\n" + "="*50
    puts "📊 SEEDING SUMMARY"
    puts "="*50
    puts "📍 Locations created: #{Location.count}"
    puts "👥 Characters created: #{Character.count}"
    puts "📺 Episodes created: #{Episode.count}"
    puts "🔗 Character-Episode relationships: #{CharacterEpisode.count}"
    puts "📊 Total database records: #{Location.count + Character.count + Episode.count + CharacterEpisode.count}"
    puts "="*50

    # Some fun statistics
    puts "\n🎯 FUN STATISTICS:"
    puts "• Alive characters: #{Character.alive.count}"
    puts "• Dead characters: #{Character.dead.count}"
    puts "• Unknown status: #{Character.unknown_status.count}"
    puts "• Most popular species: #{Character.group(:species).count.max_by{|k,v| v}}"
    puts "• Locations with most residents: #{Location.joins(:current_characters).group('locations.name').count.max_by{|k,v| v}}"
    puts "• Episode with most characters: #{Episode.joins(:characters).group('episodes.name').count.max_by{|k,v| v}}"
  end
end

# Run the seeder
seeder = RickAndMortySeeder.new
seeder.seed_all