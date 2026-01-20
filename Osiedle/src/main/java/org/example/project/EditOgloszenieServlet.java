package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/editOgloszenie") // servlet pod tym adresem
@MultipartConfig(
        fileSizeThreshold = 1024*1024,   // 1 MB - kiedy część trafia na dysk
        maxFileSize       = 5*1024*1024, // 5 MB na jeden plik
        maxRequestSize    = 20*1024*1024 // 20 MB na całość żądania
)
public class EditOgloszenieServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) // obsługa POST (edycja ogłoszenia)
            throws ServletException, IOException {

        HttpSession sess = req.getSession(false);                                      // pobierz sesję (lub null)
        String user = (sess!=null)?(String)sess.getAttribute("username"):null;         // login użytkownika
        if (user == null) {                                                           // jeśli nie zalogowany
            res.sendRedirect("login.jsp");                                            // przekieruj na login
            return;
        }

        String id      = req.getParameter("id");                                      // id ogłoszenia do edycji
        String newText = Optional.ofNullable(req.getParameter("tresc")).orElse("").trim(); // nowa treść ogłoszenia

        String appPath = getServletContext().getRealPath("/");                        // ścieżka do katalogu aplikacji
        Path uploadsDir = Paths.get(appPath, "uploads");                              // ścieżka do katalogu z uploadami
        Files.createDirectories(uploadsDir);                                          // utwórz katalog jeśli nie istnieje

        File original = new File(appPath, "ogloszenia.txt");                          // plik z ogłoszeniami
        File temp     = new File(appPath, "ogloszenia.tmp");                          // plik tymczasowy
        boolean deletedAnnouncement = false;                                          // czy ogłoszenie zostało usunięte

        try (BufferedReader br = new BufferedReader(new FileReader(original));
             BufferedWriter bw = new BufferedWriter(new FileWriter(temp))) {

            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|\\|", 4);                             // podziel linię na id||autor||treść||zdjęcia
                if (parts.length < 3) {                                               // jeśli format niepoprawny, przepisz bez zmian
                    bw.write(line);
                    bw.newLine();
                    continue;
                }
                String currId = parts[0], author = parts[1], text = parts[2];
                String imgs   = (parts.length==4? parts[3] : "");

                if (currId.equals(id) && author.equals(user)) {                       // jeśli to nasze ogłoszenie do edycji
                    // 1) Usuń zaznaczone zdjęcia
                    List<String> imgList = imgs.isEmpty()
                            ? new ArrayList<>()
                            : new ArrayList<>(Arrays.asList(imgs.split(",")));
                    String[] toRemove = req.getParameterValues("remove");             // zdjęcia do usunięcia
                    if (toRemove != null) {
                        for (String rem : toRemove) {
                            imgList.remove(rem);
                            Files.deleteIfExists(uploadsDir.resolve(rem));            // skasuj fizycznie plik
                        }
                    }
                    // 2) Dodaj nowe zdjęcia
                    for (Part p : req.getParts()) {
                        if ("images".equals(p.getName()) && p.getSize()>0) {
                            if (imgList.size()>=3) break;                            // max 3 zdjęcia
                            String submitted = Paths.get(p.getSubmittedFileName()).getFileName().toString();
                            String ext = submitted.contains(".")
                                    ? submitted.substring(submitted.lastIndexOf('.'))
                                    : "";
                            String fname = System.currentTimeMillis()
                                    + "_" + UUID.randomUUID() + ext;                  // unikalna nazwa pliku
                            p.write(uploadsDir.resolve(fname).toString());
                            imgList.add(fname);
                        }
                    }
                    // 3) Jeśli brak treści i brak zdjęć -> usuń ogłoszenie
                    if (newText.isEmpty() && imgList.isEmpty()) {
                        deletedAnnouncement = true;                                   // ustaw flagę usunięcia
                        // pomiń zapis tej linii
                    } else {
                        // zaktualizuj wpis ogłoszenia
                        String outText = newText.isEmpty() ? text : newText;         // jeśli nowy tekst pusty, zachowaj stary
                        String newImgs = String.join(",", imgList);                  // nowe zdjęcia
                        bw.write(id+"||"+user+"||"+outText+"||"+newImgs);
                        bw.newLine();
                    }
                } else {
                    // nie nasze ogłoszenie -> przepisz bez zmian
                    bw.write(line);
                    bw.newLine();
                }
            }
        }

        // Zamiana pliku ogloszenia.txt na nowy
        original.delete();                                         // usuń stary plik
        temp.renameTo(original);                                   // tymczasowy staje się właściwy

        // Jeśli ogłoszenie zostało usunięte, usuń też jego komentarze
        if (deletedAnnouncement) {
            File commentsFile = new File(appPath, "comments.txt");         // plik z komentarzami
            File commentsTmp  = new File(appPath, "comments.tmp");         // plik tymczasowy
            try (BufferedReader br2 = new BufferedReader(new FileReader(commentsFile));
                 BufferedWriter bw2 = new BufferedWriter(new FileWriter(commentsTmp))) {
                String cl;
                while ((cl = br2.readLine()) != null) {
                    if (!cl.startsWith(id+"||")) {                         // pomiń komentarze do usuniętego ogłoszenia
                        bw2.write(cl);
                        bw2.newLine();
                    }
                }
            }
            commentsFile.delete();                                         // usuń stary plik komentarzy
            commentsTmp.renameTo(commentsFile);                            // zamień tymczasowy na właściwy
        }

        res.sendRedirect("ogloszenia.jsp");                                // przekieruj do ogłoszeń
    }
}
