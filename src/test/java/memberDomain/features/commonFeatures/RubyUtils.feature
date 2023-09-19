Feature: Includes creation, updating , deletion , reading of profiles using core ruby service
  Background:
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }
    * def scenarioName = region == 'us' ? 'login.feature@withSecret' : 'login.feature@withRole'
    * def testData = read ('../../envSpecificData/'+ regionSpcfcDataFile)

 #create profile
  @createProfile
  Scenario: Create user profile
    * def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("PATIENTS")
    When url core_ruby_endpoint
    And header Authorization = 'Bearer '+ allCredentials.adminAccessToken
    And path path
    And def payload = body
    And request payload
    And method post

  @updateProfile
  Scenario: Update user profile
    * url core_ruby_endpoint
    * path '/api/v1/patients/'+id
    * def body = body
    And header Authorization = 'Bearer '+ allCredentials.adminAccessToken
    And request body
    And method patch

  @getCancellationReason
  Scenario: Fetch appointment cancellation IDs and reasons
    When url core_ruby_endpoint
    And path "/api/v2/reasons/appointment_reasons"
    And header Authorization = 'Bearer '+ allCredentials.adminAccessToken
    And method get
    Then status 200

