# The Honeymaker API (Backend)

Ruby on Rails API backend for The Honeymaker game. Handles authentication (email/password, Google, GitHub), user management, scores, and leaderboards.

---

## Features

- RESTful API for game data
- User authentication (email/password, Google OAuth, GitHub OAuth)
- Secure session management (cookies, CSRF protection)
- Score submission and leaderboards
- Automatic account linking by email
- CORS enabled for frontend integration

---

## Getting Started

### Prerequisites

- Ruby 3.x
- Rails 7.x
- PostgreSQL (or your preferred DB)

### Setup

1. **Install dependencies:**
   ```bash
   bundle install
   ```
2. **Set up the database:**
   ```bash
   rails db:create db:migrate
   ```
3. **Configure OAuth credentials:**
   - Set these environment variables (or use `.env`):
     ```
     GOOGLE_CLIENT_ID=...
     GOOGLE_CLIENT_SECRET=...
     GITHUB_CLIENT_ID=...
     GITHUB_CLIENT_SECRET=...
     FRONTEND_URL=http://localhost:5173
     ```
4. **Start the server:**
   ```bash
   rails server
   ```

---

## API Endpoints (Summary)

- `POST   /users` — Create user (signup)
- `POST   /login` — Login (email/password)
- `DELETE /logout` — Logout
- `POST   /auth/:provider` — Start OAuth (Google/GitHub)
- `GET    /auth/:provider/callback` — OAuth callback
- `GET    /auth/check` — Check current user session
- `POST   /scores` — Submit score
- `GET    /scores/personal` — Get personal top scores
- `GET    /scores/global` — Get global leaderboard

---

## OAuth & Authentication

- Uses OmniAuth for Google and GitHub
- Links accounts by email if user logs in with multiple providers
- Prevents duplicate accounts for the same email
- Secure session cookies and CSRF protection

---

## CORS

- Configured to allow requests from the frontend (see `config/initializers/cors.rb`)

---

## Development Notes

- All authentication and user data is handled server-side
- See `OAUTH_CHEATSHEET.md` for a detailed OAuth flow explanation
- Frontend is a separate project in `/snake`

---

## License

MIT License.  
(c) 2025 House of Plough
