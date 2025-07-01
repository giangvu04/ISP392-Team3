<%@ page contentType="text/html;charset=UTF-8" %>
<% 
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    
    if (message != null && messageType != null) {
%>
<div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
    <%= message %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
        // Clear the message after displaying
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>
