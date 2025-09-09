<%@ page import="java.util.List" %>
<%@ page import="code.dao.OrderDAO" %>
<%@ page import="code.dao.UserDAO" %>
<%@ page import="code.dao.TheaterDAO" %>
<%@ page import="code.model.Order" %>
<%@ page import="code.model.OrderItem" %>
<%@ page import="code.model.User" %>
<%@ page import="code.model.Theater" %>

<%
    OrderDAO orderDAO = new OrderDAO();
    UserDAO userDAO = new UserDAO();
    TheaterDAO theaterDAO = new TheaterDAO();

    // Mark order as Completed
    String completeId = request.getParameter("completeId");
    if(completeId != null && !completeId.isEmpty()){
        int orderId = Integer.parseInt(completeId);
        orderDAO.completeOrder(orderId); // updates status to completed
    }

    // Pagination
    int pageSize = 5;
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;

    List<Order> allPendingOrders = orderDAO.getPendingOrders();

    int start = (currentPage - 1) * pageSize;
    int end = Math.min(start + pageSize, allPendingOrders.size());
    List<Order> pendingOrders = allPendingOrders.subList(start, end);

    int totalPages = (int) Math.ceil(allPendingOrders.size() * 1.0 / pageSize);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pending Orders</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto py-10">
<h1 class="text-4xl font-bold mb-6">Pending Orders</h1>

<% if(pendingOrders.isEmpty()){ %>
    <p class="text-gray-600">No pending orders.</p>
<% } else { %>
<table class="w-full bg-white rounded-xl shadow mb-6">
    <thead>
        <tr class="text-left border-b bg-gray-100">
            <th class="px-4 py-2">Order ID</th>
            <th class="px-4 py-2">Customer</th>
            <th class="px-4 py-2">Theater</th>
            <th class="px-4 py-2">Items</th>
            <th class="px-4 py-2">Total</th>
            <th class="px-4 py-2">Status</th>
            <th class="px-4 py-2">Action</th>
        </tr>
    </thead>
    <tbody>
    <% for(Order o : pendingOrders){
        User user = userDAO.getUserById(o.getUserId());
        Theater theater = theaterDAO.getTheaterById(o.getTheaterId());
    %>
        <tr class="border-b hover:bg-gray-50">
            <td class="px-4 py-2"><%= o.getId() %></td>
            <td class="px-4 py-2">
                <p class="font-semibold"><%=user.getName()%></p>
                <p class="text-sm text-gray-600"><%=user.getEmail()%></p>
                <p class="text-sm text-gray-600"><%=user.getPhone()%></p>
            </td>
            <td class="px-4 py-2">
                <p class="font-semibold"><%=theater.getName()%></p>
                <p class="text-sm text-gray-600"><%=theater.getLocation()%></p>
            </td>
            <td class="px-4 py-2">
                <ul class="space-y-1">
                <% for(OrderItem item : o.getItems()){ %>
                    <li class="flex items-center">
                        <img src="<%=item.getFood().getImage()%>" 
                             alt="<%=item.getFood().getName()%>" 
                             class="w-10 h-10 rounded mr-2">
                        <span><%=item.getFood().getName()%> x <%=item.getQuantity()%></span>
                    </li>
                <% } %>
                </ul>
            </td>
            <td class="px-4 py-2 font-semibold text-green-600">$<%= o.getTotalAmount() %></td>
            <td class="px-4 py-2">
                <span class="px-2 py-1 rounded text-xs font-semibold bg-yellow-100 text-yellow-700">
                    <%= o.getStatus() %>
                </span>
            </td>
            <td class="px-4 py-2">
                <form method="get" style="display:inline-block">
                    <input type="hidden" name="completeId" value="<%= o.getId() %>">
                    <button type="submit" class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 text-sm">
                        Completed
                    </button>
                </form>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>

<!-- Pagination -->
<div class="flex justify-center space-x-2">
<% for(int i=1; i<=totalPages; i++){ %>
    <a href="pendingOrders.jsp?page=<%=i%>" 
       class="px-3 py-1 rounded <%= (i==currentPage) ? "bg-blue-600 text-white" : "bg-white border" %>"><%=i%></a>
<% } %>
</div>

<% } %>
</div>
</body>
</html>
