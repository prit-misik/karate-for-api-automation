package memberDomain.javaUtils;

import net.lingala.zip4j.ZipFile;

import java.io.File;
import java.io.IOException;

public class ZipUtils extends  LogUtils{


    public static void zipDirectory(String  reportPath , String attachmentFile) {
        try {

            new ZipFile(attachmentFile).addFolder(new File(reportPath));
            logger.info("Zipping completed.");
        }
        catch(IOException e){
            e.printStackTrace();
        }
    }
}