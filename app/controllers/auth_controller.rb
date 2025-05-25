class AuthController < ApplicationController
  ALLOWED_FRONTENDS = [
    "http://localhost:5173",
    "https://honeymaker.onrender.com"
  ]

  def oauth_callback
    auth_hash = request.env["omniauth.auth"]
    Rails.logger.info "OAuth Info: #{auth_hash["info"].inspect}"

    provider = auth_hash["provider"]
    uid_field = "#{provider}_uid".to_sym

    # First try to find user by provider UID
    user = User.find_by("#{provider}_uid" => auth_hash["uid"])

    unless user
      # Check if email has already been taken
      existing_user = User.find_by(email: auth_hash["info"]["email"])

      if existing_user
        Rails.logger.info "Found existing user with email #{existing_user.email}"
        # If user exists but doesn't have provider uid, verify email ownership
        if existing_user.send("#{provider}_uid").nil? && auth_hash["info"]["email"] == existing_user.email
          Rails.logger.info "Linking #{provider} account to existing user"
          existing_user.update("#{provider}_uid" => auth_hash["uid"])
          user = existing_user
        else
          # Email exists but already linked to different provider
          Rails.logger.warn "Email conflict: #{auth_hash["info"]["email"]} already exists"
          return redirect_to "#{frontend_url}?error=Email already registered with a different account", allow_other_host: true
        end
      else
        # Create new user if email not taken
        username = if provider == "github"
                    auth_hash["info"]["nickname"]
        else
                    auth_hash["info"]["given_name"]&.downcase ||
                      auth_hash["info"]["name"]&.split(" ")&.first&.downcase ||
                      auth_hash["info"]["email"].split("@").first
        end

        user = User.create(
          email: auth_hash["info"]["email"],
          username: username,
          password: SecureRandom.hex(20),
          "#{provider}_uid" => auth_hash["uid"]
        )
      end
    end

    if user&.persisted?
      cookies.signed[:user_id] = { value: user.id }.merge(cookie_settings)
      redirect_to frontend_url, allow_other_host: true
    else
      redirect_to "#{frontend_url}?error=Failed to create user", allow_other_host: true
    end
  end

  def oauth
    # This action will be handled by OmniAuth middleware
  end

  def check
    if current_user
      render json: { user: { id: current_user.id, email: current_user.email, username: current_user.username } }
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  private

  def frontend_url
    origin = request.headers["Origin"] || request.headers["Referer"]
    if ALLOWED_FRONTENDS.include?(origin)
      origin
    else
      ENV["FRONTEND_URL"] || ALLOWED_FRONTENDS.first
    end
  end

  def cookie_settings
    if Rails.env.test?
      { httponly: true }
    else
      { httponly: true, secure: true, same_site: "None" }
    end
  end
end
