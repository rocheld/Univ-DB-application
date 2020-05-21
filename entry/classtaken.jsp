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
                        PreparedStatement st1 = conn.prepareStatement(
                            "select index from classes " +
                            "where class_dept = ? AND class_number = ? "+ 
                            "AND class_quarter = ?  AND class_year = ?"
                        );

                        st1.setString(1,request.getParameter("DEPT"));
                        st1.setString(2,request.getParameter("NUM"));
                        st1.setString(3,request.getParameter("QUARTER"));
                        st1.setString(4,request.getParameter("YEAR"));

                        ResultSet set1 = st1.executeQuery();
                        set1.next();
                        int a = set1.getInt("index");
        
                        PreparedStatement pstmt = conn.prepareStatement(
                        "INSERT INTO public.courseEnrollment(pid,unit,grade_option, grade_earned,class_id) values(?,?,?,?,?)");
                        pstmt.setString(1,request.getParameter("PID")); 
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("UNIT")));
                         pstmt.setString(3, request.getParameter("OPTION"));
                        pstmt.setString(4, request.getParameter("GRADE"));
                        pstmt.setInt(5,a);
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
                        
                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "UPDATE courseEnrollment set pid = ?, unit = ? ,grade_option = ?, grade_earned = ? where courseEnrollment.index = ?   ");
                        pstmt2.setString(1,request.getParameter("PID")); 
                        pstmt2.setInt(2, Integer.parseInt(request.getParameter("UNIT")));
                        pstmt2.setString(3, request.getParameter("OPTION"));
                        pstmt2.setString(4, request.getParameter("GRADE"));
                        pstmt2.setInt(5, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = pstmt2.executeUpdate();
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
                        "DELETE FROM courseEnrollment WHERE index = ?");
                        pstmt.setInt(1,Integer.parseInt(request.getParameter("ID")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
                    %>

                    <%-- -------- SELECT Statement Code -------- --%>
                    <%
                    String current_quarter = "sp";
                    String current_year = "2020";

                    PreparedStatement st = conn.prepareStatement(
                        "SELECT  e.*, c.* from courseEnrollment e,classes c " + 
                        "WHERE e.class_id = c.index " +
                        "AND NOT EXISTS " + 
                        "(SELECT e2.*, c2.* from courseEnrollment e2,classes c2 " +
                        "WHERE e2.class_id = c2.index " +
                        "AND c.class_quarter = ?  AND c.class_year = ?)"
                    );

                    st.setString(1,current_quarter);
                    st.setString(2,current_year);
                    ResultSet rs = st.executeQuery();
                    %>

                    <!-- Add an HTML table header row to format the results -->
                    <table border="1">
                        <tr>
                            <th>Enrolled ID</th>
                            <th>Student ID</th>
                            <th>CourseDept</th>
                            <th>CourseNum</th>
                            <th>Class Quarter</th>
                            <th>Class Year</th>
                            <th>Unit</th>
                            <th>Grade OPtion</th>
                            <th>Grade Earned</th>
                        </tr>
                        <tr>
                            <form action="classtaken.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="ID" size = "10"></th>
                                <th><input value="" name="PID" size="10"></th>
                                <th><input value="" name="DEPT" size="10"></th>
                                <th><input value="" name="NUM" size="10"></th>
                                <th><input value="" name="QUARTER" size="10"></th>
                                <th><input value="" name="YEAR" size="10"></th>
                                <th><input value="" name="UNIT" size="10"></th>
                                <th><input value="" name="OPTION" size="10"></th>
                                <th><input value="" name="GRADE" size="10"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>
                        </tr>

                    <%-- -------- Iteration Code -------- --%>
                    <%
                    // Iterate over the ResultSet

                    while ( rs.next() ) {

                    %>      
                    <tr>
                        <form action="classtaken.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <td>
                                <input value="<%= rs.getInt("index") %>" 
                                name="ID" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("pid") %>" 
                                name="PID" size="10">
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
                                name="NUM" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("class_year") %>"
                                name="NUM" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("unit") %>"
                                name="UNIT" size="10">
                            </td>

                            <td>
                                <input value="<%= rs.getString("grade_option") %>"
                                name="OPTION" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("grade_earned") %>"
                                name="GRADE" size="10">
                            </td>

                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>

                        <form action="classtaken.jsp" method="get">
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
                st.close();

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
