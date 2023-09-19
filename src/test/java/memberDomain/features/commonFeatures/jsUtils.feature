Feature: Includes only javascript utility functions

  Scenario: javascript utility functions
    * def currentTime =
      """
        function() {
          return java.lang.System.currentTimeMillis()
        }
      """

    * def uuid =
     """
       function() {
         return java.util.UUID.randomUUID() + ''
       }
     """

    * def randomNumber =
     """
       function() {
         return Math.floor(Math.random() * 99999999) + ''
       }
     """
   * def sleep =
     """
      function(ms){
         return java.lang.Thread.sleep(ms)
       }
     """