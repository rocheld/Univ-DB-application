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
                            "AND class_quarter = 'sp' AND class_year = '2020'"
                        );

                        st1.setString(1,request.getParameter("DEPT"));
                        st1.setString(2,request.getParameter("NUM"));


                        ResultSet set1 = st1.executeQuery();
                        set1.next();
                        int a = set1.getInt("index");
                        
                        PreparedStatement pstmt = conn.prepareStatement(
                        "INSERT INTO public.courseEnrollment(pid,sid,unit,grade_option,class_id) values(?,?,?,?,?)");
                        pstmt.setString(2,request.getParameter("SID"));
                        pstmt.setString(1,request.getParameter("PID")); 
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("UNIT")));
                        pstmt.setString(4, request.getParameter("GRADE"));
                        pstmt.setInt(5,a);
                        int rowCount = pstmt.executeUpdate();

                        /*
                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "INSERT INTO public.sectionenrolled(section_id, student_id)VALUES ( ?, ?)"
                        );
                        if(is_multiple) pstmt2.setString(1,request.getParameter("SID"));
                        else pstmt2.setString(1,a);
                        pstmt2.setString(2,request.getParameter("PID"));
                        int bb = pstmt2.executeUpdate();
                        */
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
                        

                        PreparedStatement st1 = conn.prepareStatement("select section_id, count(section_id) from classes, section where section.class_id = classes.index AND class_dept = ? AND class_number = ? AND class_quarter = 'sp' AND class_year = '2020' group by section_id;");
                        st1.setString(1,request.getParameter("DEPT"));
                        st1.setString(2,request.getParameter("NUM"));

                        ResultSet set1 = st1.executeQuery();
                        set1.next();
                        String a = set1.getString("section_id");
                        boolean is_multiple = set1.next() ? true : false;
                        //set.next();
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        
                        PreparedStatement pstmt2 = conn.prepareStatement(
                        "UPDATE courseEnrollment set pid = ?, sid = ?, unit = ? ,grade_option = ? where courseEnrollment.index = ?   ");
                        if(is_multiple)
                          pstmt2.setString(2,request.getParameter("SID"));
                        else
                            pstmt2.setString(2,a);
                        pstmt2.setString(1,request.getParameter("PID")); 
                        pstmt2.setInt(3, Integer.parseInt(request.getParameter("UNIT")));
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
                        "SELECT en.index, en.pid, c.class_dept, c.class_number, en.grade_option, en.unit, en.sid " + 
                         "from  courseEnrollment en, classes c, section s where en.sid = s.section_id " +
                         "AND c.class_year = ? AND c.class_quarter = ? AND s.class_id = c.index order by en.sid::Integer asc;"
                    );

                    st.setString(1,current_year);
                    st.setString(2,current_quarter);
                    ResultSet rs = st.executeQuery();
                    %>

                    <!-- Add an HTML table header row to format the results -->
                    <table border="1">
                        <tr>
                            <th>Enrolled ID</th>
                            <th>Student ID</th>
                            <th>CourseDept</th>
                            <th>CourseNum</th>
                            <th>Grade_option</th>
                            <th>Unit</th>
                            <th>Section_id</th>
                        </tr>
                        <tr>


                            <form action="enrollment.jsp" method="get">
                                <input type="hidden" value="insert" name="action">
                                <th><input value="" name="ID" size = "10"></th>
                                <th><input value="" name="PID" size="10"></th>
                                <th><input value="" name="DEPT" size="10"></th>
                                <th><input value="" name="NUM" size="10"></th>
                                <th><input value="" name="GRADE" size="10"></th>
                                <th><input value="" name="UNIT" size="10"></th>
                                <th><input value="" name="SID" size="10"></th>
                                <th><input type="submit" value="Insert"></th>
                            </form>

                            
                        </tr>

                    <%-- -------- Iteration Code -------- --%>
                    <%
                    // Iterate over the ResultSet

                    while ( rs.next() ) {

                    %>      
                    <tr>
                        <form action="enrollment.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <td>
                                <input value="<%= rs.getInt("index") %>" 
                                name="ID" size="10">
                            </td>
                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("pid") %>" 
                                name="PID" size="10">
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
                            <input value="<%= rs.getString("grade_option") %>"
                                name="GRADE" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("unit") %>"
                                name="UNIT" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("sid") %>"
                                name="SID" size="10">
                            </td>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>

                        <form action="enrollment.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                            value="<%= rs.getString("index") %>" name="ID">
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
