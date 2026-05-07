<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advertisements | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
        }

        body {
            background-color: #121212;
            color: #f8f9fa;
        }

        .card {
            background-color: #1e1e1e;
            border: 1px solid var(--bs-red);
        }

        .btn-primary {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-primary:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        .btn-outline-danger {
            color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-outline-danger:hover {
            background-color: var(--bs-red);
            color: white;
        }

        .table-dark {
            background-color: #1e1e1e;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(220, 53, 69, 0.1);
        }

        .search-box {
            background-color: #2d2d2d;
            border-color: #444;
            color: white;
        }

        .search-box:focus {
            border-color: var(--bs-red);
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
            background-color: #2d2d2d;
            color: white;
        }

        .ad-image {
            max-width: 100px;
            max-height: 60px;
            object-fit: cover;
            border-radius: 4px;
        }

        .action-col {
            width: 150px;
        }
    </style>
</head>
<body>
<div class="container-fluid py-4">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <h2><i class="fas fa-ad me-2"></i>Advertisements</h2>
                <div>
                    <a href="/dashboard/create-advertisement" class="btn btn-primary">
                        <i class="fas fa-plus me-1"></i> Create New
                    </a>
                    <a href="/dashboard" class="btn btn-primary">
                        <i class="fas fa-home me-1"></i> Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="input-group">
                <span class="input-group-text bg-dark border-dark">
                    <i class="fas fa-search"></i>
                </span>
                <input type="text" id="searchInput" class="form-control search-box" placeholder="Search advertisements...">
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-dark table-hover mb-0" id="adsTable">
                            <thead>
                            <tr>
                                <th>Image</th>
                                <th>Title</th>
                                <th>Description</th>
                                <th class="text-end action-col">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${users}" var="ad">
                                <tr>
                                    <td>
                                        <c:if test="${not empty ad.imageUrl}">
                                            <img src="${ad.imageUrl}" alt="Ad Image" class="ad-image">
                                        </c:if>
                                    </td>
                                    <td>${ad.title}</td>
                                    <td>${ad.description.length() > 50 ? ad.description.substring(0, 50) + '...' : ad.description}</td>
                                    <td class="text-end">
                                        <a href="/dashboard/edit-advertisement/${ad.id}" class="btn btn-sm btn-outline-primary me-1">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${ad.id}">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Custom Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Search functionality
        const searchInput = document.getElementById('searchInput');
        searchInput.addEventListener('keyup', function() {
            const value = this.value.toLowerCase();
            const rows = document.querySelectorAll('#adsTable tbody tr');

            rows.forEach(row => {
                const title = row.cells[1].textContent.toLowerCase();
                const description = row.cells[2].textContent.toLowerCase();
                row.style.display = (title.includes(value) || description.includes(value)) ? '' : 'none';
            });
        });

        // Delete confirmation
        const deleteButtons = document.querySelectorAll('.delete-btn');
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const adId = this.getAttribute('data-id');

                if (confirm('Are you sure you want to delete this advertisement?')) {
                    fetch("/api/ads/"+ adId +"/hard", {
                        method: 'DELETE'
                    })
                        .then(response => {
                            if (response.ok) {
                                window.location.reload();
                            } else {
                                alert('Failed to delete advertisement');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('An error occurred while deleting the advertisement');
                        });
                }
            });
        });
    });
</script>
</body>
</html>