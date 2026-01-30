<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Sprawdzenie, czy użytkownik jest zalogowany; jeśli nie – przekierowanie na login z komunikatem
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?error=auth");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Mieszkańcy – Osiedle Zielone Wzgórze</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<!-- ======================== NAGŁÓWEK STRONY ======================== -->
<header>
    <!-- Logo osiedla -->
    <div><img src="logo.png" alt="Osiedle" width="200" height="200"></div>
    <%@ include file="/WEB-INF/jsp/clock.jspf" %>

    <!-- Menu nawigacyjne -->
    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="ogloszenia.jsp">Ogłoszenia</a>
        <a href="galeria.jsp">Galeria</a>
        <a href="mieszkancy.jsp" class="active">Mieszkańcy</a>
        <a href="kontakt.jsp">Kontakt</a>
    </div>
    <!-- Powitanie i przycisk wylogowania (po zalogowaniu) -->
    <div class="top-buttons">
        <span>Witaj, <%= sess.getAttribute("username") %></span>
        <form action="${pageContext.request.contextPath}/logout" method="get" style="display:inline;">
            <button type="submit">Wyloguj</button>
        </form>
    </div>
</header>

<!-- ======================== GŁÓWNA ZAWARTOŚĆ – WIDOK LISTY MIESZKAŃCÓW ======================== -->
<main class="container info-section">
    <h2>Lista mieszkańców</h2>
    <!-- Wybór bloku -->
    <div id="view-buildings">
        <ul class="building-list">
            <li><button class="building-link" onclick="showStaircases(0)">ul. Wiosenna 1</button></li>
            <li><button class="building-link" onclick="showStaircases(1)">ul. Wiosenna 2</button></li>
            <li><button class="building-link" onclick="showStaircases(2)">ul. Słoneczna 5</button></li>
            <li><button class="building-link" onclick="showStaircases(3)">ul. Słoneczna 6</button></li>
        </ul>
    </div>
    <!-- Wybór klatki schodowej -->
    <div id="view-staircases" style="display:none;">
        <h3 id="building-title"></h3>
        <ul class="staircase-list">
            <li><button class="staircase-link" onclick="showApartments(0)">Klatka A</button></li>
            <li><button class="staircase-link" onclick="showApartments(1)">Klatka B</button></li>
            <li><button class="staircase-link" onclick="showApartments(2)">Klatka C</button></li>
            <li><button class="staircase-link" onclick="showApartments(3)">Klatka D</button></li>
            <li><button class="staircase-link" onclick="showApartments(4)">Klatka E</button></li>
        </ul>
        <a class="back-link" onclick="showBuildings()">← Wróć do wyboru bloku</a>
    </div>
    <!-- Lista mieszkań w wybranej klatce, z możliwością edycji domowników -->
    <div id="view-apartments" style="display:none;">
        <h3 id="staircase-title"></h3>
        <div id="apartments-list"></div>
        <a class="back-link" onclick="showStaircases(currentBuilding)">← Wróć do wyboru klatki</a>
    </div>
</main>

<!-- ======================== STOPKA ======================== -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

<!-- ======================== SKRYPTY JS – LOGIKA LISTY MIESZKAŃCÓW ======================== -->
<script>
    // Lista bloków i nazw klatek (A-E) dla każdego bloku
    const data = [
        {
            name: "ul. Wiosenna 1",
            staircases: ["A","B","C","D","E"]
        },
        {
            name: "ul. Wiosenna 2",
            staircases: ["A","B","C","D","E"]
        },
        {
            name: "ul. Słoneczna 5",
            staircases: ["A","B","C","D","E"]
        },
        {
            name: "ul. Słoneczna 6",
            staircases: ["A","B","C","D","E"]
        }
    ];

    // Tablice przykładowych imion i nazwisk do losowania mieszkańców
    const imiona = ["Anna", "Jan", "Katarzyna", "Piotr", "Maria", "Tomasz", "Agnieszka", "Michał", "Ewa", "Krzysztof", "Barbara", "Grzegorz", "Joanna", "Paweł", "Monika", "Łukasz"];
    const nazwiska = ["Nowak", "Kowalski", "Wiśniewska", "Dąbrowski", "Lewandowska", "Zieliński", "Wójcik", "Kamińska", "Szymański", "Woźniak", "Kozłowski", "Jankowska", "Mazur", "Krawczyk", "Kaczmarek"];

    // Przechowywanie aktualnego stanu mieszkańców dla każdego mieszkania (tylko w przeglądarce, nie w bazie)
    let residentsData = {};

    // Funkcja losująca domowników do mieszkania (2-4 osoby)
    function losujOsoby(ile) {
        let res = [];
        for (let i=0; i<ile; ++i) {
            const imie = imiona[Math.floor(Math.random()*imiona.length)];
            const nazwisko = nazwiska[Math.floor(Math.random()*nazwiska.length)];
            res.push(imie + " " + nazwisko);
        }
        return res;
    }

    // Inicjowanie losowych mieszkańców w każdym mieszkaniu (wykonywane tylko raz)
    function initResidents() {
        for (let b=0; b<data.length; b++) {
            for (let s=0; s<5; s++) {
                for (let m=1; m<=6; m++) {
                    const key = b+"-"+s+"-"+m;
                    if (!residentsData[key]) {
                        const ile = 2 + Math.floor(Math.random()*3);
                        residentsData[key] = losujOsoby(ile);
                    }
                }
            }
        }
    }

    // Zmienne globalne do śledzenia wybranego bloku i klatki
    let currentBuilding = 0;
    let currentStaircase = 0;

    // Pokazuje widok wyboru bloku (pozostałe ukrywa)
    function showBuildings() {
        document.getElementById('view-buildings').style.display = '';
        document.getElementById('view-staircases').style.display = 'none';
        document.getElementById('view-apartments').style.display = 'none';
    }

    // Pokazuje wybór klatki schodowej dla danego bloku
    function showStaircases(buildingIdx) {
        currentBuilding = buildingIdx;
        document.getElementById('view-buildings').style.display = 'none';
        document.getElementById('view-staircases').style.display = '';
        document.getElementById('view-apartments').style.display = 'none';
        document.getElementById('building-title').innerText = data[buildingIdx].name;
    }

    // Pokazuje listę mieszkań i mieszkańców w wybranej klatce, z opcją dodania/usunięcia mieszkańca
    function showApartments(staircaseIdx) {
        currentStaircase = staircaseIdx;
        document.getElementById('view-buildings').style.display = 'none';
        document.getElementById('view-staircases').style.display = 'none';
        document.getElementById('view-apartments').style.display = '';
        document.getElementById('staircase-title').innerText = data[currentBuilding].name + " – klatka " + data[currentBuilding].staircases[staircaseIdx];
        // 6 mieszkań po 2-4 osoby + obsługa edycji
        let html = '';
        for (let m=1; m<=6; m++) {
            const key = currentBuilding+"-"+currentStaircase+"-"+m;
            const lokatorzy = residentsData[key] || [];
            html += '<div class="apartment-box"><span class="apartment-num">Mieszkanie ' + m + ':</span><ul class="residents">';
            for (let p=0; p<lokatorzy.length; p++) {
                html += '<li class="resident-row">'+
                    '<span>'+lokatorzy[p]+'</span> '+
                    '<button class="delete-btn" onclick="deleteResident('+m+','+p+')">Usuń</button>'+
                    '</li>';
            }
            html += '</ul>';
            // Formularz do dodawania mieszkańca do mieszkania
            html += '<form class="add-resident-form" onsubmit="return addResident('+m+', this)">'+
                '<input type="text" name="imienazwisko" placeholder="Imię i nazwisko" required>'+
                '<button type="submit">Dodaj</button>'+
                '</form>';
            html += '</div>';
        }
        document.getElementById('apartments-list').innerHTML = html;
    }

    // Dodaje nowego mieszkańca do wybranego mieszkania
    function addResident(mieszkanie, form) {
        const name = form.imienazwisko.value.trim();
        if (name.length > 2) {
            const key = currentBuilding+"-"+currentStaircase+"-"+mieszkanie;
            if (!residentsData[key]) residentsData[key] = [];
            residentsData[key].push(name);
            showApartments(currentStaircase);
        }
        form.imienazwisko.value = '';
        return false;
    }

    // Usuwa mieszkańca z listy po kliknięciu "Usuń"
    function deleteResident(mieszkanie, idx) {
        const key = currentBuilding+"-"+currentStaircase+"-"+mieszkanie;
        if (residentsData[key]) {
            residentsData[key].splice(idx,1);
            showApartments(currentStaircase);
        }
    }

    // Inicjalizacja przykładowych danych i wyświetlenie pierwszego widoku
    initResidents();
    showBuildings();
</script>
</body>
</html>
