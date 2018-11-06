Feature: Configuring on before notify

Background:
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint
  And I have built the service "nethttp"
  And I stop the service "nethttp"
  And I set environment variable "SERVER_PORT" to "4512"
  And I set environment variable "AUTO_CAPTURE_SESSIONS" to "false"

Scenario: Send three bugsnags and use on before notify to drop one and modify the message of another
  When I start the service "nethttp"
  And I wait for the app to open port "4512"
  And I wait for 2 seconds
  And I open the URL "http://localhost:4512/onbeforenotify"
  And I wait for 1 seconds
  Then I should receive 2 requests
  
  And the request 0 is valid for the error reporting API
  And the request 0 contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the exception "message" equals "Don't ignore this error" for request 0
  
  And the request 1 is valid for the error reporting API
  And the request 1 contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the exception "message" equals "Error message was changed" for request 1
  