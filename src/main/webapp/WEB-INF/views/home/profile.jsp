<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile | SecondCar</title>
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

        .profile-section {
            background-color: var(--bs-dark-light);
            border-radius: 8px;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid #2a2a2a;
        }

        .profile-header {
            font-size: 2rem;
            font-weight: 700;
            color: var(--bs-red);
            margin-bottom: 1.5rem;
        }

        .profile-info {
            color: #f8f9fa;
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

        .btn-primary {
            background-color: var(--bs-red);
            border: none;
            padding: 0.5rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-success {
            background-color: var(--bs-green);
            border: none;
            padding: 0.5rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            background-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .btn-outline-danger {
            border-color: var(--bs-red);
            color: var(--bs-red);
            padding: 0.5rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-outline-danger:hover {
            background-color: var(--bs-red);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .action-buttons {
            margin-top: 2rem;
        }

        .validation-error {
            color: var(--bs-red);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        #editProfileForm {
            display: none;
        }

        #passwordChangeForm {
            display: none;
            margin-top: 2rem;
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
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" id="loginLink" href="/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Login
                    </a>
                </li>
                <li class="nav-item" id="profileLink" style="display: none;">
                    <a class="nav-link" href="#">
                        <i class="fas fa-user me-1"></i><span id="userNameDisplay"></span>
                    </a>
                </li>
                <li class="nav-item" id="logoutLink" style="display: none;">
                    <a class="nav-link" href="#" onclick="logout()">
                        <i class="fas fa-sign-out-alt me-1"></i>Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Profile Section -->
<section class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="profile-section">
                <!-- Profile View -->
                <div id="profileView">
                    <h2 class="profile-header">User Profile</h2>
                    <div class="profile-info">
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Name:</div>
                            <div class="col-md-8" id="fullNameDisplay"></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Email:</div>
                            <div class="col-md-8" id="emailDisplay"></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 fw-bold">Address:</div>
                            <div class="col-md-8" id="addressDisplay"></div>
                        </div>
                    </div>
                    <div class="action-buttons">
                        <button id="editProfileBtn" class="btn btn-primary me-2">
                            <i class="fas fa-edit me-1"></i>Edit Profile
                        </button>
                        <button id="changePasswordBtn" class="btn btn-primary me-2">
                            <i class="fas fa-key me-1"></i>Change Password
                        </button>
                        <button id="myBidsBtn" class="btn btn-success me-2">
                            <i class="fas fa-gavel me-1"></i>My Bids
                        </button>
                        <button id="deleteAccountBtn" class="btn btn-outline-danger">
                            <i class="fas fa-trash-alt me-1"></i>Delete Account
                        </button>
                    </div>
                </div>

                <!-- Edit Profile Form -->
                <div id="editProfileForm">
                    <h2 class="profile-header">Edit Profile</h2>
                    <form id="userEditForm">
                        <div class="mb-3">
                            <label for="firstName" class="form-label">First Name</label>
                            <input type="text" class="form-control" id="firstName" required>
                            <div class="validation-error" id="firstNameError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="lastName" class="form-label">Last Name</label>
                            <input type="text" class="form-control" id="lastName" required>
                            <div class="validation-error" id="lastNameError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Address</label>
                            <textarea class="form-control" id="address" rows="3" required></textarea>
                            <div class="validation-error" id="addressError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" required>
                            <div class="validation-error" id="emailError"></div>
                        </div>
                        <div class="d-flex">
                            <button type="submit" class="btn btn-success me-2">
                                <i class="fas fa-save me-1"></i>Save Changes
                            </button>
                            <button type="button" id="cancelEditBtn" class="btn btn-outline-danger">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Change Password Form -->
                <div id="passwordChangeForm">
                    <h2 class="profile-header">Change Password</h2>
                    <form id="passwordForm">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <input type="password" class="form-control" id="currentPassword" required>
                            <div class="validation-error" id="currentPasswordError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" class="form-control" id="newPassword" required>
                            <div class="validation-error" id="newPasswordError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmPassword" required>
                            <div class="validation-error" id="confirmPasswordError"></div>
                        </div>
                        <div class="d-flex">
                            <button type="submit" class="btn btn-success me-2">
                                <i class="fas fa-save me-1"></i>Change Password
                            </button>
                            <button type="button" id="cancelPasswordBtn" class="btn btn-outline-danger">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Confirmation Modal for Delete Account -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content bg-dark">
            <div class="modal-header border-bottom border-secondary">
                <h5 class="modal-title text-danger">Confirm Account Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete your account? This action cannot be undone.</p>
                <p class="text-danger fw-bold">All your data will be permanently removed.</p>
            </div>
            <div class="modal-footer border-top border-secondary">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Delete My Account</button>
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
        // Check if user is logged in
        const userEmail = localStorage.getItem('userEmail');
        if (!userEmail) {
            window.location.href = '/login?redirect=' + encodeURIComponent(window.location.pathname);
            return;
        }

        // Update nav menu for logged in user
        document.getElementById('loginLink').style.display = 'none';
        document.getElementById('profileLink').style.display = 'block';
        document.getElementById('logoutLink').style.display = 'block';

        // Get user data and populate profile
        fetchUserData(userEmail);

        // Button event listeners
        document.getElementById('editProfileBtn').addEventListener('click', showEditProfile);
        document.getElementById('cancelEditBtn').addEventListener('click', showProfileView);
        document.getElementById('changePasswordBtn').addEventListener('click', showPasswordForm);
        document.getElementById('cancelPasswordBtn').addEventListener('click', showProfileView);
        document.getElementById('myBidsBtn').addEventListener('click', function() {
            window.location.href = '/my-bids/' + userEmail;
        });
        document.getElementById('deleteAccountBtn').addEventListener('click', showDeleteConfirmation);
        document.getElementById('confirmDeleteBtn').addEventListener('click', deleteAccount);

        // Form submissions
        document.getElementById('userEditForm').addEventListener('submit', updateProfile);
        document.getElementById('passwordForm').addEventListener('submit', updatePassword);
    });

    function fetchUserData(email) {
        fetch(`/api/users/`+email)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch user data');
                }
                return response.json();
            })
            .then(user => {
                populateUserData(user);
                document.getElementById('userNameDisplay').textContent = user.firstName;
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error loading user profile: ' + error.message);
            });
    }

    function populateUserData(user) {
        // Populate profile view
        document.getElementById('fullNameDisplay').textContent = user.firstName + ' ' + user.lastName;
        document.getElementById('emailDisplay').textContent = user.email;
        document.getElementById('addressDisplay').textContent = user.address;

        // Populate edit form
        document.getElementById('firstName').value = user.firstName;
        document.getElementById('lastName').value = user.lastName;
        document.getElementById('address').value = user.address;
        document.getElementById('email').value = user.email;
    }

    function showEditProfile() {
        document.getElementById('profileView').style.display = 'none';
        document.getElementById('passwordChangeForm').style.display = 'none';
        document.getElementById('editProfileForm').style.display = 'block';
    }

    function showPasswordForm() {
        document.getElementById('profileView').style.display = 'none';
        document.getElementById('editProfileForm').style.display = 'none';
        document.getElementById('passwordChangeForm').style.display = 'block';
        // Clear password fields
        document.getElementById('currentPassword').value = '';
        document.getElementById('newPassword').value = '';
        document.getElementById('confirmPassword').value = '';
    }

    function showProfileView() {
        document.getElementById('editProfileForm').style.display = 'none';
        document.getElementById('passwordChangeForm').style.display = 'none';
        document.getElementById('profileView').style.display = 'block';
        // Clear validation errors
        clearValidationErrors();
    }

    function clearValidationErrors() {
        const errorElements = document.querySelectorAll('.validation-error');
        errorElements.forEach(element => {
            element.textContent = '';
        });
    }

    function updateProfile(e) {
        e.preventDefault();
        clearValidationErrors();

        // Get form values
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const address = document.getElementById('address').value.trim();
        const email = document.getElementById('email').value.trim();
        const userEmail = localStorage.getItem('userEmail');

        // Validate form data
        let isValid = true;

        if (firstName === '') {
            document.getElementById('firstNameError').textContent = 'First name is required';
            isValid = false;
        }

        if (lastName === '') {
            document.getElementById('lastNameError').textContent = 'Last name is required';
            isValid = false;
        }

        if (address === '') {
            document.getElementById('addressError').textContent = 'Address is required';
            isValid = false;
        }

        if (email === '') {
            document.getElementById('emailError').textContent = 'Email is required';
            isValid = false;
        } else if (!validateEmail(email)) {
            document.getElementById('emailError').textContent = 'Please enter a valid email address';
            isValid = false;
        }

        if (!isValid) {
            return;
        }

        // Get existing user data to preserve password and role
        fetch(`/api/users/`+userEmail)
            .then(response => response.json())
            .then(userData => {
                // Prepare updated user data
                const updatedUser = {
                    firstName: firstName,
                    lastName: lastName,
                    address: address,
                    email: email,
                    password: userData.password, // Keep existing password
                    role: userData.role // Keep existing role
                };

                // Submit update request
                return fetch(`/api/users/`+userEmail, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(updatedUser)
                });
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to update profile');
                }
                return response.text();
            })
            .then(data => {
                alert('Profile updated successfully!');
                // Update localStorage if email was changed
                if (email !== userEmail) {
                    localStorage.setItem('userEmail', email);
                }
                // Refresh user data
                fetchUserData(email);
                showProfileView();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating profile: ' + error.message);
            });
    }

    function updatePassword(e) {
        e.preventDefault();
        clearValidationErrors();

        // Get form values
        const currentPassword = document.getElementById('currentPassword').value;
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const userEmail = localStorage.getItem('userEmail');

        // Validate form data
        let isValid = true;

        if (currentPassword === '') {
            document.getElementById('currentPasswordError').textContent = 'Current password is required';
            isValid = false;
        }

        if (newPassword === '') {
            document.getElementById('newPasswordError').textContent = 'New password is required';
            isValid = false;
        } else if (newPassword.length < 6) {
            document.getElementById('newPasswordError').textContent = 'Password must be at least 6 characters';
            isValid = false;
        }

        if (confirmPassword === '') {
            document.getElementById('confirmPasswordError').textContent = 'Please confirm your new password';
            isValid = false;
        } else if (newPassword !== confirmPassword) {
            document.getElementById('confirmPasswordError').textContent = 'Passwords do not match';
            isValid = false;
        }

        if (!isValid) {
            return;
        }

        // Verify current password and update if correct
        fetch("/api/users/"+userEmail)
            .then(response => response.json())
            .then(userData => {
                // Verify current password
                if (userData.password !== currentPassword) {
                    document.getElementById('currentPasswordError').textContent = 'Incorrect current password';
                    return null;
                }

                // Prepare updated user data
                const updatedUser = {
                    firstName: userData.firstName,
                    lastName: userData.lastName,
                    address: userData.address,
                    email: userData.email,
                    password: newPassword,
                    role: userData.role
                };

                // Submit update request
                return fetch("/api/users/"+userEmail, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(updatedUser)
                });
            })
            .then(response => {
                if (!response) return; // Current password was incorrect
                if (!response.ok) {
                    throw new Error('Failed to update password');
                }
                return response.text();
            })
            .then(data => {
                if (data) {
                    alert('Password updated successfully!');
                    showProfileView();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating password: ' + error.message);
            });
    }

    function showDeleteConfirmation() {
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    }

    function deleteAccount() {
        const userEmail = localStorage.getItem('userEmail');

        fetch(`/api/users/${userEmail}`, {
            method: 'DELETE'
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to delete account');
                }
                return response.text();
            })
            .then(data => {
                alert('Your account has been deleted successfully.');
                // Clear user data from local storage
                localStorage.removeItem('userEmail');
                // Redirect to home page
                window.location.href = '/';
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting account: ' + error.message);
            });
    }

    function logout() {
        // Clear user data from local storage
        localStorage.removeItem('userEmail');
        // Redirect to home page
        window.location.href = '/';
    }

    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }
</script>
</body>
</html>