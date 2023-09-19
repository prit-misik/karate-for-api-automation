@all
@all-us
@all-ca
Feature: This validates syncing behavior of infos to br

  Background:
    # crate a unique email id for each test case
    * def utils = call read('../commonFeatures/jsUtils.feature')
    * def randomNum = utils.randomNumber()
    * def man_email = "rubyman_" + randomNum +"@example.com"
    * configure headers = { Accept : 'application/json', Content-Type : 'application/json' }
    * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
    * def testData = read ('../../envSpecificData/'+ regionSpcfcDataFile)

  @infoSync
  Scenario: Should update man's br info when their preferred consumer network changes
    #create user,with multiple CNs
    * def cn_code = testData.cn_code_withbrSync
    * def phone_code = testData.phone_code
    * def bb_cn_id = testData.bb_cn_id
    When def payload = read('/resources/rubymaninfo.json')
    #* if( region == 'ca') karate.set('payload', '$.man.address_state_code', testData.address_state_code)
    And def result = call read('../commonFeatures/rubyUtils.feature@createinfo') { body : #(payload) }
    * def man_uuid = result.response.uuid
    * print "man's uuid is :" + man_uuid
    * def id = result.response.id
    * print "man's id is :" + id

    #get man details
    * def result = call read('classpath:memberComms/features/commonFeatures/login.feature@withUUID'){uuid: #(man_uuid) }
    * string man_access_token = result.response.access_token
    * print 'man_access_token :'+ man_access_token

    # Get the current preferred_net
    When def brResult = call read('../commonFeatures/brUtils.feature@exportByEmailAddressWithPolling') { br_api_key: '#(br_api_key)', email_address: '#(man_email)' }
    * def externalID = brResult.response.users[0].external_id
    Then def prefd_CN = brResult.response.users[0].custom_attributes.preferred_consumer_network
    * print "prefd_CN : " + prefd_CN

    # change the preferred network
    When def body = { man: { preferred_id:  #(bb_cn_id) } }
    And def result = call read('../commonFeatures/rubyUtils.feature@updateinfo') { body : #(body) }
    * sleep(30000)

    #now verify from br that the first name is modified
    When def brResult = call read('../commonFeatures/brUtils.feature@exportByEmailAlias') { br_api_key: '#(br_api_key)', man_email: '#(man_email)' }
    * def changed_CN = brResult.response.users[0].custom_attributes.preferred_consumer_network
    * print "changed_CN :" + changed_CN
    Then assert prefd_CN != changed_CN


  @infoSync
  Scenario Outline: Users with phone number are added to the transactional SMS group.

    * def cn_code = testData.cn_code_withbrSync
    * def phone_code = testData.phone_code
    When def payload = read('/resources/rubymaninfo.json')
    #* if( region == 'ca') karate.set('payload', '$.man.address_state_code', testData.address_state_code)
    And def result = call read('../commonFeatures/rubyUtils.feature@createinfo') { body : #(payload) }
    * def man_uuid = result.response.uuid
    * print "man's uuid is :" + man_uuid
    * def id = result.response.id
    * print "man's id is :" + id

    #get man details
    * def result = call read('classpath:memberComms/features/commonFeatures/login.feature@withUUID'){uuid: #(man_uuid) }
    * string man_access_token = result.response.access_token
    * print 'man_access_token :'+ man_access_token

    # verify the user is synced to br and added to the SMS subscription groups
    * def man_email = payload.man.email
    When def brResult =  call read('../commonFeatures/brUtils.feature@exportByEmailAddressWithPolling') { br_api_key: '#(br_api_key)', email_address: '#(man_email)'}
    Then assert brResult.response.users.length == 1
    * def externalID = brResult.response.users[0].external_id
    * print "externalID "+ externalID
    When def subscriptionResult =  call read('../commonFeatures/brUtils.feature@verifyUserSubscription') { externalID: '#(externalID)' }
    Then assert subscriptionResult.response.users[0].subscription_groups.length > 0
    * def subscriptionGroup = region == 'ca' ? 'Telus Transactional PreProd-CA  for SMS' : 'br_TRANSACTIONAL_SMS_GROUP'
    * print "subscriptionGroup is :"+ subscriptionGroup
    * def subscriptionGroupName = subscriptionGroup
    * def response = subscriptionResult.response.users[0].subscription_groups
    * def names = $[*].name
    * print "names : "+ names
    * def index = names.indexOf(subscriptionGroupName)
    * print "index : " + index

    Then assert subscriptionResult.response.users[0].subscription_groups[index].name == subscriptionGroupName
    Then assert subscriptionResult.response.users[0].subscription_groups[index].status == '<subscriptionGroupStatus>'

    Examples:
      | subscriptionGroupStatus |
      | Subscribed              |

  @infoSync
  Scenario Outline: Verify that if user email is changed then it will be reflected in br
    * def cn_code = testData.cn_code_withbrSync
    * def phone_code = testData.phone_code
    When def payload = read('/resources/rubymaninfo.json')
    #* if( region == 'ca') karate.set('payload', '$.man.address_state_code', testData.address_state_code)
    And def result = call read('../commonFeatures/rubyUtils.feature@createinfo') { body : #(payload) }
    * def man_uuid = result.response.uuid
    * print "man's uuid is :" + man_uuid
    * def man_id = result.response.id
    * print "man's id is :" + man_id

    #get man details
    * def result = call read('classpath:memberComms/features/commonFeatures/login.feature@withUUID'){ uuid: #(man_uuid) }
    * string man_access_token = result.response.access_token
    * print 'man_access_token :'+ man_access_token


    #verify email from br
    * def man_email = payload.man.email
    When def brResult =  call read('../commonFeatures/brUtils.feature@exportByEmailAddressWithPolling') { br_api_key: '#(br_api_key)', email_address: '#(man_email)' }
    Then match brResult.responseStatus == 201
    Then match brResult.response.users[0].email == man_email
    * def externalID = brResult.response.users[0].external_id

    # modify email id
    When def body = { man: { email: '<modified_email>' } }
    And def result = call read('../commonFeatures/rubyUtils.feature@updateinfo') { body : #(body), id : #(id) }
    * sleep(30000)

    # verify from br that email change is reflected
    * def emailAlias = {alias_name: '<modified_email>', alias_label: 'email' }
    When def brResult = call read('../commonFeatures/brUtils.feature@exportByEmailAlias') { br_api_key: '#(br_api_key)', man_email: '#(modified_email)' }
    Then match brResult.responseStatus == 201
    Then assert brResult.response.users[0].email == '<modified_email>'
    Then match brResult.response.users[0].user_aliases contains emailAlias


    Examples:
      | modified_email             |
      | modified.email@example.com |

  @infoSync
  Scenario Outline: Verify that if user phone number is changed then it will be reflected in br
    * def cn_code = testData.cn_code_withbrSync
    * def phone_code = testData.phone_code
    When def payload = read('/resources/rubymaninfo.json')
    #* if( region == 'ca') karate.set('payload', '$.man.address_state_code', testData.address_state_code)
    And def result = call read('../commonFeatures/rubyUtils.feature@createinfo') { body : #(payload) }
    * def uuid = result.response.uuid
    * def id = result.response.id
    * print "man's uuid is :" + uuid
    * def phone = payload.man.phone_country_code + payload.man.phone_number
    * replace phone.+ = ''
    * def phoneAlias = { alias_name: '#(phone)', alias_label: 'phone' }

    #verify phone number from br
    * def man_email = payload.man.email
    When def brResult =  call read('../commonFeatures/brUtils.feature@exportByEmailAddressWithPolling') { br_api_key: '#(br_api_key)', email_address: '#(man_email)' }
    Then match brResult.responseStatus == 201
    * def value = brResult.response.users[0].phone
#    Then match brResult.response.users[0].custom_attributes.phone_number.replace(' ','').replace('-', '') == phone
    * replace value . = ''
    * replace value .- = ''
    Then match value == phone
    * def externalID = brResult.response.users[0].external_id

    # modify phone number
    When def body = { man: { phone_number: '<modified_phone>' } }
    And def result = call read('../commonFeatures/rubyUtils.feature@updateinfo') { body : #(body), id : #(id) }

    # verify from br that phone number change is reflected
    * def expected_phone = (phone_code + '<modified_phone>').replace('+', '')
    * print "expected_phone is :"+ expected_phone
    * def retry_until_fn_override =
        """
        (response) => {
        return response.users.length > 0 && response.users[0].phone === expected_phone
        }
        """
    * call read('../commonFeatures/brUtils.feature@exportByEmailAddressWithPolling') { br_api_key: '#(br_api_key)', email_address: '#(man_email)' }

    Examples:
      | modified_phone |
      | 7575756666    |
