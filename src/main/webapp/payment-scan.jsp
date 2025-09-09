<%@ page import="java.util.List" %>
<%@ page import="code.model.CartItem" %>
<%@ page import="code.model.User" %>
<%
    // Get user info from URL (passed from checkout.jsp)
    String payment = request.getParameter("payment");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String theaterId = request.getParameter("theaterId");
    String totalAmountParam = request.getParameter("totalAmount");

    double totalAmount = 0;
    if(totalAmountParam != null && !totalAmountParam.isEmpty()) {
        try {
            totalAmount = Double.parseDouble(totalAmountParam);
        } catch(NumberFormatException e) {
            totalAmount = 0;
        }
    }

    // Get cart items from session to show images and names
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
    if(cartItems == null) cartItems = new java.util.ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment Scan</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center">

<div class="bg-white rounded-2xl shadow-lg p-8 max-w-4xl w-full">
    <h1 class="text-3xl font-bold mb-6 text-center text-gray-700">💳 Payment Scan</h1>

    <!-- User Info -->
    <div class="mb-6 grid grid-cols-2 gap-4">
        <p class="text-gray-600"><strong>Payment Method:</strong> <%=payment.toUpperCase()%></p>
        <p class="text-gray-600"><strong>Total Amount:</strong> $<%=totalAmount%></p>
        <p class="text-gray-600"><strong>Name:</strong> <%=name%></p>
        <p class="text-gray-600"><strong>Email:</strong> <%=email%></p>
        <p class="text-gray-600"><strong>Phone:</strong> <%=phone%></p>
        <p class="text-gray-600"><strong>Theater ID:</strong> <%=theaterId%></p>
    </div>

    <!-- Order Summary with images -->
    <h2 class="text-xl font-semibold mb-4 text-gray-700">Order Summary</h2>
    <ul class="mb-4 space-y-2">
    <% for(CartItem c : cartItems) { %>
        <li class="flex justify-between border-b pb-2 items-center">
            <div class="flex items-center space-x-4">
                <img src="<%=c.getFood().getImage()%>" alt="<%=c.getFood().getName()%>" class="w-16 h-16 object-cover rounded-lg">
                <span class="font-semibold"><%=c.getFood().getName()%> x <%=c.getQuantity()%></span>
            </div>
            <span class="font-semibold">$<%=c.getFood().getPrice()*c.getQuantity()%></span>
        </li>
    <% } %>
    </ul>

    <!-- QR code / payment -->
    <div class="flex flex-col items-center">
        <div class="w-64 h-64 bg-gray-200 rounded-lg flex items-center justify-center mb-6">
            <p class="text-gray-500 text-center">Scan QR Code Here</p>
        </div>

        <p class="text-gray-500 mb-4">After scanning, payment will be confirmed automatically.</p>

        <button id="simulatePayment" class="bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-lg font-semibold">
            Simulate Payment
        </button>
    </div>
</div>

<script>
    // Simulate payment confirmation
    document.getElementById("simulatePayment").addEventListener("click", function() {
        alert("Payment successful! Redirecting to order success page...");
        window.location.href = "order-success.jsp";
    });

    // Optional: auto redirect after 15 seconds
    setTimeout(function() {
        alert("Payment confirmed automatically! Redirecting...");
        window.location.href = "order-success.jsp";
    }, 15000);
</script>

</body>
</html>
