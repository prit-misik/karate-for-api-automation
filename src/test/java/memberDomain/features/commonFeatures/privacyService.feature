Feature: This feature is for privacy service

  Background:
    Given url services_endpoint
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }

  @getMarketingNoticeVersion
  Scenario: Get the latest marketing notice version ID
    * def path = Java.type('memberDomain.APIConfigs.APIPaths').getPropValue("GET_MARCKETING_VERSION")
    Given path path
    And method GET

  @changeMarketingDecision
  Scenario: Subscribe user
    Given def jsonBody = { accepted : '#(decision)' }
    And header Authorization = 'Bearer '+accessToken
    * def path = Java.type('memberDomain.APIConfigs.APIPaths').getPropValue("DESCISION_ENDPOINT")
    Given path path + noticeVersionId + '/decision'
    And request jsonBody
    When method POST
    Then status 201

  @changeUserConsent
  Scenario: Subscribe user
    Given def jsonBody = { accepted : '#(decision)' }
    And header Authorization = 'Bearer '+accessToken
    And header X-App-Name = 'header'
    * def path = 'ps-service/v1/patient/'+ pp_uuid+ '/noticeVersions/'+ noticeVersionId + '/decision'
    Given path path
    And request jsonBody
    When method POST
    Then status 201
