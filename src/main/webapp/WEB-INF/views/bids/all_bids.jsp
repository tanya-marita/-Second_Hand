<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bids | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bs-red: #dc3545;
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

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)),
            background-size: cover;
            background-position: center;
            height: 10vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            margin-bottom: 3rem;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }

        .card {
            background-color: var(--bs-dark-light);
            border: 1px solid #2a2a2a;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            border-color: var(--bs-red);
        }

        .section-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 2rem;
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 50px;
            height: 3px;
            background-color: var(--bs-red);
        }

        .table {
            color: #f8f9fa;
        }

        .table-dark {
            background-color: var(--bs-dark-light);
        }

        .btn-outline-red {
            color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-outline-red:hover {
            background-color: var(--bs-red);
            color: white;
        }

        .btn-red {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
            color: white;
        }

        .btn-red:hover {
            background-color: #bb2d3b;
            border-color: #bb2d3b;
            color: white;
        }

        .dropdown-menu {
            background-color: var(--bs-dark-light);
            border: 1px solid #2a2a2a;
        }

        .dropdown-item {
            color: #f8f9fa;
        }

        .dropdown-item:hover {
            background-color: #2a2a2a;
            color: var(--bs-red);
        }

        .modal-content {
            background-color: var(--bs-dark-light);
            color: #f8f9fa;
        }

        .modal-header, .modal-footer {
            border-color: #2a2a2a;
        }

        .form-control, .form-select {
            background-color: #2a2a2a;
            border-color: #444;
            color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 0.35em 0.65em;
            font-size: 0.75em;
            font-weight: 700;
            border-radius: 0.25rem;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
        }

        .status-active {
            background-color: #198754;
            color: white;
        }

        .status-outbid {
            background-color: #6c757d;
            color: white;
        }

        .status-winning {
            background-color: #0d6efd;
            color: white;
        }

        .status-lost {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>
<!-- Bids Section -->
<section class="container mb-5" style="padding:32px">
    <div class="row mb-4">
        <div class="col-md-8">
            <h2 class="section-title">All Bids</h2>
        </div>
        <div class="col-md-4 text-end">
            <button class="btn btn-outline-red" onclick="exportTableToCSV('bids_export.csv')">
                <i class="fas fa-download me-1"></i>Export
            </button>
            <a href="/dashboard" class="btn btn-outline-red">
                <i class="fas fa-home me-1"></i>Back
            </a>
        </div>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Bid Records</h5>
            <div class="input-group w-50">
                <input type="text" id="searchInput" class="form-control" placeholder="Search bids...">
                <button class="btn btn-red" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-dark table-hover table-striped mb-0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Car</th>
                        <th>Auction</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${bids}" var="bid">
                        <tr>
                            <td>${bid.id.substring(0, 10)}...</td>
                            <td>
                                <span>${bid.user.firstName} ${bid.user.lastName}</span><br>
                                <small class="text-muted">${bid.user.email}</small>
                            </td>
                            <td>
                                <span>${bid.car.brand} (${bid.car.manufacturedYear})</span><br>
                                <small class="text-muted">Reg: ${bid.car.registrationNumber}</small>
                            </td>
                            <td>
                                <span>Auction #${bid.auction.id.substring(8, 16)}</span><br>
                                <small class="text-muted">Start: $<fmt:formatNumber value="${bid.auction.bidStartPrice}" type="number" pattern="#,##0.00"/></small>
                            </td>
                            <td>$<fmt:formatNumber value="${bid.bidAmount}" type="number" pattern="#,##0.00"/></td>
                            <td>
                                <span class="status-badge status-${bid.status.toLowerCase()}">${bid.status}</span>
                            </td>
                            <td>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-outline-red dropdown-toggle" type="button" id="dropdownMenuButton${bid.id}" data-bs-toggle="dropdown" aria-expanded="false">
                                        Actions
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton${bid.id}">
                                        <li><a class="dropdown-item" href="#" onclick="prepareUpdateStatus('${bid.id}', '${bid.status}')" data-bs-toggle="modal" data-bs-target="#updateStatusModal">
                                            <i class="fas fa-edit me-1"></i>Update Status
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="#" onclick="prepareDelete('${bid.id}')" data-bs-toggle="modal" data-bs-target="#deleteBidModal">
                                            <i class="fas fa-trash-alt me-1"></i>Delete Bid
                                        </a></li>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bids}">
                        <tr>
                            <td colspan="7" class="text-center py-4">No bids found</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateStatusModalLabel">Update Bid Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="updateStatusForm">
                    <input type="hidden" id="updateBidId" name="bidId">
                    <div class="mb-3">
                        <label for="bidStatus" class="form-label">Bid Status</label>
                        <select id="bidStatus" name="status" class="form-select">
                            <option value="ACTIVE">ACTIVE</option>
                            <option value="OUTBID">OUTBID</option>
                            <option value="WINNING">WINNING</option>
                            <option value="LOST">LOST</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-red" id="confirmUpdateStatus">Update Status</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteBidModal" tabindex="-1" aria-labelledby="deleteBidModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteBidModalLabel">Confirm Delete</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this bid? This action cannot be undone.</p>
                <input type="hidden" id="deleteBidId">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-dark text-white py-4">
    <div class="container text-center">
        <p>&copy; 2025 SecondCar. All rights reserved.</p>
    </div>
</footer>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Handle status update
    function prepareUpdateStatus(bidId, currentStatus) {
        document.getElementById("updateBidId").value = bidId;
        document.getElementById("bidStatus").value = currentStatus;
    }

    document.getElementById("confirmUpdateStatus").addEventListener("click", function() {
        const bidId = document.getElementById("updateBidId").value;
        const status = document.getElementById("bidStatus").value;

        // Use the PUT endpoint from BidController to update the bid status
        fetch("/api/bids/" + bidId + "?status=" + status, {
            method: "PUT",
            headers: {
                "Content-Type": "application/json"
            }
        })
            .then(function(response) {
                if (response.ok) {
                    // Close modal and reload the page
                    var modal = bootstrap.Modal.getInstance(document.getElementById("updateStatusModal"));
                    modal.hide();
                    window.location.reload();
                } else {
                    throw new Error("Failed to update bid status");
                }
            })
            .catch(function(error) {
                console.error("Error updating bid status:", error);
                alert("Error updating bid status. Please try again.");
            });
    });

    // Handle delete
    function prepareDelete(bidId) {
        document.getElementById("deleteBidId").value = bidId;
        console.log("Bid id of "+document.getElementById("deleteBidId").value +" is going to delete")
    }

    document.getElementById("confirmDelete").addEventListener("click", function() {
        const bidId = document.getElementById("deleteBidId").value;
        console.log(bidId)

        if (bidId) {
            // Use the DELETE endpoint from BidController for soft delete
            fetch("/api/bids/" + bidId, {
                method: "DELETE"
            })
                .then(function(response) {
                    if (response.ok) {
                        // Close modal and reload the page
                        var modal = bootstrap.Modal.getInstance(document.getElementById("deleteBidModal"));
                        modal.hide();
                        window.location.reload();
                    } else {
                        console.log('error deleteing')
                        throw new Error("Failed to delete bid");
                    }
                })
                .catch(function(error) {
                    console.error("Error deleting bid:", error);
                    alert("Error deleting bid. Please try again.");
                });
        }else{
            console.log("empty bid id")
        }
    });

    // Search functionality
    document.getElementById("searchInput").addEventListener("keyup", function() {
        const searchValue = this.value.toLowerCase();
        const tableRows = document.querySelectorAll("tbody tr");

        tableRows.forEach(function(row) {
            const rowText = row.textContent.toLowerCase();
            if (rowText.includes(searchValue)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    });

    // Export to CSV functionality
    function exportTableToCSV(filename) {
        const csv = [];
        const rows = document.querySelectorAll("table tr");

        for (let i = 0; i < rows.length; i++) {
            const row = [], cols = rows[i].querySelectorAll("td, th");

            for (let j = 0; j < cols.length - 1; j++) { // Skip last column (actions)
                // Clean the text content
                let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, " ").trim();
                // Escape double-quotes with double double-quotes
                data = data.replace(/"/g, '""');
                // Add double quotes around fields
                row.push('"' + data + '"');
            }
            csv.push(row.join(","));
        }

        // Download CSV file
        downloadCSV(csv.join("\n"), filename);
    }

    function downloadCSV(csv, filename) {
        const csvFile = new Blob([csv], { type: "text/csv" });
        const downloadLink = document.createElement("a");

        downloadLink.download = filename;
        downloadLink.href = window.URL.createObjectURL(csvFile);
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);

        downloadLink.click();
        document.body.removeChild(downloadLink);
    }
</script>
</body>
</html>