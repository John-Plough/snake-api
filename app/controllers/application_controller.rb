class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection

  # protect_from_forgery with: :exception
  # before_action :set_csrf_cookie

  def authenticate_user
    unless current_user
      render json: { error: "You must be logged in" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: cookies.signed[:user_id]) if cookies.signed[:user_id]
  end

  # TEMPORARY: Run migrations in production via web request
  def run_migrations
    if Rails.env.production?
      begin
        ActiveRecord::Base.connection.migration_context.migrate
        render plain: "Migrations ran successfully!"
      rescue => e
        render plain: "Migration error: #{e.message}"
      end
    else
      render plain: "Not allowed"
    end
  end

  # private

  # def set_csrf_cookie
  #   cookies["CSRF-TOKEN"] = form_authenticity_token
  # end
end
