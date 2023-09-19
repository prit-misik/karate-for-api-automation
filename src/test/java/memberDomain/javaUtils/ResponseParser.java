package memberDomain.javaUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ResponseParser {

    /**
     *
     * @param arr
     * @param ele : user has to pass the element name it is searching for
     * @return : returns the index of the element
     * @throws JSONException
     */
    public static int getIndexOfAnElement(String arr, String ele) throws JSONException {
        if (arr == null) {
            return -1;
        }
        JSONArray jsonarray = new JSONArray(arr);
        for (int idx = 0; idx < jsonarray.length(); idx++) {
            JSONObject obj = jsonarray.getJSONObject(idx);
            String name = obj.getString("name");
            if (name.trim().contains(ele.trim())) {
                return idx;
            }
            System.out.println(name);
        }
        return -1;
    }

}
