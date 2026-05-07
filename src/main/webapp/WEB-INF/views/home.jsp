<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SecondCar | Premium Used Cars</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <!-- Custom CSS -->
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

        .nav-link {
            color: #f8f9fa !important;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            color: var(--bs-red) !important;
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
            url('https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            margin-bottom: 3rem;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .hero-subtitle {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
        }

        .btn-hero {
            background-color: var(--bs-red);
            border: none;
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-hero:hover {
            background-color: #c82333;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
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

        .badge-status {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 0.8rem;
            padding: 0.35rem 0.75rem;
        }

        .badge-open {
            background-color: #28a745;
        }

        .badge-closed {
            background-color: var(--bs-red);
        }

        .footer {
            background-color: var(--bs-dark-light);
            padding: 3rem 0;
            margin-top: 3rem;
            border-top: 1px solid var(--bs-red);
        }

        .footer-title {
            color: var(--bs-red);
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .footer-link {
            color: #aaa;
            text-decoration: none;
            transition: all 0.3s ease;
            display: block;
            margin-bottom: 0.5rem;
        }

        .footer-link:hover {
            color: var(--bs-red);
            transform: translateX(5px);
        }

        .social-icon {
            color: #aaa;
            font-size: 1.5rem;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }

        .social-icon:hover {
            color: var(--bs-red);
            transform: translateY(-3px);
        }

        /* Animation classes */
        .fade-in {
            animation: fadeIn 1s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .slide-up {
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .carousel-item img {
            height: 80vh;
            object-fit: cover;
        }

        .carousel-caption {
            background-color: rgba(0, 0, 0, 0.7);
            border-radius: 5px;
            padding: 15px;
        }

        .section-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .carousel-indicators {
            bottom: -50px;
        }

        .carousel-control-prev,
        .carousel-control-next {
            width: 5%;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container">
        <a class="navbar-brand animate_animated animate_fadeIn" href="/">
            <i class="fas fa-car me-2"></i>SecondCar
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="/">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/all-cars">Cars</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/all-auctions">Auctions</a>
                </li>

            </ul>
            <ul class="navbar-nav" id="authNav">
                <li class="nav-item">
                    <a class="nav-link" href="/login" id="loginLink">
                        <i class="fas fa-sign-in-alt me-1"></i>Login
                    </a>
                </li>
                <li class="nav-item d-none" id="profileItem">
                    <a id="profileLink" class="nav-link" href="#">
                        <i class="fas fa-user-circle me-1"></i>Profile
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section animate_animated animate_fadeIn">
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1 class="hero-title animate_animated animate_fadeInDown">Premium Used Cars</h1>
                <p class="hero-subtitle animate_animated animate_fadeInUp">Find your dream car at unbeatable prices</p>
                <a href="/all-cars" class="btn btn-hero btn-lg animate_animated animatepulse animate_infinite">
                    Browse Inventory
                </a>
            </div>
        </div>
    </div>
</section>
<!-- Advertisements Section -->
<section class="container-fluid px-0 mb-5" style="height: 100vh;margin-right: 64px;margin-left: 64px;width:calc(100vw - 140px)">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="section-title">Latest Offers</h2>
        </div>
    </div>

    <div id="advertisementCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <c:forEach items="${ads}" var="ad" varStatus="status">
                <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="${status.index}" class="${status.index == 0 ? 'active' : ''}"></button>
            </c:forEach>
        </div>

        <div class="carousel-inner">
            <c:forEach items="${ads}" var="ad" varStatus="status">
                <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                    <c:if test="${not empty ad.imageUrl}">
                        <img src="${ad.imageUrl}" class="d-block w-100" alt="${ad.title}">
                    </c:if>
                    <c:if test="${empty ad.imageUrl}">
                        <img src="https://via.placeholder.com/1200x300?text=No+Image" class="d-block w-100" alt="No Image">
                    </c:if>
                    <div class="carousel-caption d-none d-md-block">
                        <h1 style="color:white;text-transform: uppercase;font-weight: bold">${ad.title}</h1>
                        <h3 style="color:white">${ad.description.length() > 150 ? ad.description.substring(0, 150) + '...' : ad.description}</h3>
                    </div>
                </div>
            </c:forEach>
        </div>

        <button class="carousel-control-prev" type="button" data-bs-target="#advertisementCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#advertisementCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>
</section>
<!-- Featured Cars Section -->
<section class="container mb-5 slide-up">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="section-title">Featured Cars</h2>
        </div>
    </div>
    <div class="row">
        <c:forEach items="${cars}" var="car" end="3">
            <div class="col-md-6 col-lg-3 fade-in">
                <div class="card">
                    <c:if test="${not empty car.imageUrl}">
                        <img src="${car.imageUrl}" class="card-img-top" alt="${car.brand}">
                    </c:if>
                    <c:if test="${empty car.imageUrl}">
                        <img src="https://via.placeholder.com/300x200?text=No+Image" class="card-img-top" alt="No Image">
                    </c:if>
                    <div class="card-body">
                        <h5 class="card-title">${car.brand}</h5>
                        <p class="card-text">
                            <strong>Year:</strong> ${car.manufacturedYear}<br>
                            <strong>Engine:</strong> ${car.engineNumber}<br>

                        </p>
                        <a href="/car/${car.id}" class="btn btn-outline-danger">View Details</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="row mt-4">
        <div class="col-12 text-center">
            <a href="/all-cars" class="btn btn-outline-danger btn-lg">View All Cars</a>
        </div>
    </div>
</section>

<!-- Active Auctions Section -->
<section class="container mb-5 slide-up" style="animation-delay: 0.2s;">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="section-title">Live Auctions</h2>
        </div>
    </div>
    <div class="row">
        <c:forEach items="${auctions}" var="auction" end="3">
            <div class="col-md-6 col-lg-3 fade-in">
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

                            <strong>Auction Ends:</strong> ${auction.auctionDate}<br>
                            <strong>Status:</strong> ${auction.status}
                        </p>
                        <a href="/bid/${auction.id}" class="btn btn-outline-danger">Place Bid</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="row mt-4">
        <div class="col-12 text-center">
            <a href="/all-auctions" class="btn btn-outline-danger btn-lg">View All Auctions</a>
        </div>
    </div>
</section>



<!-- Footer -->
<footer class="footer slide-up" style="animation-delay: 0.6s;">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4 mb-md-0">
                <h3 class="footer-title">SecondCar</h3>
                <p>Your trusted partner for premium used cars at competitive prices.</p>
                <div class="mt-3">
                    <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="col-md-2 mb-4 mb-md-0">
                <h3 class="footer-title">Quick Links</h3>
                <a href="/" class="footer-link">Home</a>
                <a href="/all-cars" class="footer-link">Cars</a>
                <a href="/all-auctions" class="footer-link">Auctions</a>
            </div>
            <div class="col-md-3 mb-4 mb-md-0">
                <h3 class="footer-title">Contact Us</h3>
                <p><i class="fas fa-map-marker-alt me-2"></i> 123 Car Street, Auto City</p>
                <p><i class="fas fa-phone me-2"></i> +1 (555) 123-4567</p>
                <p><i class="fas fa-envelope me-2"></i> info@secondcar.com</p>
            </div>
            <div class="col-md-3">
                <h3 class="footer-title">Newsletter</h3>
                <p>Subscribe to get updates on new arrivals and special offers.</p>
                <div class="input-group mb-3">
                    <input type="email" class="form-control" placeholder="Your Email">
                    <button class="btn btn-danger" type="button">Subscribe</button>
                </div>
            </div>
        </div>
        <hr class="my-4 bg-secondary">
        <div class="row">
            <div class="col-12 text-center">
                <p class="mb-0">&copy; 2025 SecondCar. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Check if user is logged in (check localStorage)
        const userId = localStorage.getItem('userEmail');
        const loginLink = document.getElementById('loginLink');
        const profileItem = document.getElementById('profileItem');

        if (userId) {
            // User is logged in
            loginLink.parentElement.classList.add('d-none');
            profileItem.classList.remove('d-none');
        } else {
            // User is not logged in
            loginLink.parentElement.classList.remove('d-none');
            profileItem.classList.add('d-none');
        }

        // Add animation to cards on scroll
        const animateOnScroll = function() {
            const cards = document.querySelectorAll('.fade-in');
            cards.forEach(card => {
                const cardPosition = card.getBoundingClientRect().top;
                const screenPosition = window.innerHeight / 1.3;

                if (cardPosition < screenPosition) {
                    card.style.opacity = '1';
                }
            });
        };

        // Set initial opacity for fade-in cards
        document.querySelectorAll('.fade-in').forEach(card => {
            card.style.opacity = '0';
            card.style.transition = 'opacity 0.6s ease-out';
        });

        window.addEventListener('scroll', animateOnScroll);
        animateOnScroll(); // Run once on load
    });
    const userEmail = localStorage.getItem("userEmail");
    if (userEmail) {
        document.getElementById("profileLink").href = "/dashboard/profile/" + userEmail;
    }
    document.addEventListener('DOMContentLoaded', function() {
        var myCarousel = new bootstrap.Carousel(document.getElementById('advertisementCarousel'), {
            interval: 5000,
            wrap: true,
            keyboard: true
        });
    });
</script>
</body>
</html>