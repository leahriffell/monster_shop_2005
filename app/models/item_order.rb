class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  validates_inclusion_of :fulfilled?, :in => [true, false]

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def self.most_popular_items 
    ItemOrder.order(quantity: :desc).limit(5).pluck(:item_id)
  end
end
