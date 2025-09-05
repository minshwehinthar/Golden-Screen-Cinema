<%@ page import="code.dao.OrderDAO" %>
<%@ page import="code.model.Order" %>
<%@ page import="java.util.List" %>

<%
int orderId = Integer.parseInt(request.getParameter("orderId"));
OrderDAO orderDAO = new OrderDAO();
Order order = orderDAO.getOrderById(orderId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Success</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto py-10">
<h1 class="text-4xl font-bold mb-6">Order Placed Successfully!</h1>

<div class="bg-white p-6 rounded-xl shadow max-w-lg mx-auto">
    <h2 class="text-2xl font-semibold mb-4">Order Details</h2>

    <p><strong>Order ID:</strong> <%=order.getId()%></p>
    <p><strong>Theater ID:</strong> <%=order.getTheaterId()%></p>
    <p><strong>Payment:</strong> <%=order.getPaymentMethod()%></p>
    <p><strong>Status:</strong> <%=order.getStatus()%></p>
    <hr class="my-4">
    <h3 class="text-xl font-semibold mb-2">Items:</h3>
    <ul>
    <% for(var item : order.getItems()) { %>
        <li><%=item.getFood().getName()%> x <%=item.getQuantity()%> = $<%=item.getPrice()*item.getQuantity()%></li>
    <% } %>
    </ul>
</div>
</div>
</body>
</html>
