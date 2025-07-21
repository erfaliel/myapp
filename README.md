# Hello

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Running with Docker

You can build and run this project using Docker and Docker Compose. This setup uses Elixir 1.14.5, Erlang 25.3.2.6, and Alpine 3.18 as the base image. The application exposes port **4000** by default.

### Build and Run Dev
```sh
# Lancer l'environnement de développement
docker-compose -f docker-compose.dev.yml up --build

# Arrêter l'environnement
docker-compose -f docker-compose.dev.yml down

# Pour les logs
docker-compose -f docker-compose.dev.yml logs -f web
```
### Build and Run Prod
```sh
# Lancer l'environnement de production
docker-compose -f docker-compose.prod.yml up --build
```
The Phoenix server will be available at [http://localhost:4000](http://localhost:4000).

### ~~Build and Run basic~~

```sh
# Build and start the service
docker compose up --build
```

### Environment Variables

- `MIX_ENV` is set to `prod` by default in the container.
- `PHX_SERVER` is set to `true` to ensure the server starts automatically.
- You can override these or add additional environment variables as needed.

### Notes

- No external services (such as databases) are configured by default. If you add a database, update `docker-compose.yml` accordingly.
- The default exposed port is **4000**.
- The container runs as a non-root user for improved security.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
