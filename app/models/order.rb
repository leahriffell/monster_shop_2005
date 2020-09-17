class Order <ApplicationRecord
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  validates_presence_of :name, :address, :city, :state, :zip, :status

  enum status: %w(pending packaged shipped cancelled)

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

  def total_quantity
    item_orders.sum("quantity")
  end

end
