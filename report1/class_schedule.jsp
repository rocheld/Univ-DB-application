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
            <%@ page language="java" import="java.sql.*" import="java.util.*" %>
    
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
                ResultSet rs3 = set.executeQuery();
                ResultSet result = set.executeQuery();
                String student_ssn = "";

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT	distinct st.* " + 
                    "FROM	courseEnrollment e " + 
                    "INNER JOIN section s ON s.section_id = e.sid " +
                    "INNER JOIN classes c ON s.class_id = c.index " +
                    "INNER JOIN student st ON e.pid = st.student_id " +
                    "WHERE	class_quarter = ? " +
                    "AND	class_year = ? "
                );

                pstmt.setString(1,QUARTER);
                pstmt.setString(2, YEAR);

                // resultset of a student
                ResultSet ss = pstmt.executeQuery();
 
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
                        "SELECT	DISTINCT st.*  " + 
                        "FROM	courseEnrollment e " + 
                        "INNER JOIN section s ON s.section_id = e.sid " +
                        "INNER JOIN classes c ON s.class_id = c.index " +
                        "INNER JOIN student st ON e.pid = st.student_id AND st.student_ssn = ? " +
                        "WHERE	class_quarter = ? " +
                        "AND	class_year = ? " 
                    );
                    student_ssn = request.getParameter("st_select");
                    pstmt2.setString(1, student_ssn);
                    pstmt2.setString(2,QUARTER);
                    pstmt2.setString(3,YEAR);
                    
                    rs = pstmt2.executeQuery();

                    PreparedStatement pstmt3 = conn.prepareStatement(
                        "SELECT	c.class_dept, c.class_number, s.section_id, e.sid, e.unit, e.grade_option, c.class_quarter, c.class_year " + 
                        "FROM	courseEnrollment e " + 
                        "INNER JOIN section s ON s.section_id = e.sid " +
                        "INNER JOIN classes c ON s.class_id = c.index " +
                        "INNER JOIN student st ON e.pid = st.student_id AND st.student_ssn = ? " +
                        "WHERE	class_quarter = ? " +
                        "AND	class_year = ? " 
                    );

                    pstmt3.setString(1, request.getParameter("st_select"));
                    pstmt3.setString(2,QUARTER);
                    pstmt3.setString(3,YEAR);

                    rs2 = pstmt3.executeQuery();
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    }
            %>



            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->

                <table border="1">
                    <th>Select a Student
                    <form action="class_schedule.jsp" method="POST">
                        <select name="st_select">
                        <% while (ss.next()) { 
                           String att = "Name:" + ss.getString("first_name") + " " + 
                           ss.getString("last_name") +  "   SSN:" + ss.getString("student_ssn"); %>
                        <option value= "<%= ss.getString("student_ssn") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form>
                
                <table border="1">
                    <tr>
                        <th>PID</th>
                        <th>First Name</th>
                        <th>Last Name</th>
			            <th>Middle Name</th>
                        <th>SSN</th>
                        <th>Residency</th>

            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) {
            %>
                    <tr>
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
                                <input value="<%= rs.getString("student_residency") %>" 
                                    name="Residency" size="15">
                            </td>
                    </tr>
            <%
                }
            %>

                <table border="1">
                    
                    <tr>
                        <th>Class Dept</th>
                        <th>Class Num</th>
                        <th>Section ID</th>
			            <th>Units</th>
                        <th>Grade Option</th>
                        <th>Quarter</th>
                        <th>Year</th>
                    </tr>

            <%-- -------- Iteration2 Code -------- --%>
            <%
                    while ( rs2.next() ) { %>
                    <tr>
                            <td>
                                <input value="<%= rs2.getString("class_dept") %>" 
                                    name="Class Dept" size="10">
                            </td>
    
                            <td>
                                <input value="<%= rs2.getString("class_number") %>" 
                                    name="Class Num" size="10">
                            </td>
    
                            <td>
                                <input value="<%= rs2.getString("sid") %>"
                                    name="Section ID" size="15">
                            </td>
    
                            <td>
                                <input value="<%= rs2.getInt("unit") %>" 
                                    name="Units" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString("grade_option") %>" 
                                    name="Grade" size="15">
                            </td>

                            <td>
                                <input value="<%= rs2.getString("class_quarter") %>" 
                                    name="Quarter" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString("class_year") %>" 
                                    name="Year" size="15">
                            </td>
                    </tr>
            <%
                } %>
                    
                    <table border="1">
                    <tr>
                        <th>Class dept</th>
                        <th>class num</th>
                        <th>Section ID</th>
			            <th>Start_time</th>
                        <th>end_time</th>
                    </tr>
                    <caption> conflict classes </caption>

            <%
                conn.setAutoCommit(false);    
                PreparedStatement pstmt6 = conn.prepareStatement(
                    "create table if not exists sss AS " +
                    "SELECT w.* FROM weeklyschedule w " +
                    "INNER JOIN courseEnrollment e ON e.sid = w.section_id " +
                    "INNER JOIN classes c ON c.index = e.class_id " +
                    "WHERE e.pid = ? "
                );
                pstmt6.setString(1,student_ssn);
                pstmt6.executeUpdate();

            
                PreparedStatement pstmt5 = conn.prepareStatement(
                    "create table if not exists tt as ( " +
                    "select w.* , c.class_dept, c.class_number, c.class_title from weeklyschedule w " +
                    "INNER JOIN section s on w.section_id = s.section_id " +
                    "INNER JOIN classes c on c.index = s.class_id) "
                );
                        
                pstmt5.executeUpdate();
                
                PreparedStatement pstmt7 = conn.prepareStatement(
                    "SELECT tt.class_dept, tt.class_number, tt.section_id, tt.start_time, tt.end_time FROM tt,sss " +
                    "WHERE tt.section_id != sss.section_id " +
                    "AND tt.sched_day = sss.sched_day " +
                    "AND ( SELECT (tt.start_time,tt.end_time) overlaps(sss.start_time, sss.end_time)) " +
                    "Group by tt.class_dept, tt.class_number, tt.section_id, tt.start_time, tt.end_time "
                );

                result = pstmt7.executeQuery();

                PreparedStatement pstmt8 = conn.prepareStatement(
                    "DROP table tt "
                );
                PreparedStatement pstmt9 = conn.prepareStatement(
                    "DROP table sss"
                );

                while(result.next()) { 
                %>
                         <tr>
                            <td>
                                <input value="<%= result.getString("class_dept") %>" 
                                    name="Year" size="15">
                            </td>
                            <td>
                                <input value="<%= result.getString("class_number") %>" 
                                    name="Year" size="15">
                            </td>
                            <td>
                                <input value="<%= result.getString("section_id") %>" 
                                    name="Year" size="15">
                            </td>
                            <td>
                            <input value="<%= result.getTime("start_time") %>" 
                                    name="Year" size="15">
                            </td>
                            <td>
                            <input value="<%= result.getTime("end_time") %>" 
                                    name="Year" size="15">
                            </td>
                        </tr>

                <% }

                    pstmt8.executeUpdate();
                    pstmt9.executeUpdate();
                    conn.commit();
                    conn.setAutoCommit(true);
                    
             %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
                    rs2.close();
                    rs3.close();
                    result.close();
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
