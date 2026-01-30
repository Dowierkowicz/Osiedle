<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<html>
<head>
    <title>Rejestracja do osiedla</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<!-- ============ NAGŁÓWEK STRONY ============ -->
<header>
    <!-- Logo osiedla po lewej, link do strony głównej -->
    <div> <a href="index.jsp">
        <img src="logo.png" alt="Osiedle" width="200" height="200">
    </a></div>
    <%@ include file="/WEB-INF/jsp/clock.jspf" %>

    <!-- Menu główne nawigacyjne po wszystkich podstronach -->
    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="ogloszenia.jsp">Ogloszenia</a>
        <a href="galeria.jsp">Galeria</a>
        <a href="mieszkancy.jsp">Mieszkańcy</a>
        <a href="kontakt.jsp">Kontakt</a>
    </div>

    <!-- Panel użytkownika: powitanie i wylogowanie lub logowanie/rejestracja -->
    <div class="top-buttons">
        <%
            HttpSession sess = request.getSession(false);
            if (sess != null && sess.getAttribute("username") != null) {
        %>
        <span>Witaj, <%= sess.getAttribute("username") %></span>
        <form action="${pageContext.request.contextPath}/logout" method="get" style="display:inline;">

        <button type="submit">Wyloguj</button>
        </form>
        <%
        } else {
        %>
        <a href="login.jsp"><button>Zaloguj</button></a>
        <a href="register.jsp"><button>Rejestracja</button></a>
        <%
            }
        %>
    </div>
</header>

<!-- ============ GŁÓWNA SEKCJA REJESTRACJI ============ -->
<h2>Rejestracja mieszkańców</h2>
<section>
    <!-- Formularz rejestracyjny do nowego konta użytkownika -->
    <form action="${pageContext.request.contextPath}/register" method="post">
        Login: <input type="text" name="username" required>
        Hasło: <input type="password" name="password" required>
        <input type="submit" value="Zarejestruj">
    </form>
    <%
        // Jeśli podczas rejestracji pojawił się błąd (np. login zajęty) – wyświetl komunikat na czerwono
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p style="color:red;"><%= error %></p>
    <%
        }
    %>
    <!-- Link do strony logowania jeśli ktoś ma już konto -->
    <p>Masz już konto? <a href="login.jsp">Zaloguj się</a></p>
</section>

<!-- ============ STOPKA STRONY ============ -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

</body>
</html>
