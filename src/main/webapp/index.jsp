<%
    // Get the logged-in user from session
    code.model.User user = (code.model.User) session.getAttribute("user");

    // Check if user is null or not admin
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp?msg=unauthorized");
        return; // stop rendering the rest of the page
    }
%>

<jsp:include page="layout/JSPHeader.jsp"/>

<div class="flex">
    <!-- Sidebar -->
    <jsp:include page="layout/sidebar.jsp"/>

    <!-- Main content -->
    <div class="flex-1 sm:ml-64">
       <jsp:include page="/layout/AdminHeader.jsp"/>
       <div class="p-8">
           <jsp:include page="/components/DashboardModule.jsp"/>
       </div>
    </div>
</div>

<jsp:include page="layout/JSPFooter.jsp"/>
