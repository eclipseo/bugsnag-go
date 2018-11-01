Feature: Configuring release stages and notify release stages

Scenario: An error report is sent when release stage matches notify release stages
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "NOTIFY_RELEASE_STAGES" to "stage1,stage2,stage3"
  And I set environment variable "RELEASE_STAGE" to "stage2"
  When I configure with the "release stage" configuration and send an error
  And I wait for 1 second
  Then I should receive a request
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "app.releaseStage" equals "stage2"

Scenario: An error report is sent when no notify release stages are specified
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "RELEASE_STAGE" to "stage2"
  When I configure with the "release stage" configuration and send an error
  And I wait for 1 second
  Then I should receive a request
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "app.releaseStage" equals "stage2"

Scenario: An error report is sent regardless of notify release stages if release stage is not set
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "NOTIFY_RELEASE_STAGES" to "stage1,stage2,stage3"
  When I configure with the "release stage" configuration and send an error
  And I wait for 1 second
  Then I should receive a request
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"

Scenario: An error report is not sent if the release stage does not match the notify release stages
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "NOTIFY_RELEASE_STAGES" to "stage1,stage2,stage3"
  And I set environment variable "RELEASE_STAGE" to "stage4"
  When I configure with the "release stage" configuration and send an error
  And I wait for 1 second
  Then I should receive no requests

Scenario: An session report is sent when release stage matches notify release stages
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "NOTIFY_RELEASE_STAGES" to "stage1,stage2,stage3"
  And I set environment variable "RELEASE_STAGE" to "stage2"
  When I configure with the "release stage" configuration and send a session
  And I wait for 1 second
  Then I should receive a request
  And the "bugsnag-api-key" header equals "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the "bugsnag-payload-version" header equals "1.0"
  And the payload field "app.releaseStage" equals "stage2"

Scenario: An session report is sent when no notify release stages are specified
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "RELEASE_STAGE" to "stage2"
  When I configure with the "release stage" configuration and send a session
  And I wait for 1 second
  Then I should receive a request
  And the "bugsnag-api-key" header equals "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the "bugsnag-payload-version" header equals "1.0"
  And the payload field "app.releaseStage" equals "stage2"

Scenario: An session report is sent regardless of notify release stages if release stage is not set
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "NOTIFY_RELEASE_STAGES" to "stage1,stage2,stage3"
  When I configure with the "release stage" configuration and send a session
  And I wait for 1 second
  Then I should receive a request
  And the "bugsnag-api-key" header equals "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the "bugsnag-payload-version" header equals "1.0"

Scenario: An session report is not sent if the release stage does not match the notify release stages
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoints
  And I set environment variable "NOTIFY_RELEASE_STAGES" to "stage1,stage2,stage3"
  And I set environment variable "RELEASE_STAGE" to "stage4"
  When I configure with the "release stage" configuration and send a session
  And I wait for 1 second
  Then I should receive no requests

Scenario: Revel configuration through code does not prevent other release stages from going through
  Given I set environment variable "USE_CODE_CONFIG" to "YES"
  Given I set environment variable "NOTIFY_RELEASE_STAGES" to "development"
  Given I set environment variable "RELEASE_STAGE" to "development"
  And I work with a new 'revel-0.20.0' app
  And I set the "revel-0.20.0" config variable "bugsnag.apikey" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint in the config file for 'revel-0.20.0'
  When I run the script "features/fixtures/revel-0.20.0/run.sh"
  And I wait for 4 seconds
  And I go to the route "/configure"
  And I wait for 1 seconds
  Then I should receive a request
  And the event "app.releaseStage" equals "development"

Scenario: Revel configuration through code can prevent a report from being sent
  Given I set environment variable "USE_CODE_CONFIG" to "YES"
  Given I set environment variable "NOTIFY_RELEASE_STAGES" to "development"
  Given I set environment variable "RELEASE_STAGE" to "staging"
  And I work with a new 'revel-0.20.0' app
  And I set the "revel-0.20.0" config variable "bugsnag.apikey" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint in the config file for 'revel-0.20.0'
  When I run the script "features/fixtures/revel-0.20.0/run.sh"
  And I wait for 4 seconds
  And I go to the route "/configure"
  And I wait for 1 seconds
  Then I should receive no requests

Scenario: Revel configuration through config file does not prevent other release stages from going through
  And I work with a new 'revel-0.20.0' app
  And I set the "revel-0.20.0" config variable "bugsnag.apikey" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I set the "revel-0.20.0" config variable "bugsnag.notifyreleasestages" to "development"
  And I set the "revel-0.20.0" config variable "bugsnag.releasestage" to "development"
  And I configure the bugsnag endpoint in the config file for 'revel-0.20.0'
  When I run the script "features/fixtures/revel-0.20.0/run.sh"
  And I wait for 4 seconds
  And I go to the route "/configure"
  And I wait for 1 seconds
  Then I should receive a request
  And the event "app.releaseStage" equals "development"

Scenario: Revel configuration through config file can prevent a report from being sent
  And I work with a new 'revel-0.20.0' app
  And I set the "revel-0.20.0" config variable "bugsnag.apikey" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I set the "revel-0.20.0" config variable "bugsnag.notifyreleasestages" to "development"
  And I set the "revel-0.20.0" config variable "bugsnag.releasestage" to "staging"
  And I configure the bugsnag endpoint in the config file for 'revel-0.20.0'
  When I run the script "features/fixtures/revel-0.20.0/run.sh"
  And I wait for 4 seconds
  And I go to the route "/configure"
  And I wait for 1 seconds
  Then I should receive no requests

Scenario: A Revel session report contains the configured app version
  Given I set environment variable "DISABLE_REPORT_PAYLOADS" to "true"
  And I work with a new 'revel-0.20.0' app
  And I set the "revel-0.20.0" config variable "bugsnag.apikey" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I set the "revel-0.20.0" config variable "bugsnag.releasestage" to "development"
  And I configure the bugsnag sessions endpoint in the config file for 'revel-0.20.0'
  When I run the script "features/fixtures/revel-0.20.0/run.sh"
  And I wait for 4 seconds
  And I go to the route "/configure"
  And I wait for 1 seconds
  Then I should receive a request
  And the payload field "app.releaseStage" equals "development"
