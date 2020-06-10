require 'rails_helper'

RSpec.describe Category, type: :model do
  it "don't have the same name" do
    Category.create(name: 'Sport')
    category = Category.create(name: 'Sport')

    expect(category).to_not be_valid
  end
end


