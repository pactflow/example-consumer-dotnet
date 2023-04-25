# Default to the read only token - the read/write token will be present on Travis CI.
# It's set as a secure environment variable in the .travis.yml file
PACTICIPANT := "pactflow-example-consumer-dotnet"
GITHUB_WEBHOOK_UUID := "e0d3dd92-d69a-40f7-a58b-7d5f0c739028"
PACT_CLI="docker run --rm -v ${PWD}:${PWD} -e PACT_BROKER_BASE_URL -e PACT_BROKER_TOKEN pactfoundation/pact-cli:latest"

# Only deploy from master
ifeq ($(GIT_BRANCH),master)
	DEPLOY_TARGET=deploy
else
	DEPLOY_TARGET=no_deploy
endif

all: test

## ====================
## CI tasks
## ====================

clean: pacts/*.json
	rm pacts/*.json

restore:
	dotnet restore src
	dotnet restore tests

run:
	cd src && dotnet run

ci: clean restore test publish_pacts can_i_deploy $(DEPLOY_TARGET)

# Run the ci target from a developer machine with the environment variables
# set as if it was on Travis CI.
# Use this for quick feedback when playing around with your workflows.
fake_ci:
	CI=true \
	GIT_COMMIT=`git rev-parse --short HEAD`+`date +%s` \
	GIT_BRANCH=`git rev-parse --abbrev-ref HEAD` \
	make ci

publish_pacts:
	@"${PACT_CLI}" publish ${PWD}/pacts --consumer-app-version ${GIT_COMMIT} --branch ${GIT_BRANCH}

## =====================
## Build/test tasks
## =====================

test:
	dotnet test tests


## =====================
## Deploy tasks
## =====================

deploy: deploy_app record_deployment

no_deploy:
	@echo "Not deploying as not on master branch"

can_i_deploy:
	@"${PACT_CLI}" broker can-i-deploy \
	  --pacticipant ${PACTICIPANT} \
	  --version ${GIT_COMMIT} \
	  --to-environment production \
	  --retry-while-unknown 0 \
	  --retry-interval 10

deploy_app:
	@echo "Deploying to prod"

record_deployment: .env
	@"${PACT_CLI}" broker record-deployment --pacticipant ${PACTICIPANT} --version ${GIT_COMMIT} --environment production

## =====================
## PactFlow set up tasks
## =====================

# This should be called once before creating the webhook
# with the environment variable GITHUB_TOKEN set
create_github_token_secret:
	@curl -v -X POST ${PACT_BROKER_BASE_URL}/secrets \
	-H "Authorization: Bearer ${PACT_BROKER_TOKEN}" \
	-H "Content-Type: application/json" \
	-H "Accept: application/hal+json" \
	-d  "{\"name\":\"githubCommitStatusToken\",\"description\":\"Github token for updating commit statuses\",\"value\":\"${GITHUB_TOKEN}\"}"

# This webhook will update the Github commit status for this commit
# so that any PRs will get a status that shows what the status of
# the pact is.
create_or_update_github_webhook:
	@"${PACT_CLI}" \
	  broker create-or-update-webhook \
	  'https://api.github.com/repos/pactflow/example-consumer/statuses/$${pactbroker.consumerVersionNumber}' \
	  --header 'Content-Type: application/json' 'Accept: application/vnd.github.v3+json' 'Authorization: token $${user.githubCommitStatusToken}' \
	  --request POST \
	  --data @${PWD}/pactflow/github-commit-status-webhook.json \
	  --uuid ${GITHUB_WEBHOOK_UUID} \
	  --consumer ${PACTICIPANT} \
	  --contract-published \
	  --provider-verification-published \
	  --description "Github commit status webhook for ${PACTICIPANT}"

test_github_webhook:
	@curl -v -X POST ${PACT_BROKER_BASE_URL}/webhooks/${GITHUB_WEBHOOK_UUID}/execute -H "Authorization: Bearer ${PACT_BROKER_TOKEN}"

## ======================
## Travis CI set up tasks
## ======================

GIT_login:
	@docker run --rm -v ${HOME}/.travis:/root/.travis -it lirantal/travis-cli login --pro

# Requires PACT_BROKER_TOKEN to be set
GIT_encrypt_pact_broker_token:
	@docker run --rm -v ${HOME}/.travis:/root/.travis -v ${PWD}:${PWD} --workdir ${PWD} lirantal/travis-cli encrypt --pro PACT_BROKER_TOKEN="${PACT_BROKER_TOKEN}"

## ======================
## Misc
## ======================

:
	touch
