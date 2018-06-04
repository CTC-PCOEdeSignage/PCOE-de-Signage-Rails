if Rails.env.development?
  email = ENV.fetch("ADMIN_EMAIL", 'admin@example.com')
  password = ENV.fetch("ADMIN_PASSWORD", 'password')
else
  email = ENV["ADMIN_EMAIL"]
  password = ENV["ADMIN_PASSWORD"]
end

if email && password
  AdminUser.create!(email: email, password: password, password_confirmation: password)
end
