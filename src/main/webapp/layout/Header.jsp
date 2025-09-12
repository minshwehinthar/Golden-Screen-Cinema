<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="code.model.User"%>
<%@ page import="code.dao.CartDAO"%>
<%
User user = (User) session.getAttribute("user");
String username = (user != null) ? user.getName() : "Guest";
String email = (user != null && user.getEmail() != null) ? user.getEmail() : "Viewer";
String userImage = "data:image/png;base64,iVBORw0K..."; // default avatar
int cartCount = 0;

if (user != null) {
    if (user.getName() != null) username = user.getName();
    if (user.getEmail() != null) email = user.getEmail();
    if (user.getImage() != null && !user.getImage().isEmpty()) {
        if (user.getImage().startsWith("uploads/")) {
            userImage = request.getContextPath() + "/" + user.getImage();
        } else {
            userImage = request.getContextPath() + "/uploads/" + user.getImage();
        }
    }
    // Get cart count
    CartDAO cartDAO = new CartDAO();
    cartCount = cartDAO.getCartItems(user.getId()).size();
}
%>

<header class="sticky top-0 z-50 shadow-md bg-gray-50">
	<div class="container mx-auto px-4 sm:px-6 lg:px-8">
		<nav class="flex items-center justify-between h-16">

			<!-- Logo -->
			<a href="home.jsp" class="flex items-center gap-2">
				<div class="w-10 h-10 rounded-xl flex items-center justify-center text-lg">🎬</div>
				<div class="flex flex-col leading-tight">
					<span class="font-semibold text-gray-900">CineFlow</span>
					<span class="text-xs text-gray-500">Movies & Cinemas</span>
				</div>
			</a>

			<!-- Desktop Links -->
			<div class="hidden lg:flex lg:space-x-6">
				<a href="home.jsp" class="text-sm font-medium hover:text-indigo-600">Home</a>
				<a href="movies.jsp" class="text-sm font-medium hover:text-indigo-600">Movies</a>
				<a href="cinemas.jsp" class="text-sm font-medium hover:text-indigo-600">Cinemas</a>
				<a href="foods.jsp" class="text-sm font-medium hover:text-indigo-600">Food</a>
				<a href="faq.jsp" class="text-sm font-medium hover:text-indigo-600">FAQ</a>
				<a href="reviews.jsp" class="text-sm font-medium hover:text-indigo-600">Reviews</a>
				<a href="about.jsp" class="text-sm font-medium hover:text-indigo-600">About us</a>
				<a href="contact.jsp" class="text-sm font-medium hover:text-indigo-600">Contact</a>
			</div>

			<!-- Right side -->
			<div class="flex items-center gap-4">
				<% if (user != null) { %>
				<!-- User info (desktop only) -->
				<div class="hidden lg:flex items-center gap-3">
					<div class="flex flex-col text-right">
						<span class="text-sm font-medium"><%=username%></span>
						<span class="text-xs text-gray-500"><%=email%></span>
					</div>
					<img class="w-9 h-9 rounded-full object-cover" src="<%=userImage%>" alt="User avatar" />

					<!-- Chat Icon -->
					<a href="chat.jsp"
					   class="hidden md:flex items-center justify-center p-2 rounded-full hover:bg-gray-100 transition"
					   title="Chat">
						<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
						     stroke-width="1.5" stroke="currentColor" class="w-6 h-6 hover:text-sky-500">
						  <path stroke-linecap="round" stroke-linejoin="round"
						        d="M12 20.25c4.97 0 9-3.694 9-8.25s-4.03-8.25-9-8.25S3 7.444 3 12
						        c0 2.104.859 4.023 2.273 5.48.432.447.74 1.04.586 1.641a4.483 4.483
						        0 0 1-.923 1.785A5.969 5.969 0 0 0 6 21c1.282 0 2.47-.402
						        3.445-1.087.81.22 1.668.337 2.555.337Z" />
						</svg>
					</a>

					<!-- Cart Icon -->
					<a href="cart?action=view"
					   class="relative flex items-center justify-center p-2 rounded-full hover:bg-gray-100 transition"
					   title="My Cart">
						<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-700 hover:text-green-600"
						     fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
						  <path stroke-linecap="round" stroke-linejoin="round"
						        d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2 9m12-9l2 9m-6-4h.01"/>
						</svg>
						<% if (cartCount > 0) { %>
						  <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs font-bold px-1.5 py-0.5 rounded-full">
							<%=cartCount%>
						  </span>
						<% } %>
					</a>
				</div>
				<% } else { %>
				<!-- Guest buttons (desktop) -->
				<div class="hidden lg:flex items-center gap-2">
					<a href="login.jsp"
					   class="px-4 py-2 text-sm font-medium text-gray-700 border border-gray-300 rounded hover:bg-indigo-50 hover:text-indigo-600 transition">
						Login</a>
					<a href="register.jsp"
					   class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded hover:bg-indigo-700 transition">
						Get Started</a>
				</div>
				<% } %>

				<!-- Mobile toggle button -->
				<button type="button" class="lg:hidden p-2 rounded-md hover:bg-gray-100"
				        onclick="toggleMenu()">
					<svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						      d="M4 6h16M4 12h16M4 18h16"/>
					</svg>
				</button>
			</div>
		</nav>
	</div>

	<!-- Mobile Dropdown -->
	<div id="mobileMenu" class="hidden lg:hidden border-t w-full bg-white shadow-md">
		<div class="flex flex-col px-4 py-3 space-y-2">
			<a href="home.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Home</a>
			<a href="movies.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Movies</a>
			<a href="cinemas.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Cinemas</a>
			<a href="foods.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Food</a>
			<a href="faq.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">FAQ</a>
			<a href="reviews.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Reviews</a>
			<a href="about.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">About us</a>
			<a href="contact.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Contact</a>
			<a href="chat.jsp" class="block text-gray-700 font-medium hover:text-indigo-600">Chat</a>
			<a href="cart?action=view" class="block text-gray-700 font-medium hover:text-green-600">
				My Cart <% if (cartCount > 0) { %>(<%=cartCount%>)<% } %>
			</a>
		</div>
	</div>
</header>

<script>
	function toggleMenu() {
		document.getElementById("mobileMenu").classList.toggle("hidden");
	}
</script>
