Fabricator(:user) do
  email { Faker::Internet.email }
  username { Faker::Name.name }
  password "password"
  address "New York"
  age 18
end
