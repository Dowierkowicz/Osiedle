<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Galeria - Osiedle Zielone Wzgórze</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
</head>
<body>
<!-- ===================== NAGŁÓWEK STRONY ===================== -->
<header>
    <!-- Logo osiedla (klik przenosi na stronę główną) -->
    <div> <a href="index.jsp">
        <img src="logo.png" alt="Osiedle" width="200" height="200">
    </a></div>

    <!-- Menu nawigacyjne: linki do wszystkich podstron -->
    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="ogloszenia.jsp">Ogloszenia</a>
        <a href="galeria.jsp">Galeria</a>
        <a href="mieszkancy.jsp">Mieszkańcy</a>
        <a href="kontakt.jsp">Kontakt</a>
    </div>

    <!-- Panel użytkownika: powitanie i przycisk wyloguj lub logowanie/rejestracja -->
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
        <br><a href="register.jsp"><button>Rejestracja</button></a>
        <%
            }
        %>
    </div>
</header>

<!-- ===================== TYTUŁ STRONY LUB BLOK LOGOWANIA ===================== -->
<h2>Logowanie mieszkańców</h2>

<!-- ===================== SEKCJA FORMULARZA LOGOWANIA ===================== -->
<section>
    <!-- Formularz logowania do konta mieszkańca -->


    <form action="${pageContext.request.contextPath}/login" method="post">


        Login: <input type="text" name="username" required>
        Hasło: <input type="password" name="password" required>
        <input type="submit" value="Zaloguj">
    </form>
    <%
        // Jeśli został przekazany błąd (np. złe hasło) – pokaż komunikat na czerwono
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p style="color:red;"><%= error %></p>
    <%
        }
    %>
    <!-- Link do rejestracji nowego konta -->
    <p>Nie masz konta? <a href="register.jsp">Zarejestruj się</a></p>
</section>

<!-- ===================== STOPKA STRONY ===================== -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

</body>
</html>
