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
                response.sendRedirect("employees.jsp");
                return;
            }

            int userId = Integer.parseInt(idParam);
            Connection conn = MyConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("employees.jsp");
                return;
            }
            %>

<div class="container mx-auto px-12 py-8">

    <!-- Header -->
    <div class="mb-8 flex items-center justify-between">
        <h1 class="text-3xl font-bold text-gray-900">User Details</h1>
        <a href="employees.jsp" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg shadow-md flex items-center gap-2">
            ← Back to Employees
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <!-- User Profile Card -->
        <div class="bg-white rounded-xl shadow-lg p-6 flex flex-col items-center">
            <% String img = rs.getString("image"); %>
            <img src="<%= (img != null && !img.isEmpty()) ? img : "data:image/png;base64,iVBORw0..." %>" 
                 alt="User Image" class="w-40 h-40 p-1 object-cover rounded-full border-4 border-blue-500 mb-4">
            <h2 class="text-2xl font-semibold text-gray-900 text-center mb-4"><%= rs.getString("name") %></h2>

            <table class="w-48 mx-auto text-gray-700">
                <tbody class="divide-y divide-transparent">
                    <tr>
                        <td class="font-medium py-2">Email:</td>
                        <td class="py-2"><%= rs.getString("email") %></td>
                    </tr>
                    <tr>
                        <td class="font-medium py-2">Phone:</td>
                        <td class="py-2"><%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %></td>
                    </tr>
                    <tr>
                        <td class="font-medium py-2">Role:</td>
                        <td class="py-2 capitalize"><%= rs.getString("role") %></td>
                    </tr>
                    <tr>
                        <td class="font-medium py-2">Status:</td>
                        <td class="py-2 <%= "active".equals(rs.getString("status")) ? "text-green-600" : "text-red-600" %> font-semibold">
                            <%= rs.getString("status") %>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- User Details Table -->
        <div class="lg:col-span-2 bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-4 border-b pb-2">Detailed Information</h2>
            <div class="grid grid-cols-2 gap-4 text-gray-700">

                <div><strong>ID:</strong> <%= rs.getInt("id") %></div>
                <div><strong>Gender:</strong> <span class="capitalize"><%= rs.getString("gender") %></span></div>

                <div><strong>Birth Date:</strong> <%= rs.getDate("birth_date") != null ? rs.getDate("birth_date") : "N/A" %></div>
                <div><strong>Created At:</strong> <%= rs.getTimestamp("created_at") %></div>

                <div><strong>Updated At:</strong> <%= rs.getTimestamp("updated_at") %></div>
                <div><strong>Last Login:</strong> <%= rs.getTimestamp("last_login") != null ? rs.getTimestamp("last_login") : "Never" %></div>

            </div>

            <!-- Action Buttons -->
            <div class="mt-6 flex gap-4">
                <a href="employees.jsp" 
                   class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg shadow-md">
                    Back
                </a>
                <a href="deleteUser.jsp?id=<%= rs.getInt("id") %>" 
                   onclick="return confirm('Are you sure you want to delete this user?');"
                   class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg shadow-md">
                    Delete User
                </a>
            </div>
        </div>

    </div>
</div>

        </div>
    </div>
</div>

<jsp:include page="layout/JSPFooter.jsp" />
