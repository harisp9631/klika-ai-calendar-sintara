# Klika AI Calendar - Sinatra Application

An intelligent calendar application built with Sinatra that uses AI to route user requests to appropriate calendar functions. The application provides an API endpoint that intelligently determines which calendar function to execute based on user context and prompts.

## Features

- **AI-Powered Function Routing**: Uses OpenAI GPT-3.5-turbo to intelligently route user requests to appropriate calendar functions
- **Modular Function Architecture**: Clean separation of concerns with dedicated function classes
- **PostgreSQL Database Integration**: Robust data storage with PostgreSQL
- **RESTful API**: Simple JSON-based API for easy integration

## Available Functions

The application currently supports three main calendar functions:

- **`my_next_vacation`**: Retrieves information about upcoming vacation time
- **`my_general_info`**: Provides general calendar information
- **`my_teams_vacations`**: Shows team vacation schedules

## Prerequisites

- Ruby (2.7 or higher)
- PostgreSQL database
- OpenAI API key

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd klika-ai-calendar-sinatra
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Set up environment variables**:
   Create a `.env` file in the root directory with the following variables:
   ```env
   DATABASE_URL=postgresql://username:password@localhost:5432/database_name
   OPENAI_API_KEY=your_openai_api_key_here
   PORT=4567  # Optional, defaults to 4567
   ```

4. **Set up the database**:
   Ensure your PostgreSQL database is running and accessible with the credentials specified in your `DATABASE_URL`.

## Usage

### Starting the Application

```bash
ruby app.rb
```

The application will start on `http://localhost:4567` (or the port specified in your `PORT` environment variable).

### API Endpoint

#### POST `/ai-function`

Routes user requests to appropriate calendar functions using AI.

**Request Body**:
```json
{
  "context": "User context information",
  "prompt": "User's request or question"
}
```

**Example Request**:
```json
{
  "context": "I'm planning my schedule for next month",
  "prompt": "When is my next vacation?"
}
```

**Response**:
```json
{
  "function": "my_next_vacation",
  "result": {
    "message": "Placeholder for my_next_vacation"
  }
}
```

**Error Responses**:
- `400 Bad Request`: Missing required fields (context or prompt)
- `422 Unprocessable Entity`: AI couldn't determine appropriate function

## Project Structure

```
klika-ai-calendar-sinatra/
├── app.rb                 # Main Sinatra application
├── db.rb                  # Database connection utility
├── functions/             # Calendar function implementations
│   ├── my_next_vacation.rb
│   ├── my_general_info.rb
│   └── my_teams_vacations.rb
├── Gemfile               # Ruby dependencies
├── Procfile              # Deployment configuration
└── README.md             # This file
```

## Development

### Adding New Functions

1. Create a new function class in the `functions/` directory:
   ```ruby
   class MyNewFunction
     def self.call(context)
       # Your function logic here
       { message: "Function result" }
     end
   end
   ```

2. Add the function to the system prompt in `app.rb`
3. Add the function to the `function_map` in `app.rb`

### Environment Variables

- `DATABASE_URL`: PostgreSQL connection string
- `OPENAI_API_KEY`: Your OpenAI API key for function routing
- `PORT`: Port number for the application (optional)

## Deployment

The application includes a `Procfile` for easy deployment to platforms like Heroku. The application uses Puma as the web server.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

[Add your license information here] 