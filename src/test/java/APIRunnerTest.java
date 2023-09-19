import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import memberDomain.javaUtils.*;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class APIRunnerTest extends LogUtils {

    private static final String REPORT_PATH = "./././target/cucumber-html-reports";
    private static final String ATTACHMENT_FILE = "./././target/APITestReports_" + DateUtils.getTodaysDateTime("yyyy-MM-dd HH:mm:ss") + "_" + System.getProperty("env").toUpperCase() + ".zip" ;

    /**
     * Generates cucumber style reports after karate tests are executed
     * @param karateOutputPath default report dir, inside target folder
     */
    private static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "APITest");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

    @Test
    void testParallel() throws InterruptedException, IOException {

        logger.info("Triggering from "+ this.getClass());
        Results results = Runner.
                path("classpath:memberComms/features")
                .tags("@ignore")
                .reportDir("target/xmlReport")
                .outputJunitXml(true)
                .outputCucumberJson(true)
                .parallel(10);
        generateReport(results.getReportDir());
        FileHandleUtils.renameFile(REPORT_PATH + "/overview-features.html", REPORT_PATH + "/overview-features-"+ System.getProperty("env").toUpperCase()+ ".html" );
        FileHandleUtils.deleteDir(REPORT_PATH+"/js");
        ZipUtils.zipDirectory(REPORT_PATH,ATTACHMENT_FILE);
        EmailUtils.sendMail(ATTACHMENT_FILE);
        FileHandleUtils.deleteFile(ATTACHMENT_FILE);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());

    }

}
