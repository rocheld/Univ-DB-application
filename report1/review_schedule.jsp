<html>
<body>
    <table border="10">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" import="java.util.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132?user=root&password=root";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>
            <%
                // Variable daclaration
                final String QUARTER = "sp";
                final String YEAR = "2020";
                PreparedStatement set = conn.prepareStatement(
                    "select 1"
                );
                ResultSet rs = set.executeQuery();
                ResultSet rs2 = set.executeQuery();
                ResultSet rs3 = set.executeQuery();
                ResultSet result = set.executeQuery();
                ResultSet rr = set.executeQuery();
                String ssid = "";

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT	* from section s " +
                    "inner join classes c on c.index = s.class_id "+
                    "where s.section_id is not null " 
                );

                ResultSet ss = pstmt.executeQuery();
 
                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
            %>
                    
            <%-- -------- SEARCH Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("Search")) {
                    conn.setAutoCommit(false);                  
                    PreparedStatement pstmt2 = conn.prepareStatement(
                        "SELECT	e.*, c.class_dept, c.class_number, class_title ,class_quarter,class_year " + 
                        "FROM	courseEnrollment e " + 
                        "INNER JOIN section s ON s.section_id = e.sid AND s.section_id = ? " +
                        "INNER JOIN classes c ON s.class_id = c.index " +
                        "WHERE	class_quarter = ? " +
                        "AND	class_year = ? " 
                    );
                    ssid = request.getParameter("st_select");

                    pstmt2.setString(1,ssid);
                    pstmt2.setString(2,QUARTER);
                    pstmt2.setString(3,YEAR);
                    
                    rs = pstmt2.executeQuery();


                    String t1 = request.getParameter("t1");
                    String t2 = request.getParameter("t2");

                    PreparedStatement pstmt3 = conn.prepareStatement(
                        "Create table if not exists time_list AS ( " +
                        "SELECT t1, t1 + interval '1 hour' AS t2 " +
                        "FROM generate_series(?::timestamp, ?::timestamp, interval '1 hour') AS t1 " +
                        "WHERE t1::time >= '08:00:00' AND t1::time <= '19:00:00') " 
                    );

                    pstmt3.setString(1,t1);
                    pstmt3.setString(2,t2);
                    pstmt3.executeUpdate();
                    
                    /* find student who are taking the same courses */
                    PreparedStatement pstmt5 = conn.prepareStatement (
                        "CREATE TABLE IF NOT EXISTS temp AS ( SELECT e.pid FROM courseEnrollment e INNER JOIN section s ON s.section_id = e.sid AND s.section_id = ? INNER JOIN classes c ON s.class_id = c.index WHERE class_quarter = 'sp' AND class_year = '2020')"

                    );
                    pstmt5.setString(1,ssid);
                    pstmt5.executeUpdate();
                    // Commit transaction

                    PreparedStatement pstmt6 = conn.prepareStatement(
                    "create table if not exists rs as ( SELECT * FROM time_list t EXCEPT SELECT tt.t1, tt.t2 FROM time_list tt, (SELECT qs.start_time, qs.end_time FROM courseEnrollment e INNER JOIN quarter_schedule qs ON e.sid = qs.sid WHERE EXISTS ( SELECT * FROM temp t WHERE e.pid = t.pid)) AS qs2 WHERE (tt.t1, tt.t2) overlaps(qs2.start_time, qs2.end_time) )"
                );

                    pstmt6.executeUpdate();
                    PreparedStatement pstmt10 = conn.prepareStatement(
                    "SELECT distinct extract(month FROM rs.t1) AS month, extract(day FROM rs.t1) AS day, extract(DOW FROM rs.t1) AS dow, (rs.t1::time) AS t1, (rs.t2::time) AS t2 FROM rs"

                    );

                    rr = pstmt10.executeQuery();
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                }
            %>

            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
                <table border="1">
                    <th>Select a Section
                    <form action="review_schedule.jsp" method="POST">
                        <label for="p_1">FROM :</label>
                        <input type="text" id="t1" name="t1" ><br><br>
                        <label for="p_2">TO  :</label>
                        <input type="text" id="t2" name="t2"><br><br>
                        <select name="st_select">
                        <% while (ss.next()) { 
                           String att = "SID:" + ss.getString("section_id") + " " + 
                           ss.getString("class_dept") +  ss.getString("class_number"); %>
                        <option value= "<%= ss.getString("section_id") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form>  
                <table border="1">
                    <tr>
                        <th>Month</th>
                        <th>Day</th>
                        <th>DOW</th>
                        <th>start Time</th>
                        <th>end Time</th>
                    </tr>

            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rr.next() ) {
            %>
                    <tr>
                            <td>
                                <input value="<%= rr.getString("Month") %>" 
                                    name="Student ID" size="10">
                            </td>
                            <td>
                                <input value="<%= rr.getString("Day") %>" 
                                    name="First Name" size="10">
                            </td>
                            <td>
                                <input value="<%= rr.getString("DOW") %>" 
                                    name="First Name" size="10">
                            </td>
                                                        <td>
                                <input value="<%= rr.getString("t1") %>" 
                                    name="First Name" size="10">
                            </td>
                                    <td>
                                <input value="<%= rr.getString("t2") %>" 
                                    name="First Name" size="10">
                            </td>
    
                    </tr>
            <%
                }


                PreparedStatement pstmt4 = conn.prepareStatement(
                        "Drop table If exists time_list "
                );
                pstmt4.executeUpdate();
                PreparedStatement pstmt8 = conn.prepareStatement(
                    "Drop table if exists temp"
                );
                
                pstmt8.executeUpdate();
                PreparedStatement pstmt18 = conn.prepareStatement(
                    "Drop table if exists last"
                );
                
                pstmt18.executeUpdate();
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
                    rs2.close();
                    rs3.close();
                    result.close();
                    rr.close();
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
