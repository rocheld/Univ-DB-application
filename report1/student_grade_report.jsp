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
                boolean setup = false;

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT	distinct st.* " + 
                    "FROM	student st " +
                    "RIGHT JOIN courseEnrollment e on e.pid = st.student_id" 
                );
                // select all classes
                ss = pstmt.executeQuery();
 
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
                        "SELECT	en.*, c.*, g.number_grade, q.quarter_order FROM student st " +
                        "RIGHT JOIN	courseEnrollment en on st.student_id = en.pid " +
                        "LEFT join classes c on en.class_id = c.index " +
                        "LEFT join grade_conversion g on en.grade_earned = g.letter_grade " + 
                        "LEFT join quarter_order q on c.class_quarter = q.quarter_name " +
                        "WHERE st.student_ssn = ? " +
                        "ORDER BY c.class_year DESC, q.quarter_order DESC"
                    );
                    pstmt2.setString(1,request.getParameter("value_select"));
                    rs = pstmt2.executeQuery();

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
                    <th>Select a Student
                    <form action="student_grade_report.jsp" method="POST">
                        <select name="value_select">
                        <% while (ss.next()) { 
                           String att = ss.getString("first_name") + " " + 
                                        ss.getString("last_name") + " SSN: " + ss.getString("student_ssn") ;%>
                        <option value= "<%= ss.getString("student_ssn") %>"><%= att %></option>
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
                        <th>Title</th>
                        <th>Unit</th>
                        <th>Grade Earned</th>
                    </tr>
            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) {
                        String this_quarter = rs.getString("class_quarter");
                        String this_year = rs.getString("class_year");
                        int unit = rs.getInt("unit");
                        double number_grade = rs.getDouble("number_grade");
                        String letter_grade = rs.getString("grade_earned");

                        if(!this_quarter.equals(gpa_quarter) || !this_year.equals(gpa_year)) {
                            
                            // handle a case that gpa unit is 0 
                            if(term_unit == 0) term_gpa = 0.0;
                            else term_gpa /= term_unit;
                            
                            Double temp_gpa = new Double(term_gpa);
                            hash.put(gpa_quarter+gpa_year,temp_gpa);

                            term_gpa = 0.0;
                            term_unit = 0;
                            gpa_quarter = this_quarter;
                            gpa_year = this_year;    
                        } 

                        if(letter_grade.charAt(0) != 'I' && letter_grade.charAt(0) != 'S'
                            && letter_grade.charAt(0) != 'U') {
                            double grade_multiply_unit = number_grade * unit;
                            term_gpa += grade_multiply_unit;
                            total_gpa += grade_multiply_unit;
                            total_unit += unit;
                            term_unit += unit;
                        }
                        if(rs.isLast()) {
                            if(term_unit == 0) term_gpa = 0.0;
                            else term_gpa /= term_unit;

                            Double temp_gpa = new Double(term_gpa);
                            hash.put(gpa_quarter+gpa_year,temp_gpa);

                        }
                        
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
                                <input value="<%= rs.getString("class_title") %>" 
                                    name="Title" size="45" readonly>
                            </td>

                            <td>
                                <input value="<%= unit %>" 
                                    name="Title" size="5" readonly>
                            </td>

                            <td>
                                <input value="<%= rs.getString("grade_earned") %>" 
                                    name="Grade" size="15" readonly>
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
