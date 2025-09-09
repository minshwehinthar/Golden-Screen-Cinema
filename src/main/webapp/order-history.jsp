<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, code.model.OrderHistory, code.model.OrderItemHistory, code.dao.FoodDAO, code.model.FoodItem" %>

<%
    List<OrderHistory> orders = (List<OrderHistory>) request.getAttribute("orders");
    FoodDAO foodDAO = new FoodDAO(); // to fetch food details if needed
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order History</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen font-sans">
<div class="container mx-auto py-10">

    <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">Order History</h1>

    <%
        if (orders == null || orders.isEmpty()) {
    %>
        <div class="bg-white shadow-md rounded-lg p-6 text-center">
            <p class="text-gray-600 text-lg">No completed orders yet.</p>
        </div>
    <%
        } else {
            for (OrderHistory order : orders) {
    %>

    <!-- Order Card -->
    <div class="bg-white shadow-lg rounded-2xl mb-8 overflow-hidden">
        
        <!-- Header -->
        <div class="bg-indigo-600 text-white px-6 py-4 flex justify-between items-center">
            <div>
                <p class="font-semibold">Order #<%= order.getOrderId() %></p>
                <p class="text-sm opacity-80">Completed: <%= order.getCompletedAt() %></p>
            </div>
            <div class="text-right">
                <p class="font-semibold">Total: $<%= order.getTotalAmount() %></p>
                <p class="text-sm">Payment: <%= order.getPaymentMethod() %></p>
            </div>
        </div>

        <!-- User & Theater Info -->
        <div class="px-6 py-4 border-b border-gray-200 grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                <p class="text-gray-700"><span class="font-semibold">User ID:</span> <%= order.getUserId() %></p>
                <p class="text-gray-700"><span class="font-semibold">Theater ID:</span> <%= order.getTheaterId() %></p>
            </div>
        </div>

        <!-- Order Items -->
        <div class="px-6 py-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Items</h3>
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <%
                    for (OrderItemHistory item : order.getItems()) {
                        // Get actual food object if you have FoodDAO
                        FoodItem food = foodDAO.getFoodById(item.getFoodId());
                        String imagePath = (food != null && food.getImage() != null) ? food.getImage() : "images/placeholder.png";
                %>
                <div class="flex bg-gray-50 rounded-lg shadow-sm hover:shadow-md transition p-4">
                    <img src="<%= imagePath %>" alt="<%= food != null ? food.getName() : "Food Image" %>" 
                         class="w-20 h-20 object-cover rounded-lg mr-4">
                    <div class="flex flex-col justify-between">
                        <p class="font-semibold text-gray-800"><%= food != null ? food.getName() : "Food ID " + item.getFoodId() %></p>
                        <p class="text-gray-600">Qty: <%= item.getQuantity() %></p>
                        <p class="text-gray-600">Price: $<%= item.getPrice() %></p>
                        <p class="text-gray-800 font-medium">Subtotal: $<%= item.getQuantity() * item.getPrice() %></p>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

    </div>
    <%  } // end for orders %>
<% } %>

</div>
</body>
</html>
