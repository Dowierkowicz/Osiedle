<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logowanie do osiedla</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<header><h2>Logowanie mieszkańców</h2></header>
<section>
    <form action="login" method="post">
        Login: <input type="text" name="username" required><br>
        Hasło: <input type="password" name="password" required><br>
        <input type="submit" value="Zaloguj">
    </form>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p style="color:red;"><%= error %></p>
    <%
        }
    %>
    <p>Nie masz konta? <a href="register.jsp">Zarejestruj się</a></p>
</section>
<footer>Strona Osiedla</footer>
</body>
</html>