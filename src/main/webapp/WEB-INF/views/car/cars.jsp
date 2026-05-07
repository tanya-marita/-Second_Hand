<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Management | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <!-- jsPDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
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

        .table-dark {
            background-color: #1a1a1a;
            border-color: #2a2a2a;
        }

        .table-dark th {
            border-color: #2a2a2a;
            background-color: #252525;
        }

        .table-dark td {
            border-color: #2a2a2a;
            vertical-align: middle;
        }

        .btn-outline-red {
            color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .btn-outline-red:hover {
            background-color: var(--bs-red);
            color: white;
        }

        .car-image {
            width: 100px;
            height: auto;
            border-radius: 4px;
        }

        .search-box {
            position: relative;
        }

        .search-box i {
            position: absolute;
            top: 10px;
            left: 10px;
            color: #6c757d;
        }

        .search-box input {
            padding-left: 35px;
        }

        .badge-red {
            background-color: var(--bs-red);
        }

        .dataTables_filter input {
            color: white !important;
            background-color: #333 !important;
            border-color: #444 !important;
        }

        .dataTables_length select {
            color: white !important;
            background-color: #333 !important;
            border-color: #444 !important;
        }

        .dataTables_info {
            color: #aaa !important;
        }

        .page-item.active .page-link {
            background-color: var(--bs-red);
            border-color: var(--bs-red);
        }

        .page-link {
            color: var(--bs-red);
            background-color: #1e1e1e;
            border-color: #2a2a2a;
        }

        .page-link:hover {
            color: white;
            background-color: #333;
            border-color: #444;
        }
    </style>
</head>
<body>
<div class="container-fluid py-4">
    <div class="card">
        <div class="card-header border-bottom border-danger">
            <div class="d-flex justify-content-between align-items-center">
                <h4 class="mb-0"><i class="fas fa-car me-2"></i>Car Management</h4>
                <div>
                    <a href="/dashboard/create-car" class="btn btn-outline-red me-2">
                        <i class="fas fa-plus me-1"></i> Add New Car
                    </a>
                    <button id="exportPdf" class="btn btn-outline-red">
                        <i class="fas fa-file-pdf me-1"></i> Export PDF
                    </button>
                    <a href="/dashboard" class="btn btn-outline-red me-2">
                        <i class="fas fa-home me-1"></i> Home
                    </a>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-6">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" class="form-control" placeholder="Search cars...">
                    </div>
                </div>
                <div class="col-md-6 text-end">
                    <div class="btn-group">
                        <button class="btn btn-outline-red" id="filterAll">All</button>
                        <button class="btn btn-outline-red" id="filterActive">Active</button>
                        <button class="btn btn-outline-red" id="filterDeleted">Deleted</button>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table id="carsTable" class="table table-dark table-hover" style="width:100%">
                    <thead>
                    <tr>
                        <th>Image</th>
                        <th>Brand</th>
                        <th>Year</th>
                        <th>Engine No.</th>
                        <th>Chassis No.</th>
                        <th>Reg. No.</th>
                        <th>Country</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${cars}" var="car">
                        <tr>
                            <td>
                                <c:if test="${not empty car.imageUrl}">
                                    <img src="${car.imageUrl}" alt="Car Image" class="car-image">
                                </c:if>
                                <c:if test="${empty car.imageUrl}">
                                    <span class="text-muted">No image</span>
                                </c:if>
                            </td>
                            <td>${car.brand}</td>
                            <td>${car.manufacturedYear}</td>
                            <td>${car.engineNumber}</td>
                            <td>${car.chassisNumber}</td>
                            <td>${car.registrationNumber}</td>
                            <td>${car.manufacturedCountry}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${car.deleteStatus}">
                                        <span class="badge bg-secondary">Deleted</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">Active</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group" role="group">
                                    <a href="/dashboard/edit-car/${car.id}" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${car.id}">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content bg-dark">
            <div class="modal-header border-bottom border-danger">
                <h5 class="modal-title">Confirm Deletion</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this car? This action cannot be undone.</p>
                <input type="hidden" id="carIdToDelete">
            </div>
            <div class="modal-footer border-top border-danger">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<!-- DataTables -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<!-- Custom Script -->
<script>
    // Initialize DataTable
    const table = $('#carsTable').DataTable({
        dom: '<"top"f>rt<"bottom"lip><"clear">',
        language: {
            search: "_INPUT_",
            searchPlaceholder: "Search...",
            lengthMenu: "Show _MENU_ entries",
            info: "Showing _START_ to _END_ of _TOTAL_ entries",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            }
        }
    });

    // Search functionality
    $('#searchInput').keyup(function() {
        table.search(this.value).draw();
    });

    // Filter buttons
    $('#filterAll').click(function() {
        table.columns(7).search('').draw();
        $(this).addClass('active').removeClass('btn-outline-red').addClass('btn-red');
        $('#filterActive, #filterDeleted').removeClass('active').addClass('btn-outline-red').removeClass('btn-red');
    });

    $('#filterActive').click(function() {
        table.columns(7).search('^Active$', true, false).draw();
        $(this).addClass('active').removeClass('btn-outline-red').addClass('btn-red');
        $('#filterAll, #filterDeleted').removeClass('active').addClass('btn-outline-red').removeClass('btn-red');
    });

    $('#filterDeleted').click(function() {
        table.columns(7).search('^Deleted$', true, false).draw();
        $(this).addClass('active').removeClass('btn-outline-red').addClass('btn-red');
        $('#filterAll, #filterActive').removeClass('active').addClass('btn-outline-red').removeClass('btn-red');
    });

    // Delete confirmation
    $(document).on('click', '.delete-btn', function() {
        const carId = $(this).data('id');
        $('#carIdToDelete').val(carId);
        $('#deleteModal').modal('show');
    });

    $('#confirmDelete').click(function() {
        const carId = $('#carIdToDelete').val();
        // Here you would typically make an AJAX call to delete the car
        console.log('Deleting car with ID:', carId);

        // For demonstration, we'll just remove the row
        table.row($('button[data-id="' + carId + '"]').closest('tr')).remove().draw();
        $('#deleteModal').modal('hide');

        // In a real application, you would do something like:

        fetch('/api/cars/' + carId, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',

            }
        })
        .then(response => {
            if (response.ok) {
                table.row($('button[data-id="' + carId + '"]').closest('tr')).remove().draw();
                showAlert('Car deleted successfully', 'success');
            } else {
                showAlert('Error deleting car', 'danger');
            }
            $('#deleteModal').modal('hide');
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('Error deleting car', 'danger');
            $('#deleteModal').modal('hide');
        });

    });

    // PDF Export
    $('#exportPdf').click(function() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Title
        doc.setFontSize(18);
        doc.setTextColor(220, 53, 69);
        doc.text('SecondCar - Vehicle List', 14, 20);

        // Date
        doc.setFontSize(10);
        doc.setTextColor(100, 100, 100);
        doc.text('Generated on: ' + new Date().toLocaleDateString(), 14, 28);

        // Table
        doc.autoTable({
            head: [['Brand', 'Year', 'Engine No.', 'Chassis No.', 'Reg. No.', 'Country', 'Status']],
            body: table.data().toArray().map(row => [
                row[1], // Brand
                row[2], // Year
                row[3], // Engine No.
                row[4], // Chassis No.
                row[5], // Reg. No.
                row[6], // Country
                row[7].includes('Active') ? 'Active' : 'Deleted' // Status
            ]),
            startY: 35,
            theme: 'grid',
            headStyles: {
                fillColor: [220, 53, 69],
                textColor: 255
            },
            alternateRowStyles: {
                fillColor: [30, 30, 30],
                textColor: 255
            },
            styles: {
                cellPadding: 3,
                fontSize: 10,
                valign: 'middle'
            },
            columnStyles: {
                0: { cellWidth: 30 },
                1: { cellWidth: 15 },
                2: { cellWidth: 30 },
                3: { cellWidth: 30 },
                4: { cellWidth: 25 },
                5: { cellWidth: 25 },
                6: { cellWidth: 20 }
            }
        });

        // Save the PDF
        doc.save('SecondCar_Vehicle_List.pdf');
    });

    // Helper function to show alerts
    function showAlert(message, type) {
        const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;
        $('.card-body').prepend(alertHtml);

        // Auto dismiss after 5 seconds
        setTimeout(() => {
            $('.alert').alert('close');
        }, 5000);
    }
</script>
</body>
</html>