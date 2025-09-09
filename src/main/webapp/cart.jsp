<%@ page import="java.util.List"%>
<%@ page import="code.model.CartItem"%>
<%
List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
double totalAmount = (request.getAttribute("totalAmount") != null) 
        ? (Double) request.getAttribute("totalAmount") : 0.0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Cart</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">

<div class="container mx-auto py-12 px-4">
  <h1 class="text-4xl font-bold mb-8 text-center text-gray-800">🛒 My Cart</h1>

  <% if(cartItems == null || cartItems.isEmpty()){ %>
    <p class="text-gray-600 text-center text-lg">Your cart is empty.</p>
  <% } else { %>

  <div class="overflow-x-auto">
    <table class="w-full bg-white rounded-2xl shadow-lg overflow-hidden">
      <thead class="bg-gray-100">
        <tr class="text-left text-gray-700 font-semibold">
          <th class="p-4">Food</th>
          <th class="p-4">Price</th>
          <th class="p-4">Quantity</th>
          <th class="p-4">Total</th>
          <th class="p-4">Action</th>
        </tr>
      </thead>
      <tbody>
        <% for(CartItem c : cartItems) {
            double lineTotal = c.getQuantity() * c.getFood().getPrice();
        %>
        <tr class="border-b hover:bg-gray-50">
          <!-- Food Name -->
          <td class="p-4 font-medium text-gray-800"><%=c.getFood().getName()%></td>

          <!-- Price -->
          <td class="p-4 text-green-600 font-semibold">$<%=c.getFood().getPrice()%></td>

          <!-- Quantity Controls -->
          <td class="p-4">
            <form action="cart" method="get" class="flex items-center gap-2">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="cartId" value="<%=c.getId()%>">

              <!-- Decrease -->
              <button type="submit" name="quantity" value="<%=c.getQuantity()-1%>"
                class="px-3 py-1 bg-gray-200 hover:bg-gray-300 rounded-l-lg">−</button>

              <!-- Quantity Display -->
              <span class="px-4 py-1 bg-white border-t border-b"><%=c.getQuantity()%></span>

              <!-- Increase -->
              <button type="submit" name="quantity" value="<%=c.getQuantity()+1%>"
                class="px-3 py-1 bg-gray-200 hover:bg-gray-300 rounded-r-lg">+</button>
            </form>
          </td>

          <!-- Line Total -->
          <td class="p-4 font-bold text-gray-700">$<%=lineTotal%></td>

          <!-- Remove -->
          <td class="p-4">
            <a href="cart?action=remove&cartId=<%=c.getId()%>"
               class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded transition">
              Remove
            </a>
          </td>
        </tr>
        <% } %>

        <!-- Cart Total -->
        <tr class="bg-gray-100 font-bold text-lg">
          <td colspan="3" class="text-right p-4">Total:</td>
          <td colspan="2" class="p-4 text-green-700">$<%=totalAmount%></td>
        </tr>
      </tbody>
    </table>
  </div>

  <!-- Checkout Button -->
  <div class="text-right mt-6">
    <a href="checkout"
       class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg shadow transition">
      Proceed to Checkout →
    </a>
  </div>

  <% } %>
</div>

</body>
</html>
