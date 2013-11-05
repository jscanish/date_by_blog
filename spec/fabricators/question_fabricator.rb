Fabricator(:question) do
  self_summary { Faker::Lorem.paragraph(1) }
  life_story { Faker::Lorem.paragraph(1) }
  favorite_things { Faker::Lorem.paragraph(1) }
  looking_for { Faker::Lorem.paragraph(1) }
end
