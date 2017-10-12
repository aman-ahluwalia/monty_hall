json.users do
  json.array! @users do |user|
    json.name   	user.name
    json.email  	user.email
    json.max_score	user.max_score.to_s
  end
end
