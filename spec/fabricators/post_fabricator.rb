Fabricator(:post) do
  title { Faker::Lorem.words(num = 6) }
  body { Faker::Lorem.paragraph(2) }
end
