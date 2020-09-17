class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    item = Item.find(item)
    @contents[item.id.to_s] = 0 if !@contents[item.id.to_s]
    if item.inventory != 0
      @contents[item.id.to_s] += 1
    end
  end

  def update_item(item)
    item = Item.find(item)
    if @contents[item.id.to_s] < item.inventory
      @contents[item.id.to_s] += 1
    end
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def empty_cart
    @contents.clear
  end

end
