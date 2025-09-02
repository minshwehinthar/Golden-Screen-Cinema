
<%
// Get the logged-in user from session
code.model.User user = (code.model.User) session.getAttribute("user");

// Check if user is null or not admin
if (user == null || !"admin".equals(user.getRole())) {
	response.sendRedirect("login.jsp?msg=unauthorized");
	return; // stop rendering the rest of the page
}
%>

<jsp:include page="layout/JSPHeader.jsp" />

<div class="flex">
	<!-- Sidebar -->
	<jsp:include page="layout/sidebar.jsp" />

	<!-- Main content -->
	<div class="flex-1 sm:ml-64">
		<jsp:include page="/layout/AdminHeader.jsp" />
		<div>
			<!-- //////////////////////////////////////////////////////////////////////// -->

			<%@ page language="java" contentType="text/html; charset=UTF-8"
				pageEncoding="UTF-8"%>
			<%@ page import="java.sql.*, code.dao.MyConnection, code.model.User"%>

			<%
			User currentUser = (User) session.getAttribute("user");
			if (currentUser == null || !"admin".equals(currentUser.getRole())) {
				response.sendRedirect("login.jsp");
				return;
			}

			String idParam = request.getParameter("id");
			if (idParam == null) {
				response.sendRedirect("users.jsp");
				return;
			}

			int userId = Integer.parseInt(idParam);
			Connection conn = MyConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id=?");
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();

			if (!rs.next()) {
				response.sendRedirect("users.jsp");
				return;
			}
			%>
			<div class="container mx-auto px-12 py-8">

				<!-- Header -->
				<div class="mb-8 flex items-center justify-between">
					<h1 class="text-3xl font-bold text-gray-900">User Details</h1>
					<a href="users.jsp"
						class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg shadow-md flex items-center gap-2">
						← Back to Users </a>
				</div>

				<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

					<!-- User Profile Card -->
					<div
						class="bg-white rounded-xl shadow-lg p-6 flex flex-col items-center">
						<%
						String img = rs.getString("image");
						%>
						<img
							src="<%=(img != null && !img.isEmpty()) ? img
		: "data:image/png;base64,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"%>"
							alt="User Image"
							class="w-40 h-40 p-1 object-cover rounded-full border-4 border-blue-500 mb-4">
						<h2 class="text-2xl font-semibold text-gray-900 text-center mb-4"><%=rs.getString("name")%></h2>

						<table class="w-48 mx-auto text-gray-700">
							<tbody class="divide-y divide-transparent">
								<!-- no borders -->
								<tr class="py-8">
									<td class="font-medium py-2">Email:</td>
									<td class="py-2"><%=rs.getString("email")%></td>
								</tr>
								<tr class="py-8">
									<td class="font-medium py-2">Phone:</td>
									<td class="py-2"><%=rs.getString("phone") != null ? rs.getString("phone") : "N/A"%></td>
								</tr>
								<tr class="py-8">
									<td class="font-medium py-2">Role:</td>
									<td class="py-2 capitalize"><%=rs.getString("role")%></td>
								</tr>
								<tr class="py-8">
									<td class="font-medium py-2">Status:</td>
									<td
										class="py-2 <%="active".equals(rs.getString("status")) ? "text-green-600" : "text-red-600"%> font-semibold">
										<%=rs.getString("status")%>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<!-- User Details Table -->
					<div class="lg:col-span-2 bg-white rounded-xl shadow-lg p-6">
						<h2 class="text-xl font-bold text-gray-900 mb-4 border-b pb-2">Detailed
							Information</h2>
						<div class="grid grid-cols-2 gap-4 text-gray-700">

							<div>
								<strong>ID:</strong>
								<%=rs.getInt("id")%></div>
							<div>
								<strong>Gender:</strong> <span class="capitalize"><%=rs.getString("gender")%></span>
							</div>

							<div>
								<strong>Birth Date:</strong>
								<%=rs.getDate("birth_date") != null ? rs.getDate("birth_date") : "N/A"%></div>
							<div>
								<strong>Created At:</strong>
								<%=rs.getTimestamp("created_at")%></div>

							<div>
								<strong>Updated At:</strong>
								<%=rs.getTimestamp("updated_at")%></div>
							<div>
								<strong>Last Login:</strong>
								<%=rs.getTimestamp("last_login") != null ? rs.getTimestamp("last_login") : "Never"%></div>

						</div>

						<!-- Action Buttons -->
						<div class="mt-6 flex gap-4">
							<a href="users.jsp"
								class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg shadow-md">
								Back </a> <a href="deleteUser.jsp?id=<%=rs.getInt("id")%>"
								onclick="return confirm('Are you sure you want to delete this user?');"
								class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg shadow-md">
								Delete User </a>
						</div>
					</div>

				</div>
			</div>
			<!-- //////////////////////////////////////////////////////////////////////// -->
		</div>
	</div>
</div>

<jsp:include page="layout/JSPFooter.jsp" />
