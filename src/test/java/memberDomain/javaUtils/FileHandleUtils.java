package memberDomain.javaUtils;

import org.apache.commons.io.FileUtils;

import java.io.File;

public class FileHandleUtils extends LogUtils{

    public static void deleteDir(String dir){

        try{
            FileUtils.forceDelete(new File(dir));
            logger.info("Directory : "+ dir+ " deleted successfully.");
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void deleteFile(String filePath){

        try{
            FileUtils.forceDelete(new File(filePath));
            logger.info("File : "+ filePath + " deleted successfully.");
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    public static void renameFile(String source, String target){
        try{
            if(new File(source).renameTo(new File(target))) {
                logger.info("Successfully renamed the file :"+ source);
            } else {
                logger.info(("Error: Unable to rename file :"+ source));
            }
        }
        catch(NullPointerException | SecurityException e){
            logger.error(e.getMessage());
        }
    }
}
