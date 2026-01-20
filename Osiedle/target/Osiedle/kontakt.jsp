<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Kontakt - Osiedle Zielone Wzgórze</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<%
    // Pobranie aktualnej sesji (jeśli jest) – do sprawdzenia logowania
    HttpSession sess = request.getSession(false);
%>
<!-- ======================= NAGŁÓWEK STRONY ======================= -->
<header>
    <!-- Logo osiedla po lewej stronie, po kliknięciu wraca na stronę główną -->
    <div>
        <a href="index.jsp">
            <img src="logo.png" alt="Osiedle" width="200" height="200">
        </a>
    </div>
    <!-- Menu nawigacyjne z odnośnikami do wszystkich podstron -->
    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="ogloszenia.jsp">Ogłoszenia</a>
        <a href="galeria.jsp">Galeria</a>
        <a href="mieszkancy.jsp">Mieszkańcy</a>
        <a href="kontakt.jsp" class="active">Kontakt</a>
    </div>
    <!-- Panel użytkownika: przyciski logowania/rejestracji lub powitanie i wylogowanie -->
    <div class="top-buttons">
        <%
            // Jeśli użytkownik jest zalogowany – pokazujemy powitanie i przycisk wylogowania
            if (sess != null && sess.getAttribute("username") != null) {
        %>
        <span>Witaj, <%= sess.getAttribute("username") %></span>
        <form action="${pageContext.request.contextPath}/logout" method="get" style="display:inline;">
        <button type="submit">Wyloguj</button>
        </form>
        <%
        } else {
            // Jeśli NIE jest zalogowany – pokazujemy przyciski logowania i rejestracji
        %>
        <a href="login.jsp"><button>Zaloguj</button></a>
        <a href="register.jsp"><button>Rejestracja</button></a>
        <%
            }
        %>
    </div>
</header>

<!-- ======================= GŁÓWNA TREŚĆ STRONY ======================= -->
<main class="container contact-section">
    <div class="contact-box">
        <!-- Tytuł sekcji kontaktowej -->
        <h2>Kontakt z administracją</h2>
        <!-- Lista kontaktowa: tel., email, adres -->
        <ul class="contact-list">
            <li><span>Telefon:</span> +48 123 456 789</li>
            <li><span>Email:</span> admin@zielonewzgorze.pl</li>
            <li><span>Adres:</span> ul. Żartobliwa 42, 12-345 Śmieszne Miasto</li>
        </ul>
        <!-- Numery alarmowe w kolorowej ramce -->
        <div class="emergency">
            <strong>Numery alarmowe:</strong><br>
            <span>Policja:</span> 997 &nbsp;|&nbsp;
            <span>Straż pożarna:</span> 998 &nbsp;|&nbsp;
            <span>Pogotowie:</span> 999
        </div>
        <!-- Godziny pracy administracji -->
        <div>
            <strong>Administracja czynna:</strong> poniedziałek–piątek, 9:00–16:00
        </div>
        <!-- Szybki formularz zgłoszeniowy do administracji -->
        <form class="fast-report-form"
              method="post"
              action="${pageContext.request.contextPath}/zgloszenie">
            <h3>Zgłoś sprawę do administracji</h3>
            <input type="text" name="imie" placeholder="Imię i nazwisko" required>
            <input type="email" name="email" placeholder="Adres e-mail" required>
            <input type="text" name="temat" placeholder="Temat sprawy" required>
            <textarea name="wiadomosc" rows="4" placeholder="Treść wiadomości" required></textarea>
            <button type="submit">Wyślij zgłoszenie</button>
        </form>
        <%
            // Po wysłaniu zgłoszenia przez formularz (obsługiwane przez serwlet)
            // wyświetlany jest komunikat potwierdzający
            if (request.getAttribute("sent") != null) {
        %>
        <div class="msg-confirm">Dziękujemy za zgłoszenie! Administracja odezwie się do Ciebie wkrótce.</div>
        <%
            }
        %>
    </div>
</main>

<!-- ======================= STOPKA ======================= -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>
</body>
</html>
