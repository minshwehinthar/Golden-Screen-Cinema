<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="code.dao.ReviewDAO"%>
<%@ page import="code.model.Review"%>
<%@ page import="code.model.User"%>
<%
User user = (User) session.getAttribute("user");
ReviewDAO dao = new ReviewDAO();
List<Review> reviews = dao.getAllReviews();

boolean canPost = user != null && "user".equals(user.getRole());

// Count total, good, bad reviews
int totalReviews = reviews.size();
int goodReviews = 0;
int badReviews = 0;
for (Review r : reviews) {
	if ("yes".equals(r.getIsGood()))
		goodReviews++;
	else
		badReviews++;
}

int goodPercent = totalReviews > 0 ? (goodReviews * 100) / totalReviews : 0;
int badPercent = totalReviews > 0 ? (badReviews * 100) / totalReviews : 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reviews</title>
<script src="https://cdn.tailwindcss.com"></script>
<%
boolean loggedIn = (user != null);
String reviewsHeight = loggedIn ? "54vh" : "";
%>

<style>
.reviews-container {
	height: <%=reviewsHeight%>;
	overflow-y: auto;
	/* Hide scrollbar UI */
	scrollbar-width: none; /* Firefox */
	-ms-overflow-style: none; /* IE and Edge */
}

.reviews-container::-webkit-scrollbar {
	width: 0; /* Chrome, Safari, Opera */
	height: 0;
}
</style>

</head>
<body>
	<jsp:include page="layout/Header.jsp"></jsp:include>

	<div class="bg-gray-50 min-h-screen flex flex-col items-center py-6">
		<!-- Header -->
		<div class="w-full max-w-3xl px-4 mb-4 text-center">
			<h1 class="text-2xl font-semibold text-gray-800">Customer
				Reviews</h1>
		</div>

		<!-- Upper group: total / good / bad boxes -->
		<div
			class="w-full max-w-3xl mx-auto mb-4 flex flex-col md:flex-row md:space-x-4 space-y-2 md:space-y-0">
			<div id="totalBox"
				class="flex-1 cursor-pointer bg-gray-50 border border-gray-200 rounded-lg h-24 flex flex-col items-center justify-center text-gray-800 font-semibold">
				<span class="text-sm">Total</span> <span class="text-xl"><%=totalReviews%></span>
			</div>

			<div id="goodBox"
				class="flex-1 cursor-pointer bg-gray-50 border border-gray-200 rounded-lg h-24 flex flex-col items-center justify-center text-green-600 font-semibold">
				<span class="text-sm">Good</span> <span class="text-xl"><%=goodReviews%>
					(<%=goodPercent%>%)</span>
			</div>

			<div id="badBox"
				class="flex-1 cursor-pointer bg-gray-50 border border-gray-200 rounded-lg h-24 flex flex-col items-center justify-center text-red-600 font-semibold">
				<span class="text-sm">Bad</span> <span class="text-xl"><%=badReviews%>
					(<%=badPercent%>%)</span>
			</div>
		</div>

		<!-- Progress bar -->
		<div class="w-full max-w-3xl mx-auto mb-6 px-4">
			<div class="flex justify-between text-sm text-gray-700 mb-1">
				<span>Good <%=goodPercent%>%
				</span> <span>Bad <%=badPercent%>%
				</span>
			</div>
			<div class="w-full h-3 bg-gray-200 rounded-full relative">
				<div class="absolute left-0 top-0 h-3 bg-green-500 rounded-l-full"
					style="width:<%=goodPercent%>%"></div>
				<div class="absolute right-0 top-0 h-3 bg-red-500 rounded-r-full"
					style="width:<%=badPercent%>%"></div>
			</div>
		</div>

		<!-- Reviews List -->
		<div
			class="w-full max-w-3xl px-4 flex flex-col space-y-3 reviews-container mb-8">
			<%
			if (reviews.isEmpty()) {
			%>
			<p class="text-gray-400 text-center">No reviews yet.</p>
			<%
			} else {
			for (Review r : reviews) {
				String reviewUserImage;
				if (r.getUserImage() != null && !r.getUserImage().isEmpty()) {
					if (r.getUserImage().startsWith("uploads/")) {
				reviewUserImage = request.getContextPath() + "/" + r.getUserImage();
					} else {
				reviewUserImage = request.getContextPath() + "/uploads/" + r.getUserImage();
					}
				} else {
					reviewUserImage = "data:image/png;base64,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";
				}
				boolean isGood = "yes".equals(r.getIsGood());
				String textColor = isGood ? "text-green-600" : "text-red-600";
			%>
			<div
				class="flex flex-col border border-gray-200 rounded-lg p-3 bg-white">
				<div class="flex items-center space-x-3 mb-2">
					<img src="<%=reviewUserImage%>" alt="avatar"
						class="w-10 h-10 rounded-full object-cover">
					<div class="flex flex-col">
						<span class="font-medium text-gray-800"><%=r.getUserName()%></span>
						<span class="text-xs text-gray-400 review-timestamp"><%=r.getCreatedAt()%></span>
					</div>
				</div>
				<p class="<%=textColor%> text-sm whitespace-pre-wrap"><%=r.getReviewText()%></p>
			</div>
			<%
			}
			}
			%>
		</div>

		<!-- Review Input -->
		<%
		if (user != null) {
			String currentUserImage;
			if (user.getImage() != null && !user.getImage().isEmpty()) {
				if (user.getImage().startsWith("uploads/")) {
			currentUserImage = request.getContextPath() + "/" + user.getImage();
				} else {
			currentUserImage = request.getContextPath() + "/uploads/" + user.getImage();
				}
			} else {
				currentUserImage = "data:image/png;base64,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";

			}
		%>
		<div class="w-full max-w-3xl mx-auto px-4 mb-8">
			<form id="reviewForm" action="review" method="post"
				class="flex flex-col md:flex-row items-start space-y-2 md:space-y-0 md:space-x-2 bg-white border border-gray-200 rounded-lg p-3">
				<img src="<%=currentUserImage%>" alt="avatar"
					class="w-10 h-10 rounded-full object-cover">
				<textarea name="reviewText" rows="2"
					class="flex-1 p-2 border border-gray-300 rounded-md resize-none focus:ring-1 focus:ring-blue-400"
					placeholder="<%=canPost ? "Write your review..." : "Only users can post reviews"%>"
					<%=canPost ? "" : "disabled"%>></textarea>
				<select name="isGood" class="p-2 border border-gray-300 rounded-md"
					<%=canPost ? "" : "disabled"%>>
					<option value="yes">Good</option>
					<option value="no">Bad</option>
				</select>
				<button type="submit"
					class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
					<%=canPost ? "" : "disabled"%>>Send</button>
			</form>
		</div>
		<%
		}
		%>


	</div>

	<jsp:include page="layout/Footer.jsp"></jsp:include>

	<script>
  const reviews = document.querySelectorAll('.reviews-container > div');
  const totalBox = document.getElementById('totalBox');
  const goodBox = document.getElementById('goodBox');
  const badBox = document.getElementById('badBox');

  function filterReviews(filter) {
    reviews.forEach(r => {
      const isGood = r.querySelector('p').classList.contains('text-green-600');
      if(filter === 'total') r.style.display = 'flex';
      else if(filter === 'good') r.style.display = isGood ? 'flex' : 'none';
      else if(filter === 'bad') r.style.display = !isGood ? 'flex' : 'none';
    });
  }

  totalBox.addEventListener('click', () => filterReviews('total'));
  goodBox.addEventListener('click', () => filterReviews('good'));
  badBox.addEventListener('click', () => filterReviews('bad'));
  

  // Helper to format date like "22 August 2025 10:59 PM"
  function formatReviewDate(isoDate) {
    const dateObj = new Date(isoDate);
    const options = { day: '2-digit', month: 'long', year: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true };
    return dateObj.toLocaleString('en-US', options);
  }

  // Apply formatting to all review timestamps
  document.querySelectorAll('.review-timestamp').forEach(span => {
    const isoDate = span.textContent.trim();
    if (isoDate) {
      span.textContent = formatReviewDate(isoDate);
    }
  });

</script>
</body>
</html>
