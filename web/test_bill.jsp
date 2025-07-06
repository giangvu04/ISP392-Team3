<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Bill Functionality</title>
</head>
<body>
    <h1>Test Bill Functionality</h1>
    
    <h2>Test Links:</h2>
    <ul>
        <li><a href="listbills">Test ListBillsServlet (/listbills)</a></li>
        <li><a href="BillServlet?action=list">Test BillServlet (/BillServlet?action=list)</a></li>
        <li><a href="BillServlet?action=add">Test Add Bill Form</a></li>
    </ul>
    
    <h2>Session Info:</h2>
    <p>User: ${user}</p>
    <p>User Role: ${user.roleId}</p>
    <p>User Name: ${user.fullName}</p>
    
    <h2>Current Session Attributes:</h2>
    <%
        java.util.Enumeration<String> sessionAttributes = session.getAttributeNames();
        while (sessionAttributes.hasMoreElements()) {
            String attributeName = sessionAttributes.nextElement();
            Object attributeValue = session.getAttribute(attributeName);
            out.println("<p><strong>" + attributeName + ":</strong> " + attributeValue + "</p>");
        }
    %>
</body>
</html> 