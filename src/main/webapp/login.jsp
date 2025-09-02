<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

<!-- Toast Notification -->
<div id="toast" class="fixed top-5 right-5 hidden bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg"></div>

<div class="w-full max-w-md bg-white p-8 rounded-2xl shadow-md">
    <h2 class="text-2xl font-bold text-center text-gray-700 mb-6">Login</h2>

    <form id="loginForm" action="login" method="post" class="space-y-4">

        <!-- Email -->
        <div>
            <label class="block text-gray-600 mb-1">Email</label>
            <input type="email" name="email" id="email"
                   class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400">
            <p class="text-red-500 text-sm mt-1 hidden" id="emailError">⚠ Valid email is required.</p>
        </div>

        <!-- Password -->
        <div>
            <label class="block text-gray-600 mb-1">Password</label>
            <input type="password" name="password" id="password"
                   class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400">
            <p class="text-red-500 text-sm mt-1 hidden" id="passwordError">⚠ Password is required.</p>
        </div>

        <button type="submit" 
                class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg">
            Login
        </button>
    </form>

    <p class="mt-4 text-center text-gray-600">
        Don’t have an account? <a href="register.jsp" class="text-blue-500 hover:underline">Register</a>
    </p>
</div>

<script>
function showToast(message, color = "bg-red-500") {
    const toast = document.getElementById("toast");
    toast.textContent = message;
    toast.className = `fixed top-5 right-5 ${color} px-4 py-2 rounded-lg shadow-lg`;
    toast.style.display = "block";
    setTimeout(() => { toast.style.display = "none"; }, 3000);
}

// Real-time validation and red borders
const fields = [
    {id: "email", errorId: "emailError", validator: v => /^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$/.test(v)},
    {id: "password", errorId: "passwordError", validator: v => v.trim() !== ""}
];

fields.forEach(f => {
    const input = document.getElementById(f.id);
    const error = document.getElementById(f.errorId);

    input.addEventListener("input", () => {
        if (f.validator(input.value)) {
            input.classList.remove("border-red-500");
            input.classList.add("border-gray-300");
            error.classList.add("hidden");
        } else {
            input.classList.add("border-red-500");
            error.classList.remove("hidden");
        }
    });
});

// Form submit validation
document.getElementById("loginForm").addEventListener("submit", function(e){
    let valid = true;
    fields.forEach(f => {
        const input = document.getElementById(f.id);
        const error = document.getElementById(f.errorId);
        if(!f.validator(input.value)){
            input.classList.add("border-red-500");
            error.classList.remove("hidden");
            valid = false;
        }
    });
    if(!valid) e.preventDefault();
});

// Show toast messages from backend
const msg = new URLSearchParams(window.location.search).get("msg");
if(msg === "invalid") showToast("❌ Invalid email or password!");
else if(msg === "success") showToast("✅ Registration Successful! Please login.", "bg-green-500");
else if(msg === "logout") showToast("✅ Logged out successfully.", "bg-green-500");
</script>

</body>
</html>
