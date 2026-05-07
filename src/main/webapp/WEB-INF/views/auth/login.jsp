<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Second Car Purchase System - Login</title>
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
            background-color: rgba(33, 37, 41, 0.7);
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

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Custom alert */
        .alert-feedback {
            display: none;
            margin-top: 1rem;
        }

        .brand-highlight {
            color: var(--bs-red);
            font-weight: bold;
        }
    </style>
</head>
<body class="bg-dark">
<div class="container">
    <div class="row justify-content-center animate_animated animate_fadeIn">
        <div class="col-md-8 col-lg-6 col-xl-5">
            <div class="card shadow-lg">
                <div class="card-body p-5">
                    <h3 class="card-title text-center mb-4 animate_animated animate_fadeInDown">
                        <span class="brand-highlight">SecondCar</span> Login
                    </h3>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger animate_animated animate_shakeX">
                                ${error}
                        </div>
                    </c:if>

                    <!-- Custom alert for JS responses -->
                    <div class="alert alert-danger animate_animated animate_shakeX alert-feedback" id="errorFeedback"></div>
                    <div class="alert alert-success animate_animated animate_fadeIn alert-feedback" id="successFeedback"></div>

                    <form id="loginForm" novalidate>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                            <div class="invalid-feedback">Please enter a valid email address</div>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required minlength="8">
                            <div class="invalid-feedback">Password must be at least 8 characters</div>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                            <label class="form-check-label" for="rememberMe">Remember me</label>
                        </div>
                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg animate_animated animatepulse animateinfinite animate_slower">
                                Login
                            </button>
                        </div>
                    </form>

                    <div class="mt-4 text-center animate_animated animate_fadeInUp">
                        <p>Don't have an account? <a href="/register" class="fw-bold">Register here</a></p>
                        <p class="mt-2 small"><a href="/forgot-password">Forgot password?</a></p>
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

        // Get form elements
        const form = document.getElementById('loginForm')
        const email = document.getElementById('email')
        const password = document.getElementById('password')
        const rememberMe = document.getElementById('rememberMe')
        const errorFeedback = document.getElementById('errorFeedback')
        const successFeedback = document.getElementById('successFeedback')
        const submitBtn = document.getElementById('submitBtn')

        // Email validation function
        function validateEmail(emailValue) {
            const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            return re.test(String(emailValue).toLowerCase())
        }

        // Form submission handler
        form.addEventListener('submit', async function (event) {
            event.preventDefault()
            event.stopPropagation()

            // Hide any previous feedback
            errorFeedback.style.display = 'none'
            successFeedback.style.display = 'none'

            // Custom validation
            let isValid = true

            // Email validation
            if (!email.value.trim()) {
                email.classList.add('is-invalid')
                isValid = false
            } else if (!validateEmail(email.value)) {
                email.classList.add('is-invalid')
                email.nextElementSibling.textContent = 'Please enter a valid email address'
                isValid = false
            } else {
                email.classList.remove('is-invalid')
                email.classList.add('is-valid')
            }

            // Password validation
            if (!password.value) {
                password.classList.add('is-invalid')
                isValid = false
            } else if (password.value.length < 8) {
                password.classList.add('is-invalid')
                password.nextElementSibling.textContent = 'Password must be at least 8 characters'
                isValid = false
            } else {
                password.classList.remove('is-invalid')
                password.classList.add('is-valid')
            }

            // Form validation status
            form.classList.add('was-validated')
            if (!isValid) {
                return
            }

            // Create login object
            const loginData = {
                email: email.value,
                password: password.value,

            }

            // Disable submit button during request
            submitBtn.disabled = true
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Logging in...'

            try {
                const response = await fetch('/api/users/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(loginData)
                })

                // Handle different response status codes
                if (response.status === 401) {
                    throw new Error('Invalid email or password')
                } else if (response.status === 403) {
                    throw new Error('Account is locked. Please contact support')
                } else if (!response.ok) {
                    const errorData = await response.json()
                    throw new Error(errorData.message || 'Login failed')
                }

                const data = await response.json()
                localStorage.setItem("userEmail",data.email)
                localStorage.setItem("role",data.role)
                // Success
                successFeedback.textContent = 'Login successful! Redirecting...'
                successFeedback.style.display = 'block'

                // Redirect after successful login
                setTimeout(() => {
                    if(data.role === "ADMIN"){
                        window.location.href = '/dashboard'
                    }else{
                        window.location.href =  '/'
                    }
                }, 1000)
            } catch (error) {
                // Error handling
                errorFeedback.textContent = error.message || 'An error occurred during login'
                errorFeedback.style.display = 'block'
                console.error('Login error:', error)

                // Reset password field on error
                password.value = ''
                password.classList.remove('is-valid')
                form.classList.remove('was-validated')
            } finally {
                // Re-enable submit button
                submitBtn.disabled = false
                submitBtn.innerHTML = 'Login'
            }
        }, false)

        // Reset validation state when inputs change
        email.addEventListener('input', function() {
            email.classList.remove('is-invalid')
        })

        password.addEventListener('input', function() {
            password.classList.remove('is-invalid')
        })
    })()
</script>
</body>
</html>