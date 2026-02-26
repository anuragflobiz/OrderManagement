class OrderService
  def self.create_order(user, items_data)
    return { success: false, message: "Items cannot be blank" } if items_data.blank?

    order = nil
    total_amount = 0

    ActiveRecord::Base.transaction do
      order = user.orders.create!(amount: 0, status: :pending)

      items_data.each do |item_hash|
        item = Item.find(item_hash[:item_id])
        quantity = item_hash[:quantity].to_i

        raise "Invalid quantity" if quantity <= 0
        raise "Insufficient stock for #{item.name}" if item.quantity < quantity

        item.update!(quantity: item.quantity - quantity)

        order.item_orders.create!(
          item: item,
          quantity: quantity,
          item_price: item.price,
          item_name: item.name
        )

        total_amount += item.price * quantity
      end

      order.update!(amount: total_amount, status: :confirmed)
    end
    MessageWorker.perform_async(order.id)
    {
      success: true,
      order: order.as_json(
        include: {
          item_orders: {
            only: [:item_name, :item_price, :quantity]
          }
        }
      )
    }

  rescue ActiveRecord::StaleObjectError
    {
      success: false,
      message: "Item was updated by another user. Please try again."
    }

  rescue => e
    {
      success: false,
      message: e.message
    }
  end
end