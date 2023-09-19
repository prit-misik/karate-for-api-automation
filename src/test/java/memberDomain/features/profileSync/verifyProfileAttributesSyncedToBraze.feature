@all
@all-us
@all-ca
Feature: This feature file includes tests related to profile attributes which get synced to br

  Background:
    # crate a unique email id for each test case
    * def utils = call read('../commonFeatures/jsUtils.feature')
    * def randomNum = utils.randomNumber()
    * def p_email = "crubyp_" + randomNum +"@example.com"
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }
    * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
    * def testData = read ('../../envSpecificData/'+ regionSpcfcDataFile)

  @profileSync
  Scenario Outline: Should create br profile for p with correct attribute values
    #create user,with multiple CNs
    * def cn_code = testData.cn_code_withbrSync
    * def phone_code = testData.phone_code
    When def payload = read('/resources/rubypProfile.json')
    #* if( region == 'ca') karate.set('payload', '$.p.address_state_code', testData.address_state_code)
    * print "Payload for p profile creation : " + JSON.stringify(payload)
    And def result = call read('../commonFeatures/rubyUtils.feature@createProfile') { body : #(payload) }
    * def uuid = result.response.uuid
    * print "p's uuid is :" + uuid

    # verify attributes in br
    When def brResult = call read('../commonFeatures/brUtils.feature@exportByEmailAddressWithPolling') { email_address: '#(p_email)' }
    * def externalID = brResult.response.users[0].external_id
    Then match externalID == '#notnull'
    Then match brResult.response.users[0].email == p_email
    Then match brResult.response.users[0].email_subscribe == '<email_subscribe>'
    Then match brResult.response.users[0].custom_attributes.preferred_consumer_network == '<preferred_consumer_network>'
    Then match brResult.response.users[0].custom_attributes.all_consumer_networks == '#notnull'
    Then match brResult.response.users[0].custom_attributes.all_consumer_networks contains '<preferred_consumer_network>'
    Then match brResult.response.users[0].custom_attributes.all_consumer_networks contains '<CN2>'
    Then match brResult.response.users[0].first_name == payload.p.first_name
    Then match brResult.response.users[0].last_name == payload.p.last_name
    Then match brResult.response.users[0].gender == '<gender>'
    Then match brResult.response.users[0].custom_attributes.language_for_notifications == payload.p.language_for_notifications
    Then match brResult.response.users[0].created_at == '#notnull'
    Then match brResult.response.users[0].custom_attributes.active_membership_code == '<actv_membrshp_code>'
    Then match brResult.response.users[0].custom_attributes.queued_for_activation == <qd_for_activtn>
    Then match brResult.response.users[0].country == '<country>'
    Then match brResult.response.users[0].custom_attributes.family_status == '<family_status>'
    Then match brResult.response.users[0].custom_attributes.phone_number.replaceAll(' ','') == payload.p.phone_country_code +  payload.p.phone_number


    Examples:
      | email_subscribe | preferred_consumer_network  | CN2     | gender  | actv_membrshp_code | qd_for_activtn | country | family_status |
      |  unsubscribed   |  br Testing                 | sassy   | M       |  br                |  false         | GB      | not_family    |