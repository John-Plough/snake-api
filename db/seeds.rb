# Clear existing data (optional but useful during development)
User.destroy_all

# Create sample users
users = [
  { username: "snake_master", email: "snake_master@example.com", password: "password" },
  { username: "apple_chaser", email: "apple_chaser@example.com", password: "password" },
  { username: "grid_runner", email: "grid_runner@example.com", password: "password" },
  { username: "ssserpent", email: "ssserpent@example.com", password: "password" },
  { username: "pixel_crawler", email: "pixel_crawler@example.com", password: "password" }
]

users.each do |attrs|
  User.create!(attrs)
end

puts "✅ Seeded #{User.count} users!"
