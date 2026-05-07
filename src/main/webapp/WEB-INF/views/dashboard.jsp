<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
            --sidebar-width: 250px;
        }

        body {
            background-color: #121212;
            color: #f8f9fa;
            min-height: 100vh;
        }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background-color: #1a1a1a;
            border-right: 1px solid var(--bs-red);
            transition: all 0.3s;
            z-index: 1000;
        }

        .sidebar-brand {
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-bottom: 1px solid var(--bs-red);
        }

        .sidebar-nav {
            padding: 1rem 0;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 0.75rem 1.5rem;
            margin: 0.25rem 0;
            border-left: 3px solid transparent;
            transition: all 0.3s;
        }

        .nav-link:hover, .nav-link.active {
            color: white;
            background-color: rgba(220, 53, 69, 0.1);
            border-left: 3px solid var(--bs-red);
        }

        .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .main-content {

            padding: 20px;
            transition: all 0.3s;
        }

        .dashboard-card {
            background-color: #1e1e1e;
            border: 1px solid #2a2a2a;
            border-top: 3px solid var(--bs-red);
            transition: all 0.3s;
            height: 100%;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .card-icon {
            font-size: 2.5rem;
            color: var(--bs-red);
            margin-bottom: 1rem;
        }

        .card-title {
            color: var(--bs-red);
        }

        .btn-outline-red {
            color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-outline-red:hover {
            background-color: var(--bs-red);
            color: white;
        }

        .welcome-card {
            background-color: #1e1e1e;
            border: 1px solid var(--bs-red);
        }
    </style>
</head>
<body>
<!-- Main Content -->
<div class="main-content">
    <div class="container-fluid">
        <!-- Welcome Card -->
        <div class="card welcome-card mb-4">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="card-title">Welcome back, <span class="text-red">${user.firstName}!</span></h3>
                        <p class="mb-0">Here's what's happening with your SecondCar system today.</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <img src="https://purepng.com/public/uploads/large/purepng.com-red-audi-caraudicars-961524670920vwzc6.png"
                             alt="Car" style="max-height: 100px;">
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Cards -->
        <div class="row">
            <!-- Cars Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-car-side"></i>
                        </div>
                        <h5 class="card-title">Cars</h5>
                        <p class="card-text">Manage all vehicles in the system</p>
                        <a href="/dashboard/cars" class="btn btn-outline-red">
                            <i class="fas fa-list me-2"></i>View All
                        </a>
                    </div>
                </div>
            </div>

            <!-- Create Car Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                        <h5 class="card-title">Create Car</h5>
                        <p class="card-text">Add a new vehicle to the system</p>
                        <a href="/dashboard/create-car" class="btn btn-outline-red">
                            <i class="fas fa-plus me-2"></i>Create New
                        </a>
                    </div>
                </div>
            </div>

            <!-- Users Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h5 class="card-title">Users</h5>
                        <p class="card-text">Manage system users and permissions</p>
                        <a href="/dashboard/users" class="btn btn-outline-red">
                            <i class="fas fa-list me-2"></i>View All
                        </a>
                    </div>
                </div>
            </div>

            <!-- Create User Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <h5 class="card-title">Create User</h5>
                        <p class="card-text">Register a new system user</p>
                        <a href="/dashboard/create-user" class="btn btn-outline-red">
                            <i class="fas fa-plus me-2"></i>Create New
                        </a>
                    </div>
                </div>
            </div>

            <!-- Auctions Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-gavel"></i>
                        </div>
                        <h5 class="card-title">Auctions</h5>
                        <p class="card-text">Manage ongoing and past auctions</p>
                        <a href="/dashboard/auctions" class="btn btn-outline-red">
                            <i class="fas fa-list me-2"></i>View All
                        </a>
                    </div>
                </div>
            </div>

            <!-- Create Auction Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                        <h5 class="card-title">Create Auction</h5>
                        <p class="card-text">Start a new vehicle auction</p>
                        <a href="/dashboard/create-auction" class="btn btn-outline-red">
                            <i class="fas fa-plus me-2"></i>Create New
                        </a>
                    </div>
                </div>
            </div>

            <!-- Bids Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-hand-holding-usd"></i>
                        </div>
                        <h5 class="card-title">Bids</h5>
                        <p class="card-text">View and manage all bids</p>
                        <a href="/dashboard/bids" class="btn btn-outline-red">
                            <i class="fas fa-list me-2"></i>View All
                        </a>
                    </div>
                </div>
            </div>

            <!-- Advertisements Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-ad"></i>
                        </div>
                        <h5 class="card-title">Advertisements</h5>
                        <p class="card-text">Manage system advertisements</p>
                        <a href="/dashboard/advertisements" class="btn btn-outline-red">
                            <i class="fas fa-list me-2"></i>View All
                        </a>
                    </div>
                </div>
            </div>

            <!-- Create Advertisement Card -->
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="card-icon">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                        <h5 class="card-title">Create Advertisement</h5>
                        <p class="card-text">Create a new advertisement</p>
                        <a href="/dashboard/create-advertisement" class="btn btn-outline-red">
                            <i class="fas fa-plus me-2"></i>Create New
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity Section -->
        <div class="card mt-4">
            <a href="/logout"> <button

            >Logout</button></a>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom JS -->
<script>
    // Highlight active menu item
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-link');

        navLinks.forEach(link => {
            if (link.getAttribute('href').startsWith(currentPath)) {
                link.classList.add('active');
                link.parentElement.classList.add('active');
            }
        });
    });
</script>
</body>
</html>