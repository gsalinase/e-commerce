require 'rails_helper'

RSpec.describe Category, type: :model do
  it "don't have the same name" do
    category = Category.create(name: 'Sport')
    category.children.create(name: 'Basketball', category_id: category.id)
    subcategory = category.children.create(name: 'Basketball', category_id: category.id)
    expect(subcategory).to_not be_valid
  end
end
