<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Admin Dashboard</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="style.css" />

    <script>
        // Function to get the value of a query parameter by name
        function getQueryParam(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        }

        // Function to show the toast notification
        function showToast(message) {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.classList.remove('hidden');

            // Hide the toast after 5 seconds
            setTimeout(() => {
                toast.classList.add('hidden');
                cleanUpParam('message');

            }, 5000);
        }
        
        function cleanUpParam(paramName) {
            const url = new URL(window.location);
            url.searchParams.delete(paramName);
            window.history.replaceState({}, document.title, url.pathname);
        }

        // Check if 'message' parameter exists in the URL and show the toast
        window.onload = function() {
            const message = getQueryParam('message');
            if (message) {
                showToast(message);
                
            }
        };
        
        // Function to populate the coadminId field from localStorage
        function populateCoadminId() {
            // Retrieve the coadminId from localStorage
            const coadminId = localStorage.getItem('coadminId');

            // Check if the coadminId exists in localStorage
            if (coadminId) {
                // Populate the hidden input field with the retrieved coadminId
                document.getElementById('coadminId').value = coadminId;
            } else {
                console.warn('coadminId not found in localStorage');
            }
        }

        // Execute the function when the page loads
        window.onload = populateCoadminId;
        
        // Function to save data to LocalStorage
        function saveToLocalStorage(key, value) {
        	console.log("Saved", value)
            localStorage.setItem(key, value);
        }

        // Function to get data from LocalStorage
        function getFromLocalStorage(key) {
            return localStorage.getItem(key);
        }

        function populateProfileData() {
            let name = getFromLocalStorage("name") || "No Name";
            let email = getFromLocalStorage("email") || "No Email";
            let userType = getFromLocalStorage("userType") || "No Type";

            document.getElementById("name").innerText = name;
            document.getElementById("email").innerText = email;
            document.getElementById("userType").innerText = userType;
        }


        // Function to handle page load and save data
        function handlePageLoad() {
            var name = "<%= session.getAttribute("name") != null ? session.getAttribute("name").toString() : "" %>";
            var email = "<%= session.getAttribute("email") != null ? session.getAttribute("email").toString() : "" %>";
            var userType = "<%= session.getAttribute("userType") != null ? session.getAttribute("userType").toString() : "" %>";
            var coadminId = "<%= session.getAttribute("coadminId") != null ? session.getAttribute("coadminId").toString() : "" %>";

    		console.log("Name" + name + "Email "+ email +"UserType "+ userType + "CoadminId" + coadminId)
            if (name && email && userType) {
            	localStorage.removeItem('name');
            	localStorage.removeItem('email');
            	localStorage.removeItem('userType');
            	localStorage.removeItem('isLoggedIn');

                saveToLocalStorage('name', name);
                saveToLocalStorage('email', email);
                saveToLocalStorage('userType', "admin");
                saveToLocalStorage('isLoggedIn', true);
                saveToLocalStorage('coadminId', coadminId);

            } else {
                console.log("Can't set user data, maybe it already exists.");
            }

            // Populate profile data after saving to LocalStorage
            populateProfileData();
        }

     	// Ensure the function runs when the page loads
    	document.addEventListener("DOMContentLoaded", handlePageLoad);
    </script>
        <style>
        /* Tailwind CSS classes for toast animation */
        .show {
            visibility: visible;
            animation: fadeInOut 5s ease-in-out;
        }

        @keyframes fadeInOut {
            0% { opacity: 0; bottom: 0; }
            10% { opacity: 1; bottom: 20px; }
            90% { opacity: 1; bottom: 20px; }
            100% { opacity: 0; bottom: 0; }
        }
        
        /* Ensuring modal is hidden by default */
        .modal {
            display: none;
        }
        .modal.active {
            display: flex; /* Flex to center the content */
        }
        
    </style>
</head>
<body class="bg-gray-100">
	<nav id="navContainer"
		class="z-50 w-full flex justify-between items-center p-1 px-20 fixed top-0 bg-white backdrop-blur-md">
	</nav>
	<div id="toast" class="hidden z-50 fixed bottom-5 left-1/2 transform -translate-x-1/2 bg-red-600 text-white text-center px-4 py-3 rounded shadow-lg">
        <!-- Toast message will be inserted here by JavaScript -->
    </div>
	<section class="flex h-full mx-auto rounded-lg">
		<!-- Left Sidebar -->
		<div
			class="fixed top-20 left-0 bg-white shadow-lg h-full w-64 text-white flex flex-col justify-start p-4">
			<ul class="flex flex-col space-y-4 w-full pt-10">
				<li>
					<button
						class="bg-red-700 py-3 px-4 hover:bg-red-800 w-full text-left rounded-lg"
						onclick="changeTab('dashboard')">Dashboard
					</button>
				</li>
				<li>
					<button
						class="bg-red-700 py-3 px-4 hover:bg-red-800 w-full text-left rounded-lg"
						onclick="changeTab('addProduct')">Services
					</button>
				</li>
				<li>
					<button
						class="bg-red-700 py-3 px-4 hover:bg-red-800 w-full text-left rounded-lg"
						onclick="changeTab('userList')">Customer
						History</button>
				</li>
			</ul>
		</div>

		<!-- Main Content -->
		<div class="flex w-[calc(100%-20rem)] h-screen mr-20 ml-auto">
			<div class="w-screen h-screen p-5 mt-24 pl-10">
				<!-- Default Visible Section -->
				<section id="dashboard" class="relative z-10 w-full h-full overflow-y-scroll">
					
				<div class="w-full flex flex-row space-x-5">
					<div id="left">
						<h1 class="text-4xl text-red-700 font-bold mb-4 hover:text-red-650">
						Welcome to the Co-Admin Dashboard</h1>
						<div class="flex justify-around w-full mb-6">
						<!-- Total Hotels -->
						<div class="bg-gray-200 rounded-lg p-4 flex flex-col">
							<p class="text-xl font-bold text-red-500">Booked Rooms</p>
							<p id="totalHotels"
								class="text-3xl font-bold text-center text-red-600">
								0</p>
						</div>
						<!-- Total Tables -->
						<div class="bg-gray-200 rounded-lg p-4 flex flex-col">
							<p class="text-xl font-bold text-red-500">Reserved Tables</p>
							<p id="totalTables"
								class="text-3xl font-bold text-center text-red-600">
								0</p>
						</div>
						<!-- Total Articles -->
						<div class="bg-gray-200 rounded-lg p-4 flex flex-col">
							<p class="text-xl font-bold text-red-500">Total Articles</p>
							<p id="totalArticles"
								class="text-3xl font-bold text-center text-red-600">
								0</p>
						</div>
					</div>
					</div>
				</div>
    

					<div class="flex">
						<!-- Room Table -->
						<div class="overflow-x-auto w-full mb-4 space-y-2">
							<p class="text-xl my-3 font-bold text-red-500">Rooms</p>
							<table
								class="min-w-full divide-y divide-gray-200 bg-white rounded-lg shadow-lg border-r-2">
								<thead class="bg-gray-100">
									<tr>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Number</th>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Type</th>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Price</th>
										<th
											class="px-2 max-w-20 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Description</th>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Available</th>
									</tr>
								</thead>
								<tbody class="bg-white divide-y divide-gray-200">
									<!-- Example row, replace with dynamic content -->
									<tr>
										<td class="px-2 py-2 whitespace-nowrap">101</td>
										<td class="px-2 py-2 whitespace-nowrap">Suite</td>
										<td class="px-2 py-2 whitespace-nowrap">$250.00</td>
										<td class="px-2 py-2 truncate max-w-20">Spacious suite
											with ocean view.</td>
										<td class="px-2 py-2 whitespace-nowrap text-center"><span
											class="text-green-500">Yes</span></td>
									</tr>
									<tr>
										<td class="px-2 py-2 whitespace-nowrap">101</td>
										<td class="px-2 py-2 whitespace-nowrap">Suite</td>
										<td class="px-2 py-2 whitespace-nowrap">$250.00</td>
										<td class="px-2 py-2 truncate max-w-20">Spacious suite
											with ocean view.</td>
										<td class="px-2 py-2 whitespace-nowrap text-center"><span
											class="text-green-500">Yes</span></td>
									</tr>
									<tr>
										<td class="px-2 py-2 whitespace-nowrap">101</td>
										<td class="px-2 py-2 whitespace-nowrap">Suite</td>
										<td class="px-2 py-2 whitespace-nowrap">$250.00</td>
										<td class="px-2 py-2 truncate max-w-20">Spacious suite
											with ocean view.</td>
										<td class="px-2 py-2 whitespace-nowrap text-center"><span
											class="text-green-500">Yes</span></td>
									</tr>
									<!-- Add more rows as needed -->
								</tbody>
							</table>
						</div>
						<!-- Tables Table -->
						<div class="overflow-x-auto w-full">
							<p class="text-xl my-3 font-bold text-red-500">Tables</p>
							<table
								class="min-w-full divide-y divide-gray-200 bg-white rounded-lg">
								<thead class="bg-gray-100">
									<tr>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Name</th>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Location</th>
										<th
											class="px-2 max-w-20 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Description</th>
										<th
											class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Price</th>
									</tr>
								</thead>
								<tbody class="bg-white divide-y divide-gray-200">
									<!-- Example row, replace with dynamic content -->
									<tr>
										<td class="px-2 py-2 whitespace-nowrap">The Gourmet
											Bistro</td>
										<td class="px-2 py-2 whitespace-nowrap">Downtown</td>
										<td class="px-2 py-2 whitespace-nowrap">Cozy corner table
											for two.</td>
										<td class="px-2 py-2 whitespace-nowrap">$75.00</td>
									</tr>
									<!-- Add more rows as needed -->
								</tbody>
							</table>
						</div>
					</div>
				</section>
				
					</div>


				<!-- Add Product Container -->
				<section id="addProduct"
					class="hidden absolute right-0 w-[calc(100%-20rem)] mr-10 top-32 ml-auto">
					<div class="w-full flex z-10 space-x-3">
						<div id="product-left-container"
							class="flex flex-col justify-around w-4/7 h-full mb-6">
							<!-- Right Sidebar -->
							<h1 class="text-4xl font-bold mb-4 text-red-700 drop-shadow-lg">
								Services</h1>
							<div id="rightSidebar"
								class="fixed z-30 bg-gray-50 top-20 right-0 h-full w-[350px] p-4 transform translate-x-full transition-transform duration-300 overflow-y-auto">
								<div class="flex justify-end">
									<button onclick="closeSidebar()"
										class="text-gray-600 hover:text-gray-900 text-4xl text-right font-bold">
										&times;</button>
								</div>

								<div>
									<!-- Forms -->
									<!-- Hotel Form -->
									<div id="hotelForm"
										class="hidden z-50 bg-white max-w-md mx-auto">
										<h2
											class="text-3xl text-red-700 font-semibold mb-6 text-gray-800">Add
											Hotel</h2>
<form action="post" method="post" enctype="multipart/form-data">
    <input type="hidden" value="create" name="mode">
    <input type="hidden" value="hotel" name="postType">
    <input type="hidden" value="" id="coadminId" name="coadminId">

	<label for="title" class="block text-sm font-medium text-red-700 mb-2">Title:</label>
    <input type="text" id="title" name="title" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">
	
    <label for="roomTypes" class="block text-sm font-medium text-red-700 mb-2">Room Types:</label>
    <div class="mb-4">
        <label class="inline-flex items-center mr-4"> <input type="checkbox" name="roomTypes[]" value="Single" class="form-checkbox text-red-600 border-gray-300 rounded focus:ring focus:ring-red-200">
            <span class="ml-2 text-gray-700">Single</span>
        </label>
        <label class="inline-flex items-center mr-4"> <input type="checkbox" name="roomTypes[]" value="Double" class="form-checkbox text-red-600 border-gray-300 rounded focus:ring focus:ring-red-200">
            <span class="ml-2 text-gray-700">Double</span>
        </label>
        <label class="inline-flex items-center mr-4"> <input type="checkbox" name="roomTypes[]" value="Suite" class="form-checkbox text-red-600 border-gray-300 rounded focus:ring focus:ring-red-200">
            <span class="ml-2 text-gray-700">Suite</span>
        </label>
    </div>

    <label for="hotelLocation" class="block text-sm font-medium text-red-700 mb-2">Location:</label>
    <input type="text" id="hotelLocation" name="hotelLocation" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="hotelContact" class="block text-sm font-medium text-red-700 mb-2">Contact Address:</label>
    <textarea id="hotelContact" name="hotelContact" rows="4" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200"></textarea>

    <label for="hotelPhone" class="block text-sm font-medium text-red-700 mb-2">Phone:</label>
    <input type="text" id="hotelPhone" name="hotelPhone" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="price" class="block text-sm font-medium text-red-700 mb-2">Price:</label>
    <input type="number" id="price" name="price" step="0.01" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="offPercentage" class="block text-sm font-medium text-red-700 mb-2">Discount Percentage:</label>
    <input type="number" id="offPercentage" name="offPercentage" step="0.01" min="0" max="100" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200" placeholder="0.00">

    <div class="flex items-center justify-center w-full mb-2">
        <label for="hotelImages" class="flex flex-col items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
            <div class="flex flex-col items-center justify-center pt-5 pb-6">
                <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2" />
                </svg>
                <p class="mb-2 text-sm text-gray-500">
                    <span class="font-semibold">Click to upload</span> or drag and drop
                </p>
                <p class="text-xs text-gray-500">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
            </div>
            <input id="hotelImages" type="file" class="hidden" name="images" accept="image/*" multiple />
        </label>
    </div>
    
    											<div id="hotelImagesPreviewContainer" class="flex flex-wrap items-center justify-center w-full mb-4">
											    <!-- Preview images will be dynamically added here -->
											</div>

    <button type="submit" class="w-full bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition duration-300 mb-20">
        Submit
    </button>
</form>

									</div>



									<!-- Restaurant Form -->
									<div id="restForm"
										class="hidden z-50 bg-white max-w-md mx-auto">
										<h2
											class="text-3xl text-red-700 font-semibold mb-6 text-gray-800">
											Add Restaurant</h2>
<form action="post" method="post" enctype="multipart/form-data">
    <input type="hidden" value="create" name="mode">
    <input type="hidden" value="restaurant" name="postType">
	<input type="hidden" value="" id="coadminId" name="coadminId">
    

    <label for="restaurantLocation" class="block text-sm font-medium text-red-700 mb-2">Location:</label>
    <input type="text" id="restaurantLocation" name="restaurantLocation" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="price" class="block text-sm font-medium text-red-700 mb-2">Price:</label>
    <input type="number" id="price" name="price" step="0.01" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="offPercentage" class="block text-sm font-medium text-red-700 mb-2">Discount Percentage:</label>
    <input type="number" id="offPercentage" name="offPercentage" step="0.01" min="0" max="100" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200" placeholder="0.00">

    <label for="tableNumber" class="block text-sm font-medium text-red-700 mb-2">Table Number:</label>
    <input type="number" id="tableNumber" name="tableNumber" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="seats" class="block text-sm font-medium text-red-700 mb-2">Seats:</label>
    <input type="number" id="seats" name="seats" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <div class="flex items-center justify-center w-full mb-2">
        <label for="restaurantImages" class="flex flex-col items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
            <div class="flex flex-col items-center justify-center pt-5 pb-6">
                <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2" />
                </svg>
                <p class="mb-2 text-sm text-gray-500">
                    <span class="font-semibold">Click to upload</span> or drag and drop
                </p>
                <p class="text-xs text-gray-500">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
            </div>
            <input id="restaurantImages" type="file" class="hidden" name="images" accept="image/*" multiple />
        </label>
    </div>
    											<div id="restaurantImagesPreviewContainer" class="flex flex-wrap items-center justify-center w-full mb-4">
											    <!-- Preview images will be dynamically added here -->
											</div>
    

    <button type="submit" class="w-full bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition duration-300 mb-20">
        Submit
    </button>
</form>

									</div>


									<!-- TransportationForm -->
									<div id="tranForm"
										class="hidden z-50 bg-white max-w-md mx-auto">
										<h2
											class="text-3xl text-red-700 font-semibold mb-6 text-gray-800">Add
											Transportation</h2>
<form action="post" method="post" enctype="multipart/form-data">
    <input type="hidden" value="create" name="mode">
    <input type="hidden" value="" id="coadminId" name="coadminId">
    <input type="hidden" value="transportation" name="postType">

    <label for="vehicleType" class="block text-sm font-medium text-red-700 mb-2">Vehicle Type:</label>
    <input type="text" id="vehicleType" name="vehicleType" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="vehicleNumber" class="block text-sm font-medium text-red-700 mb-2">Vehicle Number:</label>
    <input type="text" id="vehicleNumber" name="vehicleNumber" required class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="price" class="block text-sm font-medium text-red-700 mb-2">Price:</label>
    <input type="number" id="price" name="price" step="0.01" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

    <label for="offPercentage" class="block text-sm font-medium text-red-700 mb-2">Discount Percentage:</label>
    <input type="number" id="offPercentage" name="offPercentage" step="0.01" min="0" max="100" class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200" placeholder="0.00">

    <div class="flex items-center justify-center w-full mb-2">
        <label for="transportationImages" class="flex flex-col items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
            <div class="flex flex-col items-center justify-center pt-5 pb-6">
                <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2" />
                </svg>
                <p class="mb-2 text-sm text-gray-500">
                    <span class="font-semibold">Click to upload</span> or drag and drop
                </p>
                <p class="text-xs text-gray-500">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
            </div>
            <input id="transportationImages" type="file" class="hidden" name="images" accept="image/*" multiple />
        </label>
    </div>

											<!-- Image preview section -->
											<div id="transportationImagesPreviewContainer" class="flex flex-wrap items-center justify-center w-full mb-4">
											    <!-- Preview images will be dynamically added here -->
											</div>
    <button type="submit" class="w-full bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition duration-300 mb-20">
        Submit
    </button>
</form>

									</div>

									<!-- Article Form -->
									<div id="articleForm"
										class="hidden z-50 bg-white max-w-md mx-auto">
										<h2
											class="text-3xl text-red-700 font-semibold mb-6 text-gray-800">Add
											Article</h2>
										<form action="UploadArticleServlet" method="post"
											enctype="multipart/form-data">
											<label for="articleTitle"
												class="block text-sm font-medium text-red-700 mb-2">Title:</label>
											<input type="text" id="articleTitle" name="articleTitle"
												required
												class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">

											<label for="articleContent"
												class="block text-sm font-medium text-red-700 mb-2">Content:</label>
											<textarea id="articleContent" name="articleContent" rows="6"
												required
												class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200"></textarea>

											<label for="articleCategory"
												class="block text-sm font-medium text-red-700 mb-2">Category:</label>
											<select id="articleCategory" name="articleCategory" required
												class="w-full border border-gray-300 p-3 rounded-lg mb-4 focus:ring focus:ring-red-200">
												<option value="Travel">Travel</option>
												<option value="Food">Food</option>
												<option value="Culture">Culture</option>
												<option value="Events">Events</option>
											</select>

											<!-- Image upload section similar to the restaurant form -->
											<div class="flex items-center justify-center w-full mb-2">
											    <label for="articleImages"
											        class="flex flex-col items-center justify-center w-full h-40 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
											        <div class="flex flex-col items-center justify-center pt-5 pb-6">
											            <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true"
											                xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
											                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
											                    stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2" />
											            </svg>
											            <p class="mb-2 text-sm text-gray-500">
											                <span class="font-semibold">Click to upload</span> or drag and drop
											            </p>
											            <p class="text-xs text-gray-500">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
											        </div>
											        <input id="articleImages" type="file" class="hidden" name="images" accept="image/*" multiple />
											    </label>
											</div>
											
											<!-- Image preview section -->
											<div id="articleImagePreviewContainer" class="flex flex-wrap items-center justify-center w-full mb-4">
											    <!-- Preview images will be dynamically added here -->
											</div>


											<button type="submit"
												class="w-full bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition duration-300 mb-20">
												Submit</button>
										</form>
									</div>

								</div>
							</div>

							<!-- Edit Drawer -->
							<div id="editDrawer"
								class="fixed inset-0 bg-gray-700 bg-opacity-50 z-50 hidden">
								<div
									class="fixed right-0 top-0 w-1/3 h-full bg-white p-6 shadow-lg">
									<button id="closeDrawer" class="text-gray-500">✕</button>
									<form id="editForm" action="editProduct" method="post">
										<input type="hidden" name="id" />
										<div id="formFields"></div>
										<button type="submit"
											class="w-full bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition duration-300">
											Save Changes</button>
									</form>
								</div>
							</div>


							<div id="btns" class="flex space-x-3">
								<!-- Sidebar Buttons -->
								<button
									class="block py-2 px-4 text-white text-lg bg-red-700 hover:bg-red-700 rounded-lg mb-2 focus:outline-none"
									onclick="openSidebarAndToggleForm('hotelForm')">
									Add Hotel</button>
								<button
									class="block py-2 px-4 text-white text-lg bg-red-700 hover:bg-red-700 rounded-lg mb-2 focus:outline-none"
									onclick="openSidebarAndToggleForm('restForm')">
									Add Restaurant</button>
								<button
									class="block py-2 px-4 text-white text-lg bg-red-700 hover:bg-red-700 rounded-lg mb-2 focus:outline-none"
									onclick="openSidebarAndToggleForm('tranForm')">
									Add Transportation</button>
								<button
									class="block py-2 px-4 text-white text-lg bg-red-700 hover:bg-red-700 rounded-lg mb-2 focus:outline-none"
									onclick="openSidebarAndToggleForm('articleForm')">
									Add Article</button>
							</div>
							<div class="flex flex-col flex-wrap">
								<!-- Room Table -->
								<div class="table-container w-full p-6">
									<div class="w-full flex items-center justify-around">
										<p class="text-xl w-1/3 font-bold text-red-700">Room</p>
										<div class="w-3/5 flex-1">
											<input id="searchInputRooms" type="text"
												placeholder="Search Rooms"
												class="mb-2 p-2 border border-gray-300 rounded" />
											<select id="sortSelectRooms"
												class="mb-2 p-2 border border-gray-300 rounded">
												<option value="none">Sort By</option>
												<option value="price">Price</option>
												<option value="promotion_price">Promotion Price</option>
												<option value="room_type">Room Type</option>
											</select>
										</div>
									</div>
									<div id="tableContainerRooms" class="overflow-x-auto"></div>
								</div>
								
										<!-- Separator Line -->
										<div class="w-full border-t border-red-500 my-6"></div>

										<!-- Restaurant Table -->
										<div class="table-container w-full p-6">
											<div class="w-full flex items-center justify-around">
												<p class="text-xl w-1/3 font-bold text-red-700">
													Restaurants</p>
												<div class="flex-1 w-3/5">
													<input id="searchInputRestaurants" type="text"
														placeholder="Search Restaurants"
														class="mb-2 w-2/3 p-2 border border-gray-300 rounded" />
													<select id="sortSelectRestaurants"
														class="mb-2 w-1/3 p-2 border border-gray-300 rounded">
														<option value="none">Sort By</option>
														<option value="price">Price</option>
														<option value="type">Type</option>
													</select>
												</div>
											</div>
											<div id="tableContainerRestaurants" class="overflow-x-auto"></div>
										</div>



<!-- Separator Line -->
										<div class="w-full border-t border-red-500 my-6"></div>
										
											
											
										<!-- Transportation Table -->
										<div class="table-container w-full md:w-1/2 p-2">
											<div class="w-full flex items-center justify-around">
												<p class="text-xl w-1/3 font-bold text-red-700">
													Transportations</p>
												<div class="flex-1 w-3/5">
													<input id="searchInputTransportation" type="text"
														placeholder="Search Transportation"
														class="mb-2 p-2 border border-gray-300 rounded" />
													<select id="sortSelectTransportation"
														class="mb-2 p-2 border border-gray-300 rounded">
														<option value="none">Sort By</option>
														<option value="price">Price</option>
														<option value="type">Type</option>
													</select>
												</div>
											</div>
											<div id="tableContainerTransportation"
												class="overflow-x-auto"></div>
										</div>



<!-- Separator Line -->
										<div class="w-full border-t border-red-500 my-6"></div>
										
											
										<!-- Article Table -->
										<div class="table-container w-full md:w-1/2 p-2">
											<div class="w-full flex items-center justify-around">
												<p class="text-xl w-1/3 font-bold text-red-700">
													Articles</p>
												<div class="w-3/5">
													<input id="searchInputArticles" type="text"
														placeholder="Search Articles"
														class="mb-2 p-2 border border-gray-300 rounded" />
													<select id="sortSelectArticles"
														class="mb-2 p-2 border border-gray-300 rounded">
														<option value="none">Sort By</option>
														<option value="title">Title</option>
													</select>
												</div>
											</div>
											<div id="tableContainerArticles" class="overflow-x-auto"></div>
										</div>
									</div>
								</div>
							</div>
				</section>

				<section id="userList"
					class="hidden absolute right-0 w-[calc(100%-20rem)] mr-10 m ml-auto">
					<h1 class="text-4xl font-bold mb-4 text-red-700 drop-shadow-lg">
						Customer History</h1>
					<!-- Search Bar -->
					<input type="text" id="searchInput" placeholder="Search..."
						class="mb-4 p-2 border border-gray-300 rounded-md w-full" />

					<!-- Tables Table -->
					<div class="overflow-x-auto w-full">
						<p class="text-xl my-3 font-bold text-red-500">Tables</p>
						<table id="customerHistoryTable"
							class="min-w-full divide-y divide-gray-200 bg-white rounded-lg">
							<thead class="bg-gray-100">
								<tr>
									<th data-sort="name"
										class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer">
										Name</th>
									<th data-sort="location"
										class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer">
										Location</th>
									<th data-sort="description"
										class="px-2 max-w-20 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer">
										Description</th>
									<th data-sort="price"
										class="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer">
										Price</th>
								</tr>
							</thead>
							<tbody class="bg-white divide-y divide-gray-200">
								<!-- Rows will be populated dynamically -->
							</tbody>
						</table>
					</div>
				</section>
			</div>
		</div>
	</section>
	<script src="innerHtmlInserter.js"></script>
	<script src="coadmin.js"></script>

	<script>

    // Close the drawer
    document.getElementById('closeDrawer').addEventListener('click', function() {
        document.getElementById('editDrawer').classList.add('hidden');
    });


    // Close the drawer
    document.getElementById('closeDrawer').addEventListener('click', function() {
        document.getElementById('editDrawer').classList.add('hidden');
    });


      function closeDrawer() {
        document.getElementById("editDrawer").classList.add("hidden");
      }

      // Close drawer when clicking on the close button
      document
        .getElementById("closeDrawer")
        .addEventListener("click", closeDrawer);

      // Show default section
      document.addEventListener("DOMContentLoaded", function () {
        changeTab("dashboard");
      });

      function changeTab(containerId) {
        // Hide all main sections
        ["dashboard", "addProduct", "userList"].forEach((id) => {
          document.getElementById(id).classList.add("hidden");
        });

        // Show selected section
        document.getElementById(containerId).classList.remove("hidden");
      }

      // JavaScript functions
      function openSidebarAndToggleForm(formId) {
        console.log(formId);
        const sidebar = document.getElementById("rightSidebar");

        // Open sidebar if it's not already open
        if (sidebar.classList.contains("translate-x-full")) {
          sidebar.classList.remove("translate-x-full");
        } else {
          sidebar.classList.add("translate-x-full");
        }

        // Hide all forms
        ["hotelForm", "restForm", "tranForm", "articleForm"].forEach((id) => {
          document.getElementById(id).classList.add("hidden");
        });

        // Show selected form
        if (formId) {
          document.getElementById(formId).classList.remove("hidden");
        }
      }

      function closeSidebar() {
        document
          .getElementById("rightSidebar")
          .classList.add("translate-x-full");
      }
    </script>
	<script>
	document.getElementById('articleImages').addEventListener('change', function(event) {
	    const files = event.target.files; // Get the selected files
	    const previewContainer = document.getElementById('articleImagePreviewContainer');
	    
	    // Clear any previous previews
	    previewContainer.innerHTML = '';

	    for (const file of files) {
	        if (file && file.type.startsWith('image/')) {
	            const reader = new FileReader();

	            reader.onload = function(e) {
	                // Create an image element for each selected file
	                const img = document.createElement('img');
	                img.src = e.target.result; // Set the src to the file data URL
	                img.alt = 'Image Preview';
	                img.className = 'max-w-full h-auto rounded-lg shadow-md'; // Tailwind classes for styling

	                // Append the image to the preview container
	                previewContainer.appendChild(img);
	            };

	            reader.readAsDataURL(file); // Read the image file as a data URL
	        }
	    }
	});
	
	document.getElementById('hotelImages').addEventListener('change', function(event) {
	    const files = event.target.files; // Get the selected files
	    const previewContainer = document.getElementById('hotelImagesPreviewContainer');
	    
	    // Clear any previous previews
	    previewContainer.innerHTML = '';

	    for (const file of files) {
	        if (file && file.type.startsWith('image/')) {
	            const reader = new FileReader();

	            reader.onload = function(e) {
	                // Create an image element for each selected file
	                const img = document.createElement('img');
	                img.src = e.target.result; // Set the src to the file data URL
	                img.alt = 'Image Preview';
	                img.className = 'max-w-full h-auto rounded-lg shadow-md'; // Tailwind classes for styling

	                // Append the image to the preview container
	                previewContainer.appendChild(img);
	            };

	            reader.readAsDataURL(file); // Read the image file as a data URL
	        }
	    }
	});
	
	document.getElementById('restaurantImages').addEventListener('change', function(event) {
	    const files = event.target.files; // Get the selected files
	    const previewContainer = document.getElementById('restaurantImagesPreviewContainer');
	    
	    // Clear any previous previews
	    previewContainer.innerHTML = '';

	    for (const file of files) {
	        if (file && file.type.startsWith('image/')) {
	            const reader = new FileReader();

	            reader.onload = function(e) {
	                // Create an image element for each selected file
	                const img = document.createElement('img');
	                img.src = e.target.result; // Set the src to the file data URL
	                img.alt = 'Image Preview';
	                img.className = 'max-w-full h-auto rounded-lg shadow-md'; // Tailwind classes for styling

	                // Append the image to the preview container
	                previewContainer.appendChild(img);
	            };

	            reader.readAsDataURL(file); // Read the image file as a data URL
	        }
	    }
	});
	
	document.getElementById('transportationImages').addEventListener('change', function(event) {
	    const files = event.target.files; // Get the selected files
	    const previewContainer = document.getElementById('transportationImagesPreviewContainer');
	    
	    // Clear any previous previews
	    previewContainer.innerHTML = '';

	    for (const file of files) {
	        if (file && file.type.startsWith('image/')) {
	            const reader = new FileReader();

	            reader.onload = function(e) {
	                // Create an image element for each selected file
	                const img = document.createElement('img');
	                img.src = e.target.result; // Set the src to the file data URL
	                img.alt = 'Image Preview';
	                img.className = 'max-w-full h-auto rounded-lg shadow-md'; // Tailwind classes for styling

	                // Append the image to the preview container
	                previewContainer.appendChild(img);
	            };

	            reader.readAsDataURL(file); // Read the image file as a data URL
	        }
	    }
	});

    document.addEventListener('DOMContentLoaded', function () {
        const openModalButton = document.getElementById('openModalButton');
        const modal = document.getElementById('modal');
        const closeModalButton = document.getElementById('closeModalButton');

        openModalButton.addEventListener('click', function () {
            modal.classList.add('active');
        });

        closeModalButton.addEventListener('click', function () {
            modal.classList.remove('active');
        });

        // Close the modal if the user clicks outside the modal content
        window.addEventListener('click', function (event) {
            if (event.target === modal) {
                modal.classList.remove('active');
            }
        });
    });
    </script>
    <script>
	document.addEventListener("DOMContentLoaded", function() {
	    // Retrieve values from localStorage
	    const coadminIdValues = localStorage.getItem('coadminId');

	        // Add more IDs as needed

	    // Get all input elements with the class 'coadminId'
	    const hiddenInputs = document.querySelectorAll('.coadminId');

	    // Check if there are enough values to populate all fields
	    if (hiddenInputs.length > 0 && coadminIdValues.length > 0) {
	        hiddenInputs.forEach((input, index) => {
	            if (index < coadminIdValues.length) {
	                input.value = coadminIdValues[index];
	            }
	        });
	    } else {
	        console.error("No hidden inputs found or no values in localStorage.");
	    }
	});
    </script>
</body>
</html>
