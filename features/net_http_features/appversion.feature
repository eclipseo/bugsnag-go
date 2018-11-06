Feature: Configuring app type

Background:
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint
  And I set environment variable "APP_VERSION" to "3.1.2"
  And I have built the service "nethttp"
  And I stop the service "nethttp"
  And I set environment variable "SERVER_PORT" to "4512"

Scenario: A error report contains the configured app type when using a net http app
  Given I set environment variable "AUTO_CAPTURE_SESSIONS" to "false"
  When I start the service "nethttp"
  And I wait for the app to open port "4512"
  And I wait for 1 seconds
  And I open the URL "http://localhost:4512/handled"
  And I wait for 1 seconds
  Then I should receive a request
  And the request is valid for the error reporting API
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "app.version" equals "3.1.2"

Scenario: A session report contains the configured app type when using a net http app
  When I start the service "nethttp"
  And I wait for the app to open port "4512"
  And I wait for 1 seconds
  And I open the URL "http://localhost:4512/session"
  And I wait for 1 seconds
  Then I should receive a request
  And the request is valid for the session tracking API
  And the session contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the payload field "app.version" equals "3.1.2"
