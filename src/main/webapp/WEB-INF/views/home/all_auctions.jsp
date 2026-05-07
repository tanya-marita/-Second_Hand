<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Auctions | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
            --bs-green: #28a745;
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

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
            url('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2083&q=80');
            background-size: cover;
            background-position: center;
            height: 40vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            margin-bottom: 3rem;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .card {
            background-color: var(--bs-dark-light);
            border: 1px solid #2a2a2a;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
            height: 100%;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            border-color: var(--bs-red);
        }

        .card-img-top {
            height: 200px;
            object-fit: cover;
        }

        .card-title {
            font-weight: 600;
            color: var(--bs-red);
        }

        .card-text {
            color: #aaa;
        }

        .btn-outline-red {
            color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-outline-red:hover {
            background-color: var(--bs-red);
            color: white;
        }

        .btn-outline-green {
            color: var(--bs-green);
            border-color: var(--bs-green);
        }

        .btn-outline-green:hover {
            background-color: var(--bs-green);
            color: white;
        }

        .section-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 2rem;
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 50px;
            height: 3px;
            background-color: var(--bs-red);
        }

        .badge-status {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 0.8rem;
            padding: 0.35rem 0.75rem;
        }

        .badge-open {
            background-color: var(--bs-green);
        }

        .badge-closed {
            background-color: var(--bs-red);
        }

        .pagination .page-item.active .page-link {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .pagination .page-link {
            color: var(--bs-red);
            background-color: var(--bs-dark-light);
            border-color: #2a2a2a;
        }

        .pagination .page-link:hover {
            color: white;
            background-color: #333;
            border-color: #444;
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
                <li class="nav-item active">
                    <a class="nav-link" href="/all-auctions">Auctions</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">

                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <h1 class="hero-title">Live Auctions</h1>
    </div>
</section>

<!-- Auctions Section -->
<section class="container mb-5">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="section-title">Current Auctions</h2>
        </div>
    </div>
    <div class="row">
        <c:forEach items="${auctions}" var="auction">
            <div class="col-md-6 col-lg-4">
                <div class="card">
                        <span class="badge badge-status ${auction.status == 'OPEN' ? 'badge-open' : 'badge-closed'}">
                                ${auction.status}
                        </span>
                    <c:if test="${not empty auction.car.imageUrl}">
                        <img src="${auction.car.imageUrl}" class="card-img-top" alt="${auction.car.brand}">
                    </c:if>
                    <c:if test="${empty auction.car.imageUrl}">
                        <img src="https://via.placeholder.com/300x200?text=No+Image" class="card-img-top" alt="No Image">
                    </c:if>
                    <div class="card-body">
                        <h5 class="card-title">${auction.car.brand}</h5>
                        <p class="card-text">
                            <strong>Year:</strong> ${auction.car.manufacturedYear}<br>
                            <strong>Current Bid:</strong> $${auction.bidStartPrice}<br>
                            <strong>Ends:</strong> ${auction.auctionDate}
                        </p>
                        <a href="/bid/${auction.id}" class="btn ${auction.status == 'OPEN' ? 'btn-outline-green' : 'btn-outline-red'}">
                                ${auction.status == 'OPEN' ? 'Place Bid' : 'View Details'}
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="row mt-4">

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