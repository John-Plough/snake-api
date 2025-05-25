json.array! @scores.each_with_index do |score, index|
  json.partial! "scores/score", score: score, index: index
end
