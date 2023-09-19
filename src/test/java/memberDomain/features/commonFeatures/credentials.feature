Feature: This feature is to collect all credentials, ids for admin, clinicians etc and add it to a common json var

  Scenario: Get credentials for all roles
   * call read('classpath:memberComms/features/commonFeatures/getAllCredentials.feature@getACredential')
   * call read('classpath:memberComms/features/commonFeatures/getAllCredentials.feature@getSCCredential')
   * call read('classpath:memberComms/features/commonFeatures/getAllCredentials.feature@getGPCredential')