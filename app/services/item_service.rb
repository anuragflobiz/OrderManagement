class ItemService
  include Pagination

  def initialize(user)
    @user = user
  end

  def create(params)
    @user.items.create!(params)
  end

  def update(item, params)
    item.update!(params)
    item
  end

  def destroy(item)
    item.destroy!
  end

  def list(params)
    base_scope = @user.retailer? ? @user.items : Item.all
    filtered = apply_search(base_scope, params[:search])

    result = self.class.paginate(filtered, params)

    {
      items: result[:records].as_json(only: [:id, :name, :price, :quantity]),
      pagination: result[:pagination]
    }
  end

  private

  def apply_search(scope, search)
    return scope unless search.present?
    scope.where("LOWER(name) LIKE ?", "#{search.downcase}%")
  end
end