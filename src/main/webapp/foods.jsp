<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="code.model.FoodItem"%>
<%@ page import="code.dao.FoodDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Food Menu</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<jsp:include page="layout/Header.jsp"/>

<div class="container mx-auto py-10">
<h1 class="text-4xl font-bold text-center mb-10">Food Menu</h1>
<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
<%
    FoodDAO dao = new FoodDAO();
    List<FoodItem> foods = dao.getAllFoods(); // direct from DAO
    if(foods != null){
        for(FoodItem f: foods){
%>
<div class="bg-white rounded-xl shadow p-4 flex flex-col items-center">
    <img src="<%=f.getImage()%>" alt="<%=f.getName()%>" class="h-40 w-full object-cover rounded-lg mb-2">
    <h2 class="text-xl font-semibold"><%=f.getName()%></h2>
    <p class="text-gray-600 font-bold">$<%=f.getPrice()%></p>
    <a href="foods?action=details&id=<%=f.getId()%>" class="mt-2 bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600">Details</a>
</div>
<%
        }
    } else {
%>
<p>No food items found!</p>
<% } %>
</div>
</div>
</body>
</html>
