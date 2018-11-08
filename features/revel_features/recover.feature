Feature: Using recover

Background:
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint
  And I set environment variable "SERVER_PORT" to "4515"
  And I set environment variable "USE_CODE_CONFIG" to "true"

Scenario: An error report and session is sent when request crashes but is recovered
  When I start the service "revel"
  And I wait for the app to open port "4515"
  And I wait for 4 seconds
  And I open the URL "http://localhost:4515/recover"
  Then I wait to receive 2 requests
  And the request 0 is a valid error report with api key "a35a2a72bd230ac0aa0f52715bbdc6aa"

  And the exception "errorClass" equals "*errors.errorString" for request 0
  And the exception "message" equals "Request killed but recovered" for request 0

  And the request 1 is a valid session report with api key "a35a2a72bd230ac0aa0f52715bbdc6aa"

  And the event handled sessions count equals 1 for request 0
  And the number of sessions started equals 1 for request 1
