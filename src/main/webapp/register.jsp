<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Register</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex flex-col items-center justify-center min-h-screen">
	<!-- Toast Notification -->
	<div id="toast"
		class="fixed top-5 right-5 hidden bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg"></div>
		<h1 class="text-3xl font-bold  mb-5">Golden Gate Cinema</h1>
	<div class="w-full max-w-md bg-white p-8 rounded-2xl shadow-md">
		<!-- <h2 class="text-2xl font-bold text-center text-gray-700 mb-6">Create
			Account</h2> -->
		<form id="registerForm" action="register" method="post"
			class="space-y-4">
			<!-- Name -->
			<div>
				<label class="block text-gray-600 mb-1">Name</label> <input
					type="text" name="name" id="name"
					class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400">
				<p class="text-red-500 text-sm mt-1 hidden" id="nameError">⚠
					Name is required.</p>
			</div>
			<!-- Email -->
			<div>
				<label class="block text-gray-600 mb-1">Email</label> <input
					type="email" name="email" id="email"
					class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400">
				<p class="text-red-500 text-sm mt-1 hidden" id="emailError">⚠
					Valid email is required.</p>
			</div>
			<!-- Phone -->
			<div>
				<label class="block text-gray-600 mb-1">Phone</label> <input
					type="text" name="phone" id="phone"
					class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400">
				<p class="text-red-500 text-sm mt-1 hidden" id="phoneError">⚠
					Phone is required.</p>
			</div>
			<!-- Password -->
			<div>
				<label class="block text-gray-600 mb-1">Password</label> <input
					type="password" name="password" id="password"
					class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400">
				<p class="text-red-500 text-sm mt-1 hidden" id="passwordError">⚠
					Password must be at least 6 characters.</p>
			</div>
			<!-- Submit -->
			<button type="submit"
				class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg">
				Register</button>
		</form>
		<p class="mt-4 text-center text-gray-600">
			Already have an account? <a href="login.jsp"
				class="text-blue-500 hover:underline">Login</a>
		</p>
	</div>
	<script>
		// Toast function function showToast(message, color = "bg-red-500") { const toast = document.getElementById("toast"); toast.textContent = message; toast.className = fixed top-5 right-5 ${color} px-4 py-2 rounded-lg shadow-lg; toast.style.display = "block"; setTimeout(() => { toast.style.display = "none"; }, 3000); } // Form Validation document.getElementById("registerForm").addEventListener("submit", function(e) { let valid = true; const name = document.getElementById("name"); const email = document.getElementById("email"); const phone = document.getElementById("phone"); const password = document.getElementById("password"); // Reset errors document.querySelectorAll("p.text-red-500").forEach(p => p.classList.add("hidden")); if (name.value.trim() === "") { document.getElementById("nameError").classList.remove("hidden"); valid = false; } if (!email.value.includes("@")) { document.getElementById("emailError").classList.remove("hidden"); valid = false; } if (phone.value.trim() === "") { document.getElementById("phoneError").classList.remove("hidden"); valid = false; } if (password.value.length < 6) { document.getElementById("passwordError").classList.remove("hidden"); valid = false; } if (!valid) { e.preventDefault(); // stop submit } }); // Show toast from backend msg const urlParams = new URLSearchParams(window.location.search); if (urlParams.get("msg") === "exists") { showToast("❌ Email already exists!"); } else if (urlParams.get("msg") === "success") { showToast("✅ Registration Successful!", "bg-green-500"); } else if (urlParams.get("msg") === "fail") { showToast("❌ Registration Failed!"); }
	</script>
</body>
</html>