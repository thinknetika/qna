class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @query = params[:query]
    @selected_category = params[:category]
    @results = SearchService.search(@query, @selected_category)

    turbo_stream
  end
end
