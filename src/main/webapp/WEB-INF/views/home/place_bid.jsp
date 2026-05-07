<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Place Bid | SecondCar</title>
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

        .bid-section {
            background-color: var(--bs-dark-light);
            border-radius: 8px;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid #2a2a2a;
        }

        .car-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }

        .car-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--bs-red);
            margin-bottom: 1rem;
        }

        .car-info {
            color: #aaa;
            margin-bottom: 1.5rem;
        }

        .current-bid {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--bs-green);
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #f8f9fa;
        }

        .form-control {
            background-color: #2d2d2d;
            border-color: #444;
            color: white;
        }

        .form-control:focus {
            background-color: #2d2d2d;
            border-color: var(--bs-red);
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
            color: white;
        }

        .btn-bid {
            background-color: var(--bs-green);
            border: none;
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-bid:hover {
            background-color: #218838;
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
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

<!-- Bid Section -->
<section class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="bid-section">
                <div class="row">
                    <div class="col-md-6">
                        <c:if test="${not empty car.imageUrl}">
                            <img src="${car.imageUrl}" class="car-image" alt="${car.brand}">
                        </c:if>
                        <c:if test="${empty car.imageUrl}">
                            <img src="https://via.placeholder.com/600x400?text=No+Image" class="car-image" alt="No Image">
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <h2 class="car-title">${car.brand} ${car.manufacturedYear}</h2>
                        <div class="car-info">
                            <p><strong>Engine:</strong> ${car.engineNumber}</p>
                            <p><strong>Chassis:</strong> ${car.chassisNumber}</p>
                            <p><strong>Registration:</strong> ${car.registrationNumber}</p>
                        </div>
                        <div class="current-bid">
                            Current Bid: $${auction.bidStartPrice}
                        </div>
                        <form id="bidForm">
                            <div class="mb-3">
                                <label for="bidAmount" class="form-label">Your Bid Amount ($)</label>
                                <input type="number" class="form-control" id="bidAmount"
                                      step="100" required>
                                <div class="form-text">Minimum bid: $${auction.bidStartPrice}</div>
                            </div>
                            <div class="d-grid">
                                <c:if test="${auction.status == 'OPEN'}">
                                    <button type="submit" class="btn btn-bid btn-lg">
                                        <i class="fas fa-gavel me-1"></i> Place Bid
                                    </button>
                                </c:if>
                                <c:if test="${auction.status != 'OPEN'}">
                                    <p>Auction Ended</p>
                                </c:if>

                            </div>
                        </form>
                    </div>
                </div>
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
<script>
    console.log(${auction.bidStartPrice})
    document.addEventListener('DOMContentLoaded', function() {

        const bidForm = document.getElementById('bidForm');
        const bidAmountInput = document.getElementById('bidAmount');



        bidForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const bidAmount = parseFloat(bidAmountInput.value);



            // Get user email from localStorage
            const userEmail = localStorage.getItem('userEmail');

            if (!userEmail) {
                alert('Please login to place a bid');
                window.location.href = '/login?redirect=' + encodeURIComponent(window.location.pathname);
                return;
            }

            const auctionId = '${auction.id}';
            const biddedAt = Math.floor(Date.now() / 1000).toString(); // Current timestamp in seconds

            // Prepare JSON data
            const jsonData = {
                userEmail: userEmail,
                bidAmount: bidAmount,
                auctionId:auctionId,
                biddedAt: biddedAt
            };

            // Submit bid to backend
            fetch('/api/bids', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(jsonData)
            })
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    return response.text().then(text => { throw new Error(text) });
                })
                .then(data => {
                    alert('Bid placed successfully!');
                    window.location.href = '/'; // Refresh the page
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error placing bid: ' + error.message);
                });
        });
    });
</script>
</body>
</html>