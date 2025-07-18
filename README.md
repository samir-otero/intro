# 🛸 Rick and Morty Database (Rails Project)

This is a Ruby on Rails application that connects to the [Rick and Morty API](https://rickandmortyapi.com/) and builds an interactive database of characters, locations, and episodes from the *Rick and Morty* universe. Designed with a Bootstrap-based responsive UI and enriched with additional Faker-generated content for variety and testing.

---

## 🚀 Features

- 🔎 **Search and Filter**:
  - Search characters by name.
  - Filter by status, species, and location.
  - Filter locations by type and name.
  - Search episodes by title or episode code.

- 🧬 **Models and Relationships**:
  - **Characters** belong to origin and current locations, and appear in many episodes.
  - **Locations** list their residents and originating characters.
  - **Episodes** show associated characters and stats.

- 🖼️ **Media-Rich UI**:
  - Character avatars pulled from the API.
  - Cards for quick visual browsing.
  - Clean layouts using Bootstrap’s grid system.

- 📊 **Statistics Panel**:
  - Total counts of characters, locations, episodes.
  - Episode-specific stats like alive/dead humans.

- 🌀 **Thematic Styling**:
  - Stylized using Bootstrap 5 with plans for *Rick and Morty*-inspired color palette and UI enhancements.

---

## 📁 Project Structure

```
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   ├── assets/
├── config/
├── db/
│   ├── seeds.rb
├── public/
├── Gemfile
└── README.md
```

---

## 📦 Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/samir-otero/intro.git
cd rick-and-morty-db
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Setup the database

```bash
rails db:create
rails db:migrate
rails db:seed
```

Seeding pulls data from the [Rick and Morty API](https://rickandmortyapi.com/) and uses the `faker` gem to generate additional mock data.

### 4. Run the server

```bash
rails server
```

Then visit `http://localhost:3000` in your browser.

---

## 🧪 Testing

Basic validations and logic can be tested manually through the UI. You can add model or controller tests using RSpec or MiniTest as needed.

---

## 🔧 Technologies Used

- Ruby on Rails 8
- SQLite3 (development)
- Bootstrap 5
- Faker
- Kaminari (for pagination)
- Rick and Morty API
- HTML + ERB templates

---

## 🤖 Credits

- **API**: [Rick and Morty API](https://rickandmortyapi.com/)
- **Icons**: [Bootstrap Icons](https://icons.getbootstrap.com/)
- **Font/Style Inspiration**: *Rick and Morty* (Adult Swim)

---

## 📃 License

This project is for educational purposes only.

---

## 🌌 Future Enhancements

- Apply *Rick and Morty*-inspired UI styling with themed colors and fonts
- Add charts for character/episode/location stats
- Add favoriting system or filters like "most seen characters"
- Support for multiple dimensions or universe types

---

🛸 *Wubba Lubba Dub Dub!* Thanks for checking it out!