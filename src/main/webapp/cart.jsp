<%@ page import="java.util.List"%>
<%@ page import="code.model.CartItem"%>
<%
List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Cart</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto py-10">
<h1 class="text-4xl font-bold mb-6">My Cart</h1>
<% if(cartItems.isEmpty()){ %>
<p class="text-gray-600">Your cart is empty.</p>
<% } else { %>
<table class="w-full bg-white rounded-xl shadow p-4">
<thead>
<tr class="text-left border-b">
<th>Food</th><th>Price</th><th>Quantity</th><th>Total</th><th>Action</th>
</tr>
</thead>
<tbody>
<%
double totalAmount = 0;
for(CartItem c : cartItems) {
double lineTotal = c.getQuantity() * c.getFood().getPrice();
totalAmount += lineTotal;
%>
<tr class="border-b">
<td><%=c.getFood().getName()%></td>
<td>$<%=c.getFood().getPrice()%></td>
<td>
<form action="cart?action=update" method="get">
<input type="hidden" name="cartId" value="<%=c.getId()%>">
<input type="number" name="quantity" value="<%=c.getQuantity()%>" min="1" class="border px-2 py-1 w-16 inline">
<button type="submit" class="bg-green-500 text-white px-2 rounded">Update</button>
</form>
</td>
<td>$<%=lineTotal%></td>
<td>
<a href="cart?action=remove&cartId=<%=c.getId()%>" class="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Remove</a>
</td>
</tr>
<% } %>
<tr>
<td colspan="3" class="text-right font-bold">Total:</td>
<td colspan="2" class="font-bold">$<%=totalAmount%></td>
</tr>
</tbody>
</table>
<a href="checkout" class="mt-4 inline-block bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Proceed to Checkout</a>
<% } %>
</div>
</body>
</html>
