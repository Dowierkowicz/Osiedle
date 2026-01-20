<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<html>
<head>
    <title>Strona Osiedla</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- Nagłówek strony: logo, menu oraz przyciski logowania/wylogowania/rejestracji -->
<header>
    <!-- Logo osiedla po lewej, po kliknięciu wraca na stronę główną -->
    <div>
        <a href="index.jsp">
            <img src="logo.png" alt="Osiedle" width="200" height="200">
        </a>
    </div>

    <!-- Menu główne: nawigacja po stronie osiedla -->
    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="ogloszenia.jsp">Ogloszenia</a>
        <a href="galeria.jsp">Galeria</a>
        <a href="mieszkancy.jsp">Mieszkańcy</a>
        <a href="kontakt.jsp">Kontakt</a>
    </div>

    <!-- Blok przycisków po prawej: logowanie, wylogowanie lub rejestracja -->
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

<!-- Główna część strony -->
<main>
    <!-- Duże zdjęcie/banner z przekierowaniem do galerii -->
    <nav>
        <div class="foto">
            <a href="galeria.jsp">
                <img src="logo2.png" alt="Osiedle" width=100% height="500">
            </a>
        </div>
    </nav>
    <br>
    <!-- Sekcja z najważniejszymi blokami treści -->
    <section>
        <!-- Blok powitalny -->
        <div class="blok">
            <h3>Witamy na stronie naszego osiedla!</h3>
            <p>Ta witryna została stworzona, aby mieszkańcy mogli być na bieżąco z informacjami, ogłoszeniami i kontaktami.</p>
        </div>
        <!-- Blok z aktualnościami -->
        <div class="blok">
            <h3>Aktualności</h3>
            <p>Nowy harmonogram wywozu śmieci został dodany do zakładki ogłoszenia.</p>
            <p>Zapraszamy na zebranie wspólnoty mieszkaniowej – szczegóły w zakładce <a href="kontakt.jsp">kontakt.</a></p>
        </div>
        <div class="blok">
            <h3>Mapa osiedla Zielone Wzgórza</h3>

            <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d719.20816497151!2d23.104688822905594!3d53.12258772797361!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x471ffb8536d8a141%3A0xf03e2966afc1ea3d!2sZielone%20Wzg%C3%B3rza%2C%20Bia%C5%82ystok!5e1!3m2!1spl!2spl!4v1768932489034!5m2!1spl!2spl"
                width="100%"
                height="450"
                style="border:0; border-radius:12px;"
                allowfullscreen
                loading="lazy"
                referrerpolicy="no-referrer-when-downgrade">
            </iframe>

        </div>
    </section>
</main>

<!-- Stopka z prawami autorskimi -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

</body>
</html>