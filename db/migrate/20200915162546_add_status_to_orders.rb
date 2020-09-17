class AddStatusToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :status?, :boolean, default: false
  end
end
