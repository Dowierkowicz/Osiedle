<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<html>
<head>
    <title>Strona Osiedla</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
    <div><h2>Strona Osiedla</h2></div>
    <div class="top-buttons">
        <%
            HttpSession sess = request.getSession(false);
            if (sess != null && sess.getAttribute("username") != null) {
        %>
            <span>Witaj, <%= sess.getAttribute("username") %></span>
            <form action="logout" method="get" style="display:inline;">
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

<nav>
    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="oferta.jsp">Oferta</a>
        <a href="galeria.jsp">Galeria</a>
        <a href="kontakt.jsp">Kontakt</a>
        <a href="mieszkancy.jsp">Mieszkańcy</a>
    </div>
</nav>


<main>
    <section>
        <div class="blok">
            <h3>Witamy na stronie naszego osiedla!</h3>
            <p>Ta witryna została stworzona, aby mieszkańcy mogli być na bieżąco z informacjami, ogłoszeniami i kontaktami.</p>
        </div>


        <div class="blok">
            <h3>Aktualności</h3>
            <p>Nowy harmonogram wywozu śmieci został dodany do zakładki ogłoszenia.</p>
            <p>Zapraszamy na zebranie wspólnoty mieszkaniowej – szczegóły w zakładce kontakt.</p>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

</body>
</html>
