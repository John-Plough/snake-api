json.rank index + 1
json.id score.id
json.value score.value
json.created_at score.created_at
json.updated_at score.updated_at
json.user do
  json.id score.user.id
  json.username score.user.username
end
