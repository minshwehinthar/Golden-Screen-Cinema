<%@ page import="code.dao.OrderDAO" %>
<%@ page import="code.dao.UserDAO" %>
<%@ page import="code.dao.TheaterDAO" %>
<%@ page import="code.model.Order" %>
<%@ page import="code.model.OrderItem" %>
<%@ page import="code.model.User" %>
<%@ page import="code.model.Theater" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    int orderId = Integer.parseInt(request.getParameter("orderId"));

    OrderDAO orderDAO = new OrderDAO();
    UserDAO userDAO = new UserDAO();
    TheaterDAO theaterDAO = new TheaterDAO();

    // Get order from DB
    Order order = orderDAO.getOrderById(orderId);

    // Get user info
    User user = userDAO.getUserById(order.getUserId());

    // Get theater info
    Theater theater = theaterDAO.getTheaterById(order.getTheaterId());

    // Format date/time
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String orderDateTime = sdf.format(order.getCreatedAt());
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Order Success</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 py-10">

<div class="max-w-3xl mx-auto">

    <h1 class="text-3xl font-bold text-center mb-8 text-gray-800">Order Placed Successfully!</h1>

    <div class="bg-white rounded-xl p-6 border border-gray-200">

        <!-- Status & Order Info -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <p class="font-semibold text-gray-700">Order ID: <span class="text-gray-900"><%=order.getId()%></span></p>
                <p class="text-gray-500 text-sm">Placed: <%=orderDateTime%></p>
            </div>
            <div>
                <span class="px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                    <%=order.getStatus()%>
                </span>
            </div>
        </div>

        <!-- User Info & Theater Info side by side -->
        <div class="flex justify-between mb-6">
            <!-- User Info -->
            <div class="w-1/2 pr-4">
                <h3 class="font-semibold text-gray-700 mb-2">Customer Info</h3>
                <p><strong>Name:</strong> <%=user.getName()%></p>
                <p><strong>Email:</strong> <%=user.getEmail()%></p>
                <p><strong>Phone:</strong> <%=user.getPhone()%></p>
            </div>

            <!-- Theater Info -->
            <div class="w-1/2 pl-4">
                <h3 class="font-semibold text-gray-700 mb-2">Theater Info</h3>
                <p><strong>Name:</strong> <%=theater.getName()%></p>
                <p><strong>Location:</strong> <%=theater.getLocation()%></p>
            </div>
        </div>

        <!-- Items List -->
        <div class="mb-6">
            <h3 class="font-semibold text-gray-700 mb-3">Items</h3>
            <ul class="space-y-2">
            <% for(OrderItem item : order.getItems()) { %>
                <li class="flex justify-between items-center border-b border-gray-200 pb-2">
                    <div class="flex items-center space-x-3">
                        <img src="<%=item.getFood().getImage()%>" alt="<%=item.getFood().getName()%>" class="w-12 h-12 rounded">
                        <span><%=item.getFood().getName()%> x <%=item.getQuantity()%></span>
                    </div>
                    <span class="font-semibold">$<%=item.getPrice() * item.getQuantity()%></span>
                </li>
            <% } %>
            </ul>
        </div>

        <!-- Payment & Total -->
        <div class="flex justify-between items-center border-t border-gray-200 pt-4">
            <p><strong>Payment:</strong> <%=order.getPaymentMethod()%></p>
            <p class="text-lg font-bold">$<%=order.getTotalAmount()%></p>
        </div>

    </div>
</div>

</body>
</html>
