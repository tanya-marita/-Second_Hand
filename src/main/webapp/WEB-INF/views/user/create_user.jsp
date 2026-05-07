<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New User | SecondCar</title>
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
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header border-bottom border-danger">
                    <h4 class="mb-0"><i class="fas fa-user-plus me-2"></i>Add New User</h4>
                </div>
                <div class="card-body">
                    <form id="userForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" required>
                                <div class="invalid-feedback">Please provide a first name</div>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" required>
                                <div class="invalid-feedback">Please provide a last name</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
                            <div class="invalid-feedback">Please provide an address</div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                                <div class="invalid-feedback">Please provide a valid email</div>
                            </div>
                            <div class="col-md-6">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required minlength="6">
                                <div class="invalid-feedback">Password must be at least 6 characters</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="role" class="form-label">Role</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="ADMIN" selected>Admin</option>
                                <option value="USER">Regular User</option>
                            </select>
                            <div class="invalid-feedback">Please select a role</div>
                        </div>

                        <div id="adminFields" class="row mb-3">
                            <div class="col-md-6">
                                <label for="employeeId" class="form-label">Employee ID</label>
                                <input type="text" class="form-control" id="employeeId" name="employeeId">
                                <div class="invalid-feedback">Please provide an employee ID</div>
                            </div>
                            <div class="col-md-6">
                                <label for="accessLevel" class="form-label">Access Level</label>
                                <select class="form-select" id="accessLevel" name="accessLevel">
                                    <option value="ALL" selected>All Access</option>
                                    <option value="USERS">Users Management</option>
                                    <option value="CARS">Cars Management</option>
                                </select>
                                <div class="invalid-feedback">Please select an access level</div>
                            </div>
                        </div>

                        <div id="userFields" class="row mb-3" style="display: none;">
                            <div class="col-md-6">
                                <label for="drivingLicense" class="form-label">Driving License Number</label>
                                <input type="text" class="form-control" id="drivingLicense" name="drivingLicense">
                                <div class="invalid-feedback">Please provide a driving license number</div>
                            </div>
                            <div class="col-md-6">
                                <label for="phoneNumber" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber">
                                <div class="invalid-feedback">Please provide a valid phone number</div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Save User
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
        const form = document.getElementById('userForm');
        const roleSelect = document.getElementById('role');
        const adminFields = document.getElementById('adminFields');
        const userFields = document.getElementById('userFields');
        const feedbackDiv = document.getElementById('formFeedback');

        // Toggle fields based on role
        roleSelect.addEventListener('change', function() {
            if (this.value === 'ADMIN') {
                adminFields.style.display = 'flex';
                userFields.style.display = 'none';

                // Make admin fields required
                document.getElementById('employeeId').setAttribute('required', '');
                document.getElementById('drivingLicense').removeAttribute('required');
                document.getElementById('phoneNumber').removeAttribute('required');
            } else {
                adminFields.style.display = 'none';
                userFields.style.display = 'flex';

                // Make user fields required
                document.getElementById('employeeId').removeAttribute('required');
                document.getElementById('drivingLicense').setAttribute('required', '');
                document.getElementById('phoneNumber').setAttribute('required', '');
            }
        });

        // Form validation and submission
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            // Validate form
            if (!form.checkValidity()) {
                e.stopPropagation();
                form.classList.add('was-validated');
                return;
            }

            const role = roleSelect.value;
            let userData;

            if (role === 'ADMIN') {
                userData = {
                    firstName: document.getElementById('firstName').value,
                    lastName: document.getElementById('lastName').value,
                    address: document.getElementById('address').value,
                    email: document.getElementById('email').value,
                    password: document.getElementById('password').value,
                    role: role,
                    employeeId: document.getElementById('employeeId').value,
                    accessLevel: document.getElementById('accessLevel').value
                };
            } else {
                userData = {
                    firstName: document.getElementById('firstName').value,
                    lastName: document.getElementById('lastName').value,
                    address: document.getElementById('address').value,
                    email: document.getElementById('email').value,
                    password: document.getElementById('password').value,
                    role: role,
                    drivingLicense: document.getElementById('drivingLicense').value,
                    phoneNumber: document.getElementById('phoneNumber').value
                };
            }

            try {
                const response = await fetch('/api/users/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(userData)
                });

                if (response.ok) {
                    showFeedback('User created successfully!', 'success');
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
            window.location.href = "/dashboard/users";
        }

        // Email validation with regex
        const emailInput = document.getElementById('email');
        emailInput.addEventListener('input', function() {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailRegex.test(this.value)) {
                this.setCustomValidity('');
            } else {
                this.setCustomValidity('Please enter a valid email address');
            }
        });

        // Password strength validation
        const passwordInput = document.getElementById('password');
        passwordInput.addEventListener('input', function() {
            if (this.value.length < 6) {
                this.setCustomValidity('Password must be at least 6 characters');
            } else {
                this.setCustomValidity('');
            }
        });
    });
</script>
</body>
</html>