class Order <ApplicationRecord
  belongs_to :user
  has_many :item_orders
  has_many :items, through: :item_orders

  validates_presence_of :name, :address, :city, :state, :zip, :status

  enum status: %w(Pending Packaged Shipped Cancelled)

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    item_orders.sum("quantity")
  end

  def change_to_cancel_status
    update(status: 3)
  end

  def unfulfill_item_orders
    item_orders.each do |item_order|
      if item_order.fulfilled?
        item_order.update(fulfilled?: false)
        item = Item.find(item_order.item_id)
        item.update(inventory: (item.inventory + item_order.quantity))
      end
    end
  end

  def cancel
    change_to_cancel_status
    unfulfill_item_orders
  end

  def package_order
    fulfilled_orders = []
    self.item_orders.each do |item_order|
      if item_order.fulfilled?
        fulfilled_orders << item_order
      end
    end
    if fulfilled_orders.count == self.item_orders.count
      self.update(status: 1)
    end
  end

end
