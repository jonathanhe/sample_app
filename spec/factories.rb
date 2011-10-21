# By using the symbol ':user', we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                  "Admin user"
  user.email                 "admin@abbb.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "user-#{n}@example.com"
end

# By user the symbol ':micropost', the Factory Girl will simulate the
# Micropost model
Factory.define :micropost do |micropost|
  micropost.content     "Sample post content"
  micropost.association :user
end
