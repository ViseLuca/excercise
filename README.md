# Backend code exercise

## Implementation details
### Assumptions
- The currency is in a separated column and is registered with the code ISO 4217
- The amount is stored as a bigint and the last N digits, depending on the currency, are the decimals `eg. 3200000 -> 32.000,00` for EUR, to avoid errors on floating point numbers in maths operations. How is explained [here](https://0.30000000000000004.com/)
- The functionality to send invitations to users with an active salary is stateless, so if the API is called multiple time, multiple invitations will be sent.
- The invitation sending is done asynchronously using Oban to schedule a job for each user with an active salary, in this way we have a retry for every single error.
- The SendEmail job has its own queue because is better to specify max_concurrency worker on it, different timeouts and prioritization of different jobs in different queues.
- The last salary active (`last_activation_at` field) is the most recent one. A salary can have never been activated so the field can be null. 
- The queryParam to filter by name is called `name` and is searching with an insensitive case if the are names starting with the parameter value. If parameter is not passed the default value is `""`(empty string) to retrieve all the users. 
- The queryParam to order the list is `orderBy` expecting `asc/desc/ASC/DESC` parameters, is nullable and if the parameter is not passed I am setting the default as `asc` 

### Code maintenance and style
I have added 2 dependencies `credo` and `dialyzer` to check code style and for maintenance.
- Credo: is for static code analysis focused on code consistency and some refactoring opportunities (alias ordering, remove IO.inspect, too deep nested anonymous fn)
- Dialyzer: is for static code analysis focused on the bytecode for BEAM VM. It shows warnings about wrong specs and type mismatch

They can be run together executing `mix check` in the terminal.

### API Spec
When the server is running you can check the [swagger](http://localhost:4000/swagger) to have a look at the API, it can be used also
from FE side (eg. Typescript) to generate the modules with types without using them manually or to try directly the APIs from the webpage

### How to run
How to run information can be found in [docs/how_to_run.md](docs/how_to_run.md)
