Fabricator(:post) do
  title { Faker::Lorem.sentence(word_count = 4) }
  body { Faker::Lorem.paragraph(2) }
end
