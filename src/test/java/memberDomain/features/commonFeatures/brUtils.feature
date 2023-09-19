Feature: This feature is for braze related operations

  Background:
    Given url braze_endpoint
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }
    * configure retry = { count: 15, interval: 5000 }

  @exportByEmailAlias
  Scenario: Export from Braze by email alias
    Given def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("BRAZE_EXPORT")
    And def jsonBody = read('classpath:memberComms/features/commonFeatures/resources/braze_export_by_email_alias.json')
    When path path
    And header Authorization = 'Bearer ' + braze_api_key
    And request jsonBody
    And method POST
    Then status 201
    * print "Export from Braze by email alias completed."

  @deleteUserFromBraze
  Scenario: Delete user from Braze
    Given def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("BRAZE_USER_DELETE")
    And def jsonBody = read('classpath:memberComms/features/commonFeatures/resources/braze_delete_user.json')
    When path path
    And header Authorization = 'Bearer ' + braze_api_key
    And request jsonBody
    And method POST
    Then status 201
    * print "Braze user deletion completed"

  @verifyUserSubscription
  Scenario: Verify from braze that a user has subscribed to notice
    * def extid = function(){return encodeURIComponent(externalID)}
    Given def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("BRAZE_USER_SUBSCRIPTION")
    Given path path + extid()
    And header Authorization = 'Bearer ' + braze_api_key
    And method GET
    Then status 200

  @exportByEmailAddress
  Scenario: Export from Braze by email address
    Given def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("BRAZE_EXPORT")
    And def jsonBody = { email_address: '#(email_address)' }
    When path path
    And header Authorization = 'Bearer ' + braze_api_key
    And request jsonBody
    And method POST
    Then status 201
    * print "Export from Braze by email address completed."

  @exportByEmailAddressWithPolling
  Scenario: Export from Braze by email address
    * def path = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("BRAZE_EXPORT")
    # By default, retry until the response has at least one user
    * def retry_until_fn = karate.get('retry_until_fn_override', function(response) { return response.users.length > 0 })
    Given def jsonBody = { email_address: '#(email_address)' }
    When path path
    And header Authorization = 'Bearer ' + braze_api_key
    And request jsonBody
    And retry until call retry_until_fn response
    And method POST
    Then status 201
    * print "Export from Braze by email address completed."

