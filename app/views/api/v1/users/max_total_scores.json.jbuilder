json.users do
  json.array! @users do |user|
    json.name   		user.name
    json.email  		user.email
    json.total_score	user.total_score.to_s
  end
end
