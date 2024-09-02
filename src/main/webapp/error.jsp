<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-lg text-center">
        <h1 class="text-2xl font-bold text-red-600">Oops! Something went wrong.</h1>
        <p class="text-gray-700 mt-4">An error occurred while processing your request. Please try again later.</p>
        <!-- Simplified error message for debugging -->
        <p class="text-gray-500 mt-2">Error details: <%= request.getAttribute("javax.servlet.error.message") %></p>
        <a href="index.jsp" class="mt-6 inline-block bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">Go Back to Home</a>
    </div>
</body>
</html>
