<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Car | SecondCar</title>
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

        .form-control:focus {
            border-color: var(--bs-red);
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
        }

        .invalid-feedback {
            color: var(--bs-red);
        }

        .preview-image {
            max-width: 100%;
            max-height: 200px;
            margin-top: 10px;
            display: none;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header border-bottom border-danger">
                    <h4 class="mb-0"><i class="fas fa-car me-2"></i>Add New Car</h4>
                </div>
                <div class="card-body">
                    <form id="carForm" enctype="multipart/form-data">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="engineNumber" class="form-label">Engine Number</label>
                                <input type="text" class="form-control" id="engineNumber" name="engineNumber" required>
                                <div class="invalid-feedback">Please provide a valid engine number</div>
                            </div>
                            <div class="col-md-6">
                                <label for="chassisNumber" class="form-label">Chassis Number</label>
                                <input type="text" class="form-control" id="chassisNumber" name="chassisNumber" required>
                                <div class="invalid-feedback">Please provide a valid chassis number</div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="brand" class="form-label">Brand</label>
                                <input type="text" class="form-control" id="brand" name="brand" required>
                                <div class="invalid-feedback">Please provide a brand</div>
                            </div>
                            <div class="col-md-6">
                                <label for="manufacturedYear" class="form-label">Manufactured Year</label>
                                <input type="number" class="form-control" id="manufacturedYear" name="manufacturedYear"
                                       min="1900" max="2023" required>
                                <div class="invalid-feedback">Please provide a valid year</div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="manufacturedCountry" class="form-label">Manufactured Country</label>
                                <input type="text" class="form-control" id="manufacturedCountry" name="manufacturedCountry" required>
                                <div class="invalid-feedback">Please provide a country</div>
                            </div>
                            <div class="col-md-6">
                                <label for="registrationNumber" class="form-label">Registration Number</label>
                                <input type="text" class="form-control" id="registrationNumber" name="registrationNumber" required>
                                <div class="invalid-feedback">Please provide a registration number</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="image" class="form-label">Car Image</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/*" required>
                            <div class="invalid-feedback">Please upload an image</div>
                            <img id="imagePreview" class="preview-image rounded" alt="Preview">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Save Car
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
<!-- Custom Script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('carForm');
        const imageInput = document.getElementById('image');
        const imagePreview = document.getElementById('imagePreview');
        const feedbackDiv = document.getElementById('formFeedback');

        // Image preview
        imageInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                }
                reader.readAsDataURL(file);
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

            // Create FormData
            const formData = new FormData();
            formData.append('engineNumber', document.getElementById('engineNumber').value);
            formData.append('chassisNumber', document.getElementById('chassisNumber').value);
            formData.append('manufacturedYear', document.getElementById('manufacturedYear').value);
            formData.append('brand', document.getElementById('brand').value);
            formData.append('manufacturedCountry', document.getElementById('manufacturedCountry').value);
            formData.append('registrationNumber', document.getElementById('registrationNumber').value);
            formData.append('image', imageInput.files[0]);

            try {
                const response = await fetch('/api/cars', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    const data = await response.json();
                    showFeedback('Car created successfully!', 'success');
                    form.reset();
                    form.classList.remove('was-validated');
                    imagePreview.style.display = 'none';
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
            window.location.href = "/dashboard/cars"
        }
    });
</script>
</body>
</html>