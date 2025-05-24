<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("username") == null) {
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tylko dla zalogowanych użytkowników</title>
    <link rel="stylesheet" href="style.css">
    <script>
        setTimeout(function() {
            window.location.href = 'login.jsp';
        }, 2000); // 2 sekundy
    </script>
</head>
<body>
<div style="text-align:center; margin-top:100px;">
    <div class="blok" style="display: inline-block;">
        <h2 style="color: red;">Tylko dla zalogowanych użytkowników</h2>
        <p>Za chwilę zostaniesz przeniesiony do strony logowania...</p>
    </div>
</div>
</body>
</html>
<%
        return;
    }
%>
<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<html>
<head>
    <title>Mieszkańcy osiedla</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
    <div><h2>Strona Osiedla</h2></div>
    <div class="top-buttons">
        <%
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
        <a href="rejestracja.jsp"><button>Rejestracja</button></a>
        <%
            }
        %>
    </div>
</header>

<main>
    <section>
        <div class="blok">
            <h3>Lista mieszkańców</h3>
            <!-- Wstaw tutaj dane z mieszkancy1.jsp -->
            <ul>
                <li>Jan Kowalski – klatka A, mieszkanie 3</li>
                <li>Anna Nowak – klatka B, mieszkanie 8</li>
                <li>Piotr Zieliński – klatka A, mieszkanie 7</li>

            </ul>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

</body>
</html>