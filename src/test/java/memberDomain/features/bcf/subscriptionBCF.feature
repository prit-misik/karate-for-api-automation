@all
@all-us
Feature: This feature validates BBC's subscription related functionality

  Background:
    * url services_endpoint
    * def utils = call read('../commonFeatures/jsUtils.feature')
    * def uniqueNum = utils.currentTime()
    * def p_email = "bcftest." + uniqueNum +"@example.com"
    * def testData = read ('../../envSpecificData/'+ regionSpcfcDataFile)
    * def cn_code = testData.cn_code_withBrSync
    * def phone_code = testData.phone_code
    When def patientPayload = read('/resources/bcfTestProfileWithBrCN.json')

    #if region is aa, then add the extra param 'address_state_code' in payload
    * if( region == 'aa') karate.set('payload', '$.patient.address_state_code', testData.address_state_code)
    * print "Payload for patient profile creation : " + JSON.stringify(patientPayload)
    And def result = call read('../commonFeatures/rubyUtils.feature@createProfile') { body : #(patientPayload) }
    * def p_uuid = result.response.uuid

    #get details
    * def result = call read('classpath:memberDomain/features/commonFeatures/login.feature@withUUID'){uuid: #(p_uuid) }
    * string p = result.response.access_token


  @bbc
  Scenario: Verify decision on marketing notice is passed on to privacy service correctly

     #Get latest marketing notice version ID
    Given def result = call read('../commonFeatures/privacyService.feature@getMarketingNoticeVersion')
    * def expectedStatus = region == 'us' ? 404 : 200
    Then match expectedStatus == result.responseStatus
    * def noticeVersionId = result.response.noticeVersionId

    #if region is 'us' expectedNoticeVersionId should be null
    * def expectedNoticeVersionId = region == 'us' ?  null : noticeVersionId
    * match expectedNoticeVersionId == noticeVersionId

    * if( region == 'us') karate.abort()

    When def BrResult = call read('../commonFeatures/BrUtils.feature@exportByEmailAddressWithPolling') { Br_api_key: '#(Br_api_key)', email_address: '#(p_email)'}
    * def externalID = BrResult.response.users[0].external_id
    * print 'externalID is :' + externalID
    * print "====== email_subscribe " + BrResult.response.users[0].email_subscribe
    Given def result = call read('../commonFeatures/privacyService.feature@changeMarketingDecision') {accessToken: #(p_access_token), noticeVersionId: #(noticeVersionId), decision: 'true' }
    Then match result.responseStatus == 201
    * utils.sleep(40000)

    Given url services_endpoint+ 'privacy-service/v1/me/settings'
    And  header Authorization = 'Bearer ' + p_access_token
    And method get
    * string res = response
    * def ids = $[*].noticeVersion.noticeVersionId
    * def index = ids.indexOf(noticeVersionId)
    * def strJson = JSON.stringify(response[index])
    * def jsonContent = karate.fromString(strJson)
    Then match jsonContent.accepted == true