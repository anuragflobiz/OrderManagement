module Pagination
  extend ActiveSupport::Concern

  MAX_PER_PAGE = 100
  DEFAULT_PER_PAGE = 10
  DEFAULT_PAGE = 1

  class_methods do
    def paginate(scope, params)
      page = page_param(params)
      per_page = per_page_param(params)

      paginated = scope
                    .order(created_at: :desc)
                    .limit(per_page)
                    .offset((page - 1) * per_page)

      {
        records: paginated,
        pagination: {
          page: page,
          per_page: per_page,
        }
      }
    end

    private

    def page_param(params)
      page = params[:page].to_i
      page > 0 ? page : DEFAULT_PAGE
    end

    def per_page_param(params)
      per_page = params[:per_page].to_i
      per_page = DEFAULT_PER_PAGE if per_page <= 0
      [per_page, MAX_PER_PAGE].min
    end
  end
end