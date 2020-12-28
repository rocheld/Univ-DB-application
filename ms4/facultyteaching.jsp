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
                int fid = 0;
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
                    "select * from faculty order by index asc"
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

                    fid = Integer.parseInt(request.getParameter("faculty_select"));


                    PreparedStatement pstmt2 = conn.prepareStatement(
                        "select c.* from class_taught c " +
                        "where c.fid = ? AND c.sid is not null "
                    );
                    pstmt2.setInt(1,fid);
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
                        PreparedStatement stmt = conn.prepareStatement(
                            "insert into public.class_taught (course_dept,course_number,sid,fid,class_quarter,class_year) " +
                             "values (?,?,?,?,?,?)"
                        );                        
                        stmt.setString(1,request.getParameter("DEPT"));
                        stmt.setString(2,request.getParameter("NUM"));
                        stmt.setString(3,request.getParameter("SID"));
                        stmt.setInt(4, Integer.parseInt(request.getParameter("FID")));
                        stmt.setString(5,current_quarter);
                        stmt.setString(6,current_year);
                        
                        int rowCount = stmt.executeUpdate();
                        
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
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement stmt = conn.prepareStatement(
                            "Update public.class_taught set course_dept = ?, course_number = ? , sid = ?, fid = ? where index = ?"
                        );
                        stmt.setString(1,request.getParameter("DEPT"));
                        stmt.setString(2,request.getParameter("NUM"));
                        stmt.setString(3,request.getParameter("SID"));
                        stmt.setInt(4, Integer.parseInt(request.getParameter("FID")));
                        stmt.setInt(5, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = stmt.executeUpdate();
                        // Commit transaction
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
                            "DELETE FROM class_taught WHERE index = ? ");
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
                    <th>Select a Section
                    <form action="facultyteaching.jsp" method="POST">
                        <select name="faculty_select">
                        <% while (selec.next()) { 
                            String att = selec.getString("firstname") + " " + 
                                        selec.getString("lastname") + " " + selec.getString("faculty_type") ;%>
                        <option value= "<%= selec.getInt("index") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form></th>


                <table border="1">
                    <tr>
                        <th>Faculty ID</th>
                        <th>Course Dept</th>
                        <th>Course Number</th>
                        <th>Section ID</th>

                    </tr>
                    <tr>
                    <form action="facultyteaching.jsp" method="get">
                            <input type="hidden" value="winsert" name="action">
                            <th><input value="<%=fid%>" name="FID" size="10"</th>
                            <th><input value="" name="DEPT" size="10"></th>
                            <th><input value="" name="NUM" size="10"></th>
                            <th><input value="" name="SID" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                    </form>
                    </tr>

            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) { %>
                    <tr>
                        <form action="facultyteaching.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("index") %>" name="ID">
                            <td>
                                <input value="<%= rs.getInt("fid") %>" 
                                    name="FID" size="10" readonly>
                            </td>
                            <td>
                                <input value="<%= rs.getString("course_dept") %>" 
                                    name="DEPT" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("course_number") %>" 
                                    name="NUM" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("sid") %>" 
                                    name="SID" size="10">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="facultyteaching.jsp" method="get">
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
