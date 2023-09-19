Feature: This feature is to collect all credentials, ids for admin, clinicians etc and add it to a common json var
  Background:
    Given configure headers = { Accept : 'application/json', Content-Type : 'application/json'}
    Given url services_endpoint
    * def testData = read ('../../envSpecificData/'+ regionSpcfcDataFile)

  @getACredential
  Scenario: Get admin credentials and add it to a common json variable named 'credentials'
    #get admin access token
    * def uuid = testData.admin_uuid
    * def result = call read('classpath:memberComms/features/commonFeatures/login.feature@withUUID'){uuid: #(uuid) }
    * def adminAccessToken = result.response.access_token
    * karate.set('credentials', 'adminAccessToken', adminAccessToken)


  @getSCCredential
  Scenario: Get clinician credentials and add it to a common json variable 'credentials'
    #get clinician's access token
    * def uuid =  testData.clinician_uuid
    * def result = call read('classpath:memberComms/features/commonFeatures/login.feature@withUUID'){uuid: #(uuid) }
    * def clinician_access_token = result.response.access_token
    * karate.set('credentials', 'clinician_access_token', clinician_access_token)

  @getGPCredential
  Scenario: Get GP's credentials and add it to a common json variable 'credentials'
    #get gp details
    * def uuid =  testData.clinician_uuid
    * def result = call read('classpath:memberComms/features/commonFeatures/login.feature@withUUID'){uuid: #(uuid) }
    * string gp_access_token = result.response.access_token
    * karate.set('credentials', 'gp_access_token', gp_access_token)
