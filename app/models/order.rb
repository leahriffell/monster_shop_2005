class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates_inclusion_of :status?, :in => [true, false]

  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def status_string
    if status?
      "Shipped"
    else
      "Pending"
    end
  end
end
