require 'spec_helper'

describe Picture do
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }
end
