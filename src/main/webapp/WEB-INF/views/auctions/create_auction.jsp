<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Auction | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Flatpickr for date picker -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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

        .form-control:focus, .form-select:focus {
            border-color: var(--bs-red);
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
            background-color: #2d2d2d;
            color: white;
        }

        .invalid-feedback {
            color: var(--bs-red);
        }

        .form-label.required:after {
            content: " *";
            color: var(--bs-red);
        }

        .form-control, .form-select {
            background-color: #2d2d2d;
            border-color: #444;
            color: white;
        }

        .flatpickr-input {
            background-color: #2d2d2d !important;
            color: white !important;
            border-color: #444 !important;
        }

        .car-option {
            display: flex;
            align-items: center;
        }
        .car-option img {
            width: 50px;
            height: 30px;
            object-fit: cover;
            margin-right: 10px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header border-bottom border-danger">
                    <h4 class="mb-0"><i class="fas fa-gavel me-2"></i>Create New Auction</h4>
                </div>
                <div class="card-body">
                    <form id="auctionForm">
                        <div class="mb-3">
                            <label for="carId" class="form-label required">Select Car</label>
                            <select class="form-select" id="carId" name="carId" required>
                                <option value="" selected disabled>Select a car...</option>
                                <c:forEach items="${cars}" var="car">
                                    <option value="${car.id}" data-image="${car.imageUrl}">
                                            ${car.brand} - ${car.registrationNumber} (${car.manufacturedYear})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please select a car</div>
                        </div>

                        <div class="mb-3">
                            <label for="bidStartPrice" class="form-label required">Starting Bid Price ($)</label>
                            <input type="number" class="form-control" id="bidStartPrice" name="bidStartPrice"
                                   min="100" step="0.01" required>
                            <div class="invalid-feedback">Please enter a valid starting price (minimum $100)</div>
                        </div>

                        <div class="mb-3">
                            <label for="status" class="form-label required">Auction Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="" selected disabled>Select status...</option>
                                <option value="OPEN">Open</option>
                                <option value="CLOSED">Closed</option>
                            </select>
                            <div class="invalid-feedback">Please select a status</div>
                        </div>

                        <div class="mb-3">
                            <label for="auctionDate" class="form-label required">Auction Date</label>
                            <input type="text" class="form-control flatpickr-input" id="auctionDate"
                                   name="auctionDate" placeholder="Select date..." required readonly>
                            <div class="invalid-feedback">Please select a valid date</div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Create Auction
                            </button>
                        </div>
                    </form>

                    <div id="formFeedback" class="mt-3"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<!-- Custom Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('auctionForm');
        const feedbackDiv = document.getElementById('formFeedback');
        const carSelect = document.getElementById('carId');

        // Initialize date picker
        flatpickr("#auctionDate", {
            minDate: "today",
            dateFormat: "Y-m-d",
            allowInput: false,
            disableMobile: true
        });

        // Custom select with images
        carSelect.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            if (selectedOption.dataset.image) {
                // You could show a preview here if needed
            }
        });

        // Form submission
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            // Validate form
            if (!form.checkValidity()) {
                e.stopPropagation();
                form.classList.add('was-validated');
                return;
            }

            // Prepare form data
            const formData = new URLSearchParams();
            formData.append('carId', carSelect.value);
            formData.append('bidStartPrice', document.getElementById('bidStartPrice').value);
            formData.append('status', document.getElementById('status').value);
            formData.append('auctionDate', document.getElementById('auctionDate').value);

            try {
                const response = await fetch('/api/auctions', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });

                if (response.ok) {
                    const data = await response.json();
                    showFeedback('Auction created successfully!', 'success');
                    form.reset();
                    form.classList.remove('was-validated');
                } else {
                    const error = await response.text();
                    showFeedback('Error: ' + error, 'danger');
                }
            } catch (error) {
                showFeedback('Network error: ' + error.message, 'danger');
            }
        });

        function showFeedback(message, type) {
            alert(message);
            window.location.href = "/dashboard/auctions";
        }
    });
</script>
</body>
</html>