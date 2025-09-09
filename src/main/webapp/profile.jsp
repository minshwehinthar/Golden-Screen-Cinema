<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="code.model.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect("login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
	integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800">

	<!-- Include Navigation -->
	<jsp:include page="layout/Header.jsp"></jsp:include>

	<!-- Main Content -->
	<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

		<div class="flex flex-col md:flex-row gap-10">

			<!-- Left: Profile Image & Upload -->
			<div
				class="flex flex-col items-center space-y-6 relative w-full md:w-1/3 rounded-xl p-6 bg-white shadow-sm">
				<div class="relative">
					<img id="profilePreview"
						src="<%=(user.getImage() != null ? "uploads/" + user.getImage() : "data:image/png;base64,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")%>"
						class="w-48 h-48 rounded-full object-cover border-2 border-sky-300"
						alt="Profile">

					<!-- Pencil Button -->
					<label for="profileImage"
						class="absolute bottom-2 right-2 bg-white border border-gray-300 rounded-full h-8 w-8 flex items-center justify-center cursor-pointer hover:bg-sky-100">
						<i class="fa-solid fa-pen"></i>
					</label>
				</div>

				<!-- Upload Form -->
				<form action="updateProfileImage" method="post"
					enctype="multipart/form-data"
					class="w-full flex flex-col items-center gap-2">
					<input id="profileImage" type="file" name="profileImage"
						accept="image/*" class="hidden" onchange="previewImage(event)"
						required>
					<button type="submit"
						class="py-2 px-4 bg-sky-500 text-white font-medium rounded hover:bg-sky-600 transition">
						<i class="fa-solid fa-upload"></i> Upload
					</button>
				</form>

				<!-- User Info Table -->
				<div class="w-full mt-4 overflow-x-auto">
					<table
						class="min-w-full bg-white rounded-lg shadow-inner text-gray-700">
						<tbody>
							<tr class="border-b">
								<td class="px-4 py-2 font-medium">Name</td>
								<td class="px-4 py-2"><%=user.getName()%></td>
							</tr>
							<tr class="border-b">
								<td class="px-4 py-2 font-medium">Email</td>
								<td class="px-4 py-2"><%=user.getEmail()%></td>
							</tr>
							<tr class="border-b">
								<td class="px-4 py-2 font-medium">Phone</td>
								<td class="px-4 py-2"><%=user.getPhone()%></td>
							</tr>
							<tr class="border-b">
								<td class="px-4 py-2 font-medium">Birth Date</td>
								<td class="px-4 py-2"><%=user.getBirthDate() != null ? user.getBirthDate() : "-"%></td>
							</tr>
							<tr class="border-b">
								<td class="px-4 py-2 font-medium">Gender</td>
								<td class="px-4 py-2"><%=user.getGender() != null ? user.getGender() : "-"%></td>
							</tr>
							<tr>
								<td class="px-4 py-2 font-medium">Role</td>
								<td class="px-4 py-2"><%=user.getRole() != null ? user.getRole() : "-"%></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!-- Right: Profile Info -->
			<div class="flex-1 w-full md:w-2/3">
				<h2 class="text-3xl font-bold text-sky-700 mb-4">My Profile</h2>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-4">

					<!-- Name -->
					<div class="col-span-1">
						<label class="block text-sky-600 font-medium">Name</label>
						<div id="nameDisplay"
							class="flex justify-between items-center p-2 border rounded">
							<span><%=user.getName()%></span>
							<button onclick="enableEdit('name')" class="text-sky-500 text-sm">Edit</button>
						</div>
						<form id="nameForm" action="profile" method="post"
							class="hidden mt-2 flex gap-2">
							<input type="hidden" name="field" value="name"> <input
								type="text" name="value" value="<%=user.getName()%>"
								class="border p-1 rounded w-full" required>
							<button type="submit" class="text-green-600">Save</button>
							<button type="button" onclick="cancelEdit('name')"
								class="text-gray-600">Cancel</button>
						</form>
					</div>

					<!-- Email -->
					<div class="col-span-1">
						<label class="block text-sky-600 font-medium">Email</label>
						<div id="emailDisplay"
							class="flex justify-between items-center p-2 border rounded">
							<span><%=user.getEmail()%></span>
							<button onclick="enableEdit('email')"
								class="text-sky-500 text-sm">Edit</button>
						</div>
						<form id="emailForm" action="profile" method="post"
							class="hidden mt-2 flex gap-2">
							<input type="hidden" name="field" value="email"> <input
								type="email" name="value" value="<%=user.getEmail()%>"
								class="border p-1 rounded w-full" required>
							<button type="submit" class="text-green-600">Save</button>
							<button type="button" onclick="cancelEdit('email')"
								class="text-gray-600">Cancel</button>
						</form>
					</div>

					<!-- Phone -->
					<div class="col-span-1">
						<label class="block text-sky-600 font-medium">Phone</label>
						<div id="phoneDisplay"
							class="flex justify-between items-center p-2 border rounded">
							<span><%=user.getPhone()%></span>
							<button onclick="enableEdit('phone')"
								class="text-sky-500 text-sm">Edit</button>
						</div>
						<form id="phoneForm" action="profile" method="post"
							class="hidden mt-2 flex gap-2">
							<input type="hidden" name="field" value="phone"> <input
								type="text" name="value" value="<%=user.getPhone()%>"
								class="border p-1 rounded w-full" required>
							<button type="submit" class="text-green-600">Save</button>
							<button type="button" onclick="cancelEdit('phone')"
								class="text-gray-600">Cancel</button>
						</form>
					</div>

					<!-- Birth Date -->
					<div class="col-span-1">
						<label class="block text-sky-600 font-medium">Birth Date</label>
						<div id="birthDateDisplay"
							class="flex justify-between items-center p-2 border rounded">
							<span><%=user.getBirthDate() != null ? user.getBirthDate() : ""%></span>
							<button onclick="enableEdit('birthDate')"
								class="text-sky-500 text-sm">Edit</button>
						</div>
						<form id="birthDateForm" action="profile" method="post"
							class="hidden mt-2 flex gap-2">
							<input type="hidden" name="field" value="birth_date"> <input
								type="date" name="value"
								value="<%=user.getBirthDate() != null ? user.getBirthDate() : ""%>"
								class="border p-1 rounded w-full" required>
							<button type="submit" class="text-green-600">Save</button>
							<button type="button" onclick="cancelEdit('birthDate')"
								class="text-gray-600">Cancel</button>
						</form>
					</div>

					<!-- Gender (colspan 2) -->
					<div class="col-span-1 md:col-span-2">
						<label class="block text-sky-600 font-medium">Gender</label>
						<div id="genderDisplay"
							class="flex justify-between items-center p-2 border rounded">
							<span><%=user.getGender() != null ? user.getGender() : ""%></span>
							<button onclick="enableEdit('gender')"
								class="text-sky-500 text-sm">Edit</button>
						</div>
						<form id="genderForm" action="profile" method="post"
							class="hidden mt-2 flex gap-2">
							<input type="hidden" name="field" value="gender"> <select
								name="value" class="border p-1 rounded w-full" required>
								<option value="">Select</option>
								<option value="Male"
									<%="Male".equals(user.getGender()) ? "selected" : ""%>>Male</option>
								<option value="Female"
									<%="Female".equals(user.getGender()) ? "selected" : ""%>>Female</option>
								<option value="Other"
									<%="Other".equals(user.getGender()) ? "selected" : ""%>>Other</option>
							</select>
							<button type="submit" class="text-green-600">Save</button>
							<button type="button" onclick="cancelEdit('gender')"
								class="text-gray-600">Cancel</button>
						</form>
					</div>

					<!-- Password (colspan 2) -->
					<div class="col-span-1 md:col-span-2">
						<h3 class="text-sky-600 font-medium">Change Password</h3>
						<form action="updatePassword" method="post"
							class="flex flex-col gap-2 mt-2">
							<input type="password" name="oldPassword"
								placeholder="Old Password" class="border p-1 rounded w-72"
								required> <input type="password" name="newPassword"
								placeholder="New Password" class="border p-1 rounded w-72"
								required>
							<button type="submit"
								class="py-2 px-4 w-72 bg-red-500 text-white rounded hover:bg-red-600 transition">Update
								Password</button>
						</form>
					</div>

				</div>
			</div>
		</div>
	</main>

	<jsp:include page="layout/Footer.jsp"></jsp:include>

	<script>
function enableEdit(field) {
    document.getElementById(field + 'Display').classList.add('hidden');
    document.getElementById(field + 'Form').classList.remove('hidden');
}
function cancelEdit(field) {
    document.getElementById(field + 'Form').classList.add('hidden');
    document.getElementById(field + 'Display').classList.remove('hidden');
}
function previewImage(event) {
    const reader = new FileReader();
    reader.onload = e => document.getElementById('profilePreview').src = e.target.result;
    reader.readAsDataURL(event.target.files[0]);
}
</script>

</body>
</html>
