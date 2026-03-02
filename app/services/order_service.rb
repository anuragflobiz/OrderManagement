class OrderService
  def self.create_order(user, items_data)
    raise CustomErrors::BadRequest, "Items cannot be blank" if items_data.blank?

    item_ids = items_data.map { |i| i[:item_id] }
    current_time = Time.current
    total_amount = 0
    order_items_attributes = []

    order = ActiveRecord::Base.transaction do
      order = user.orders.create!(amount: 0, status: :pending)

      items = Item.where(id: item_ids).index_by(&:id)

      items_data.each do |item_hash|
        item = items[item_hash[:item_id]]
        raise CustomErrors::BadRequest, "Item not found" unless item

        quantity = item_hash[:quantity].to_i
        raise CustomErrors::BadRequest, "Invalid quantity" if quantity <= 0
        raise CustomErrors::BadRequest, "Insufficient stock for #{item.name}" if item.quantity < quantity

        item.update!(quantity: item.quantity - quantity)

        order_items_attributes << {
          order_id: order.id,
          item_id: item.id,
          quantity: quantity,
          item_price: item.price,
          item_name: item.name,
          created_at: current_time,
          updated_at: current_time
        }

        total_amount += item.price * quantity
      end

      ItemOrder.insert_all(order_items_attributes)

      order.update!(amount: total_amount, status: :confirmed)

      order
    end
    MessageWorker.perform_async("order_confirmation", order.id)

    order.as_json(
      include: { item_orders: { only: [:item_name, :item_price, :quantity] } }
    )
  end
end