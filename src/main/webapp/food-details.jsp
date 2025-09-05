<%@ page import="code.model.FoodItem, code.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Food Details</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">

<jsp:include page="layout/Header.jsp"/>

<%
    FoodItem food = (FoodItem) request.getAttribute("food");
    User user = (User) session.getAttribute("user");
%>

<% if(food == null){ %>
    <p class="text-red-500 text-center mt-10 text-xl">Food item not found!</p>
<% } else { %>

<div class="max-w-md mx-auto bg-white p-6 rounded-xl shadow-md mt-10">
    <img src="<%=food.getImage()%>" alt="<%=food.getName()%>" class="w-full h-64 object-cover rounded-lg mb-4">
    <h1 class="text-2xl font-bold mb-2"><%=food.getName()%></h1>
    <p class="text-gray-600 font-semibold mb-2">$<%=food.getPrice()%></p>
    <p class="text-gray-700 mb-4"><%=food.getDescription()%></p>

    <% if(user != null){ %>
        <!-- Quantity + Add to Cart -->
        <form action="cart" method="post" class="flex items-center space-x-2">
            <input type="hidden" name="food_id" value="<%=food.getId()%>">
            <input type="number" name="quantity" value="1" min="1"
                   class="border px-2 py-1 rounded w-20 text-center">
            <button type="submit" class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded">
                Add to Cart
            </button>
        </form>
    <% } else { %>
        <p class="text-red-500 mt-4">
            Please <a href="login.jsp" class="text-blue-500 underline">login</a> to add this item to your cart.
        </p>
    <% } %>
</div>

<% } %>

</body>
</html>
