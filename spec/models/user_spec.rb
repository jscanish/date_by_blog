require 'spec_helper'

describe User do
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:address) }
  it { should have_one(:set_of_questions) }
  it { should have_many(:posts) }
  it { should validate_presence_of(:age) }
end
