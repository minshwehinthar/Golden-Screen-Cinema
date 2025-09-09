<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="code.model.User"%>
<%
User user = (User) session.getAttribute("user");
String username = (user != null) ? user.getName() : "Guest";
String email = (user != null && user.getEmail() != null) ? user.getEmail() : "Viewer";
String userImage = "data:image/png;base64,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";

if (user != null) {
	if (user.getName() != null) {
		username = user.getName();
	}
	if (user.getEmail() != null) {
		email = user.getEmail();
	}
	if (user.getImage() != null && !user.getImage().isEmpty()) {
		if (user.getImage().startsWith("uploads/")) {
	userImage = request.getContextPath() + "/" + user.getImage();
		} else {
	userImage = request.getContextPath() + "/uploads/" + user.getImage();
		}
	}
}
%>

<header class="sticky top-0 z-50 shadow-md bg-gray-50">
	<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
		<nav class="flex items-center justify-between h-16">

			<!-- Logo -->
			<a href="home.jsp" class="flex items-center gap-2">
				<div
					class="w-10 h-10 rounded-xl flex items-center justify-center text-lg">🎬</div>
				<div class="flex flex-col leading-tight">
					<span class="font-semibold text-gray-900">CineFlow</span> <span
						class="text-xs text-gray-500">Movies & Cinemas</span>
				</div>
			</a>

			<!-- Desktop Links (lg & up) -->
			<div class="hidden lg:flex lg:space-x-6">
				<a href="home.jsp" class="text-sm font-medium hover:text-indigo-600">Home</a>
				<a href="movies.jsp"
					class="text-sm font-medium hover:text-indigo-600">Movies</a> <a
					href="cinemas.jsp"
					class="text-sm font-medium hover:text-indigo-600">Cinemas</a> <a
					href="foods.jsp" class="text-sm font-medium hover:text-indigo-600">Food</a>
				<a href="faq.jsp" class="text-sm font-medium hover:text-indigo-600">FAQ</a>
				<a href="reviews.jsp"
					class="text-sm font-medium hover:text-indigo-600">Reviews</a> <a
					href="about.jsp" class="text-sm font-medium hover:text-indigo-600">About
					us</a> <a href="contact.jsp"
					class="text-sm font-medium hover:text-indigo-600">Contact</a>
			</div>

			<!-- Right side -->
			<%
			if (user != null) {
			%>
			<!-- Right side -->
			<div class="flex items-center gap-4">
				<!-- User info (hidden on mobile/sm/md) -->
				<div class="hidden lg:flex items-center gap-3">
					<div class="flex flex-col text-right">
						<span class="text-sm font-medium"><%=username%></span> <span
							class="text-xs text-gray-500"><%=email%></span>
					</div>
					<a href="profile.jsp">
						<img class="w-9 h-9 rounded-full object-cover"
						src="<%=userImage%>" alt="User avatar" />
					</a>
					<!-- Chat Icon -->
					<a href="chat.jsp"
						class="hidden md:flex items-center justify-center p-2 rounded-full hover:bg-gray-100 transition"
						title="Chat"> <svg xmlns="http://www.w3.org/2000/svg"
							fill="none" viewBox="0 0 24 24" stroke-width="1.5"
							stroke="currentColor" class="size-6 hover:text-sky-500">
  <path stroke-linecap="round" stroke-linejoin="round"
								d="M12 20.25c4.97 0 9-3.694 9-8.25s-4.03-8.25-9-8.25S3 7.444 3 12c0 2.104.859 4.023 2.273 5.48.432.447.74 1.04.586 1.641a4.483 4.483 0 0 1-.923 1.785A5.969 5.969 0 0 0 6 21c1.282 0 2.47-.402 3.445-1.087.81.22 1.668.337 2.555.337Z" />
</svg>

					</a>
				</div>
				<%
				} else {
				%>
				<!-- Guest buttons (Desktop) -->
				<div class="hidden lg:flex items-center gap-2">
					<a href="login.jsp"
						class="px-4 py-2 text-sm font-medium text-gray-700 border border-gray-300 rounded hover:bg-indigo-50 hover:text-indigo-600 transition">
						Login </a> <a href="register.jsp"
						class="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded hover:bg-indigo-700 transition">
						Get Started </a>
				</div>
				<%
				}
				%>

				<!-- Mobile / MD toggle button -->
				<button type="button"
					class="lg:hidden p-2 rounded-md hover:bg-gray-100"
					onclick="toggleMenu()">
					<svg class="w-6 h-6 text-gray-700" fill="none"
						stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round"
							stroke-linejoin="round" stroke-width="2"
							d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
				</button>
			</div>

			<!-- Mobile / MD toggle button -->
			<button type="button"
				class="lg:hidden p-2 rounded-md hover:bg-gray-100"
				onclick="toggleMenu()">
				<svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor"
					viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round"
						stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
			</button>

		</nav>
	</div>

	<!-- Mobile/MD Dropdown Menu -->
	<div id="mobileMenu"
		class="hidden lg:hidden border-t w-full bg-white shadow-md">
		<div class="flex flex-col px-4 py-3 space-y-2">
			<a href="index.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">Home</a>
			<a href="movies.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">Movies</a>
			<a href="cinemas.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">Cinemas</a>
			<a href="foods.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">Food</a>
			<a href="faq.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">FAQ</a>
			<a href="reviews.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">Reviews</a>
			<a href="about.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">About
				us</a> <a href="contact.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">Contact</a>
			<a href="chat.jsp"
				class="block text-gray-700 font-medium hover:text-indigo-600">
				Chat </a>
		</div>
	</div>
</header>

<script>
	function toggleMenu() {
		document.getElementById("mobileMenu").classList.toggle("hidden");
	}
</script>