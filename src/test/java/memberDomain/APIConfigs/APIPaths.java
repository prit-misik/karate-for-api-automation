package memberDomain.APIConfigs;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public final class APIPaths {

    private static final Map<String, String> CONFIGMAP = new HashMap<String, String>();
    private static final String pathToPropFile = "src/test/java/memberDomain/APIConfigs/APIPath.properties";
    private static final Properties property = new Properties();

    /**
     * Private constructor to avoid external instantiation
     */
    private APIPaths() {
    }


    public static Map getMapFromPropFile() throws IOException {
        try (FileInputStream file = new FileInputStream(pathToPropFile)) {

            property.load(file);
            for (Map.Entry<Object, Object> entry : property.entrySet()) {
                CONFIGMAP.put(String.valueOf(entry.getKey()), String.valueOf(entry.getValue()).trim()); //remove the trailing and leading spaces
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            System.exit(0);
        }
        return CONFIGMAP;
    }

    public static String getPropValue(String key) throws Exception {

        if (key == null) {
            throw new Exception("Property name " + key + " is not found. Please check APIPath.properties file");
        }
        return (String) getMapFromPropFile().get(key);
    }

}
