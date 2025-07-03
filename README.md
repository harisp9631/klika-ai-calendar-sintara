# Sinatra User Lookup App

## Setup

1. Install dependencies:

    bundle install

2. Set up your `.env` file with your PostgreSQL credentials:

    DB_HOST=localhost
    DB_PORT=5432
    DB_NAME=your_database
    DB_USER=your_user
    DB_PASSWORD=your_password

3. Ensure your PostgreSQL database has a `users` table with an `email` column.

## Running the App

    ruby app.rb

## Usage

Send a POST request to `/user` with JSON body:

    { "email": "user@example.com" }

The app will return user information as JSON if found, or a 404 error if not found. 