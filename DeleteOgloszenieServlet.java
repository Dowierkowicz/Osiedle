package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/deleteOgloszenie") // servlet pod tym adresem
public class DeleteOgloszenieServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) // obsługa POST
            throws ServletException, IOException {

        HttpSession sess = req.getSession(false);                            // pobierz sesję
        String user = (sess!=null)?(String)sess.getAttribute("username"):null; // login użytkownika z sesji
        if (user == null) {                                                  // jeśli nie zalogowany
            res.sendRedirect("login.jsp");                                   // przekieruj na login
            return;
        }

        String id = req.getParameter("id");                                  // id ogłoszenia do usunięcia
        String appPath = getServletContext().getRealPath("/");               // ścieżka do katalogu aplikacji
        Path uploadsDir = Paths.get(appPath, "uploads");                     // ścieżka do katalogu z uploadami

        // 1) Usuń wpis z ogloszenia.txt i powiązane zdjęcia
        File ogFile   = new File(appPath, "ogloszenia.txt");                 // plik z ogłoszeniami
        File ogTmp    = new File(appPath, "ogloszenia.tmp");                 // plik tymczasowy do nadpisania
        try (BufferedReader br = new BufferedReader(new FileReader(ogFile));
             BufferedWriter bw = new BufferedWriter(new FileWriter(ogTmp))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split("\\|\\|",4);                     // id||autor||tekst||zdjecia
                if (parts.length>=3 && parts[0].equals(id) && parts[1].equals(user)) {
                    // usuwamy powiązane zdjęcia
                    if (parts.length==4) {
                        for (String fn : parts[3].split(",")) {
                            Files.deleteIfExists(uploadsDir.resolve(fn));    // kasuj każdy plik zdjęcia
                        }
                    }
                    // NIE przepisujemy tej linii -> kasujemy wpis ogłoszenia
                } else {
                    bw.write(line);                                          // przepisz inne ogłoszenia
                    bw.newLine();
                }
            }
        }
        ogFile.delete();                                                     // usuń stary plik
        ogTmp.renameTo(ogFile);                                              // zamień tymczasowy na właściwy

        // 2) Usuń komentarze związane z tym ogłoszeniem
        File cFile   = new File(appPath, "comments.txt");                    // plik z komentarzami
        File cTmp    = new File(appPath, "comments.tmp");                    // plik tymczasowy
        try (BufferedReader br = new BufferedReader(new FileReader(cFile));
             BufferedWriter bw = new BufferedWriter(new FileWriter(cTmp))) {
            String cl;
            while ((cl = br.readLine()) != null) {
                if (!cl.startsWith(id+"||")) {                               // nie przepisuj komentarzy tego ogłoszenia
                    bw.write(cl);
                    bw.newLine();
                }
            }
        }
        cFile.delete();                                                      // usuń stary plik z komentarzami
        cTmp.renameTo(cFile);                                                // zamień tymczasowy na właściwy

        res.sendRedirect("ogloszenia.jsp");                                  // przekieruj do ogłoszeń
    }
}
