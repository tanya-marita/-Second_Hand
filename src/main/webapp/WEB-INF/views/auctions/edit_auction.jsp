<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Auction | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
            --bs-green: #28a745;
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

        .car-image {
            max-width: 300px;
            max-height: 200px;
            border-radius: 4px;
            margin-bottom: 10px;
        }

        .flatpickr-input {
            background-color: #2d2d2d !important;
            color: white !important;
            border-color: #444 !important;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header border-bottom border-danger">
                    <h4 class="mb-0"><i class="fas fa-gavel me-2"></i>Edit Auction</h4>
                </div>
                <div class="card-body">
                    <form id="auctionForm">
                        <input type="hidden" id="auctionId" value="${auction.id}">

                        <div class="mb-3">
                            <label class="form-label">Car Information</label>
                            <div class="card bg-dark p-3 mb-2">
                                <div class="d-flex align-items-center">
                                    <c:if test="${not empty auction.car.imageUrl}">
                                        <img src="${auction.car.imageUrl}" alt="Car Image" class="car-image me-3">
                                    </c:if>
                                    <div>
                                        <h5>${auction.car.brand} (${auction.car.manufacturedYear})</h5>
                                        <p class="mb-1">Engine: ${auction.car.engineNumber}</p>
                                        <p class="mb-1">Chassis: ${auction.car.chassisNumber}</p>
                                        <p class="mb-1">Registration: ${auction.car.registrationNumber}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="bidStartPrice" class="form-label required">Starting Bid Price ($)</label>
                            <input type="number" class="form-control" id="bidStartPrice" name="bidStartPrice"
                                   value="${auction.bidStartPrice}" min="100" step="0.01" required>
                            <div class="invalid-feedback">Please enter a valid starting price (minimum $100)</div>
                        </div>

                        <div class="mb-3">
                            <label for="status" class="form-label required">Auction Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="OPEN" ${auction.status == 'OPEN' ? 'selected' : ''}>Open</option>
                                <option value="CLOSED" ${auction.status == 'CLOSED' ? 'selected' : ''}>Closed</option>
                            </select>
                            <div class="invalid-feedback">Please select a status</div>
                        </div>

                        <div class="mb-4">
                            <label for="auctionDate" class="form-label required">Auction Date</label>
                            <input type="text" class="form-control flatpickr-input" id="auctionDate"
                                   name="auctionDate" value="${auction.auctionDate}" required readonly>
                            <div class="invalid-feedback">Please select a valid date</div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="/dashboard/auctions" class="btn btn-outline-secondary me-md-2">
                                <i class="fas fa-times me-1"></i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i> Save Changes
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
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<!-- Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<!-- Custom Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize date picker
        flatpickr("#auctionDate", {
            minDate: "today",
            dateFormat: "Y-m-d",
            allowInput: false,
            disableMobile: true
        });

        const form = document.getElementById('auctionForm');
        const feedbackDiv = document.getElementById('formFeedback');
        const auctionId = document.getElementById('auctionId').value;

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
            formData.append('bidStartPrice', document.getElementById('bidStartPrice').value);
            formData.append('status', document.getElementById('status').value);
            formData.append('auctionDate', document.getElementById('auctionDate').value);

            try {
                const response = await fetch(/api/auctions/+auctionId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });

                if (response.ok) {
                    const data = await response.json();
                    showFeedback('Auction updated successfully!', 'success');
                    setTimeout(() => {
                        window.location.href = "/dashboard/auctions";
                    }, 1500);
                } else {
                    const error = await response.text();
                    showFeedback('Error: ' + error, 'danger');
                }
            } catch (error) {
                showFeedback('Network error: ' + error.message, 'danger');
            }
        });

        function showFeedback(message, type) {
            feedbackDiv.innerHTML =
                "<div class=\"alert alert-" + type + " alert-dismissible fade show\" role=\"alert\">" +
                message +
                "<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>" +
                "</div>";
        }

    });
</script>
</body>
</html>