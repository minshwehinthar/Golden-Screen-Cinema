<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin - Add Food Item</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Image preview */
        #imagePreview {
            width: 150px;
            height: 150px;
            border: 2px dashed #ccc;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            color: #999;
            overflow: hidden;
        }

        #imagePreview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-6">

<div class="w-full max-w-3xl bg-white p-8 rounded-2xl shadow-xl">
    <h1 class="text-3xl font-bold mb-6 text-gray-700 text-center">Add New Food Item</h1>

    <form action="admin-add-food" method="post" enctype="multipart/form-data" class="space-y-6">
        <!-- Food Name & Category -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block font-medium text-gray-600 mb-2">Food Name <span class="text-red-500">*</span></label>
                <input type="text" name="name" required
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400">
            </div>

            <div>
                <label class="block font-medium text-gray-600 mb-2">Category</label>
                <select name="category" class="w-full border border-gray-300 rounded-lg px-4 py-2">
                    <option value="snack">Snack</option>
                    <option value="drink">Drink</option>
                </select>
            </div>
        </div>

        <!-- Description -->
        <div>
            <label class="block font-medium text-gray-600 mb-2">Description</label>
            <textarea name="description" rows="4" placeholder="Describe your food..."
                      class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400"></textarea>
        </div>

        <!-- Price & Quantity -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block font-medium text-gray-600 mb-2">Price (MMK) <span class="text-red-500">*</span></label>
                <input type="number" name="price" required min="0"
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400">
            </div>

            <div>
                <label class="block font-medium text-gray-600 mb-2">Quantity <span class="text-red-500">*</span></label>
                <input type="number" name="quantity" required min="0"
                       class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-blue-400">
            </div>
        </div>

        <!-- Image Upload -->
        <div>
            <label class="block font-medium text-gray-600 mb-2">Food Image</label>
            <input type="file" name="image" id="imageInput" accept="image/*"
                   class="w-full border border-gray-300 rounded-lg px-4 py-2">
            <div id="imagePreview" class="mt-4">Image Preview</div>
        </div>

        <!-- Submit Button -->
        <button type="submit"
                class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-lg transition duration-300">
            Add Food Item
        </button>
    </form>
</div>

<script>
    // Image preview functionality
    const imageInput = document.getElementById('imageInput');
    const imagePreview = document.getElementById('imagePreview');

    imageInput.addEventListener('change', function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                imagePreview.innerHTML = `<img src="${e.target.result}" alt="Food Image">`;
            }
            reader.readAsDataURL(file);
        } else {
            imagePreview.innerHTML = 'Image Preview';
        }
    });
</script>
</body>
</html>
