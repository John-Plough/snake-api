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

# Clear old data (optional during development)
Score.destroy_all

# Use existing users
users = User.all

# Add scores to each user
users.each do |user|
  3.times do
    user.scores.create!(
      value: rand(50..300), # random score between 50 and 300
      created_at: rand(1..30).days.ago
    )
  end
end

puts "✅ Seeded #{Score.count} scores for #{User.count} users."
