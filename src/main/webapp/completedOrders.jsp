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

    // Pick / Confirm (move completed order to history)
    String confirmId = request.getParameter("confirmId");
    if(confirmId != null && !confirmId.isEmpty()){
        int orderId = Integer.parseInt(confirmId);
        orderDAO.confirmOrder(orderId); // moves to order_history
    }

    // Pagination
    int pageSize = 5;
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;

    List<Order> allCompletedOrders = orderDAO.getCompletedOrders();

    int start = (currentPage - 1) * pageSize;
    int end = Math.min(start + pageSize, allCompletedOrders.size());
    List<Order> completedOrders = allCompletedOrders.subList(start, end);

    int totalPages = (int) Math.ceil(allCompletedOrders.size() * 1.0 / pageSize);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Completed Orders</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
function confirmPick(form){
    if(confirm("Confirm picking this order?")){
        setTimeout(function(){
            form.submit();
        }, 5000);
        return false;
    }
    return false;
}
</script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto py-10">
<h1 class="text-4xl font-bold mb-6">Completed Orders</h1>

<% if(completedOrders.isEmpty()){ %>
    <p class="text-gray-600">No completed orders.</p>
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
    <% for(Order o : completedOrders){
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
                <span class="px-2 py-1 rounded text-xs font-semibold bg-blue-100 text-blue-700">
                    <%= o.getStatus() %>
                </span>
            </td>
            <td class="px-4 py-2">
                <form method="get" onsubmit="return confirmPick(this)" style="display:inline-block">
                    <input type="hidden" name="confirmId" value="<%= o.getId()%>">
                    <button type="submit" class="bg-green-500 text-white px-3 py-1 rounded hover:bg-green-600 text-sm">
                        Pick / Confirm
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
    <a href="completedOrders.jsp?page=<%=i%>" 
       class="px-3 py-1 rounded <%= (i==currentPage) ? "bg-green-600 text-white" : "bg-white border" %>"><%=i%></a>
<% } %>
</div>

<% } %>
</div>
</body>
</html>
