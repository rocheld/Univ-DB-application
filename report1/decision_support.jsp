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
                import="java.util.*" import="java.text.DecimalFormat"%>
    
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

                /* calculate gpa */
                String gpa_quarter = current_quarter;
                String gpa_year = current_year;
                double term_gpa = 0.0;
                double total_gpa = 0.0;
                int term_unit = 0;
                int total_unit = 0;
                Hashtable<String, Double> hash = new Hashtable<String, Double>(); 

                PreparedStatement set = conn.prepareStatement(
                    "select 1"
                );
                ResultSet rs = set.executeQuery();
                ResultSet rs2 = set.executeQuery();
                ResultSet ss = set.executeQuery();
                ResultSet s2 = set.executeQuery();
                ResultSet s3 = set.executeQuery();

                boolean setup = false;

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT * from courses"
                );
                // select all classes
                ss = pstmt.executeQuery();

                PreparedStatement stst = conn.prepareStatement(
                    "Select * from faculty " + 
                    "where faculty_type = 'Professor'"
                );

                PreparedStatement stst2 = conn.prepareStatement (
                    "Select * " +
                     "from quarter_year"
                );
                s2 = stst.executeQuery();
                s3 = stst2.executeQuery();

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
                    PreparedStatement stmt = conn.prepareStatement(
                        "SELECT ct.course_dept, ct.course_number, ct.class_quarter, ct.class_year, ct.faculty_first, count(*)  from class_taught ct " +
                        "where ct.faculty_first = (SELECT f.firstname from faculty f where f.index = ? ) " +
                        "AND   ct.course_dept = (select c.class_dept from classes c where c.index = ? ) " +
                        "AND   ct.course_number =(select c2.class_number from classes c2 where c.index = ?) " +
                        "AND   ct.class_quarter = (select qy.class_quarter from quarter_year where qy.index = ?) " +
                        "AND   ct.class_year = (select qy2.class_year from quater_year qy2 where qy2.index = ?) " 
                    );
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        stmt.setInt(2, Integer.parseInt(request.getParameter("ID")));
                        stmt.setInt(3, Integer.parseInt(request.getParameter("F_ID")));
                        stmt.setInt(4, Integer.parseInt(request.getParameter("Q_ID")));
                        stmt.setInt(5, Integer.parseInt(request.getParameter("Q_ID")));

                        rs = stmt.executeQuery();
                    PreparedStatement pstmt2 = conn.prepareStatement(
                        "SELECT	en.*, c.*, g.number_grade, q.quarter_order FROM student st " +
                        "RIGHT JOIN	courseEnrollment en on st.student_id = en.pid " +
                        "LEFT join classes c on en.class_id = c.index " +
                        "LEFT join grade_conversion g on en.grade_earned = g.letter_grade " + 
                        "LEFT join quarter_order q on c.class_quarter = q.quarter_name " +
                        "WHERE st.student_ssn = ? " +
                        "ORDER BY c.class_year DESC, q.quarter_order DESC"
                    );
                    //pstmt2.setString(1,request.getParameter("value_select"));
                    //rs = pstmt2.executeQuery();

                    PreparedStatement pstmt3 = conn.prepareStatement(
                        "SELECT	c.class_quarter, c.class_year, q.quarter_order FROM student st " +
                        "RIGHT JOIN	courseEnrollment en on st.student_id = en.pid " +
                        "LEFT join classes c on en.class_id = c.index " +
                        "LEFT join grade_conversion g on en.grade_earned = g.letter_grade " + 
                        "LEFT join quarter_order q on c.class_quarter = q.quarter_name " +
                        "WHERE st.student_ssn = ? " +
                        "GROUP BY c.class_quarter, c.class_year, q.quarter_order " + 
                        "ORDER BY c.class_year DESC, q.quarter_order DESC"
                    );

                    pstmt3.setString(1,request.getParameter("value_select"));
                    rs2 = pstmt3.executeQuery();
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    }
            %>

            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
            
                <table border="1">
                    <th>Select a Course
                    <form action="decision_support.jsp" method="POST">
                        <select name="class_id">

                        <% while (ss.next()) { 
                           String att = "ID: " + ss.getString("index") + " " + 
                                        ss.getString("course_dept") + ss.getString("course_number") ;%>
                        <option value= "<%= ss.getString("index") %>"><%= att %></option>
                        <% } %>
                        </select>

                         <select name="F_ID">
                        <% while (s2.next()) { 
                           String att = "ID: " + s2.getString("index") + " " + 
                                        s2.getString("firstname") + s2.getString("lastname") ;%>
                        <option value= "<%= s2.getString("index") %>"><%= att %></option>
                        <% } %>
                        </select>

                         <select name="Q_ID">
                        <% while (s3.next()) { 
                           String att = "ID: " + s3.getString("class_quarter") + " " + 
                                        s3.getString("class_year") ;%>
                        <option value= "<%= s3.getString("index") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form></th>
            
                <table border="1">
                    <tr>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Course Dept</th>
			            <th>Course Number</th>
                        <th>Count </th>
                    </tr>
            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) {

                        /*
                        String this_quarter = rs.getString("class_quarter");
                        String this_year = rs.getString("class_year");
                        String number_grade = rs.getDouble("class_dept");
                        String letter_grade = rs.getString("class_number");
                        String cont = rs.getInt("count");
                        */
            %>
                    <tr>
                            <td>
                                <input value="<%= rs.getString("class_quarter") %>" 
                                    name="Quarter" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_year") %>" 
                                    name="class_year" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_dept") %>"
                                    name="course_dept" size="15" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("class_number") %>" 
                                    name="course_number" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= rs.getInt("count") %>" 
                                    name="Title" size="45" readonly>
                            </td>

                    </tr>
            <%
                }
            %>
            
                <table border="1">
                    <tr>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Term GPA</th>
                    </tr>

            <%-- -------- Iteration2 Code -------- --%>
            <%
                    while ( rs2.next() ) {
                    /* get string from the resultset */
                    String qq = rs2.getString("class_quarter");
                    String yy = rs2.getString("class_year");
                    String rr = qq+yy;
            %>
                    <tr>
                            <td>
                                <input value="<%= qq %>" 
                                    name="class_quarter" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= yy %>" 
                                    name="class_year" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= hash.get(rr) %>"
                                    name="term_gpa" size="15" readonly>
                            </td>
                    </tr>
                    

            <%
               }

               DecimalFormat df2 = new DecimalFormat("#.##");
               if(total_unit == 0) total_gpa = 0.0;
               else total_gpa /= total_unit;
               String cum_gpa = df2.format(total_gpa);
            %>  
                <h3> Cumulatvie GPA: <%= cum_gpa%> </h3>
            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    ss.close();
                    rs.close();
                    rs2.close();
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
