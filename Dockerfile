# Extend from the official Elixir image.
FROM elixir:1.17.3

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force

RUN mix deps.get && mix compile
