class ChangeFulfilledDefaultOnItemOrders < ActiveRecord::Migration[5.2]
  def change
    change_column_default :item_orders, :fulfilled?, false
  end
end
