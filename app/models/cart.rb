class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    @contents.reduce(0.0) do |grand_total, (item_id, quantity)|
      grand_total += subtotal_of(item_id)
      grand_total
    end
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    quantity = count_of(item_id)
    (quantity * item.price) * percent_of_price_with_discount(item, quantity)
  end

  def percent_of_price_with_discount(item, quantity)
    amount = applicable_discounts(item, quantity).maximum("percent_off")
    (1 - amount.to_f/100)
  end

  def unit_price(item_id)
    subtotal_of(item_id) / count_of(item_id)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  private
  
  def applicable_discounts(item, quantity)
    Discount
    .where("min_quantity <= ? AND merchant_id = ?", quantity, item.merchant.id)
  end
end
