json.array! @scores.each_with_index do |score, index|
  json.partial! "scores/score", locals: { score: score, index: index }
end
