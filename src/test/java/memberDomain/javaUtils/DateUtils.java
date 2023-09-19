package memberDomain.javaUtils;

import org.joda.time.LocalTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

public class DateUtils {

    private static final String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'Z'";


    public static String getTodaysDateTime(){
        String nowAsISO="";
        try{
            TimeZone tz = TimeZone.getTimeZone("UTC");
            DateFormat df = new SimpleDateFormat(DATE_FORMAT); // Quoted "Z" to indicate UTC, no timezone offset
            df.setTimeZone(tz);
            nowAsISO = df.format(new Date());
            System.out.println("Today's date and time is : " +nowAsISO);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return nowAsISO;
    }

    /**
     * Overloaded funtion, where user has to pass the date format
     * @return
     */
    public static String getTodaysDateTime(String format){
        String rewsultDate="";
        try{
            TimeZone tz = TimeZone.getTimeZone("UTC");
            DateFormat df = new SimpleDateFormat(format); // Quoted "Z" to indicate UTC, no timezone offset
            df.setTimeZone(tz);
            rewsultDate = df.format(new Date());
            System.out.println("Today's date and time is : " +rewsultDate);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return rewsultDate;
    }

    public static String getOnlyCurrentTime(){
        String time="";
        try{
            TimeZone tz = TimeZone.getTimeZone("UTC");
            DateFormat df = new SimpleDateFormat("HH:mm:ss"); // Quoted "Z" to indicate UTC, no timezone offset
            df.setTimeZone(tz);
            time = df.format(new Date());
            System.out.println("Current and time is : " +time);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return time;
    }

    public static String getOnlyCurrentTime(String format){
        String time="";
        try{
            TimeZone tz = TimeZone.getTimeZone("UTC");
            DateFormat df = new SimpleDateFormat(format); // Quoted "Z" to indicate UTC, no timezone offset
            df.setTimeZone(tz);
            time = df.format(new Date());
            System.out.println("Current and time is : " +time);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return time;
    }


    public static String getFutureDateTime(String toAdd) {
        String date = getTodaysDateTime();
        Calendar c = Calendar.getInstance();
        DateFormat df = new SimpleDateFormat(DATE_FORMAT);
        try {
            Date myDate = df.parse(date.trim());
            c.setTime(myDate);
            toAdd = toAdd.toUpperCase();
            if(toAdd.contains("DAY")){
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                System.out.println("Days to add: "+toAdd);
                c.add(Calendar.DATE, Integer.parseInt(toAdd));
            }
            else if(toAdd.contains("MONTH")){
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                c.add(Calendar.MONTH, Integer.parseInt(toAdd));
            }
            else if(toAdd.contains("YEAR")){
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                c.add(Calendar.YEAR, Integer.parseInt(toAdd));
            }
            else if(toAdd.contains("HOUR")){
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                c.add(Calendar.HOUR, Integer.parseInt(toAdd));
            }
            else if(toAdd.contains("MINUTE")){
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                c.add(Calendar.MINUTE, Integer.parseInt(toAdd));
            }
            else if(toAdd.contains("SECOND")){
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                c.add(Calendar.SECOND, Integer.parseInt(toAdd));
            }
            else{
                System.out.println("Not matching anything .......");
                toAdd = toAdd.replaceAll("[^0-9]", "").trim();
                c.add(Calendar.DATE, Integer.parseInt(toAdd));

            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        String toDate = df.format(c.getTime());
        System.out.println("Future date and time is : " +toDate);
        return toDate;
    }

    /**
     *
     * @param format
     * @param timeToAdd example 15M, meaning 15 minutes
     * @return
     */
    public static String getFutureDateTime(String format, String timeToAdd) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(format);
        LocalTime time = formatter.parseLocalTime(getTodaysDateTime());
        System.out.println("Now Time : "+time);
        try {
            if(timeToAdd.toUpperCase().contains("M"))
                time= time.plusMinutes(Integer.parseInt(timeToAdd.replace("M","")));
            if(timeToAdd.toUpperCase().contains("S"))
                time = time.plusSeconds(Integer.parseInt(timeToAdd.replace("S","")));
            if(timeToAdd.toUpperCase().contains("H"))
                time = time.plusHours(Integer.parseInt(timeToAdd.replace("H","")));
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Future date and time is : " +time.toString());
        return time.toString();
    }

    public static String getOnlyFutureTime(String format , String timeToAdd) {
        DateTimeFormatter formatter = DateTimeFormat.forPattern(format);
        LocalTime time = formatter.parseLocalTime(getOnlyCurrentDate(format));
        System.out.println("Now Time : "+time);
        try {
            if(timeToAdd.toUpperCase().contains("M"))
               time= time.plusMinutes(Integer.parseInt(timeToAdd.replace("M","")));
            if(timeToAdd.toUpperCase().contains("S"))
                time = time.plusSeconds(Integer.parseInt(timeToAdd.replace("S","")));
            if(timeToAdd.toUpperCase().contains("H"))
                time = time.plusHours(Integer.parseInt(timeToAdd.replace("H","")));
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Future time is : " +time.toString());
        return time.toString();
    }

    public static String getPastDateTime( String days) {
        String date = getTodaysDateTime();
        Calendar c = Calendar.getInstance();
        DateFormat df = new SimpleDateFormat(DATE_FORMAT);
        try {
            Date myDate = df.parse(date.trim());
            c.setTime(myDate);
            c.add(Calendar.DATE, (Integer.parseInt(days) * -1));
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String toDate = df.format(c.getTime());
        System.out.println("Past date and time is : " +toDate);
        return toDate;
    }

    /**
     * returns the difference in milli seconds
     * @param date1
     * @param date2
     * @return
     */

    public static long getTimeDiffInMills(String date1, String date2){
        long diff = 0;
        try{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            Date d1 = sdf.parse(date1);
            Date d2 = sdf.parse(date2);
            diff = Math.abs(d1.getTime()-d2.getTime());
            System.out.println(" Time difference in milliseconds : "+ diff);
            return diff;

        }
        catch(Exception e){
           e.printStackTrace();
        }
        return diff;
    }

    /**
     * Copmare two dates
     * @param date1
     * @param date2
     * @return
     */
    public static long compareDates(String date1, String date2){

        try{
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            Date d1 = sdf.parse(date1);
            Date d2 = sdf.parse(date2);
              if(d1.before(d2)){
                  return 1;
              }
              else if(d1.after(d2)){
                  return -1;
              }
              else{
                  return 0;
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }

    public static String getOnlyCurrentDate(String format){

        String onlyDate ="";
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        Date date = new Date();
        String strDate = formatter.format(date);
        return strDate;
    }

    public static String getOnlyCurrentMonth(String format){

        String onlyDate ="";
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        Date date = new Date();
        String strDate = formatter.format(date);
        return strDate;
    }

    public static String getOnlyCurrentYear(String format){

        String onlyDate ="";
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        Date date = new Date();
        String strDate = formatter.format(date);
        return strDate;
    }


    public static void main(String[] args) {
//            String date =getTodaysDateTime();
//            String futureDate = getFutureDateTime("10"); //get date after adding 280 days to the above date
//            System.out.println("Future Date : " + futureDate);
//            String pastDate = getPastDateTime("10"); //get past date after subtracting 30 days from the above date
//            System.out.println("Past Date : " + pastDate );
//            getTimeDiff("2021-07-16T06:50:21Z", "2021-07-16T07:00:00Z");

       // getFutureDateTime("yyyy-MM-dd'T'HH:mm:ss'Z'" , "15M");
        getFutureDateTime("1DAY");
        }

}
