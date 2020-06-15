class Category < ApplicationRecord
  has_and_belongs_to_many :products
  belongs_to :parent, class_name: 'Category', optional: true, foreign_key: :category_id
  has_many :children, class_name: 'Category', dependent: :destroy
  validates :name, uniqueness: true

  def find_parents(category = self)
    @result ||= []
    return @result if category.parent.nil?

    @result << parent
    find_parents(category.parent)
  end

  # def parents(category = self)
  #   result = []
  #   while category.parent.present?
  #     result << category.parent
  #     category = category.parent
  #   end
  #   return result
  # end

  def find_childrens
    current_children = children.to_a
    childs_to_return = []
    while current_children.present?
      current_node = current_children.shift
      childs_to_return << current_node
      current_children.concat(current_node.children)
    end
    childs_to_return
  end
end
