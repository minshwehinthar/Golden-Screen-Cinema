<%@ page import="java.util.List" %>
<%@ page import="code.model.CartItem" %>
<%@ page import="code.model.Theater" %>
<%@ page import="code.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    List<Theater> theaters = (List<Theater>) request.getAttribute("theaters");

    if (cartItems == null) cartItems = new java.util.ArrayList<>();
    if (theaters == null) theaters = new java.util.ArrayList<>();

    double totalAmount = cartItems.stream()
                                  .mapToDouble(c -> c.getFood().getPrice() * c.getQuantity())
                                  .sum();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto py-10">
<h1 class="text-4xl font-bold mb-6">Checkout</h1>

<div class="bg-white p-6 rounded-xl shadow max-w-lg mx-auto">
    <h2 class="text-2xl font-semibold mb-4">Order Summary</h2>

    <% if(cartItems.isEmpty()) { %>
        <p class="text-red-500">Your cart is empty.</p>
    <% } else { %>
        <ul class="mb-4">
        <% for(CartItem c : cartItems) { %>
            <li><%=c.getFood().getName()%> x <%=c.getQuantity()%> = $<%=c.getFood().getPrice()*c.getQuantity()%></li>
        <% } %>
        </ul>

        <p class="font-bold mb-4">Total: $<%=totalAmount%></p>

        <form action="checkout" method="post" class="space-y-4">
            <label>Theater:</label>
            <select name="theaterId" class="border px-2 py-1 w-full" required>
            <% for(Theater t : theaters) { %>
                <option value="<%=t.getId()%>"><%=t.getName()%> - <%=t.getLocation()%></option>
            <% } %>
            </select>

            <label>Payment Method:</label>
            <select name="paymentMethod" class="border px-2 py-1 w-full" required>
                <option value="Cash">Cash</option>
                <option value="KPZ">KPZ</option>
                <option value="Wave">Wave</option>
            </select>

            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 w-full">Place Order</button>
        </form>
    <% } %>
</div>
</div>
</body>
</html>
