package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/addOgloszenie") // servlet dostępny pod adresem /addOgloszenie
@MultipartConfig(fileSizeThreshold=1024*1024,        // minimalny próg zapisu na dysk (1MB)
        maxFileSize=5*1024*1024,                    // maksymalny rozmiar pojedynczego pliku (5MB)
        maxRequestSize=20*1024*1024)                // maksymalny rozmiar całego żądania (20MB)
public class AddOgloszenieServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)    // obsługa POST (dodawanie ogłoszenia)
            throws ServletException, IOException {

        HttpSession sess = req.getSession(false);                            // pobranie sesji (lub null)
        String user = sess!=null?(String)sess.getAttribute("username"):null; // nazwa użytkownika lub null
        if (user == null) {                                                  // jeśli nie zalogowany
            req.setAttribute("mustLogin","Aby dodać ogłoszenie, musisz się zalogować."); // info do wyświetlenia
            req.getRequestDispatcher("ogloszenia.jsp").forward(req, res);    // przekierowanie z info
            return;
        }

        String text = req.getParameter("ogloszenie").trim();                 // treść ogłoszenia (usuniecie spacji)
        if (text.isEmpty()) {                                                // jeśli puste – nie dodawaj
            res.sendRedirect("ogloszenia.jsp");
            return;
        }

        // katalog do zapisu zdjęć
        String uploadPath = getServletContext().getRealPath("/") + "uploads"; // pełna ścieżka do katalogu 'uploads'
        Files.createDirectories(Paths.get(uploadPath));                        // utwórz katalog jeśli nie istnieje

        // przetwarzanie przesłanych plików (multipart)
        Collection<Part> parts = req.getParts();             // wszystkie części żądania
        List<String> saved = new ArrayList<>();              // lista zapisanych nazw plików
        for (Part p : parts) {
            if ("images".equals(p.getName()) && p.getSize()>0) {      // jeśli to pole "images" i plik niepusty
                if (saved.size()>=3) break;                           // max 3 pliki
                String submitted = Paths.get(p.getSubmittedFileName()).getFileName().toString(); // oryginalna nazwa
                String ext = submitted.contains(".")                  // wyciągnięcie rozszerzenia
                        ? submitted.substring(submitted.lastIndexOf('.')) : "";
                String fname = System.currentTimeMillis() + "_"
                        + UUID.randomUUID() + ext;                    // unikalna nazwa pliku: czas_uuid.ext
                p.write(uploadPath + File.separator + fname);          // zapis pliku na serwerze
                saved.add(fname);                                      // dodanie nazwy do listy
            }
        }

        // dopisanie wpisu do pliku ogloszenia.txt (każde ogłoszenie w nowej linii)
        String path = getServletContext().getRealPath("/") + "ogloszenia.txt"; // pełna ścieżka do pliku ogłoszeń
        File f = new File(path);
        int nextId = 1;                                               // domyślne ID ogłoszenia (1)
        if (f.exists()) {                                             // jeśli plik istnieje, policz ile już jest ogłoszeń
            try (BufferedReader br = new BufferedReader(new FileReader(f))) {
                while (br.readLine()!=null) nextId++;                 // inkrementuj dla każdej linii
            }
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(f,true))) { // otwórz do dopisywania
            String imgs = String.join(",", saved);                    // scal nazwy plików przecinkiem
            bw.write(nextId + "||" + user + "||" + text + "||" + imgs); // wpisz: id||autor||tekst||zdjecia
            bw.newLine();                                             // nowa linia
        }

        res.sendRedirect("ogloszenia.jsp");                           // po dodaniu ogłoszenia przekieruj do listy
    }
}
