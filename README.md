# Example Consumer

[![Build Status](https://travis-ci.com/pactflow/pactflow-example-consumer-dotnet.svg?branch=master)](https://travis-ci.com/pactflow/pactflow-example-consumer-dotnet)

[![Pact Status](https://test.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-pactflow-example-consumer-dotnet/latest/badge.svg?label=provider)](https://test.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-pactflow-example-consumer-dotnet/latest) (latest pact)

[![Pact Status](https://test.pactflow.io/matrix/provider/pactflow-example-provider-dotnet/latest/prod/consumer/pactflow-pactflow-example-consumer-dotnet/latest/prod/badge.svg?label=provider)](https://test.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-pactflow-example-consumer-dotnet/latest/prod) (prod/prod pact)


This is an example of a dotnet core consumer using Pact to create a consumer driven contract, and sharing it via [Pactflow](https://pactflow.io).

It is using a public tenant on Pactflow, which you can access [here](https://test.pactflow.io) using the credentials `dXfltyFMgNOFZAxr8io9wJ37iUpY42M`/`O5AIZWxelWbLvqMd8PkAVycBJh2Psyg1`. The latest version of the Example Consumer/Example Provider pact is published [here](https://test.pactflow.io/pacts/provider/pactflow-example-provider-dotnet/consumer/pactflow-pactflow-example-consumer-dotnet/latest).

The project uses a Makefile to simulate a very simple build pipeline with two stages - test and deploy.

* Test
  * Run tests (including the pact tests that generate the contract)
  * Publish pacts, tagging the consumer version with the name of the current branch
  * Check if we are safe to deploy to prod (ie. has the pact content been successfully verified)
* Deploy (only from master)
  * Deploy app (just pretend for the purposes of this example!)
  * Tag the deployed consumer version as 'prod'

## Usage

See the [Pactflow CI/CD Workshop](https://github.com/pactflow/ci-cd-workshop).

The below commands are designed for a Linux/OSX environment, please translate for use on Windows/PowerShell as necessary:

### Run tests
`make test`

### To emulate the full the consumer pipeline
1. Sign up to a Pactflow account at https://pactflow.io/register.
1. Grab a **read/write** API token from the "Settings > API Tokens" page
1. Export the following into your shell before running
    ```
    export PACT_BROKER_TOKEN=<insert token here> # do not a user/email/password here e.g. it should like something like 8Axvelr123xCq98h1
    export PACT_BROKER_HOST=<insert host here> # e.g. https://foo.pactflow.io
    ```
    ```
    make fake_ci
    ```
