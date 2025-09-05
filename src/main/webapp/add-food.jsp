<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Add Food</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

<div class="container mx-auto py-10">
  <h1 class="text-4xl font-bold mb-6 text-center">Add New Food</h1>

  <%
    String msg = request.getParameter("msg");
    if ("success".equals(msg)) { %>
      <p class="text-green-600 mb-4 text-center">✅ Food added successfully!</p>
  <% } else if ("error".equals(msg)) { %>
      <p class="text-red-600 mb-4 text-center">❌ Error adding food. Try again.</p>
  <% } %>

  <form action="add-food" method="post" enctype="multipart/form-data"
        class="bg-white p-6 rounded-xl shadow-md max-w-md mx-auto space-y-4">

    <!-- Name -->
    <label class="block font-semibold">Food Name:</label>
    <input type="text" name="name" class="border px-3 py-2 w-full rounded" required>

    <!-- Price -->
    <label class="block font-semibold">Price:</label>
    <input type="number" name="price" step="0.01" class="border px-3 py-2 w-full rounded" required>

    <!-- Description -->
    <label class="block font-semibold">Description:</label>
    <textarea name="description" class="border px-3 py-2 w-full rounded" rows="3"></textarea>

    <!-- Image -->
    <label class="block font-semibold">Upload Image:</label>
    <input type="file" name="image" id="imageInput" accept="image/*" class="border px-3 py-2 w-full rounded" required>

    <!-- Image Preview -->
    <div class="mt-2">
      <img id="imagePreview" src="#" alt="Image Preview" class="hidden w-full h-64 object-cover rounded border">
    </div>

    <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded">
      Add Food
    </button>
  </form>
</div>

<script>
// Image preview
const imageInput = document.getElementById("imageInput");
const imagePreview = document.getElementById("imagePreview");

imageInput.addEventListener("change", function(){
    const file = this.files[0];
    if(file){
        const reader = new FileReader();
        reader.addEventListener("load", function(){
            imagePreview.setAttribute("src", this.result);
            imagePreview.classList.remove("hidden");
        });
        reader.readAsDataURL(file);
    } else {
        imagePreview.setAttribute("src", "#");
        imagePreview.classList.add("hidden");
    }
});
</script>

</body>
</html>
