class ApplicationController < ActionController::Base
  # Add any application-wide before_actions or helper methods here

  protected

  def paginate_collection(collection, per_page = 12)
    collection.page(params[:page]).per(per_page)
  end

  private

  def page_number
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end