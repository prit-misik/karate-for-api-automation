package memberDomain.performance



import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder

class GatlingTest extends Simulation{
  val amountRampUsers: Int = 1
  val amountRampDuration: Int = 1

  val subcr: ScenarioBuilder = scenario("Subscription test 01")
    .exec(
      karateFeature("classpath:memberDomain/features/privacy/privacy.feature")
    )

  val subcr_dup: ScenarioBuilder = scenario("Subscription test 02")
    .exec(
      karateFeature("classpath:memberDomain/features/privacy/privacy.feature")
    )

  setUp(
    subcr.inject(rampUsers(amountRampUsers) during amountRampDuration),
    subcr_dup.inject(rampConcurrentUsers(1) to 5 during amountRampDuration)
  ).assertions(
    global.responseTime.max.lt(5000),
    global.successfulRequests.percent.gt(95)
  )

}
