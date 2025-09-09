<%@ page import="java.util.List" %>
<%@ page import="code.model.CartItem" %>
<%@ page import="code.model.Theater" %>
<%@ page import="code.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    List<Theater> theaters = (List<Theater>) request.getAttribute("theaters");

    if (cartItems == null) cartItems = new java.util.ArrayList<>();
    if (theaters == null) theaters = new java.util.ArrayList<>();

    double totalAmount = cartItems.stream()
                                  .mapToDouble(c -> c.getFood().getPrice() * c.getQuantity())
                                  .sum();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen">

<div class="container mx-auto py-12 px-4">
    <h1 class="text-4xl font-bold text-center mb-10 text-gray-800">💳 Checkout</h1>

    <div class="bg-white p-8 rounded-2xl shadow-lg max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-8">
        
        <!-- Left Column: Cart Summary with Images -->
        <div>
            <h2 class="text-2xl font-semibold mb-6 text-gray-700">Order Summary</h2>

            <% if(cartItems.isEmpty()) { %>
                <p class="text-red-500 text-center">Your cart is empty.</p>
            <% } else { %>
                <ul class="mb-6 space-y-4">
                <% for(CartItem c : cartItems) { %>
                    <li class="flex items-center justify-between border-b pb-2">
                        <div class="flex items-center space-x-4">
                            <img src="<%=c.getFood().getImage()%>" alt="<%=c.getFood().getName()%>" class="w-16 h-16 object-cover rounded-lg">
                            <div>
                                <p class="font-semibold"><%=c.getFood().getName()%></p>
                                <p class="text-gray-500">Qty: <%=c.getQuantity()%></p>
                            </div>
                        </div>
                        <span class="font-semibold">$<%=c.getFood().getPrice() * c.getQuantity()%></span>
                    </li>
                <% } %>
                </ul>

                <p class="text-right font-bold text-lg mb-6">Total: $<%=totalAmount%></p>
            <% } %>
        </div>

        <!-- Right Column: Checkout Form -->
        <div>
            <h2 class="text-2xl font-semibold mb-6 text-gray-700">Your Information</h2>

            <form id="checkoutForm" action="checkout" method="post" class="space-y-4">

                <!-- Name & Email -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="name" class="block font-semibold mb-1">Name:</label>
                        <input type="text" name="name" id="name" value="<%=user.getName()%>" 
                               class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
                    </div>

                    <div>
                        <label for="email" class="block font-semibold mb-1">Email:</label>
                        <input type="email" name="email" id="email" value="<%=user.getEmail()%>" 
                               class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
                    </div>
                </div>

                <!-- Phone -->
                <div>
                    <label for="phone" class="block font-semibold mb-1">Phone:</label>
                    <input type="text" name="phone" id="phone" value="<%=user.getPhone()%>" 
                           class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
                </div>

                <!-- Theater & Payment -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="theaterId" class="block font-semibold mb-1">Select Theater:</label>
                        <select name="theaterId" id="theaterId" class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
                            <% if(theaters.isEmpty()) { %>
                                <option value="">No theaters available</option>
                            <% } else { %>
                                <% for(Theater t : theaters) { %>
                                    <option value="<%=t.getId()%>"><%=t.getName()%> - <%=t.getLocation()%></option>
                                <% } %>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label for="paymentMethod" class="block font-semibold mb-1">Payment Method:</label>
                        <select name="paymentMethod" id="paymentMethod" class="border px-3 py-2 w-full rounded-lg focus:ring-2 focus:ring-blue-400" required>
                            <option value="cash">Cash</option>
                            <option value="kpz">KPZ</option>
                            <option value="wave">Wave</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-lg font-semibold transition">
                    Place Order
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    const checkoutForm = document.getElementById("checkoutForm");
    const paymentSelect = document.getElementById("paymentMethod");

    checkoutForm.addEventListener("submit", function(e){
        const payment = paymentSelect.value;
        if(payment === "kpz" || payment === "wave") {
            e.preventDefault();

            const theaterId = document.getElementById("theaterId").value;
            const name = document.getElementById("name").value.trim();
            const email = document.getElementById("email").value.trim();
            const phone = document.getElementById("phone").value.trim();

            if(!theaterId || !name || !email || !phone){
                alert("Please fill in all required fields!");
                return;
            }

            // JS concatenation to avoid JSP EL issues
            var url = "payment-scan.jsp?payment=" + encodeURIComponent(payment)
                    + "&theaterId=" + encodeURIComponent(theaterId)
                    + "&name=" + encodeURIComponent(name)
                    + "&email=" + encodeURIComponent(email)
                    + "&phone=" + encodeURIComponent(phone);

            window.location.href = url;
        }
        // Cash will submit normally
    });
</script>

</body>
</html>
