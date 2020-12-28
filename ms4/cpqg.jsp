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
                int cid = 0;
                String sid = " ";

                PreparedStatement set = conn.prepareStatement(
                    "select 1"
                );
                ResultSet rs = set.executeQuery();
                ResultSet selec = set.executeQuery();

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "select * from courses order by index asc"
                );
                // select all classes
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
                        "select c.* from cpqg c " +
                        "where c.cid = ? "
                    );
                    pstmt2.setInt(1, Integer.parseInt(request.getParameter("cid_select")));
                    rs = pstmt2.executeQuery();
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>



            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
            
                <table border="1">
                    <th>Select a Course
                    <form action="cpqg.jsp" method="POST">
                        <select name="cid_select">
                        <% while (selec.next()) { 
                            String att = selec.getString("course_dept") + " " + 
                                        selec.getString("course_number") ;%>
                        <option value= "<%= selec.getInt("index") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form></th>


                <table border="1">
                    <tr>
                        <th>Professor Name</th>
                        <th>Course Dept</th>
                        <th>Course Number</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>A</th>
                        <th>B</th>
                        <th>C</th>
                        <th>D</th>
                        <th>Other</th>




            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) { %>
                    <tr>    
                            <td>
                                <input value="<%= rs.getString("firstname") %>" 
                                    name="NAME" size="10">
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
                                <input value="<%= rs.getInt("A") %>" 
                                    name="AA" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("B") %>" 
                                    name="BB" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("C") %>" 
                                    name="CC" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("D") %>" 
                                    name="DD" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("Other") %>" 
                                    name="OO" size="10">
                            </td>
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
