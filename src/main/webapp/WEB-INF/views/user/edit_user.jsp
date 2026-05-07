<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User | SecondCar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow">
                <div class="card-header border-bottom border-danger">
                    <h4 class="mb-0"><i class="fas fa-user-edit me-2"></i>Edit User</h4>
                </div>
                <div class="card-body">
                    <form id="userForm">
                        <!-- Same form fields as create_user.jsp -->
                        <!-- Including IDs: firstName, lastName, address, email, password, role, etc. -->
                        <!-- You can copy all your input fields from create_user.jsp here -->

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save me-2"></i>Update User
                            </button>
                        </div>
                    </form>
                    <div id="formFeedback" class="mt-3"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', async function () {
        const email = new URLSearchParams(window.location.search).get("email");
        const form = document.getElementById("userForm");

        if (!email) {
            alert("No email provided for editing.");
            window.location.href = "/dashboard/users";
            return;
        }

        // Fetch existing user
        try {
            const res = await fetch(`/api/users/${email}`);
            if (!res.ok) throw new Error("Failed to fetch user");

            const user = await res.json();

            // Pre-fill form
            document.getElementById('firstName').value = user.firstName;
            document.getElementById('lastName').value = user.lastName;
            document.getElementById('address').value = user.address;
            document.getElementById('email').value = user.email;
            document.getElementById('password').value = user.password; // or leave blank
            document.getElementById('role').value = user.role;

            if (user.role === "ADMIN") {
                document.getElementById('employeeId').value = user.employeeId;
                document.getElementById('accessLevel').value = user.accessLevel;
            } else {
                document.getElementById('drivingLicense').value = user.drivingLicense;
                document.getElementById('phoneNumber').value = user.phoneNumber;
            }

            // Trigger change to show/hide fields
            document.getElementById('role').dispatchEvent(new Event('change'));

        } catch (err) {
            alert("Error loading user data.");
            window.location.href = "/dashboard/users";
        }

        // Submit updated data
        form.addEventListener("submit", async function (e) {
            e.preventDefault();

            const role = document.getElementById("role").value;
            let updatedUser;

            if (role === "ADMIN") {
                updatedUser = {
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
                updatedUser = {
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
                const res = await fetch(`/api/users/${email}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(updatedUser)
                });

                if (res.ok) {
                    alert("User updated successfully.");
                    window.location.href = "/dashboard/users";
                } else {
                    const msg = await res.text();
                    alert("Update failed: " + msg);
                }
            } catch (err) {
                alert("Network error: " + err.message);
            }
        });
    });
</script>
</body>
</html>
