import java.sql.*;
import java.sql.Driver;
public class jdbc {

    public static void main(String[] args) {
        // Load PostgreSQL driver
        String dbURL = "jdbc:postgresql:class_application?user=root&password=root";
        try {
            Connection conn = DriverManager.getConnection(dbURL);

            conn.close();
        } catch (SQLException ex) {
             ex.printStackTrace();
        }

    }

}
