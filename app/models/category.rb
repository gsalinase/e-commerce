class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true, foreign_key: :category_id
  has_many :children, class_name: 'Category', dependent: :destroy
  has_and_belongs_to_many :products
  validates :name, uniqueness: true

  def get_parents
    current_parent = parent
    parent_to_return = []
    while current_parent.present?
      parent_to_return << current_parent.name
      current_parent = current_parent.parent
    end
    parent_to_return
  end

  def get_childrens
    current_childs = children.to_a
    childs_to_return = []
    while current_childs.present?
      current_node = current_childs.shift
      childs_to_return << current_node
      current_childs.concat(current_node.children)
    end
    childs_to_return
  end
end
