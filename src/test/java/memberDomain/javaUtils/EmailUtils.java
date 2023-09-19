package memberDomain.javaUtils;

import javax.activation.*;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.IOException;
import java.util.Properties;

public class EmailUtils extends LogUtils{


    public static void sendMail(String attachmentFile) {

        final String username = "abc@gmail.com";
        final String password = "aaaa";
        final String sendTo = "bbc@gmail.com";

        Properties props = new Properties();
        props.put("mail.smtp.auth", true);
        props.put("mail.smtp.starttls.enable", true);
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.port", "587");


        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {
            logger.info("Sending email to "+ sendTo);
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(sendTo));
            message.setSubject("API Test Result for "+ System.getProperty("env").toUpperCase());
            message.setText("Hi Team, please find the API test results attached with this email.");

            MimeBodyPart messageBodyPart = new MimeBodyPart();
            Multipart multipart = new MimeMultipart();

            String file = attachmentFile;
            String fileName = "APITestResult.zip";
            DataSource source = new FileDataSource(file);
            messageBodyPart.setDataHandler(new DataHandler(source));
            messageBodyPart.setFileName(fileName);
            messageBodyPart.attachFile(file, "application/zip", "base64");
            multipart.addBodyPart(messageBodyPart);
            message.setContent(multipart);
            Transport.send(message);
            logger.info("Email with results sent successfully to " + sendTo);
        } catch (MessagingException | IOException e) {
            e.printStackTrace();
        }
    }


}