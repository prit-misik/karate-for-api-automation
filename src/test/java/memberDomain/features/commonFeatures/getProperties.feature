Feature: To get all properties into a map

  Scenario: Get properties from APIConfig.properties file and return a map and this map can be used in any other feature files as it becomes global
    * def propVal = Java.type('memberComms.APIConfigs.APIPaths').getPropValue("LOGIN")
