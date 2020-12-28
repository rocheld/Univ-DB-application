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
                        
                        PreparedStatement st = conn.prepareStatement("SELECT index FROM Classes where class_dept = ? AND class_number = ? AND class_quarter = ? AND class_year = ?");
                        st.setString(1,request.getParameter("DEPT"));
                        st.setString(2,request.getParameter("NUM"));
                        st.setString(3,request.getParameter("Q"));
                        st.setString(4,request.getParameter("Y"));
                        ResultSet set = st.executeQuery();
                        set.next();

                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                        "INSERT INTO public.section(section_id, class_id,seats) VALUES (?,?,?)");
                        pstmt.setString(1,request.getParameter("ID"));
                        pstmt.setInt(2, set.getInt("index")); 
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("SEAT")));
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
                        "UPDATE public.section set seats = ? WHERE section_id = ?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SEAT")));
                        pstmt.setString(2, request.getParameter("ID"));
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
                    ResultSet rs = statement.executeQuery("select * from section s, classes c where s.class_id = c.index order by section_id::Integer asc" );
                    %>

                    <!-- Add an HTML table header row to format the results -->
                    <table border="1">
                        <tr>
                            <th>Section ID</th>
                            <th>DEPT</th>
                            <th>NUM</th>
                            <th>QUARTER</th>
                            <th>YEAR</th>
                            <th>SEAT</th>
                        </tr>
                        <tr>
                            <form action="section.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="ID" size="10"></th>
                                <th><input value="" name="DEPT" size="10"></th>
                                <th><input value="" name="NUM" size="10"></th>
                                <th><input value="" name="Q" size="10"></th>
                                <th><input value="" name="Y" size="10"></th>
                                <th><input value="" name="SEAT" size="10"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>

                                <%-- -------- Iteration Code -------- --%>
                                <%
                    // Iterate over the ResultSet

                    while ( rs.next() ) {

                    %>      
                    <tr>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("section_id") %>" 
                                name="ID" size="10">
                            </td>

                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("class_dept") %>" 
                                name="DEPT" size="10">
                            </td>

                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("class_number") %>"
                                name="NUM" size="10">
                            </td>
                            <td>
                            <input value="<%= rs.getString("class_quarter") %>"
                                name="Q" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_year") %>"
                                name="Y" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("seats") %>"
                                name="SEAT" size="10">
                            </td>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                            value="<%= rs.getString("section_id") %>" name="ID">
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
