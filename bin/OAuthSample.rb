






# OAuth Implementation

# Users: username, email, password, github_id, google_id

# When a user signs up through my app, they set username, email, password.
# But github_id and google_id remain nil.

# When a user logs in on Google or GitHub (using OAuth), and is redirected back to my app...



























def oauth_callback # <--- new method
  auth_hash = request.env["omniauth.auth"] # grabs returned data (email, ID, name)
  provider = auth_hash["provider"]
  uid_field = "#{provider}_uid".to_sym # build UID to match column in users table

  # Try to find user in DB with provider UID
  user = User.find_by("#{provider}_uid" => auth_hash["uid"])

  unless user
    # If no user found, check by email for existing user
    existing_user = User.find_by(email: auth_hash["info"]["email"])

    if existing_user
      # If user exists, but without UID, (i.e. "unlinked"), update UID field
      if existing_user.send("#{provider}_uid").nil? && auth_hash["info"]["email"] == existing_user.email
        existing_user.update("#{provider}_uid" => auth_hash["uid"])
        user = existing_user
      else
        # email exists but UID is already linked to something else, show error
        return redirect_to "#{frontend_url}?error=Email already registered with a different account"
      end
    else
      # If email not found, assume new user & create new user
      username = ... # logic to pick username (if github, it's this, if google...)
      user = User.create(
        email: auth_hash["info"]["email"],
        username: username,
        password: SecureRandom.hex(20), # random 40 character pw created
        "#{provider}_uid" => auth_hash["uid"] # UID and email are stored
      )
    end
  end

  # Set session and redirect
  if user&.persisted? # if user successfully saved to DB
    session[:user_id] = user.id # set session
    redirect_to frontend_url # redirect to frontend
  else
    redirect_to "#{frontend_url}?error=Failed to create user"
  end
end



# Summary:

# Email is the “glue” that links all login methods to the same user.

# User signs up with email/password:
    # username, email, password are set.
    # github_uid and google_uid are nil.

# User logs in with Google or GitHub (OAuth)
    # If their email matches an existing user, my logic links the appropriate UID (google_uid or github_uid) to that user.
    # If their email is new, a new user is created with a random password, a username, and the appropriate UID set.

# If a user signs up with Google or GitHub first, then tries to sign up with email/password:
    # They are told “email is already taken.”
    # They cannot create a new account with that email, because it’s already in use (by their OAuth account).