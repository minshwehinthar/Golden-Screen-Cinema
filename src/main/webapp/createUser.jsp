
<%
// Get the logged-in user from session
code.model.User user = (code.model.User) session.getAttribute("user");

// Check if user is null or not admin
if (user == null || !"admin".equals(user.getRole())) {
	response.sendRedirect("login.jsp?msg=unauthorized");
	return; // stop rendering the rest of the page
}
%>
<script src="https://unpkg.com/feather-icons"></script>


<jsp:include page="layout/JSPHeader.jsp" />

<div class="flex">
	<!-- Sidebar -->
	<jsp:include page="layout/sidebar.jsp" />

	<!-- Main content -->
	<div class="flex-1 sm:ml-64">
		<jsp:include page="/layout/AdminHeader.jsp" />
		<div>
			<!-- //////////////////////////////////////////////////////////////////////// -->

			<div class="flex justify-center items-start p-10">
				<div class="w-full">
					<h2 class="text-2xl font-bold mb-8">Create User</h2>

					<form action="CreateUserServlet" method="post"
						enctype="multipart/form-data"
						class="grid grid-cols-1 md:grid-cols-2 gap-6">

						<!-- Column 1 -->
						<div class="flex flex-col gap-4">
							<label class="font-medium text-gray-700">Name</label> <input
								type="text" name="name" placeholder="John Doe"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400"
								required> <label class="font-medium text-gray-700">Email</label>
							<input type="email" name="email" placeholder="email@example.com"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400"
								required> <label class="font-medium text-gray-700">Phone</label>
							<input type="text" name="phone" placeholder="+123456789"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400">

							<!-- Image upload row -->
							<div class="md:col-span-2 flex flex-col gap-2 mt-4">
								<label class="font-medium text-gray-700">Profile Photo</label> <label
									for="imageUpload"
									class="flex items-center gap-2 cursor-pointer bg-gray-100 p-3 rounded-lg hover:bg-gray-200 w-32 justify-center">
									<i data-feather="camera"></i> Upload
								</label> <input type="file" name="image" id="imageUpload" class="hidden"
									accept="image/*">

								<!-- Image preview -->
								<img id="previewImg" src="#" alt="Preview"
									class="hidden mt-4 w-32 h-32 object-cover rounded-full border">
							</div>
						</div>

						<!-- Column 2 -->
						<div class="flex flex-col gap-4">
							<label class="font-medium text-gray-700">Role</label> <select
								name="role"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400"
								required>
								<option value="">Select Role</option>
								<option value="user">User</option>
								<option value="employee">Employee</option>
							</select> <label class="font-medium text-gray-700">Password</label> <input
								type="password" name="password" placeholder="********"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400"
								required> <label class="font-medium text-gray-700">Birth
								Date</label> <input type="date" name="birth_date"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400">

							<label class="font-medium text-gray-700">Gender</label> <select
								name="gender"
								class="p-3 border rounded-lg focus:ring-2 focus:ring-blue-400">
								<option value="">Select Gender</option>
								<option value="male">Male</option>
								<option value="female">Female</option>
								<option value="other">Other</option>
							</select>
							<!-- Submit button row -->
							<div
								class="mt-28 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
								<!-- Checkbox with custom style -->
								<label
									class="flex items-center gap-2 text-gray-700 cursor-pointer">
									<input type="checkbox" required
									class="w-5 h-5 text-blue-500 border-gray-300 rounded focus:ring-2 focus:ring-blue-400">
									<span>Are you sure to create account?</span>
								</label>

								<!-- Submit button -->
								<button type="submit"
									class="bg-blue-500 text-white p-3 px-6 rounded-lg hover:bg-blue-600 transition-colors font-medium">
									Create User</button>
							</div>

						</div>




					</form>
				</div>

				<script>
    feather.replace(); // Replace feather icons

    const fileInput = document.getElementById('imageUpload');
    const previewImg = document.getElementById('previewImg');

    fileInput.addEventListener('change', () => {
        if(fileInput.files.length > 0){
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                previewImg.classList.remove('hidden');
            }
            reader.readAsDataURL(fileInput.files[0]);
        } else {
            previewImg.classList.add('hidden');
        }
    });
</script>
			</div>



			<!-- //////////////////////////////////////////////////////////////////////// -->
		</div>
	</div>
</div>

<jsp:include page="layout/JSPFooter.jsp" />




