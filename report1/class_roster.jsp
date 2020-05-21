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
            <%@ page language="java" import="java.sql.*" %>
    
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
                ResultSet ss = set.executeQuery();
                boolean setup = false;

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT	distinct c.* " + 
                    "FROM	classes c " +
                    "ORDER BY c.class_year DESC"
                );
                // select all classes
                ss = pstmt.executeQuery();
 
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
                        "SELECT     c.* " + 
                        "FROM       classes c " +
                        "WHERE      c.index = ?"
                    );
                    pstmt2.setInt(1, Integer.parseInt(request.getParameter("value_select")));
                    rs = pstmt2.executeQuery();

                    PreparedStatement pstmt3 = conn.prepareStatement(
                        "SELECT	st.*, en.unit, sid, en.grade_option " +
                        "FROM	classes c " +
                        "INNER JOIN courseEnrollment en on en.class_id = c.index " +
                        "INNER JOIN student st on en.pid = st.student_id " + 
                        "WHERE 	c.index = ? "
                    );

                    pstmt3.setInt(1, Integer.parseInt(request.getParameter("value_select")));
                    rs2 = pstmt3.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    }
            %>



            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
            
                <table border="1">
                    <th>Select a Class
                    <form action="class_roster.jsp" method="POST">
                        <select name="value_select">
                        <% while (ss.next()) { 
                           String att = ss.getString("class_dept") + " " + ss.getString("class_number")+
                                        " " + ss.getString("class_quarter") + ss.getString("class_year");%>
                        <option value= "<%= ss.getInt("index") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form></th>
            
                <table border="1">
                    <tr>
                        <th>Dept</th>
                        <th>Course Number</th>
                        <th>Quarter</th>
			            <th>Year</th>
                        <th>Title</th>
                    </tr>
            <%-- -------- Iteration1 Code -------- --%>
            

            <%
                //if (rs != null) {
                    while ( rs.next() ) {
            %>
                    <tr>
                            <td>
                                <input value="<%= rs.getString("class_dept") %>" 
                                    name="Dept" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_number") %>" 
                                    name="Course Number" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_quarter") %>"
                                    name="Quarter" size="15" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_year") %>" 
                                    name="Year" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_title") %>" 
                                    name="Title" size="45" readonly>
                            </td>
                    </tr>
            <%
                }//}
            %>
            
                <table border="1">
                    <tr>
                        <th>PID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Middle Name</th>
                        <th>Units </th>
			            <th>Section ID</th>
                        <th>Grade Option</th>
                    </tr>

            <%-- -------- Iteration2 Code -------- --%>
            <%
                    // Iterate over the ResultSet
                //if( rs2 != null) {
                    while ( rs2.next() ) {
            %>
                    <tr>
                            <td>
                                <input value="<%= rs2.getString("student_id") %>" 
                                    name="PID" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs2.getString("first_name") %>" 
                                    name="First Name" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs2.getString("last_name") %>"
                                    name="Last Name" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= rs2.getString("middle_name") %>"
                                    name="Middle Name" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= rs2.getInt("unit") %>" 
                                    name="Units" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= rs2.getString("sid") %>" 
                                    name="Section ID" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= rs2.getString("grade_option") %>" 
                                    name="Grade Option" size="15" readonly>
                            </td>
                    </tr>
            <%
               }
            %>
            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    ss.close();
                    rs.close();
                    rs2.close();
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
