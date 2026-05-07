<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Second Car Purchase System - Join Us</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <!-- Custom CSS -->
    <style>
        :root {
            --bs-red: #dc3545;
            --bs-body-bg: #121212;
        }

        body {
            background-color: var(--bs-body-bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-image: linear-gradient(rgba(18, 18, 18, 0.9), rgba(18, 18, 18, 0.9)),
            url('https://purepng.com/public/uploads/large/purepng.com-red-audi-caraudicars-961524670920vwzc6.png');
            background-size: contain;
            background-position: right center;
            background-repeat: no-repeat;
        }

        .card {
            border: 1px solid var(--bs-red);
            animation: fadeIn 0.5s ease-in-out;
            background-color: rgba(33, 37, 41, 0.7); /* More transparent background */
            backdrop-filter: blur(5px);
        }

        .card-title {
            color: var(--bs-red);
        }

        .btn-primary {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-primary:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        a {
            color: var(--bs-red);
            text-decoration: none;
        }

        a:hover {
            color: #c82333;
            text-decoration: underline;
        }

        .form-control:focus {
            border-color: var(--bs-red);
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25);
        }

        .invalid-feedback {
            color: var(--bs-red);
        }

        .hero-text {
            font-size: 1.1rem;
            line-height: 1.6;
            opacity: 0.9;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .brand-highlight {
            color: var(--bs-red);
            font-weight: bold;
        }

        /* Password container */
        .password-container {
            display: flex;
            width: 100%;
            justify-content: space-between;
            gap: 15px;
        }

        .password-container > div {
            flex: 1;
        }

        /* Custom alert */
        .alert-feedback {
            display: none;
            margin-top: 1rem;
        }
    </style>
</head>
<body class="bg-dark">
<div class="container">
    <div class="row justify-content-center animate_animated animate_fadeIn">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-lg">
                <div class="card-body p-5">
                    <h3 class="card-title text-center mb-3 animate_animated animate_fadeInDown">
                        Join <span class="brand-highlight">SecondCar</span> Marketplace
                    </h3>

                    <p class="hero-text text-center mb-4 animate_animated animate_fadeIn">
                        Find your dream car or sell your vehicle with ease. Join thousands of happy customers
                        in our premium automotive marketplace.
                    </p>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger animate_animated animate_shakeX">
                                ${error}
                        </div>
                    </c:if>

                    <!-- Custom alert for JS responses -->
                    <div class="alert alert-danger animate_animated animate_shakeX alert-feedback" id="errorFeedback"></div>
                    <div class="alert alert-success animate_animated animate_fadeIn alert-feedback" id="successFeedback"></div>

                    <form id="registerForm" novalidate>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="firstName" class="form-label">First Name</label>
                                <input type="text" class="form-control" id="firstName" name="firstName" required>
                                <div class="invalid-feedback">Please enter your first name</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="lastName" class="form-label">Last Name</label>
                                <input type="text" class="form-control" id="lastName" name="lastName" required>
                                <div class="invalid-feedback">Please enter your last name</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                            <div class="invalid-feedback">Please enter a valid email address</div>
                        </div>

                        <div class="mb-3 password-container">
                            <div>
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password"
                                       required minlength="8" pattern="(?=.\d)(?=.[a-z])(?=.*[A-Z]).{8,}">
                                <div class="invalid-feedback">
                                    Password must be at least 8 characters with 1 uppercase, 1 lowercase, and 1 number
                                </div>
                            </div>
                            <div>
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" required>
                                <div class="invalid-feedback">Passwords must match</div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   pattern="[0-9]{10}" required>
                            <div class="invalid-feedback">Please enter a valid 10-digit phone number</div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label" for="terms">
                                I agree to the <a href="#" class="text-decoration-none">Terms and Conditions</a>
                            </label>
                            <div class="invalid-feedback">You must agree to the terms</div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg animate_animated animatepulse animateinfinite animate_slower">
                                Create Account
                            </button>
                        </div>
                    </form>

                    <div class="mt-4 text-center animate_animated animate_fadeInUp">
                        <p>Already have an account? <a href="/login" class="fw-bold">Sign in here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Form Validation and Fetch API -->
<script>
    (function () {
        'use strict'

        const form = document.getElementById('registerForm')
        const password = document.getElementById('password')
        const confirmPassword = document.getElementById('confirmPassword')
        const errorFeedback = document.getElementById('errorFeedback')
        const successFeedback = document.getElementById('successFeedback')
        const submitBtn = document.getElementById('submitBtn')

        function validatePassword() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords don't match")
            } else {
                confirmPassword.setCustomValidity('')
            }
        }

        password.onchange = validatePassword
        confirmPassword.onkeyup = validatePassword

        form.addEventListener('submit', async function (event) {
            event.preventDefault()
            event.stopPropagation()

            // Hide any previous feedback
            errorFeedback.style.display = 'none'
            successFeedback.style.display = 'none'

            // Form validation
            form.classList.add('was-validated')
            if (!form.checkValidity()) {
                return
            }

            // If terms not checked
            if (!document.getElementById('terms').checked) {
                errorFeedback.textContent = 'You must agree to the terms and conditions'
                errorFeedback.style.display = 'block'
                return
            }

            // Create user object
            const userData = {
                firstName: document.getElementById('firstName').value,
                lastName: document.getElementById('lastName').value,
                email: document.getElementById('email').value,
                password: password.value,
                phone: document.getElementById('phone').value,
                type : "regular"
            }

            // Disable submit button during request
            submitBtn.disabled = true
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...'

            try {
                const response = await fetch('/api/users/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(userData)
                })



                if (!response.ok) {
                    throw new Error('Registration failed')
                }

                // Success
                successFeedback.textContent = 'Registration successful! Redirecting to login...'
                successFeedback.style.display = 'block'
                form.reset()
                form.classList.remove('was-validated')

                // Redirect after successful registration
                setTimeout(() => {
                    window.location.href = '/login'
                }, 2000)
            } catch (error) {
                // Error handling
                errorFeedback.textContent = error.message || 'An error occurred during registration'
                errorFeedback.style.display = 'block'
                console.error('Registration error:', error)
            } finally {
                // Re-enable submit button
                submitBtn.disabled = false
                submitBtn.innerHTML = 'Create Account'
            }
        }, false)
    })()
</script>
</body>
</html>