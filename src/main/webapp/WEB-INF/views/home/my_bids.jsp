<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bids | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
            --bs-green: #28a745;
            --bs-blue: #0d6efd;
            --bs-yellow: #ffc107;
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

        .bids-section {
            background-color: var(--bs-dark-light);
            border-radius: 8px;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid #2a2a2a;
        }

        .section-header {
            font-size: 2rem;
            font-weight: 700;
            color: var(--bs-red);
            margin-bottom: 1.5rem;
        }

        .bid-card {
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .bid-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .card-header {
            background-color: #333;
            color: #fff;
            font-weight: 600;
            border-bottom: 1px solid #444;
        }

        .card-body {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .car-details {
            margin-bottom: 1rem;
            flex-grow: 1;
        }

        .car-name {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #fff;
        }

        .car-info {
            color: #aaa;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .status-badge {
            padding: 0.5rem;
            border-radius: 4px;
            font-weight: 600;
            display: inline-block;
            min-width: 6rem;
            text-align: center;
        }

        .status-active {
            background-color: var(--bs-green);
            color: white;
        }

        .status-outbid {
            background-color: var(--bs-yellow);
            color: #212529;
        }

        .status-winning {
            background-color: var(--bs-blue);
            color: white;
        }

        .status-lost {
            background-color: var(--bs-red);
            color: white;
        }

        .bid-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: #f8f9fa;
        }

        .amount-currency {
            font-size: 1rem;
            color: #aaa;
        }

        .bidded-at {
            color: #aaa;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .auction-details {
            margin-bottom: 1rem;
            padding: 0.75rem;
            background-color: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        .auction-info {
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
        }

        .auction-title {
            font-weight: 600;
            color: #fff;
            margin-bottom: 0.5rem;
        }

        .card-footer {
            background-color: #333;
            border-top: 1px solid #444;
            padding: 0.75rem;
        }

        .btn-primary {
            background-color: var(--bs-red);
            border: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-outline-danger {
            border-color: var(--bs-red);
            color: var(--bs-red);
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-outline-danger:hover {
            background-color: var(--bs-red);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .no-bids-message {
            text-align: center;
            font-size: 1.25rem;
            color: #999;
            padding: 3rem 0;
        }

        .grid-layout {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }

        /* Media queries for responsive grid */
        @media (max-width: 1199.98px) {
            .grid-layout {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 767.98px) {
            .grid-layout {
                grid-template-columns: 1fr;
            }
        }

        /* Pill filters */
        .filter-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 2rem;
        }

        .filter-pill {
            background-color: #333;
            border: 1px solid #444;
            color: #fff;
            border-radius: 20px;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .filter-pill:hover, .filter-pill.active {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
            color: #fff;
        }

        .grid-view-toggle {
            margin-left: auto;
        }

        .grid-view-toggle .btn {
            background-color: #333;
            border: 1px solid #444;
            color: #aaa;
            padding: 0.375rem 0.75rem;
        }

        .grid-view-toggle .btn.active {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
            color: #fff;
        }

        .card-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 0.75rem;
        }

        .card-actions .btn {
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
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
                <li class="nav-item">
                    <a class="nav-link active" href="#">My Bids</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">

                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/logout">
                        <i class="fas fa-sign-out-alt me-1"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- My Bids Section -->
<section class="container my-5">
    <div class="bids-section">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="section-header mb-0">My Bids</h2>
            <div class="grid-view-toggle">

            </div>
        </div>

        <div class="filter-pills mb-4">
            <div class="filter-pill active" data-filter="all">All Bids</div>
            <div class="filter-pill" data-filter="ACTIVE">Active</div>
            <div class="filter-pill" data-filter="WINNING">Winning</div>
            <div class="filter-pill" data-filter="OUTBID">Outbid</div>
            <div class="filter-pill" data-filter="LOST">Lost</div>
        </div>

        <c:choose>
            <c:when test="${empty bids}">
                <div class="no-bids-message">
                    <i class="fas fa-gavel fa-3x mb-3 text-muted"></i>
                    <p>You haven't placed any bids yet.</p>
                    <a href="/all-auctions" class="btn btn-primary mt-3">
                        <i class="fas fa-search me-2"></i>Browse Auctions
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid-layout">
                    <c:forEach var="bid" items="${bids}">
                        <div class="bid-card" data-status="${bid.status}">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span>Bid #${bid.id.substring(bid.id.lastIndexOf('-') + 1)}</span>
                                <span class="status-badge
                                <c:choose>
                                    <c:when test="${bid.status eq 'ACTIVE'}">status-active</c:when>
                                    <c:when test="${bid.status eq 'OUTBID'}">status-outbid</c:when>
                                    <c:when test="${bid.status eq 'WINNING'}">status-winning</c:when>
                                    <c:when test="${bid.status eq 'LOST'}">status-lost</c:when>
                                </c:choose>
                                ">${bid.status}</span>
                            </div>

                            <div class="card-body">
                                <div class="car-details">
                                    <h5 class="car-name">${bid.car.manufacturedYear} ${bid.car.brand}</h5>
                                    <div class="car-info">
                                        <i class="fas fa-hashtag me-1"></i>Chassis: ${bid.car.chassisNumber}
                                    </div>
                                    <div class="car-info">
                                        <i class="fas fa-engine me-1"></i>Engine: ${bid.car.engineNumber}
                                    </div>
                                </div>

                                <div class="auction-details">
                                    <div class="auction-title">
                                        <i class="fas fa-gavel me-1"></i>Auction Details
                                    </div>
                                    <div class="auction-info">
                                        <strong>Start Price:</strong> $${bid.auction.bidStartPrice}
                                    </div>
                                    <div class="auction-info">
                                        <strong>Date:</strong> ${bid.auction.auctionDate}
                                    </div>
                                    <div class="auction-info">
                                        <strong>Status:</strong> ${bid.auction.status}
                                    </div>
                                </div>

                                <div class="bid-amount">
                                    <span class="amount-currency">$</span>${bid.bidAmount}
                                </div>

                            </div>

                            <div class="card-footer">
                                <div class="card-actions">


                                    <c:if test="${bid.status eq 'ACTIVE'}">
                                        <button class="btn btn-outline-danger delete-bid-btn"
                                                data-bs-toggle="modal"
                                                data-bs-target="#deleteBidModal"
                                                data-bid-id="${bid.id}">
                                            <i class="fas fa-trash-alt me-1"></i>Delete
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteBidModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content bg-dark">
            <div class="modal-header border-bottom border-secondary">
                <h5 class="modal-title text-danger">Delete Bid Confirmation</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this bid?</p>
                <p>This action cannot be undone.</p>
            </div>
            <div class="modal-footer border-top border-secondary">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete Bid</button>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p>&copy; 2025 SecondCar. All rights reserved.</p>
    </div>
</footer>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set up the delete bid functionality
        let bidIdToDelete = null;

        // When delete button is clicked, store the bid ID
        const deleteBtns = document.querySelectorAll('.delete-bid-btn');
        deleteBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                bidIdToDelete = this.getAttribute('data-bid-id');
                document.getElementById('confirmDeleteBtn').setAttribute('data-bid-id', bidIdToDelete);
            });
        });

        // When confirm delete button is clicked
        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (bidIdToDelete) {
                deleteBid(bidIdToDelete);
            }
        });

        // Filter functionality
        const filterPills = document.querySelectorAll('.filter-pill');
        filterPills.forEach(pill => {
            pill.addEventListener('click', function() {
                // Remove active class from all pills
                filterPills.forEach(p => p.classList.remove('active'));

                // Add active class to clicked pill
                this.classList.add('active');

                const filter = this.getAttribute('data-filter');
                const bidCards = document.querySelectorAll('.bid-card');

                bidCards.forEach(card => {
                    if (filter === 'all' || card.getAttribute('data-status') === filter) {
                        card.style.display = 'flex';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    });

    function deleteBid(bidId) {
        fetch(`/api/bids/${bidId}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to delete bid');
                }
                // Close the modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('deleteBidModal'));
                modal.hide();

                // Show success message and reload page
                alert('Bid successfully deleted');
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting bid: ' + error.message);
            });
    }
</script>
</body>
</html>