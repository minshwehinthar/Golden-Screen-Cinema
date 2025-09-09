<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="code.model.FoodItem"%>
<%@ page import="code.dao.FoodDAO"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Food Menu</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen font-sans">

  <!-- Header -->
  <jsp:include page="layout/Header.jsp"/>

  <!-- Container -->
  <div class="container mx-auto px-4 py-12">

    <!-- Page Title -->
    <h1 class="text-3xl font-bold text-center text-gray-800 mb-10">🍴 Our Menu</h1>

    <!-- Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8">
      <%
        FoodDAO dao = new FoodDAO();
        List<FoodItem> foods = dao.getAllFoods();
        if (foods != null && !foods.isEmpty()) {
          for (FoodItem f : foods) {
      %>

      <!-- Food Card -->
      <div class="bg-white rounded-xl shadow-sm hover:shadow-md border border-gray-100 overflow-hidden flex flex-col transition duration-300">
        
        <!-- Image -->
        <img src="<%=f.getImage()%>" alt="<%=f.getName()%>" 
             class="w-full h-48 object-cover">

        <!-- Content -->
        <div class="p-4 flex flex-col flex-grow">
          <!-- Food Name -->
          <h2 class="text-lg font-semibold text-gray-800 mb-2 text-center"><%=f.getName()%></h2>

          <!-- Price -->
          <p class="text-green-600 font-bold text-center text-lg mb-2">$<%=f.getPrice()%></p>

          <!-- Rating -->
          <div class="flex justify-center mb-4">
            <%
              int fullStars = (int) f.getRating(); // integer part
              boolean halfStar = (f.getRating() - fullStars) >= 0.5;
              int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

              for(int i=0; i<fullStars; i++) { %>
                <svg class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.974a1 1 0 00.95.69h4.18c.969 0 1.371 1.24.588 1.81l-3.386 2.46a1 1 0 00-.364 1.118l1.286 3.974c.3.921-.755 1.688-1.54 1.118l-3.386-2.46a1 1 0 00-1.176 0l-3.386 2.46c-.784.57-1.838-.197-1.539-1.118l1.285-3.974a1 1 0 00-.364-1.118L2.045 9.4c-.783-.57-.38-1.81.588-1.81h4.18a1 1 0 00.95-.69l1.286-3.974z"/>
                </svg>
            <% } 
              if(halfStar) { %>
                <svg class="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M10 15l-3.09 1.62.59-3.44-2.5-2.44 3.46-.5L10 7l1.54 3.24 3.46.5-2.5 2.44.59 3.44z"/>
                </svg>
            <% } 
              for(int i=0; i<emptyStars; i++) { %>
                <svg class="w-5 h-5 text-gray-300" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.974a1 1 0 00.95.69h4.18c.969 0 1.371 1.24.588 1.81l-3.386 2.46a1 1 0 00-.364 1.118l1.286 3.974c.3.921-.755 1.688-1.54 1.118l-3.386-2.46a1 1 0 00-1.176 0l-3.386 2.46c-.784.57-1.838-.197-1.539-1.118l1.285-3.974a1 1 0 00-.364-1.118L2.045 9.4c-.783-.57-.38-1.81.588-1.81h4.18a1 1 0 00.95-.69l1.286-3.974z"/>
                </svg>
            <% } %>
          </div>

          <!-- Actions -->
          <div class="mt-auto space-y-2">
            <a href="foods?action=details&id=<%=f.getId()%>"
               class="block w-full text-center text-indigo-600 hover:text-indigo-800 font-medium text-sm">
              View Details
            </a>
            <form action="cart" method="post" class="w-full">
              <input type="hidden" name="food_id" value="<%=f.getId()%>">
              <input type="hidden" name="quantity" value="1">
              <button type="submit"
                      class="w-full bg-green-600 hover:bg-green-700 text-white text-sm py-2 rounded-lg transition">
                Add to Cart
              </button>
            </form>
          </div>
        </div>
      </div>

      <%
          }
        } else {
      %>
        <p class="col-span-full text-center text-gray-500 text-lg">No food items found!</p>
      <% } %>
    </div>
  </div>

</body>
</html>
