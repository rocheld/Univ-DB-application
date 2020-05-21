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
                            "INSERT INTO public.classes(class_dept, class_number, class_title, class_quarter, class_year) VALUES (?, ?, ?, ?,?)");
                        pstmt.setString(1,request.getParameter("DEPT"));
                        pstmt.setString(2, request.getParameter("NUM"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                        pstmt.setString(4, request.getParameter("QUARTER"));
                        pstmt.setString(5, request.getParameter("YEAR"));
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
                            "DELETE FROM classes WHERE index = ?");


                        pstmt = conn.prepareStatement(
                            "UPDATE public.classes SET class_dept = ?, class_number = ? , class_title = ? , class_quarter = ?, class_year = ? " +
                            "WHERE index = ?");
                        pstmt.setString(1,request.getParameter("DEPT"));
                        pstmt.setString(2, request.getParameter("NUM"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                        pstmt.setString(4, request.getParameter("QUARTER"));
                        pstmt.setString(5, request.getParameter("YEAR"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("CLASSID")));
                        int rowCount = pstmt.executeUpdate();
                        rowCount = pstmt.executeUpdate();
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
                            "DELETE FROM classes WHERE index = ?");
                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("CLASSID")));
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
                        ("SELECT * FROM classes ORDER BY class_title DESC");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>CLASS_ID</th>
                        <th>DEPT</th>
                        <th>NUM</th>
                        <th>TITLE</th>
			            <th>Quarter</th>
                        <th>Year</th>
                    </tr>
                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value= "" name="CLASSID" size="10" readonly></th>
                            <th><input value="" name="DEPT" size="10"></th>
                            <th><input value="" name="NUM" size="15"></th>
                            <th><input value="" name="TITLE" size="15"></th>
			                <th><input value="" name="QUARTER" size="15"></th>
                            <th><input value="" name="YEAR" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("index") %>" 
                                    name="CLASSID" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_dept") %>" 
                                    name="DEPT" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_number") %>"
                                    name="NUM" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_title") %>"
                                    name="TITLE" size="40">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_quarter") %>" 
                                    name="QUARTER" size="15">
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_year") %>" 
                                    name="YEAR" size="15">
                            </td>

    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("index") %>" name="CLASSID">
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
