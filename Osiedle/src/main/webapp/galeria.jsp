<%@ page session="true" contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Galeria - Osiedle Zielone Wzgórze</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* ...style lightboxa, układ siatki galerii, przyciski itd... */
    </style>
</head>
<body>
<!-- =============== NAGŁÓWEK STRONY =============== -->
<header>
    <!-- Logo osiedla -->
    <div><img src="logo.png" alt="Osiedle" width="200" height="200"></div>
    <!-- Menu nawigacyjne po stronie -->

    <%@ include file="/WEB-INF/jsp/clock.jspf" %>


    <div class="menu">
        <a href="index.jsp">Strona główna</a>
        <a href="ogloszenia.jsp">Ogłoszenia</a>
        <a href="galeria.jsp" class="active">Galeria</a>
        <a href="mieszkancy.jsp">Mieszkańcy</a>
        <a href="kontakt.jsp">Kontakt</a>
    </div>
    <!-- Przyciski logowania/wylogowania/rejestracji po prawej stronie -->
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

<main class="container info-section">
    <!-- ======= SEKCJA OPISOWA GALERII ======= -->
    <section class="intro">
        <!-- Tytuł i krótki opis galerii -->
        <h2>Galeria Osiedla Zielone Wzgórze</h2>
        <p>
            Zapraszamy do obejrzenia naszej galerii! Zobacz nowoczesne budynki, zielone przestrzenie, plac zabaw oraz ujęcia z drona – wszystko w jednym miejscu.
        </p>
    </section>

    <!-- ======= SIATKA ZDJĘĆ GALERII ======= -->
    <section class="gallery-grid">
        <!-- 10 miniatur zdjęć. Po kliknięciu każda odpala powiększenie w lightboxie -->
        <img src="blok1.jpg" alt="Zdjęcie 1" onclick="openLightbox(0)">
        <img src="blok2.jpg" alt="Zdjęcie 2" onclick="openLightbox(1)">
        <img src="blok3.jpg" alt="Zdjęcie 3" onclick="openLightbox(2)">
        <img src="blok4.jpg" alt="Zdjęcie 4" onclick="openLightbox(3)">
        <img src="blok5.jpg" alt="Zdjęcie 5" onclick="openLightbox(4)">
        <img src="blok6.jpg" alt="Zdjęcie 6" onclick="openLightbox(5)">
        <img src="blok7.jpg" alt="Zdjęcie 7" onclick="openLightbox(6)">
        <img src="blok8.jpg" alt="Zdjęcie 8" onclick="openLightbox(7)">
        <img src="blok9.jpg" alt="Zdjęcie 9" onclick="openLightbox(8)">
        <img src="blok10.jpg" alt="Zdjęcie 10" onclick="openLightbox(9)">
    </section>
</main>

<!-- =============== LIGHTBOX =============== -->
<!-- To div pojawia się po kliknięciu zdjęcia, pokazuje powiększone zdjęcie z nawigacją -->
<div id="lightbox-overlay">
    <!-- Przycisk zamykający lightbox -->
    <button id="lightbox-close" onclick="closeLightbox()">✕</button>
    <!-- Przycisk poprzednie zdjęcie -->
    <button id="lightbox-prev" onclick="prevImage()">&#x2039;</button>
    <!-- Tutaj wyświetlane jest powiększone zdjęcie -->
    <img id="lightbox-img" src="" alt="">
    <!-- Przycisk następne zdjęcie -->
    <button id="lightbox-next" onclick="nextImage()">&#x203A;</button>
</div>

<!-- =============== STOPKA STRONY =============== -->
<footer>
    <p>&copy; 2025 Strona Osiedla – Wszelkie prawa zastrzeżone.</p>
</footer>

<!-- =============== SKRYPTY OBSŁUGUJĄCE GALERIĘ (LIGHTBOX) =============== -->
<script>
    // Tablica ze ścieżkami do wszystkich zdjęć galerii
    const images = [
        "blok1.jpg", "blok2.jpg", "blok3.jpg", "blok4.jpg", "blok5.jpg",
        "blok6.jpg", "blok7.jpg", "blok8.jpg", "blok9.jpg", "blok10.jpg"
    ];
    let currentIndex = 0;
    const overlay = document.getElementById('lightbox-overlay');
    const lbImg = document.getElementById('lightbox-img');

    // ===== Funkcja wywoływana po kliknięciu miniaturki: pokazuje powiększone zdjęcie w lightboxie =====
    function openLightbox(idx) {
        currentIndex = idx;
        lbImg.src = images[currentIndex];
        overlay.style.display = 'flex';
    }
    // ===== Funkcja zamykająca powiększenie =====
    function closeLightbox() {
        overlay.style.display = 'none';
        lbImg.src = "";
    }
    // ===== Funkcja pokazująca poprzednie zdjęcie w lightboxie =====
    function prevImage() {
        currentIndex = (currentIndex + images.length - 1) % images.length;
        lbImg.src = images[currentIndex];
    }
    // ===== Funkcja pokazująca następne zdjęcie w lightboxie =====
    function nextImage() {
        currentIndex = (currentIndex + 1) % images.length;
        lbImg.src = images[currentIndex];
    }
    // ===== Obsługa zamykania i przewijania lightboxa z klawiatury (ESC, lewo, prawo) =====
    document.addEventListener('keydown', function(e){
        if(overlay.style.display === 'flex'){
            if(e.key === 'Escape') closeLightbox();
            if(e.key === 'ArrowLeft') prevImage();
            if(e.key === 'ArrowRight') nextImage();
        }
    });
</script>
</body>
</html>