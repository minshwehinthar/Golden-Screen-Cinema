<%@ page import="code.model.FoodItem, code.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Food Details</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen font-sans">

  <!-- Header -->
  <jsp:include page="layout/Header.jsp"/>

  <%
    FoodItem food = (FoodItem) request.getAttribute("food");
    User user = (User) session.getAttribute("user");
  %>

  <% if(food == null){ %>
    <p class="text-red-500 text-center mt-10 text-xl">Food item not found!</p>
  <% } else { %>

  <!-- Container -->
  <div class="max-w-5xl mx-auto bg-white rounded-2xl shadow-md mt-12 flex flex-col md:flex-row">

    <!-- Left Column: Fixed Image -->
    <div class="md:w-1/2 bg-gray-50 flex justify-center items-start p-6 sticky top-24">
      <img src="<%=food.getImage()%>" alt="<%=food.getName()%>" class="h-[400px] w-full object-contain rounded-xl">
    </div>

    <!-- Right Column: Details -->
    <div class="md:w-1/2 p-6 flex flex-col justify-between space-y-6">

      <!-- Food Info -->
      <div class="space-y-3">
        <span class="inline-block text-xs px-2 py-1 bg-green-100 text-green-700 rounded-full">
          <%=food.getFoodType()%>
        </span>

        <h1 class="text-3xl font-bold text-gray-800"><%=food.getName()%></h1>

        <p class="text-yellow-500">
          Rating: <%=food.getRating()%> &#9733;
        </p>

        <p class="text-green-600 font-bold text-2xl">$<%=food.getPrice()%></p>
      </div>

      <!-- FAQ-style Sections -->
      <div class="space-y-2">

        <!-- Description -->
        <div class="border rounded-lg">
          <button type="button" class="w-full flex justify-between items-center p-4 font-medium text-left"
                  onclick="toggleFAQ('desc')">
            Description
            <span id="desc-icon">+</span>
          </button>
          <div id="desc" class="px-4 pb-4 hidden text-gray-600">
            <%=food.getDescription()%>
          </div>
        </div>

        <!-- Shipping Info -->
        <div class="border rounded-lg">
          <button type="button" class="w-full flex justify-between items-center p-4 font-medium text-left"
                  onclick="toggleFAQ('shipping')">
            Shipping Info
            <span id="shipping-icon">+</span>
          </button>
          <div id="shipping" class="px-4 pb-4 hidden text-gray-600">
            Free shipping on orders over $50. Delivered within 3-5 business days.
          </div>
        </div>
      </div>

      <!-- Quantity + Add to Cart -->
      <form action="cart" method="post" class="flex items-center gap-4 mt-4" onsubmit="return checkLogin();">
        <input type="hidden" name="food_id" value="<%=food.getId()%>">
        <input type="hidden" name="quantity" id="qtyInput" value="1">

        <!-- Modern Quantity Selector -->
        <div class="flex items-center border rounded-lg overflow-hidden">
          <button type="button" onclick="updateQty(-1)" 
                  class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-lg font-bold">-</button>
          <span id="qtyDisplay" class="w-12 text-center text-lg font-medium">1</span>
          <button type="button" onclick="updateQty(1)" 
                  class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-lg font-bold">+</button>
        </div>

        <button type="submit" 
                class="flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-2 rounded-lg transition">
          Add to Cart
        </button>
      </form>

    </div>
  </div>

  <script>
    let quantity = 1;
    const qtyDisplay = document.getElementById('qtyDisplay');
    const qtyInput = document.getElementById('qtyInput');

    function updateQty(change) {
      quantity = Math.max(1, quantity + change);
      qtyDisplay.textContent = quantity;
      qtyInput.value = quantity;
    }

    function checkLogin() {
      const isLoggedIn = <%= (user != null) ? "true" : "false" %>;
      if (!isLoggedIn) {
        alert("Please login to add items to your cart.");
        window.location.href = "login.jsp";
        return false;
      }
      qtyInput.value = quantity; // update hidden input
      return true;
    }

    function toggleFAQ(id) {
      const content = document.getElementById(id);
      const icon = document.getElementById(id + '-icon');
      content.classList.toggle('hidden');
      icon.textContent = content.classList.contains('hidden') ? '+' : '-';
    }
  </script>

  <% } %>
</body>
</html>
