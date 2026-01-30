<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession, java.io.*, java.util.*" %>
<html>
<head>
    <title>Ogłoszenia</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- ============ NAGŁÓWEK STRONY ============ -->
<header>
    <!-- Logo osiedla po lewej stronie, po kliknięciu wraca na stronę główną -->
    <div> <a href="index.jsp">
        <img src="logo.png" alt="Osiedle" width="200" height="200">
    </a></div>
    <%@ include file="/WEB-INF/jsp/clock.jspf" %>

    <!-- Menu nawigacyjne po wszystkich podstronach -->
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
            String user = (sess != null) ? (String) sess.getAttribute("username") : null;
            if (user != null) {
        %>
        <span>Witaj, <%= user %></span>
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

<main>
    <section>
        <div class="blok">
            <h3>Ogłoszenia mieszkańców</h3>
            <ul>
                <%
                    // ========== Wczytanie listy ogłoszeń z pliku ==========
                    String pathO = application.getRealPath("/") + "ogloszenia.txt";
                    File fo = new File(pathO);
                    List<String[]> posts = new ArrayList<>();
                    if (fo.exists()) {
                        try (BufferedReader br = new BufferedReader(new FileReader(fo))) {
                            String line;
                            while ((line = br.readLine()) != null) {
                                String[] parts = line.split("\\|\\|", 4);
                                if (parts.length >= 3) {
                                    posts.add(parts);
                                }
                            }
                        }
                    }
                    if (posts.isEmpty()) {
                %>
                <li>Brak ogłoszeń.</li>
                <%
                } else {
                    for (String[] og : posts) {
                        String id    = og[0];
                        String autor = og[1];
                        String tresc = og[2];
                        String imgs  = (og.length == 4 ? og[3] : "");
                %>
                <li>
                    <strong><%= autor %></strong>:
                    <span id="content-<%= id %>"><%= tresc %></span>
                    <%-- ======= Jeśli ogłoszenie należy do zalogowanego użytkownika, pokaż opcje edycji i usuwania ======= --%>
                    <%
                        if (user != null && user.equals(autor)) {
                    %>
                    <button onclick="showEdit(<%= id %>)">Edytuj</button>
                    <form action="${pageContext.request.contextPath}/deleteOgloszenie" method="post">
                          Na pewno usunąć to ogłoszenie?
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit">Usuń</button>
                    </form>
                    <%
                        }
                    %>

                    <%-- ======= Formularz edycji ogłoszenia (pokazuje się po kliknięciu "Edytuj") ======= --%>
                    <div id="edit-<%= id %>" style="display:none; margin-top:8px;">
                        <form action="${pageContext.request.contextPath}/editOgloszenie" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<%= id %>"><br>
                            <input type="text" name="tresc" value="<%= tresc %>"
                                   style="width:70%; padding:4px;"><br><br>
                            <% if (!imgs.isEmpty()) {
                                String[] existing = imgs.split(",");
                                for (String fn : existing) {
                            %>
                            <div style="display:inline-block; text-align:center; margin-right:8px;">
                                <img src="uploads/<%= fn %>" style="width:100px; height:auto;"><br>
                                <label>
                                    <input type="checkbox" name="remove" value="<%= fn %>">
                                    Usuń
                                </label>
                            </div>
                            <%     } %>
                            <br><br>
                            <% } %>
                            <label>Dodaj nowe zdjęcia (max 3):</label><br>
                            <input type="file" name="images" multiple accept="image/*"><br><br>
                            <button type="submit">Zapisz zmiany</button>
                        </form>
                    </div>

                    <%-- ======= Galeria zdjęć powiązanych z ogłoszeniem ======= --%>
                    <div class="gallery">
                        <%
                            if (!imgs.isEmpty()) {
                                for (String fn : imgs.split(",")) {
                        %>
                        <img src="uploads/<%= fn %>" alt="zdjęcie ogłoszenia">
                        <%
                                }
                            }
                        %>
                    </div>

                    <%-- ======= Lista komentarzy do ogłoszenia (wczytane z pliku comments.txt) ======= --%>
                    <ul style="margin-left:20px;">
                        <%
                            String pathC = application.getRealPath("/") + "comments.txt";
                            File fc = new File(pathC);
                            if (fc.exists()) {
                                try (BufferedReader br2 = new BufferedReader(new FileReader(fc))) {
                                    String cl;
                                    while ((cl = br2.readLine()) != null) {
                                        String[] cp = cl.split("\\|\\|", 3);
                                        if (cp.length == 3 && cp[0].equals(id)) {
                                            String cAutor = cp[1], cText = cp[2];
                        %>
                        <li>
                            <em><%= cAutor %></em>: <%= cText %>
                            <% if (user != null && user.equals(cAutor)) { %>
                            <form action="${pageContext.request.contextPath}/deleteComment" method="post">
                            Usunąć komentarz?
                                <input type="hidden" name="id" value="<%= id %>">
                                <input type="hidden" name="author" value="<%= cAutor %>">
                                <input type="hidden" name="text" value="<%= cText %>">
                                <button type="submit">✖</button>
                            </form>
                            <% } %>
                        </li>
                        <%
                                        }
                                    }
                                }
                            }
                        %>
                    </ul>

                    <%-- ======= Dodawanie nowego komentarza (widoczne tylko dla zalogowanych) ======= --%>
                    <% if (user != null) { %>
                    <form action="${pageContext.request.contextPath}/addComment" method="post">
                    <input type="hidden" name="id" value="<%= id %>">
                        <input type="text" name="comment" required style="width:60%;padding:4px;">
                        <button type="submit">Dodaj komentarz</button>
                    </form>
                    <% } %>
                </li>
                <%
                        }  // koniec for
                    }  // koniec else posts
                %>
            </ul>

            <%-- ======= Komunikat o konieczności logowania przy dodawaniu nowego ogłoszenia ======= --%>
            <%
                String mustLogin = (String) request.getAttribute("mustLogin");
                if (mustLogin != null) {
            %>
            <div class="blok" style="background-color:#ffe6e6; color:red;">
                <%= mustLogin %>
            </div>
            <% } %>

            <%-- ======= Formularz dodania nowego ogłoszenia (tylko po zalogowaniu) ======= --%>
            <% if (user != null) { %>
            <form action="${pageContext.request.contextPath}/addOgloszenie" method="post" enctype="multipart/form-data">
            <label>Treść ogłoszenia:</label><br>
                <textarea name="ogloszenie" required style="width:80%;height:60px;"></textarea><br><br>
                <label>Zdjęcia (max 3):</label><br>
                <input type="file" name="images" multiple accept="image/*"><br><br>
                <button type="submit">Dodaj ogłoszenie</button>
            </form>
            <% } else { %>
            <form action="addOgloszenie" method="post">
                <button type="submit">Dodaj ogłoszenie</button>
            </form>
            <% } %>
        </div>
    </section>
</main>

<!-- ============ SKRYPT DO POKAZYWANIA FORMULARZA EDYCJI OGŁOSZENIA ============ -->
<script>
    // Pokazuje formularz edycji wybranego ogłoszenia
    function showEdit(id) {
        document.getElementById('edit-' + id).style.display = 'block';
    }
</script>

<!-- ============ STOPKA STRONY ============ -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

</body>
</html>
