json.id score.id
json.value score.value
json.created_at score.created_at
json.updated_at score.updated_at

json.array! @scores.each_with_index do |score, index|
  json.rank index + 1
  json.id score.id
  json.value score.value
  json.username score.user.username
  json.created_at score.created_at
end
