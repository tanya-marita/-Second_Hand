<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management Dashboard</title>

    <!-- Bootstrap Dark Theme -->
    <link href="https://stackpath.bootstrapcdn.com/bootswatch/4.5.2/darkly/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    <!-- Core JS Libraries - Load before other scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <!-- jsPDF Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js"></script>

    <style>
        .bg-custom-dark {
            background-color: #1a1a1a;
        }
        .bg-custom-red {
            background-color: #8B0000;
        }
        .text-custom-red {
            color: #FF4444;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(139, 0, 0, 0.2);
        }
        .btn-outline-custom-red {
            color: #FF4444;
            border-color: #FF4444;
        }
        .btn-outline-custom-red:hover {
            background-color: #8B0000;
            color: white;
        }
        .search-box {
            border-color: #8B0000;
            background-color: #2d2d2d;
            color: white;
        }
        .badge-admin {
            background-color: #8B0000;
            color: white;
        }
    </style>
</head>
<body class="bg-custom-dark">
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <nav class="navbar navbar-expand-lg navbar-dark bg-custom-red mb-4">
                <a class="navbar-brand" href="#">
                    <i class="fas fa-users mr-2"></i>User Management
                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                <i class="fas fa-tachometer-alt mr-1"></i>Dashboard
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <h2 class="text-custom-red">
                <i class="fas fa-list mr-2"></i>User List
            </h2>
        </div>

    </div>



    <div class="row">
        <div class="col-12">
            <div class="table-responsive">
                <table class="table table-dark table-hover table-bordered" id="usersTable">
                    <thead class="bg-custom-red">
                    <tr>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Address</th>
                        <th>Email</th>
                        <th>Role</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${not empty users}">
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td>${user.firstName}</td>
                                <td>${user.lastName}</td>
                                <td>${user.address}</td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="badge ${user.role == 'ADMIN' ? 'badge-danger' : 'badge-secondary'}">
                                            ${user.role}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    // Wait for document to be fully loaded
    $(document).ready(function() {
        // Search functionality
        $("#searchInput").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $("#usersTable tbody tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
            });
        });

        // PDF Export functionality
        $("#exportPdf").click(function() {
            // Properly initialize jsPDF
            window.jsPDF = window.jspdf.jsPDF;

            // Create new PDF document
            var doc = new jsPDF();

            // Title
            doc.setFontSize(18);
            doc.setTextColor(139, 0, 0);
            doc.text('User List Report', 105, 15, { align: 'center' });

            // Date
            doc.setFontSize(10);
            doc.setTextColor(100, 100, 100);
            doc.text('Generated: ' + new Date().toLocaleDateString(), 105, 22, { align: 'center' });

            // Create table data array
            var tableData = [];

            <c:if test="${not empty users}">
            <c:forEach items="${users}" var="user">
            tableData.push(['${user.firstName}', '${user.lastName}', '${user.address}', '${user.email}', '${user.role}']);
            </c:forEach>
            </c:if>

            // Generate table
            doc.autoTable({
                head: [['First Name', 'Last Name', 'Address', 'Email', 'Role']],
                body: tableData,
                startY: 30,
                theme: 'grid',
                headStyles: {
                    fillColor: [139, 0, 0],
                    textColor: [255, 255, 255]
                },
                alternateRowStyles: {
                    fillColor: [45, 45, 45],
                    textColor: [255, 255, 255]
                },
                styles: {
                    cellPadding: 3,
                    fontSize: 10,
                    valign: 'middle',
                    overflow: 'linebreak',
                    tableWidth: 'auto'
                }
            });

            // Save the PDF
            doc.save("user_report_" + new Date().toISOString().slice(0,10) + ".pdf");
        });
    });
</script>
</body>
</html>