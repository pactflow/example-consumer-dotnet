# Example Consumer

[![Build](https://github.com/pactflow/example-consumer-dotnet/actions/workflows/build.yml/badge.svg)](https://github.com/pactflow/example-consumer-dotnet/actions/workflows/build.yml)

[![Pact Status](https://testdemo.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-example-consumer-dotnet/latest/badge.svg?label=provider)](https://testdemo.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-example-consumer-dotnet/latest) (latest pact)

[![Pact Status](https://testdemo.pactflow.io/matrix/provider/pactflow-example-provider-dotnet/latest/prod/consumer/pactflow-example-consumer-dotnet/latest/prod/badge.svg?label=provider)](https://testdemo.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-example-consumer-dotnet/latest/prod) (prod/prod pact)

This is an example of a dotnet core consumer using Pact to create a consumer driven contract, and sharing it via [PactFlow](https://pactflow.io).

It is using a private tenant on PactFlow. The latest version of the Example Consumer/Example Provider pact is published [here](https://testdemo.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-example-consumer-dotnet/latest).

The project uses a Makefile to simulate a very simple build pipeline with two stages - test and deploy.

* Test
  * Run tests (including the pact tests that generate the contract)
  * Publish pacts, tagging the consumer version with the name of the current branch
  * Check if we are safe to deploy to prod (ie. has the pact content been successfully verified)
* Deploy (only from master)
  * Deploy app (just pretend for the purposes of this example!)
  * Tag the deployed consumer version as 'prod'

## Dependencies

* Docker
* A [PactFlow](https://pactflow.io) account 
* A [read/write API Token](https://docs.pactflow.io/#configuring-your-api-token) from your PactFlow account
* .NET 6.x installed. You can install it from here: https://docs.microsoft.com/en-us/dotnet/core/install/macos

## Usage

See the [PactFlow CI/CD Workshop](https://github.com/pactflow/ci-cd-workshop).

The below commands are designed for a Linux/OSX environment, please translate for use on Windows/PowerShell as necessary:

Please ensure the following environment variables have been exported in the process that you run the tests (generally a terminal):

```
export PACT_BROKER_TOKEN=<your pactflow read/write token here>
export PACT_BROKER_BASE_URL=https://<your pactflow subdomain>.pactflow.io
```

### Run tests

```
make restore
make test
```

### Simulating CI

Usually, you would integrate this into a real CI system (such as Buildkite/Jenkins/CircleCI etc., or Travis as this repository is built against).

You can simulate a CI process with the following command:

```
make fake_ci
```
