<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Food</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    .star {
      font-size: 1.5rem;
      cursor: pointer;
      color: gray;
      transition: color 0.2s;
    }
    .star.selected {
      color: gold;
    }
  </style>
</head>
<body class="bg-gray-100 min-h-screen">

  <div class="container mx-auto py-12 px-4">

    <h1 class="text-4xl font-bold mb-8 text-center text-gray-800">➕ Add New Food</h1>

    <%
      String msg = request.getParameter("msg");
      if ("success".equals(msg)) { %>
        <p class="text-green-600 mb-6 text-center font-semibold">✅ Food added successfully!</p>
    <% } else if ("error".equals(msg)) { %>
        <p class="text-red-600 mb-6 text-center font-semibold">❌ Error adding food. Try again.</p>
    <% } %>

    <form action="add-food" method="post" enctype="multipart/form-data"
          class="bg-white p-8 rounded-2xl shadow-lg max-w-lg mx-auto space-y-6">

      <!-- Name -->
      <div>
        <label class="block font-semibold mb-1">Food Name:</label>
        <input type="text" name="name" class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
      </div>

      <!-- Price -->
      <div>
        <label class="block font-semibold mb-1">Price:</label>
        <input type="number" name="price" step="0.01"
               class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
      </div>

      <!-- Food Type -->
      <div>
        <label class="block font-semibold mb-1">Food Type:</label>
        <select name="food_type" class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
          <option value="snack">Snack</option>
          <option value="drink">Drink</option>
        </select>
      </div>

      <!-- Description -->
      <div>
        <label class="block font-semibold mb-1">Description:</label>
        <textarea name="description" rows="3"
                  class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400"></textarea>
      </div>

      <!-- Rating -->
      <div>
        <label class="block font-semibold mb-1">Rating:</label>
        <input type="hidden" name="rating" id="ratingInput" value="0">
        <div id="starContainer">
          <span class="star" data-value="1">★</span>
          <span class="star" data-value="2">★</span>
          <span class="star" data-value="3">★</span>
          <span class="star" data-value="4">★</span>
          <span class="star" data-value="5">★</span>
        </div>
      </div>

      <!-- Image Upload -->
      <div>
        <label class="block font-semibold mb-1">Upload Image:</label>
        <input type="file" name="image" id="imageInput" accept="image/*"
               class="border px-3 py-2 w-full rounded-lg" required>
      </div>

      <!-- Image Preview -->
      <div class="mt-3">
        <img id="imagePreview" src="#" alt="Image Preview"
             class="hidden w-full h-64 object-cover rounded-lg border shadow-sm">
      </div>

      <!-- Submit Button -->
      <button type="submit"
              class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-3 px-4 rounded-lg transition-colors duration-200">
        Add Food
      </button>
    </form>
  </div>

  <!-- Scripts -->
  <script>
    // Image Preview
    const imageInput = document.getElementById("imageInput");
    const imagePreview = document.getElementById("imagePreview");
    imageInput.addEventListener("change", function () {
      const file = this.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
          imagePreview.setAttribute("src", e.target.result);
          imagePreview.classList.remove("hidden");
        }
        reader.readAsDataURL(file);
      } else {
        imagePreview.setAttribute("src", "#");
        imagePreview.classList.add("hidden");
      }
    });

    // Rating Stars
    const stars = document.querySelectorAll(".star");
    const ratingInput = document.getElementById("ratingInput");

    stars.forEach(star => {
      star.addEventListener("click", () => {
        const rating = star.getAttribute("data-value");
        ratingInput.value = rating;

        stars.forEach(s => {
          if (s.getAttribute("data-value") <= rating) {
            s.classList.add("selected");
          } else {
            s.classList.remove("selected");
          }
        });
      });
    });
  </script>

</body>
</html>
