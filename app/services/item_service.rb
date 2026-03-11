class ItemService
  class UnauthorizedError < StandardError; end

  MAX_PER_PAGE = 100
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1

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

  def self.list(user, params)
    items = base_scope(user)
    items = apply_search(items, params[:search])
    total_count = items.count
    items = apply_pagination(items, params)

    {
      items: items.as_json(only: [:id, :name, :price, :quantity]),
      pagination: {
        page: page_param(params),
        per_page: per_page_param(params),
        total_count: total_count
      }
    }
  end

  private

  def self.authorize_owner!(user, item)
    raise UnauthorizedError, "Access denied" unless item.user_id == user.id
  end

  def self.base_scope(user)
    if user.retailer?
      user.items.active
    else
      Item.active
    end
  end

  def self.apply_search(scope, search)
    return scope unless search.present?

    search_term = search.downcase
    scope.where("LOWER(name) LIKE ?", "#{search_term}%")
  end

  def self.apply_pagination(scope, params)
    page = page_param(params)
    per_page = per_page_param(params)

    scope
      .order(created_at: :desc)
      .limit(per_page)
      .offset((page - 1) * per_page)
  end

  def self.page_param(params)
    page = params[:page].to_i
    page > 0 ? page : DEFAULT_PAGE
  end

  def self.per_page_param(params)
    per_page = params[:per_page].to_i
    per_page = DEFAULT_PER_PAGE if per_page <= 0
    [per_page, MAX_PER_PAGE].min
  end
end