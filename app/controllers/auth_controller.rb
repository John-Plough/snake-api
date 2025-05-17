class AuthController < ApplicationController
  def github
    auth_hash = request.env["omniauth.auth"]
    Rails.logger.info "GitHub OAuth Info: #{auth_hash["info"].inspect}"

    # First try to find user by GitHub UID
    user = User.find_by(github_uid: auth_hash["uid"])

    unless user
      # Check if email is already taken
      existing_user = User.find_by(email: auth_hash["info"]["email"])

      if existing_user
        Rails.logger.info "Found existing user with email #{existing_user.email}"
        # If user exists but doesn't have github_uid, verify email ownership
        if existing_user.github_uid.nil? && auth_hash["info"]["email"] == existing_user.email
          Rails.logger.info "Linking GitHub account to existing user"
          existing_user.update(github_uid: auth_hash["uid"])
          user = existing_user
        else
          # Email exists but already linked to different provider
          Rails.logger.warn "Email conflict: #{auth_hash["info"]["email"]} already exists"
          return redirect_to "#{frontend_url}?error=Email already registered with a different account"
        end
      else
        # Create new user if email not taken
        user = User.create(
          email: auth_hash["info"]["email"],
          username: auth_hash["info"]["nickname"],
          password: SecureRandom.hex(20),
          github_uid: auth_hash["uid"]
        )
      end
    end

    frontend_url = ENV["FRONTEND_URL"] || "http://localhost:5173"

    if user&.persisted?
      session[:user_id] = user.id
      redirect_to frontend_url
    else
      redirect_to "#{frontend_url}?error=Failed to create user"
    end
  end

  def google
    auth_hash = request.env["omniauth.auth"]
    Rails.logger.info "Google OAuth Info: #{auth_hash["info"].inspect}"

    # First try to find user by Google UID
    user = User.find_by(google_uid: auth_hash["uid"])

    unless user
      # Check if email is already taken
      existing_user = User.find_by(email: auth_hash["info"]["email"])

      if existing_user
        Rails.logger.info "Found existing user with email #{existing_user.email}"
        # If user exists but doesn't have google_uid, verify email ownership
        if existing_user.google_uid.nil? && auth_hash["info"]["email"] == existing_user.email
          Rails.logger.info "Linking Google account to existing user"
          existing_user.update(google_uid: auth_hash["uid"])
          user = existing_user
        else
          # Email exists but already linked to different provider
          Rails.logger.warn "Email conflict: #{auth_hash["info"]["email"]} already exists"
          return redirect_to "#{frontend_url}?error=Email already registered with a different account"
        end
      else
        # Create new user if email not taken
        user = User.create(
          email: auth_hash["info"]["email"],
          username: auth_hash["info"]["given_name"]&.downcase ||
                   auth_hash["info"]["name"]&.split(" ")&.first&.downcase ||
                   auth_hash["info"]["email"].split("@").first,
          password: SecureRandom.hex(20),
          google_uid: auth_hash["uid"]
        )
      end
    end

    frontend_url = ENV["FRONTEND_URL"] || "http://localhost:5173"

    if user&.persisted?
      session[:user_id] = user.id
      redirect_to frontend_url
    else
      redirect_to "#{frontend_url}?error=Failed to create user"
    end
  end

  def check
    if current_user
      render json: { user: { id: current_user.id, email: current_user.email, username: current_user.username } }
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  private

  def generate_username(provider_name, email)
    # If user already exists with this email, return their username
    existing_user = User.find_by(email: email)
    return existing_user.username if existing_user

    # Start with provider name if available, otherwise use email username
    base_name = if provider_name.present?
      # Remove spaces and special characters, convert to lowercase
      provider_name.gsub(/[^a-zA-Z0-9]/, "").downcase
    else
      # Use part before @ in email
      email.split("@").first.downcase
    end

    # Try the base name first
    return base_name unless User.exists?(username: base_name)

    # If base name is taken, add a timestamp
    timestamp = Time.now.to_i.to_s[-4..-1] # last 4 digits of timestamp
    "#{base_name}#{timestamp}"
  end
end
