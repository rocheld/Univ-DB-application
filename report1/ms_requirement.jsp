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
            <%
                // Variable daclaration
                final String QUARTER = "sp";
                final String YEAR = "2020";
                String st_ssn = "2";
                PreparedStatement set = conn.prepareStatement(
                    "select 1"
                );
                ResultSet rs = set.executeQuery();
                ResultSet rs2 = set.executeQuery();
                ResultSet ss = set.executeQuery();
                ResultSet dd = set.executeQuery();


                // find undergrad student
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT st.* " +
                    "FROM student st " +
                    "INNER JOIN MS m ON m.pid = st.student_id " +
                    "AND m.degree_name = 'Computer Science' " +
                    "AND m.degree_type = 'M.S' " +
                    "WHERE EXISTS ( SELECT DISTINCT en.pid " +
                    "FROM courseEnrollment en " +
                    "WHERE en.pid = st.student_id " +
                    "AND en.sid IS NOT NULL) "
                );
                // select all classes
                ss = pstmt.executeQuery();
                

                PreparedStatement degree_pstmt = conn.prepareStatement(
                    "SELECT	d.* " + 
                    "FROM	degree d " + 
                    "WHERE  d.degree_type = 'M.S' "
                );

                dd = degree_pstmt.executeQuery();

                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
            %>
                    
            <%-- -------- SEARCH student and degree -------- --%>
            <%
                String action = request.getParameter("action");
                /* search student */
                if (action != null && action.equals("search")) {
                    conn.setAutoCommit(false);                  
                    PreparedStatement pstmt2 = conn.prepareStatement(
                        "SELECT     st.*, m.* " + 
                        "FROM       student st " +
                        "INNER JOIN MS m ON st.student_id = m.pid " +
                        "where st.student_ssn = ? "
                    );
                    st_ssn = request.getParameter("value_student");
                    pstmt2.setString(1,st_ssn);
                    rs = pstmt2.executeQuery();

                    /* search degree */
                    PreparedStatement pstmt3 = conn.prepareStatement(
                        "SELECT     d.* " + 
                        "FROM       degree d " +
                        "WHERE      d.degree_name = 'Computer Science' " + 
                        "AND        d.degree_type = ?"
                    );
                    pstmt3.setString(1,request.getParameter("value_degree"));
                    rs2 = pstmt3.executeQuery();
                    conn.commit();
                    conn.setAutoCommit(true);
                    }
            %>


            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
            
                <table border="1">
                    <th>Select
                    <form action="ms_requirement.jsp" method="POST">
                        <select name="value_student">
                        <% while (ss.next()) { 
                           String att = ss.getString("first_name") + " " + 
                                        ss.getString("last_name") + " SSN: " + ss.getString("student_ssn");%>
                        <option value= "<%= ss.getString("student_ssn") %>"><%= att %></option>
                        <% } %>
                        </select>

                        <select name="value_degree">
                        <% while (dd.next()) { 
                           String att = dd.getString("degree_type") + " IN " + dd.getString("degree_name");%>
                        <option value= "<%= dd.getString("degree_type") %>"><%= att %></option>
                        <% } %>
                        </select>
                        
                        <input type="submit" name="action" value="search">
                        
                    </form></th>

                    <table border="1">
                    <tr>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Middle Name</th>
			            <th>SSN</th>
                    </tr>
 
           <%-- -------- Iteration1 Code -------- --%>
            

            <%
                    while ( rs.next() ) {
            %>
                    <tr>
                            <td>
                                <input value="<%= rs.getString("first_name") %>" 
                                    name="first_name" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("last_name") %>" 
                                    name="last_name" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("middle_name") %>"
                                    name="middle_name" size="15" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getString("student_ssn") %>" 
                                    name="SSN" size="15" readonly>
                            </td>
                    </tr>
            <%
                }//}
            %>
            
                <table border="1">
                    <tr>
                        <th>Total Units</th>
                        <th>Lower Divison Unit</th>
                        <th>Upper Division Units</th>
                        <th>Tech Elective</th>
                        <th>Grad Units</th>
                    </tr>


            <%-- -------- Iteration2 Code -------- --%>
            <%
                    // Iterate over the ResultSet
                    /*
                     total_unit | lower_unit | upper_unit | tech_unit | grad_unit 
                     */
                    while ( rs2.next() ) {

                        int total = rs2.getInt("total_unit");
                        int lower = rs2.getInt("lower_unit");
                        int upper = rs2.getInt("upper_unit");
                        int tech = rs2.getInt("tech_unit");
                        int grad = rs2.getInt("grad_unit");
            %>
                    <tr>
                            <td>
                                <input value="<%= total %>" 
                                    name="total_unit" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= lower %>" 
                                    name="lower_unit" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= upper %>"
                                    name="upper_unit" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= tech %>"
                                    name="tech_unit" size="15" readonly>
                            </td>
                            <td>
                                <input value="<%= grad %>" 
                                    name="grad_unit" size="15" readonly>
                            </td>
                    </tr>

                 <table border="1">
                    <tr>
                        <th>Total Units Needs</th>
                        <th>Lower Divison Unit Needs</th>
                        <th>Upper Division Units Needs</th>
                        <th>Tech Elective Needs</th>
                        <th>Grad Units Needs</th>
                    </tr>                   
            <%      

                    conn.setAutoCommit(false); 
                    PreparedStatement stmt1 = conn.prepareStatement(
                            "CREATE TABLE if NOT EXISTS degree_audit AS " +
                            "(SELECT c.class_dept, c.class_number, en.grade_earned, en.unit, cc.category " +
                            "FROM courseEnrollment en " +
                            "INNER JOIN classes c ON en.class_id = c.index " +
                            "INNER JOIN courseCategory cc ON cc.course_dept = c.class_dept " +
                            "AND cc.course_number = c.class_number " +
                            "WHERE en.pid = ?)"
                        );
                        stmt1.setString(1,request.getParameter("value_student"));
                        stmt1.executeUpdate();         
                    /* total */
                    PreparedStatement stmt2 = conn.prepareStatement(
                            "SELECT sum(unit) as total_unit from degree_audit"
                    );
                    /* lower */
                    PreparedStatement stmt3 = conn.prepareStatement(
                            "Select sum(unit) as lower_unit from degree_audit "+
                            "where category = 'lower' "
                    );
                    /* upper */
                    PreparedStatement stmt4 = conn.prepareStatement(
                            "Select sum(unit) as upper_unit from degree_audit "+
                            "where class_dept = 'CSE' AND category = 'upper' "
                    );
                    /*  elective */
                    PreparedStatement stmt5 = conn.prepareStatement(
                            "Select sum(unit) as tech_unit from degree_audit d "+
                            "inner join technical_elective t on t.elec_dept = d.class_dept " +
                            "AND t.elec_number = d.class_number " 
                    );

                    PreparedStatement stmt6 = conn.prepareStatement(
                            "Select sum(unit) as grad_unit from degree_audit "+
                            "where class_dept = 'CSE' AND category = 'grad' "
                    );
                    
                    int taken;
                    ResultSet temp = stmt2.executeQuery();
                    if( temp.next()) {
                        taken = total - temp.getInt("total_unit") ;
                        if(taken < 0) taken = 0;
                        %>
                         <tr>
                            <td>
                                <input value="<%= taken %>" 
                                    name="total_unit" size="10" readonly>
                            </td>
                    <% }
                    temp = stmt3.executeQuery();
                    if( temp.next()) {
                        taken = lower - temp.getInt("lower_unit");
                        if(taken < 0) taken = 0;
                    %>
                            <td>
                                <input value="<%= taken %>" 
                                    name="total_unit" size="10" readonly>
                            </td>
                    <% }
                    temp = stmt4.executeQuery();
                    if( temp.next()) {
                        taken = upper - temp.getInt("upper_unit");
                        if(taken < 0) taken = 0;
                    %>
                            <td>
                                <input value="<%= taken %>" 
                                    name="total_unit" size="10" readonly>
                            </td>
                    <% }
                    temp = stmt5.executeQuery();
                    if(temp.next()) {
                        taken = tech - temp.getInt("tech_unit");
                        if(taken < 0) taken = 0;
                    %>
                            <td>
                                <input value="<%= taken %>" 
                                    name="total_unit" size="10" readonly>
                            </td>
                    <% }

                    temp = stmt6.executeQuery();
                    if(temp.next()) {
                        taken = grad - temp.getInt("grad_unit");
                        if(taken < 0) taken = 0;
                    %>
                            <td>
                                <input value="<%= taken %>" 
                                    name="total_unit" size="10" readonly>
                            </td>
                        </tr>
                    <% }
                    %>
                    <tr>
                        <th>
                            Completed Concentration
                        </th>
                    </tr>
                    <%
                    PreparedStatement completed_concentration = conn.prepareStatement (
                        "SELECT * FROM concentration c1 " +
                        "WHERE ( SELECT c2.c_name FROM concentration c2 " +
                                "WHERE NOT EXISTS ( SELECT * FROM concentration_course co " +
                                                   "WHERE c2.c_name = co.cname " +
                                                   "AND NOT EXISTS ( SELECT * FROM degree_audit d2 " +
                                                                    "WHERE co.course_dept = d2.class_dept " +
                                                                    "AND co.course_number = d2.class_number " +
                                                                    "AND d2.grade_earned NOT IN ('IN', 'D', 'F', 'U')))) = c1.c_name " +
                        "AND c1.min_gpa <= ( SELECT completed_con.gpa " +
                        "FROM (SELECT sum(unit * number_grade) / sum(unit) AS gpa FROM degree_audit d1 " +
                        "INNER JOIN grade_conversion g ON g.letter_grade = d1.grade_earned " +
                        "INNER JOIN concentration_course co2 ON co2.course_dept = d1.class_dept " +
                        "AND co2.course_number = d1.class_number " +
                        "INNER JOIN concentration c3 ON co2.cname = c3.c_name) AS completed_con) "
                    );

                    ResultSet compl_conc = completed_concentration.executeQuery();

                    while(compl_conc.next()) { %>
                        <tr>
                            <td>
                                <input value="<%= compl_conc.getString("c_name") %>" 
                                    name="conc" size="10" readonly>
                            </td>
                        </tr>
                    <%}
                    PreparedStatement stmt7 = conn.prepareStatement(
                        "drop table degree_audit"
                    );
                    stmt7.executeUpdate();
                    
                    conn.commit();
                    conn.setAutoCommit(true);
                    temp.close();
               }
            %>
            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    ss.close();
                    rs.close();
                    rs2.close();
                    dd.close();
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
