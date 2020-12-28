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
                int type = -1;
                String sid = " ";

                PreparedStatement set = conn.prepareStatement(
                    "select 1"
                );
                ResultSet rs = set.executeQuery();
                ResultSet selec = set.executeQuery();
                boolean setup = false;

                // Begin transaction
                conn.setAutoCommit(false);                  
                PreparedStatement pstmt = conn.prepareStatement(
                    "select s.*, c.class_number, c.class_dept from section s inner join classes c on s.class_id = c.index order by s.index asc"
                );
                // select all classes
                selec = pstmt.executeQuery();
 
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
                    sid = request.getParameter("section_select");
                    
                    PreparedStatement pstmt2 = conn.prepareStatement(
                            "select w.* from weeklyschedule w " +
                            "where w.section_id = ? order by w.index asc"
                    );
                    pstmt2.setString(1,sid);
                    rs = pstmt2.executeQuery();
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%-- -------- INSERT weekly schedule Code -------- --%>
            <%
                    // Check if an insertion is requested
                    if (action != null && action.equals("winsert")) {
                        conn.setAutoCommit(false);
                        PreparedStatement stmt = conn.prepareStatement(
                            "insert into public.weeklyschedule (section_id,sched_type,sched_day,start_time) values (?,?,?,?)");                        

                        PreparedStatement up = conn.prepareStatement (
                            "Update public.weeklyschedule set end_time = start_time + '1 hour' where section_id = ? AND sched_type = ? AND sched_day = ? AND start_time = ?"
                        );

                        stmt.setString(1,request.getParameter("SID"));
                        stmt.setString(2,request.getParameter("type_select"));
                        stmt.setString(3, request.getParameter("DOW"));
                        stmt.setTime(4, Time.valueOf(request.getParameter("START")));

                        up.setString(1,request.getParameter("SID"));
                        up.setString(2,request.getParameter("type_select"));
                        up.setString(3, request.getParameter("DOW"));
                        up.setTime(4, Time.valueOf(request.getParameter("START")));
                        int rowCount = stmt.executeUpdate();
                        up.executeUpdate();
                        
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE weekly schedule  Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement stmt = conn.prepareStatement(
                            "Update public.weeklyschedule set section_id = ?, sched_type = ? , sched_day = ?, start_time = ? where index = ?"
                        );
                        PreparedStatement up = conn.prepareStatement(
                            "Update public.weeklyschedule set end_time = start_time + '1 hour' where index = ?"
                        );
                        stmt.setString(1,request.getParameter("SID"));
                        stmt.setString(2,request.getParameter("TYPE"));
                        stmt.setString(3, request.getParameter("DOW"));
                        stmt.setTime(4, Time.valueOf(request.getParameter("START")));
                        stmt.setInt(5, Integer.parseInt(request.getParameter("ID")));
                        up.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = stmt.executeUpdate();
                        up.executeUpdate();
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE  weekly schedule Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("wdelete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement stmt = conn.prepareStatement(
                            "DELETE FROM weeklyschedule WHERE index = ? ");
                        stmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = stmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>
            <!-- Add an HTML table header row to format the results -->
            <!-- -------------------- HTML SELECT ----------------- -->
            
                <table border="1">
                    <th>Select a Section
                    <form action="section_schedule.jsp" method="POST">
                        <select name="section_select">
                        <% while (selec.next()) { 
                           String att = selec.getString("class_dept") + " " + 
                                        selec.getString("class_number") + " Section: " + selec.getString("section_id") ;%>
                        <option value= "<%= selec.getString("section_id") %>"><%= att %></option>
                        <% } %>
                        </select>
                        <input type="submit" name="action" value="Search">
                    </form></th>


                <table border="1">
                    <tr>
                        <th>Section_id</th>
                        <th>Type</th>
                        <th>DOW</th>
                        <th>Start Time</th>
                    </tr>
                    <tr>
                    <form action="section_schedule.jsp" method="get">
                            <input type="hidden" value="winsert" name="action">
                            <th><input value="<%=sid%>" name="SID" size="10" readonly> </th>
                            <th> <select name="type_select"><option value="LE">LE</option><option value="DI">DI</option><option value="LAB">LAB</option></select> </th>
                            <th><input value="" name="DOW" size="10"></th>
                            <th><input value="" name="START" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                    </form>
                    </tr>

            <%-- -------- Iteration1 Code -------- --%>
            <%
                    while ( rs.next() ) { %>
                    <tr>
                        <form action="section_schedule.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("index") %>" name="ID">
                            <td>
                                <input value="<%= rs.getString("section_id") %>" 
                                    name="SID" size="10" readonly>
                            </td>

                            <td>
                                <input value="<%= rs.getString("sched_type") %>" 
                                    name="TYPE" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("sched_day") %>" 
                                    name="DOW" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("start_time") %>" 
                                    name="START" size="10">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="section_schedule.jsp" method="get">
                            <input type="hidden" value="wdelete" name="action">
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
                    selec.close();
                    rs.close();
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
