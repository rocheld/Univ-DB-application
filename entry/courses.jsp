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
                            "INSERT INTO public.courses(course_dept, course_number, consent, lab) VALUES (?, ?, ?, ?)");

                        pstmt.setString(
                            1, request.getParameter("Dept"));

                        pstmt.setString(2, request.getParameter("Course Number"));
                        pstmt.setBoolean(3, Boolean.parseBoolean(request.getParameter("Consent Required")));
                        pstmt.setBoolean(4, Boolean.parseBoolean(request.getParameter("Lab")));

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
                            "DELETE FROM Courses WHERE course_dept = ? AND course_number = ?");

            

                        pstmt.setString(1, request.getParameter("Dept"));
                        pstmt.setString(2, request.getParameter("Course Number"));
                         int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "INSERT INTO public.courses(course_dept, course_number, consent, lab) VALUES (?, ?, ?, ?)");
                        pstmt2.setString(1, request.getParameter("Dept"));
                        pstmt2.setString(2, request.getParameter("Course Number"));
                        pstmt2.setBoolean(3, Boolean.parseBoolean(request.getParameter("Consent Required")));
                        pstmt2.setBoolean(4, Boolean.parseBoolean(request.getParameter("Lab")));
                       
                        rowCount = pstmt2.executeUpdate();
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
                            "DELETE FROM Courses WHERE course_dept = ? AND course_number = ? ");

                        pstmt.setString(
                            1, request.getParameter("Dept"));
                        pstmt.setString(
                        	2, request.getParameter("Course Number"));

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
                        ("SELECT * FROM Courses");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Dept</th>
                        <th>Course Number</th>
                        <th>Consent Required</th>
			            <th>Lab</th>
                    </tr>
                    <tr>
                        <!--
    					A hidden field let web developers include data that cannot be seen or modified by users when a form is submitted.
                        -->
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="Dept" size="10"></th>
                            <th><input value="" name="Course Number" size="10"></th>
                            <th><select name="Consent Required" size="1">
			           			<option value="true">Consent Required</option>
			                	<option value="false">No Consent</option></select></th>
			                <th><select name="Lab" size="1">
			           			<option value="true">Lab Required</option>
			                	<option value="false">No Lab</option></select></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("course_dept") %>" 
                                    name="Dept" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("course_number") %>" 
                                    name="Course Number" size="10">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("consent") %>"
                                    name="Consent Required" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("lab") %>" 
                                    name="Lab" size="15">
                            </td>
    
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("course_dept") %>" name="Dept">
                            <input type="hidden" 
                                value="<%= rs.getString("course_number") %>" name="Course Number">
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
