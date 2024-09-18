# HOW TO RUN

## Seeding the database for tests
The `seeds.ex` file reads the environment configuration `:test_rows` to determine how many rows should be inserted for seeding.
The current configuration is `10` for tests and `20.000` for development.

To launch the tests you can run `MIX_ENV=test mix ecto.reset` to fill the database before running `mix test`.

## Test coverage
Using `ex_doc` and `excoveralls`, you can run `mix test.coverage` to generate an HTML file that displays the test coverage for each file.
The coverage report can be found at `priv/static/excoveralls.html`.

My target for coverage threshold is >= 80.0%. If the current coverage is below 80.0%, running `mix test.coverage` will 
show an alert like `FAILED: Expected minimum coverage of 80%, got currentCoverage%.` 
The threshold can be changed in the configuration file `coveralls.json`.

## Launching the server
The server can be started using `mix s`, and you can send all the requests to `localhost:4000`.

Examples to extract users:
- `curl --request GET --url 'http://localhost:4000/users'`
- `curl --request GET --url 'http://localhost:4000/users?orderBy=asc'`
- `curl --request GET --url 'http://localhost:4000/users?name=Lu'`
- `curl --request GET --url 'http://localhost:4000/users?name=Luca&orderBy=desc'`

Example to send email:
- `curl --request POST --url http://localhost:4000/invite-users`

Example of the api exposes:
- http://localhost:4000/swagger
