<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="code.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="bg-sky-50 p-2 px-4 border-b border-sky-200 flex justify-between items-center">
    <div>Logo</div>

    <div class="flex items-center gap-5">
        <div class="text-end">
            <h1 class="text-md"><%= user.getName() %></h1>
            <p class="text-sm text-gray-400"><%= user.getEmail() %></p>
        </div>
        <a href="./profile.jsp">
            <img class="w-12 h-12 object-cover rounded-full" 
                 src="<%= (user.getImage() != null ? "uploads/" + user.getImage() : "assets/default-avatar.png") %>" 
                 alt="Profile"/>
        </a>
    </div>
</div>
