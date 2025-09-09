<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="code.dao.TheaterDAO"%>
<%@ page import="code.model.Theater"%>

<%
TheaterDAO theaterDAO = new TheaterDAO();
List<Theater> theaters = theaterDAO.getAllTheaters();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Select Theater</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans">

<div class="max-w-6xl mx-auto py-12 px-4">
    <!-- Page Heading -->
    <h1 class="text-4xl font-bold text-center text-gray-800 mb-10">Choose a Theater</h1>

    <!-- Theater Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <% for (Theater t : theaters) { %>
        <a href="reviews.jsp?theaterId=<%=t.getId()%>" 
           class="group bg-white rounded-xl shadow-md hover:shadow-xl transition duration-300 p-6 flex flex-col items-center text-center border border-gray-100">
            <!-- Theater Name -->
            <h2 class="text-xl font-semibold text-gray-900 mb-2 group-hover:text-blue-600 transition duration-300"><%=t.getName()%></h2>

            <!-- Location -->
            <p class="text-gray-500 text-sm mb-2"><%=t.getLocation()%></p>

            <!-- Seats -->
            <p class="text-gray-400 text-sm">Seats: <%=t.getSeatTotal()%></p>

            <!-- Optional Icon -->
            <svg class="w-8 h-8 mt-4 text-blue-400 group-hover:text-blue-600 transition duration-300" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"></path>
            </svg>
        </a>
        <% } %>
    </div>
</div>

</body>
</html>
