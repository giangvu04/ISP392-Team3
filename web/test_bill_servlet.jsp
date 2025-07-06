<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Bill Servlet</title>
</head>
<body>
    <h1>Test Bill Servlet</h1>
    
    <h2>Test Links:</h2>
    <ul>
        <li><a href="BillServlet?action=list">List Bills</a></li>
        <li><a href="BillServlet?action=add">Add Bill Form</a></li>
        <li><a href="BillServlet?action=getTenants">Get Tenants (JSON)</a></li>
        <li><a href="BillServlet?action=getRooms">Get Rooms (JSON)</a></li>
    </ul>
    
    <h2>Test Form:</h2>
    <form action="BillServlet" method="POST">
        <input type="hidden" name="action" value="create">
        
        <p>
            <label>Tenant Name:</label>
            <input type="text" name="tenantName" value="Test Tenant" required>
        </p>
        
        <p>
            <label>Room Number:</label>
            <input type="text" name="roomNumber" value="A101" required>
        </p>
        
        <p>
            <label>Electricity Cost:</label>
            <input type="number" name="electricityCost" value="100000" required>
        </p>
        
        <p>
            <label>Water Cost:</label>
            <input type="number" name="waterCost" value="50000" required>
        </p>
        
        <p>
            <label>Service Cost:</label>
            <input type="number" name="serviceCost" value="100000" required>
        </p>
        
        <p>
            <label>Due Date:</label>
            <input type="date" name="dueDate" value="2024-12-31" required>
        </p>
        
        <p>
            <label>Status:</label>
            <select name="status" required>
                <option value="Unpaid">Unpaid</option>
                <option value="Paid">Paid</option>
                <option value="Pending">Pending</option>
            </select>
        </p>
        
        <button type="submit">Create Bill</button>
    </form>
    
    <h2>Debug Info:</h2>
    <p>Current time: <%= new java.util.Date() %></p>
    <p>Context path: <%= request.getContextPath() %></p>
    <p>Request URI: <%= request.getRequestURI() %></p>
    <p>Servlet path: <%= request.getServletPath() %></p>
</body>
</html> 