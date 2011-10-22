require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    # we grant the admin priviledge to the first user.
    admin = User.create!(:name => "Admin User",
                 :email => "admin@aabb.com",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle!(:admin)

    # populate another 99 regular users in the development DB
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end

    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end
