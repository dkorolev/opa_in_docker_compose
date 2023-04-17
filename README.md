# OPA in `docker-compose`

This simple test:

* Runs OPA in a Docker container, that terminates once the test completes.
* Waits for this OPA container to start.
* Runs the HTTP PUT+PATCH test against this running OPA.
* Terminates the OPA container.
