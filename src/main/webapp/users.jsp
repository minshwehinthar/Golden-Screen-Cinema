
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
		<div class="p-8">
			<%@ page language="java" contentType="text/html; charset=UTF-8"
				pageEncoding="UTF-8"%>
			<%@ page import="java.sql.*, code.dao.MyConnection, code.model.User"%>

			<%
			User currentUser = (User) session.getAttribute("user");
			if (currentUser == null || !"admin".equals(currentUser.getRole())) {
				response.sendRedirect("login.jsp");
				return;
			}

			String searchQuery = request.getParameter("search");
			%>

			<div>
				<div class="container mx-auto">
					<h1 class="text-3xl font-bold mb-6 text-gray-900">Users
						Management</h1>

					<form method="get" class="mb-4">
						<input type="text" name="search" placeholder="Search users ..."
							value="<%=searchQuery != null ? searchQuery : ""%>"
							class=" px-4 py-2 rounded w-96 focus:outline-none focus:ring-2 focus:ring-blue-500" />
					</form>

					<div class="overflow-x-auto rounded-lg">
						<table class="min-w-full text-left text-sm font-light">
							<thead
								class="text-xs font-medium uppercase bg-gray-200 text-gray-700">
								<tr>
									<th class="px-6 py-4">ID</th>
									<th class="px-6 py-4">Name</th>
									<th class="px-6 py-4">Email</th>
									<th class="px-6 py-4">Phone</th>
									<th class="px-6 py-4">Status</th>
									<th class="px-6 py-4 text-right">Actions</th>
								</tr>
							</thead>
							<tbody>
								<%
								Connection conn = MyConnection.getConnection();
								PreparedStatement ps;
								if (searchQuery != null && !searchQuery.trim().isEmpty()) {
									ps = conn.prepareStatement(
									"SELECT * FROM users WHERE role='user' AND (name LIKE ? OR email LIKE ? OR phone LIKE ?)");
									String query = "%" + searchQuery + "%";
									ps.setString(1, query);
									ps.setString(2, query);
									ps.setString(3, query);
								} else {
									ps = conn.prepareStatement("SELECT * FROM users WHERE role='user'");
								}
								ResultSet rs = ps.executeQuery();
								while (rs.next()) {
								%>
								<tr class="bg-white border-b border-gray-200 hover:bg-gray-50">
									<td class="px-6 py-4"><%=rs.getInt("id")%></td>
									<th
										class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">
										<%=rs.getString("name")%>
									</th>
									<td class="px-6 py-4"><%=rs.getString("email")%></td>
									<td class="px-6 py-4 text-right"><%=rs.getString("phone")%></td>
									<td class="px-6 py-4 text-right"><span
										class="<%="active".equals(rs.getString("status")) ? "bg-green-400 text-xs text-white rounded-full px-2 py-1"
		: "bg-red-400 text-xs text-white rounded-full px-2 py-1"%> font-semibold">
											<%=rs.getString("status")%>
									</span></td>
									<td class="px-6 py-4 text-right">
										<div class="inline-flex rounded-md shadow-xs" role="group">
											<a
												href="userDetails.jsp?id=<%=rs.getInt("id")%>"
												class="px-4 py-2 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-s-lg hover:bg-gray-100 hover:text-blue-700">
												View </a> <a href="deleteUser.jsp?id=<%=rs.getInt("id")%>"
												onclick="return confirm('Are you sure to delete this user?');"
												class="px-4 py-2 text-sm font-medium text-red-500 bg-white border border-gray-200 rounded-e-lg hover:bg-gray-100 hover:text-blue-700">
												Delete </a>
										</div>
									</td>
								</tr>
								<%
								}
								rs.close();
								ps.close();
								conn.close();
								%>
							</tbody>
						</table>
					</div>
				</div>

			</div>
		</div>
	</div>

	<jsp:include page="layout/JSPFooter.jsp" />