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
            <%@ page language="java" import="java.sql.*" 
                import="java.util.*" import="java.text.SimpleDateFormat"
                import="java.util.Date"%>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132?user=root&password=root";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>
            <%
                // Variable daclaration
                final String current_quarter = "sp";
                final String current_year = "2020";
                int type = -1;
                int class_id = -1;
                String sid = " ";

                PreparedStatement set = conn.prepareStatement(
                    "select 1"
                );
                ResultSet rs = set.executeQuery();
                ResultSet selec = set.executeQuery();
                boolean setup = false;

                // Begin transaction
                conn.setAutoCommit(false);                  

                PreparedStatement pstmt = conn.prepareStatement(
                    "select * from classes c inner join quarter_order q on c.class_quarter = q.quarter_name " + 
                    "order by c.class_year asc, q.quarter_order asc"
                );
                selec = pstmt.executeQuery();
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
                        "select c.*, s.first_name, s.student_id, cl.class_dept, cl.class_number, cl.class_quarter, cl.class_year " +
                        "from courseEnrollment c inner join student s on c.pid = s.student_id " +
                        "inner join classes cl on cl.index = c.class_id " + 
                        "where c.class_id = ? "
                    );
                    pstmt2.setInt(1,Integer.parseInt(request.getParameter("class_select")));
                    rs = pstmt2.executeQuery();
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- INSERT weekly schedule Code -------- --%>
            <%
                    // Check if an insertion is requested
                    if (action != null && action.equals("winsert")) {
                        conn.setAutoCommit(false);
                        class_id = -1;
                        PreparedStatement temp = conn.prepareStatement(
                            "select index from classes where class_dept = ? AND class_number = ? AND class_year = ? AND class_quarter = ?"
                        );

                        temp.setString(1, request.getParameter("DEPT"));
                        temp.setString(2, request.getParameter("NUM"));
                        temp.setString(3, request.getParameter("YY"));
                        temp.setString(4, request.getParameter("QQ"));
                        ResultSet ts = temp.executeQuery();

                        if(ts.next())
                            class_id = ts.getInt("index");

                        PreparedStatement stmt = conn.prepareStatement(
                            "insert into public.courseEnrollment (pid,unit,grade_option,grade_earned,class_id) " +
                             "values (?,?,?,?,?)"
                        );                        

                        stmt.setString(1,request.getParameter("PID"));
                        stmt.setInt(2,Integer.parseInt(request.getParameter("UNIT")));
                        stmt.setString(3,request.getParameter("OPT"));
                        stmt.setString(4,request.getParameter("GRADE"));
                        stmt.setInt(5, class_id);
                        
                        int rowCount = stmt.executeUpdate();
                        ts.close();
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE weekly schedule  Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        // Begin transaction
                        conn.setAutoCommit(false);

                        class_id = -1;
                        PreparedStatement temp = conn.prepareStatement(
                            "select index from classes where class_dept = ? AND class_number = ? AND class_year = ? AND class_quarter = ?"
                        );

                        temp.setString(1, request.getParameter("DEPT"));
                        temp.setString(2, request.getParameter("NUM"));
                        temp.setString(3, request.getParameter("YY"));
                        temp.setString(4, request.getParameter("QQ"));
                        ResultSet ts = temp.executeQuery();

                        if(ts.next())
                            class_id = ts.getInt("index");
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement stmt = conn.prepareStatement(
                            "Update public.courseEnrollment set pid = ? , unit = ?, grade_option = ?, grade_earned = ?, class_id = ? where index = ?"
                        );
                        stmt.setString(1,request.getParameter("PID"));
                        stmt.setInt(2,Integer.parseInt(request.getParameter("UNIT")));
                        stmt.setString(3,request.getParameter("OPT"));
                        stmt.setString(4, request.getParameter("GRADE"));
                        stmt.setInt(5,class_id);
                        stmt.setInt(6, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = stmt.executeUpdate();
                        // Commit transaction
                        ts.close();
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE  weekly schedule Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("wdelete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement stmt = conn.prepareStatement(
                            "DELETE FROM courseEnrollment WHERE index = ? ");
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = stmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>
            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
            
                <table border="1">
                    <form action="grade_entry.jsp" method="POST">
                    <th>Search by a Class
                        <select name="class_select">
                        <% while (selec.next()) { 
                            String att = selec.getString("class_quarter") + " " + selec.getString("class_year") + "   | " +
                                        selec.getString("class_dept") + selec.getString("class_number") ;%>
                        <option value= "<%= selec.getInt("index") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form></th>

                <!-------------------- DATA FIELD -------------------------------->
                <table border="1">
                    <tr>
                        <th>Student Firstname</th>
                        <th>Student SSN</th>
                        <th>Course Dept</th>
                        <th>Course Number</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Unit</th>
                        <th>Grade Option</th>
                        <th>Grade Earned</th>

                    </tr>
                    <tr>
                    <form action="grade_entry.jsp" method="get">
                            <input type="hidden" value="winsert" name="action">
                            <th><input value="" name="NAME" size="10" readonly</th>
                            <th><input value="" name="PID" size="5" ></th>
                            <th><input value="" name="DEPT" size="10" ></th>
                            <th><input value="" name="NUM" size="10"></th>
                            <th><input value="" name="QQ" size="5"></th>
                            <th><input value="" name="YY" size="5"></th>
                            <th><input value="" name="UNIT" size="5"></th>
                            <th><select name="OPT"><option value= "Letter Grade">Letter Grade</option><option value="S/U">S/U</option></th>
                            <th><input value="" name="GRADE" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                    </form>
                    </tr>

            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) { %>
                    <tr>
                        <form action="grade_entry.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("index") %>" name="ID">
                            <td>
                                <input value="<%= rs.getString("first_name") %>" 
                                    name="NAME" size="10" readonly>
                            </td>
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="PID" size="5">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_dept") %>" 
                                    name="DEPT" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_number") %>" 
                                    name="NUM" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_quarter") %>" 
                                    name="QQ" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_year") %>" 
                                    name="YY" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("unit") %>" 
                                    name="UNIT" size="5">
                            </td>
                            <td>
                                <input value="<%= rs.getString("grade_option") %>" 
                                    name="OPT" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("grade_earned") %>" 
                                    name="GRADE" size="10">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="grade_entry.jsp" method="get">
                            <input type="hidden" value="wdelete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("index") %>" name="ID">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
                
            <%
                }
            %>
            
            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    selec.close();
                    rs.close();
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
