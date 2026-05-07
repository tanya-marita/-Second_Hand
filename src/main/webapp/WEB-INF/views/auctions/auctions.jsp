<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction Management | SecondCar</title>
    <!-- Bootstrap Dark Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-dark-5@1.1.3/dist/css/bootstrap-night.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <!-- jsPDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
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

        .btn-outline-green {
            color: var(--bs-green);
            border-color: var(--bs-green);
        }

        .btn-outline-green:hover {
            background-color: var(--bs-green);
            color: white;
        }

        .car-image {
            width: 80px;
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

        .badge-open {
            background-color: var(--bs-green);
        }

        .badge-closed {
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
                <h4 class="mb-0"><i class="fas fa-gavel me-2"></i>Auction Management</h4>
                <div>
                    <a href="/dashboard/create-auction" class="btn btn-outline-red me-2">
                        <i class="fas fa-plus me-1"></i> New Auction
                    </a>
                    <button id="exportPdf" class="btn btn-outline-red me-2">
                        <i class="fas fa-file-pdf me-1"></i> Export PDF
                    </button>
                    <a href="/dashboard" class="btn btn-outline-red">
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
                        <input type="text" id="searchInput" class="form-control" placeholder="Search auctions...">
                    </div>
                </div>
                <div class="col-md-6 text-end">

                </div>
            </div>

            <div class="table-responsive">
                <table id="auctionsTable" class="table table-dark table-hover" style="width:100%">
                    <thead>
                    <tr>
                        <th>Car</th>

                        <th>Brand</th>
                        <th>Year</th>
                        <th>Start Price</th>
                        <th>Status</th>
                        <th>Auction Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${auctions}" var="auction">
                        <tr>
                            <td>
                                <c:if test="${not empty auction.car.id}">
                                    <p  >${auction.car.id} </p>
                                </c:if>

                            </td>
                            <td>${auction.car.brand}</td>
                            <td>${auction.car.manufacturedYear}</td>
                            <td>$${auction.bidStartPrice}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${auction.status == 'OPEN'}">
                                        <span class="badge badge-open">Open</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-closed">Closed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${auction.auctionDate}</td>
                            <td>
                                <div class="btn-group" role="group">
                                    <a href="/dashboard/edit-auction/${auction.id}" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${auction.id}">
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
                <p>Are you sure you want to delete this auction? This action cannot be undone.</p>
                <input type="hidden" id="auctionIdToDelete">
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
<!-- Flatpickr -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<!-- Custom Script -->
<script>
    // Initialize DataTable
    const table = $('#auctionsTable').DataTable({
        dom: '<"top"f>rt<"bottom"lip><"clear">',
        language: {
            search: "INPUT",
            searchPlaceholder: "Search...",
            lengthMenu: "Show MENU entries",
            info: "Showing START to END of TOTAL entries",
            paginate: {
                first: "First",
                last: "Last",
                next: "Next",
                previous: "Previous"
            }
        },
        columnDefs: [
            { targets: [4], orderDataType: 'dom-text', type: 'string' },
            { targets: [5], type: 'date' }
        ]
    });

    // Search functionality
    $('#searchInput').keyup(function() {
        table.search(this.value).draw();
    });

    // Filter buttons
    $('#filterAll').click(function() {
        table.columns(4).search('').draw();
        $(this).removeClass('btn-outline-red').addClass('btn-red');
        $('#filterOpen, #filterClosed').removeClass('btn-green btn-red').addClass('btn-outline-green btn-outline-red');
    });

    $('#filterOpen').click(function() {
        table.columns(4).search('^Open$', true, false).draw();
        $(this).removeClass('btn-outline-green').addClass('btn-green');
        $('#filterAll, #filterClosed').removeClass('btn-red btn-green').addClass('btn-outline-red btn-outline-green');
    });

    $('#filterClosed').click(function() {
        table.columns(4).search('^Closed$', true, false).draw();
        $(this).removeClass('btn-outline-red').addClass('btn-red');
        $('#filterAll, #filterOpen').removeClass('btn-red btn-green').addClass('btn-outline-red btn-outline-green');
    });

    // Delete confirmation
    $(document).on('click', '.delete-btn', function() {
        const auctionId = $(this).data('id');
        $('#auctionIdToDelete').val(auctionId);
        $('#deleteModal').modal('show');
    });

    $('#confirmDelete').click(function() {
        const auctionId = $('#auctionIdToDelete').val();

        fetch('/api/auctions/' + auctionId + '/hard', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            }
        })
            .then(response => {
                if (response.ok) {
                    table.row($('button[data-id="' + auctionId + '"]').closest('tr')).remove().draw();
                    showAlert('Auction deleted successfully', 'success');
                } else {
                    showAlert('Error deleting auction', 'danger');
                }
                $('#deleteModal').modal('hide');
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Error deleting auction', 'danger');
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
        doc.text('SecondCar - Auction List', 14, 20);

        // Date
        doc.setFontSize(10);
        doc.setTextColor(100, 100, 100);
        doc.text('Generated on: ' + new Date().toLocaleDateString(), 14, 28);

        // Table
        doc.autoTable({
            head: [['Car Brand', 'Year', 'Start Price', 'Status', 'Auction Date']],
            body: table.data().toArray().map(row => [
                row[1], // Brand
                row[2], // Year
                row[3], // Start Price
                row[4].includes('Open') ? 'Open' : 'Closed', // Status
                row[5]  // Auction Date
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
                0: { cellWidth: 40 },
                1: { cellWidth: 20 },
                2: { cellWidth: 25 },
                3: { cellWidth: 20 },
                4: { cellWidth: 30 }
            }
        });

        // Save the PDF
        doc.save('SecondCar_Auction_List.pdf');
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