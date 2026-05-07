<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Advertisement | SecondCar</title>
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

        .form-label.required:after {
            content: " *";
            color: var(--bs-red);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header border-bottom border-danger">
                    <h4 class="mb-0"><i class="fas fa-ad me-2"></i>Create New Advertisement</h4>
                </div>
                <div class="card-body">
                    <form id="adForm" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="title" class="form-label required">Title</label>
                            <input type="text" class="form-control" id="title" name="title"
                                   minlength="5" maxlength="100" required>
                            <div class="invalid-feedback">
                                Please provide a title (5-100 characters)
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label required">Description</label>
                            <textarea class="form-control" id="description" name="description"
                                      minlength="20" maxlength="500" required></textarea>
                            <div class="invalid-feedback">
                                Please provide a description (20-500 characters)
                            </div>
                            <div class="form-text text-muted">
                                <span id="charCount">0</span>/500 characters
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="image" class="form-label required">Advertisement Image</label>
                            <input type="file" class="form-control" id="image" name="image"
                                   accept="image/*" required>
                            <div class="invalid-feedback">
                                Please upload an image (JPEG, PNG, etc.)
                            </div>
                            <img id="imagePreview" class="preview-image rounded" alt="Preview">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Create Advertisement
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
        const form = document.getElementById('adForm');
        const imageInput = document.getElementById('image');
        const imagePreview = document.getElementById('imagePreview');
        const feedbackDiv = document.getElementById('formFeedback');
        const description = document.getElementById('description');
        const charCount = document.getElementById('charCount');

        // Image preview
        imageInput.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                // Validate file type
                const validTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
                if (!validTypes.includes(file.type)) {
                    this.setCustomValidity('Please upload a valid image (JPEG, PNG, GIF, or WebP)');
                    this.reportValidity();
                    this.value = '';
                    imagePreview.style.display = 'none';
                    return;
                } else {
                    this.setCustomValidity('');
                }

                // Validate file size (max 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    this.setCustomValidity('Image must be less than 5MB');
                    this.reportValidity();
                    this.value = '';
                    imagePreview.style.display = 'none';
                    return;
                } else {
                    this.setCustomValidity('');
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                }
                reader.readAsDataURL(file);
            }
        });

        // Character count for description
        description.addEventListener('input', function() {
            const currentLength = this.value.length;
            charCount.textContent = currentLength;

            if (currentLength < 20 || currentLength > 500) {
                this.setCustomValidity('Description must be between 20-500 characters');
            } else {
                this.setCustomValidity('');
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
            formData.append('title', document.getElementById('title').value);
            formData.append('description', document.getElementById('description').value);
            formData.append('image', imageInput.files[0]);

            try {
                const response = await fetch('/api/ads', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    const data = await response.json();
                    showFeedback('Advertisement created successfully!', 'success');
                    form.reset();
                    form.classList.remove('was-validated');
                    imagePreview.style.display = 'none';
                    charCount.textContent = '0';
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
            window.location.href = "/dashboard/advertisements";
        }
    });
</script>
</body>
</html>