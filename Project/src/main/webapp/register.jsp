
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Rejestracja do osiedla</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<header><h2>Rejestracja mieszkańców</h2></header>
<section>
    <form action="register" method="post">
        Login: <input type="text" name="username" required><br>
        Hasło: <input type="password" name="password" required><br>
        <input type="submit" value="Zarejestruj">
    </form>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <p style="color:red;"><%= error %></p>
    <%
        }
    %>
    <p>Masz już konto? <a href="login.jsp">Zaloguj się</a></p>
</section>
<footer>Strona Osiedla</footer>
</body>
</html>