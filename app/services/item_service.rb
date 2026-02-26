class ItemService
  class UnauthorizedError < StandardError; end


  def self.create(user, params)
    raise UnauthorizedError, "Retailers only" unless user.retailer?

    item = user.items.new(params)
    item.save!
    item
  end


  def self.update(user, item, params)
    authorize_owner!(user, item)
    item.update!(params)
    item
  end


  def self.destroy(user, item)
    authorize_owner!(user, item)
    item.destroy!
  end

  private

  def self.authorize_owner!(user, item)
    raise UnauthorizedError, "Access denied" unless item.user_id == user.id
  end
end