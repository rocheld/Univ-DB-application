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
                    System.out.println("a");

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
                            "insert into public.probation (pid,type,start_date,end_date) values (?,? , ?,?)");
                        if(request.getParameter("E").equals("")) {
                            pstmt = conn.prepareStatement(
                            "insert into public.probation (pid,type,start_date) values (?,?,?)");

                            pstmt.setString(1,request.getParameter("PID"));
                            pstmt.setString(2, request.getParameter("TYPE"));
                            pstmt.setDate(3, Date.valueOf(request.getParameter("S")));
                        }

                        else {
                            pstmt.setString(1,request.getParameter("PID"));
                            pstmt.setString(2, request.getParameter("TYPE"));
                            pstmt.setDate(3, Date.valueOf(request.getParameter("S")));

                        }
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
                            "Update public.probation set pid = ?, type = ?, start_date =?, end_date=? where index = ?");
                        if(request.getParameter("E").equals("")) {
                            pstmt = conn.prepareStatement(
                            "Update public.probation set pid = ?, type = ?, start_date =?, end_date = null where index = ?");
                            pstmt.setString(1, request.getParameter("PID"));
                            pstmt.setString(2,request.getParameter("TYPE"));
                            pstmt.setDate(3, Date.valueOf(request.getParameter("S")));
                            pstmt.setInt(4, Integer.parseInt(request.getParameter("ID")));
                        }
                        else {
                            pstmt.setString(1, request.getParameter("PID"));
                            pstmt.setString(2,request.getParameter("TYPE"));
                            pstmt.setDate(3, Date.valueOf(request.getParameter("S")));
                            pstmt.setDate(4, Date.valueOf(request.getParameter("E")));
                            pstmt.setInt(5, Integer.parseInt(request.getParameter("ID")));
                        }
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
                            "DELETE FROM probation WHERE index = ? ");
                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("ID")));
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
                        ("SELECT * FROM probation");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>ProbationNo</th>
                        <th>Student ID</th>
                        <th>Type</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ID" size="10" readonly> </th>
                            <th><input value="" name="PID" size="10" ></th>
                            <th><input value="" name="TYPE" size="10"></th>
                            <th><input value="" name="S" size="15"></th>
                            <th><input value="" name="E" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <td>
                                <input value="<%= rs.getString("index") %>" 
                                    name="ID" size="10" readonly>
                            </td>

                            <td>
                                <input value="<%= rs.getString("pid") %>" 
                                    name="PID" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("type") %>" 
                                    name="TYPE" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("start_date")%>"
                                    name="S" size="15">
                            </td>

                            <td>
                                <input value="<%= rs.getString("end_date") %>"
                                    name="E" size="15">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
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
