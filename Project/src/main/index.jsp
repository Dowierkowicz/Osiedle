<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<html>
<head>
    <title>Strona główna osiedla</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .top-nav {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .top-nav a {
            margin: 0 10px;
            color: #2e8b57;
            font-weight: bold;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="top-nav">
    <%
        HttpSession sessionUser = request.getSession(false);
        if (sessionUser != null && sessionUser.getAttribute("username") != null) {
    %>
    <span>Witaj, <%= sessionUser.getAttribute("username") %></span>
    <a href="logout">Wyloguj</a>
    <%
    } else {
    %>
    <a href="login.jsp">Zaloguj</a>
    <a href="register.jsp">Rejestracja</a>
    <%
        }
    %>
</div>