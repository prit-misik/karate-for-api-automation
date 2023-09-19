Feature: Includes creation, updation,deletion , reading of profiles
  Background:
    Given configure headers = { Accept : 'application/json', Content-Type : 'application/json'}
    Given url services_endpoint
    * def sleep = function(ms){ java.lang.Thread.sleep(ms) }

  @create
  Scenario: create user profile
    When header Authorization = 'Bearer '+accessToken
    When path "profiles/v1/users"
    And def body = read('classpath:'+inputFile)
    And request body
    And method post
    #Then status 201

  @delete
  Scenario: delete a profile

    When path 'profiles/v1/users/'+uuid
    When header Authorization = 'Bearer '+access_token
    And method delete
    Then status 200
    * sleep(40000)
    * print 'Deleted profile successfully.'

  @update
  Scenario: update user profile
    #update profile
    Given header Authorization = 'Bearer '+accessToken
    Given path "profiles/v1/users/" + uuid
    And def body = body
    And request body
    And method patch
    Then status 200
    * print "User profile updated successfully"
