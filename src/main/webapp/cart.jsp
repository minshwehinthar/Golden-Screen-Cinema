<%@ page import="java.util.List"%>
<%@ page import="code.model.CartItem"%>
<%
List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
double totalAmount = (request.getAttribute("totalAmount") != null) 
        ? (Double) request.getAttribute("totalAmount") : 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Cart</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen font-sans">

<div class="max-w-6xl mx-auto py-12 px-4">

  <h1 class="text-4xl font-extrabold mb-10 text-center text-gray-900">🛒 My Cart</h1>

  <% if(cartItems == null || cartItems.isEmpty()){ %>
    <p class="text-gray-500 text-center text-lg">Your cart is empty.</p>
  <% } else { %>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

    <!-- Cart Items List -->
    <div class="lg:col-span-2 space-y-6">
      <% for(CartItem c : cartItems) {
          double lineTotal = c.getQuantity() * c.getFood().getPrice();
      %>
      <div class="bg-white p-6 rounded-3xl shadow-md flex flex-col sm:flex-row items-center justify-between hover:shadow-xl transition duration-300">

        <!-- Food Info -->
        <div class="flex items-center gap-4 w-full sm:w-2/3">
          <img src="<%=c.getFood().getImage()%>" alt="<%=c.getFood().getName()%>" 
               class="w-28 h-28 object-cover rounded-2xl shadow-sm">
          <div>
            <h2 class="text-xl font-semibold text-gray-900"><%=c.getFood().getName()%></h2>
            <p class="text-green-600 font-bold mt-1 text-lg">$<%=c.getFood().getPrice()%></p>
          </div>
        </div>

        <!-- Quantity Controls -->
        <div class="flex items-center gap-2 mt-4 sm:mt-0">
          <form action="cart" method="get" class="flex items-center gap-1">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="cartId" value="<%=c.getId()%>">
            <button type="submit" name="quantity" value="<%=c.getQuantity()-1%>" 
                    class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-lg transition duration-200 font-semibold text-lg">−</button>
            <span class="px-5 py-2 border bg-gray-50 rounded-lg font-medium text-lg"><%=c.getQuantity()%></span>
            <button type="submit" name="quantity" value="<%=c.getQuantity()+1%>" 
                    class="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-lg transition duration-200 font-semibold text-lg">+</button>
          </form>
        </div>

        <!-- Total & Remove -->
        <div class="flex flex-col items-end gap-2 mt-4 sm:mt-0">
          <p class="font-bold text-gray-900 text-lg">$<%=lineTotal%></p>
          <a href="cart?action=remove&cartId=<%=c.getId()%>" 
             class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-2xl shadow transition duration-200 font-medium text-sm">
            Remove
          </a>
        </div>

      </div>
      <% } %>
    </div>

    <!-- Checkout Summary -->
    <div class="bg-white p-6 rounded-3xl shadow-md h-fit sticky top-24">
      <h2 class="text-2xl font-bold text-gray-900 mb-6 border-b pb-4">Order Summary</h2>
      <div class="flex justify-between text-gray-700 mb-4">
        <span class="font-medium">Items:</span>
        <span class="font-semibold"><%=cartItems.size()%></span>
      </div>
      <div class="flex justify-between text-gray-700 mb-6">
        <span class="font-medium">Total Amount:</span>
        <span class="font-bold text-green-600 text-xl">$<%=totalAmount%></span>
      </div>
      <a href="checkout" 
         class="block w-full text-center bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-2xl shadow-lg font-semibold transition duration-200">
        Proceed to Checkout →
      </a>
    </div>

  </div>

  <% } %>
</div>

</body>
</html>
