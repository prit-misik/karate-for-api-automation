api-tests
Goal

To create a framework for API testing which can be used by multiple domains

Approach

After reviewing the problems with the existing framework , we've decided to use a tool which gives us flexibility as well as speed to add new tests. So we've started the approach using Karate APIs.

About Karate

Karate is the only open-source tool to combine API test-automation, mocks, performance-testing and even UI automation into a single, unified framework. The BDD syntax popularized by Cucumber is language-neutral, and easy for even non-programmers. It is not a pure BDDframework.Assertions and HTML reports are built-in, and you can run tests in parallel for speed.There's also a cross-platform stand-alone executable for teams not comfortable with Java. Users don't have to compile code. Just write tests in a simple, readable syntax - carefully designed for HTTP, JSON, GraphQL and XML. And you can mix API and UI test-automation within the same test script.

This repository contains the current project, which shows how we can utilize Karate for robust API test cases, in a fast speed. It contains API tests, as well as performance tests, using the same set of feature files.

About the current framework :

1. The test are written under "src/test/java/<squad>/features"
2. The file karate-config.js contains configurable envs which becomes global once the execution starts.
3. The feature files under "src/test/java/features/<module>/" shows how different feature files can be
   re-used for testing, also demonstrates how to seperate out test data from test cases.
4. Every fetaure folder contains a reousrces folder where test data or other files are placed, for example .json files
   used as payload for test cases are placed here.
5. There are two types of result files generated under target folder, out of which target\cucumber-html-reports are clearly better for reporting purpose.
   Also after the run a zipped result file is sent a s an email to "abc@gmail.com"
6. Different tags are used to make tests moduler , current ly available tags are:
   -all
   -domain_01
   -domain_02

6. To run a set of test cases from command line :
   ./gradlew clean test -Denv=dev-uk -Doptions="--tags @<tag name>"

7. Or the features can be run from any IDE , by right clicking and clicking run option.
8. We are using the following Azure pipeline to trigger the tests
9. Karate official documentation can be found here : https://github.com/karatelabs/karate