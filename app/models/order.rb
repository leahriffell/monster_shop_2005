class Order <ApplicationRecord
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  validates_presence_of :name, :address, :city, :state, :zip

  enum role: %w(pending packaged shipped cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end
end
