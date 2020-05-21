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


            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO public.student(student_id, first_name, last_name,middle_name,student_ssn, student_type, student_residency) VALUES (?, ?, ?, ?, ?,?,?)");

                        pstmt.setString(
                            1, request.getParameter("Student ID"));
                        pstmt.setString(2, request.getParameter("First Name"));
                        pstmt.setString(3, request.getParameter("Last Name"));
                        pstmt.setString(4, request.getParameter("Middle Name"));
                        pstmt.setString(5, request.getParameter("SSN"));
                        pstmt.setString(6, request.getParameter("TYPE"));
                        pstmt.setString(7, request.getParameter("Residency"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Student SET FIRST_NAME = ?," +
                            "MIDDLE_NAME = ?, LAST_NAME = ?, student_type = ? , student_residency = ? WHERE student_ssn = ?");
                        pstmt.setString(1, request.getParameter("First Name"));
                        pstmt.setString(2, request.getParameter("Middle Name"));
                        pstmt.setString(3, request.getParameter("Last Name"));
                        pstmt.setString(4, request.getParameter("TYPE"));
                        pstmt.setString(5, request.getParameter("Residency"));
                        pstmt.setString(6,request.getParameter("SSN"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Student WHERE student_ssn = ?");

                        pstmt.setString(1,request.getParameter("SSN"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Student");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
			            <th>Middle Name</th>
                        <th>SSN</th>
                        <th>Type</th>
                        <th>Residency</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Student ID" size="10"></th>
                            <th><input value="" name="First Name" size="10"></th>
                            <th><input value="" name="Last Name" size="15"></th>
			                <th><input value="" name="Middle Name" size="15"></th>
                            <th><input value="" name="SSN" size="15"></th>
                            <th><select name="TYPE">
                                <option value = "undergrad">undergrad</option>
                                <option value = "phd">phd</option>
                                <option value = "MS">MS</option>
                                <option value = "MS program">MS program</option></th>
                            <th><input value="" name="Residency" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <td>
                                <input value="<%= rs.getString("student_id") %>" 
                                    name="Student ID" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("first_name") %>" 
                                    name="First Name" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("last_name") %>"
                                    name="Last Name" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("middle_name") %>" 
                                    name="Middle Name" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("student_ssn") %>" 
                                    name="SSN" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("student_type") %>" 
                                    name="TYPE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("student_residency") %>" 
                                    name="Residency" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("student_ssn") %>" name="SSN">
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
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
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
