Feature: This feature file contains all the main methods used in zendesk operations

  Background:
    * url zendesk_endpoint
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }

   @searchPresent
  Scenario: Search a user in zendesk
      * configure retry = { count: 15, interval: 10000 }
      Given header Authorization = 'Bearer '+ zendesk_accessToken
      Given path '/api/v2/users/search?query='+searchCriteria+':' + value
      And retry until response.count >= '1'
      When method get

  @searchNotPresent
  Scenario: check a user not present in zendesk
    * configure retry = { count: 15, interval: 10000 }
    Given header Authorization = 'Bearer '+ zendesk_accessToken
    Given path '/api/v2/users/search?query='+searchCriteria+':' + value
    And retry until response.count == '0'
    When method get

  @deleteZendeskProfile
  Scenario: check a user not present in zendesk
    * header Authorization = 'Bearer '+ zendesk_accessToken
    * path '/api/v2/users/'+ id +'.json'
    * header Authorization = 'Bearer '+ zendesk_accessToken
    *  method delete