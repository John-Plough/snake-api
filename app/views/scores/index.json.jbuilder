json.array! @scores do |score|
  json.id          score.id
  json.value       score.value
  json.username    score.user.username
  json.created_at  score.created_at
end
