<%@ page import="java.util.List" %>
<%@ page import="code.dao.OrderDAO" %>
<%@ page import="code.model.Order" %>
<%
    // Initialize DAO
    OrderDAO orderDAO = new OrderDAO();

    // Confirm order if admin clicked "Pick"
    String confirmId = request.getParameter("confirmId");
    if(confirmId != null && !confirmId.isEmpty()) {
        int orderId = Integer.parseInt(confirmId);
        orderDAO.confirmOrder(orderId); // sets status = 'completed'
    }

    // Get updated lists
    List<Order> pendingOrders = orderDAO.getPendingOrders(); // status='pending' or 'picked' as needed
    List<Order> completedOrders = orderDAO.getCompletedOrders(); // status='completed'
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Orders Panel</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto py-10">

<h1 class="text-4xl font-bold mb-6">Admin Orders Panel</h1>

<!-- Pending Orders -->
<h2 class="text-2xl font-semibold mb-4">Pending Orders</h2>
<% if(pendingOrders.isEmpty()){ %>
    <p>No pending orders.</p>
<% } else { %>
<table class="w-full bg-white rounded-xl shadow p-4 mb-10">
    <thead>
        <tr class="text-left border-b">
            <th>Order ID</th>
            <th>User ID</th>
            <th>Total</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
    <% for(Order o : pendingOrders) { %>
        <tr class="border-b">
            <td><%= o.getId() %></td>
            <td><%= o.getUserId() %></td>
            <td>$<%= o.getTotalAmount() %></td>
            <td><%= o.getStatus() %></td>
            <td>
                <form method="get">
                    <input type="hidden" name="confirmId" value="<%= o.getId() %>">
                    <button type="submit" class="bg-green-500 text-white px-2 py-1 rounded hover:bg-green-600">
                        Pick / Confirm
                    </button>
                </form>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>
<% } %>

<!-- Completed Orders / History -->
<h2 class="text-2xl font-semibold mb-4">Order History</h2>
<% if(completedOrders.isEmpty()){ %>
    <p>No completed orders.</p>
<% } else { %>
<table class="w-full bg-white rounded-xl shadow p-4">
    <thead>
        <tr class="text-left border-b">
            <th>Order ID</th>
            <th>User ID</th>
            <th>Total</th>
            <th>Status</th>
            <th>Confirmed</th>
        </tr>
    </thead>
    <tbody>
    <% for(Order o : completedOrders) { %>
        <tr class="border-b">
            <td><%= o.getId() %></td>
            <td><%= o.getUserId() %></td>
            <td>$<%= o.getTotalAmount() %></td>
            <td><%= o.getStatus() %></td>
            <td>Yes</td>
        </tr>
    <% } %>
    </tbody>
</table>
<% } %>

</div>
</body>
</html>
