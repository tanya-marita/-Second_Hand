<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
            --bs-dark: #121212;
            --bs-dark-light: #1e1e1e;
        }

        body {
            background-color: var(--bs-dark);
            color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar {
            background-color: var(--bs-dark-light);
            border-bottom: 1px solid var(--bs-red);
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--bs-red) !important;
        }

        .car-detail-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 2rem;
        }

        .car-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--bs-red);
            margin-bottom: 1rem;
        }

        .car-subtitle {
            font-size: 1.25rem;
            color: #aaa;
            margin-bottom: 2rem;
        }

        .specs-list {
            list-style: none;
            padding: 0;
        }

        .specs-list li {
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #2a2a2a;
        }

        .spec-label {
            font-weight: 600;
            color: var(--bs-red);
            display: inline-block;
            width: 150px;
        }

        .btn-outline-red {
            color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-outline-red:hover {
            background-color: var(--bs-red);
            color: white;
        }

        .btn-lg {
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <i class="fas fa-car me-2"></i>SecondCar
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/all-cars">Cars</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/all-auctions">Auctions</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Login
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Car Detail Section -->
<section class="container my-5">
    <div class="row">
        <div class="col-lg-6">
            <c:if test="${not empty car.imageUrl}">
                <img src="${car.imageUrl}" class="car-detail-image" alt="${car.brand}">
            </c:if>
            <c:if test="${empty car.imageUrl}">
                <img src="https://via.placeholder.com/800x400?text=No+Image" class="car-detail-image" alt="No Image">
            </c:if>
        </div>
        <div class="col-lg-6">
            <h1 class="car-title">${car.brand}</h1>
            <h2 class="car-subtitle">${car.manufacturedYear} • ${car.manufacturedCountry}</h2>

            <ul class="specs-list">
                <li><span class="spec-label">Engine Number:</span> ${car.engineNumber}</li>
                <li><span class="spec-label">Chassis Number:</span> ${car.chassisNumber}</li>
                <li><span class="spec-label">Registration:</span> ${car.registrationNumber}</li>
                <li><span class="spec-label">Brand:</span> ${car.brand}</li>
                <li><span class="spec-label">Manufactured:</span> ${car.manufacturedCountry}</li>
                <li><span class="spec-label">Year:</span> ${car.manufacturedYear}</li>
            </ul>

            <div class="mt-4">
                <a href="/all-cars" class="btn btn-outline-red me-3">
                    <i class="fas fa-arrow-left me-1"></i> Back to Cars
                </a>
                <a href="/all-auctions" class="btn btn-outline-red">
                    <i class="fas fa-gavel me-1"></i> View Auctions
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white py-4">
    <div class="container text-center">
        <p>&copy; 2025 SecondCar. All rights reserved.</p>
    </div>
</footer>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>