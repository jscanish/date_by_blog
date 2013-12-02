Fabricator(:message) do
  title { Faker::Lorem.sentence(word_count = 4) }
  body  { Faker::Lorem.paragraph(1) }
  unread true
end
