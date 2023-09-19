Feature: Login feature

  Background:
    Given url services_endpoint
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }

  @withRole
  Scenario: Login to get an access token
    #User login does a login
    * def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("LOGIN")
    * path path
    * request payload
    * method POST
    * status 200

  @withSecret
  Scenario: Login to get an access token
    #User login does a login
    * def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("INTERNAL_SERVICE_SECRETS")
    * path path
    * def inputjson = {client_id: '#(c_client_id)' , client_secret: '#(c_client_secret)'}
    * request inputjson
    * method POST
    * status 200

  @withUUID
  Scenario: Login with uuid
    #User login does a login
    * def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("LOGIN")+ uuid + '/authenticate'
    * path path
    When method post
    Then status 201
