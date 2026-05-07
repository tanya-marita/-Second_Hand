<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function logout(confirmLogout) {
            if (confirmLogout) {
                localStorage.clear();
                window.location.href = "/login";
            } else {
                window.history.back();
            }
        }
    </script>
</head>
<body class="bg-light d-flex justify-content-center align-items-center vh-100">
<div class="card p-4 shadow" style="max-width: 400px;">
    <h4 class="text-center mb-4">Are you sure you want to logout?</h4>
    <div class="d-flex justify-content-between">
        <button class="btn btn-danger w-45" onclick="logout(true)">Yes, Logout</button>
        <button class="btn btn-secondary w-45" onclick="logout(false)">No, Go Back</button>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>