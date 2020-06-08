Category.destroy_all

categories = ['smartphone', 'shoes', 'accesories']

categories.each do |category|
  Category.create(name: category)
end
