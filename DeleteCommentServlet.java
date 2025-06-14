package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/deleteComment") // servlet pod tym adresem
public class DeleteCommentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)   // obsługa żądania POST
            throws ServletException, IOException {

        String id     = req.getParameter("id");        // ID ogłoszenia
        String author = req.getParameter("author");    // autor komentarza
        String text   = req.getParameter("text");      // treść komentarza

        HttpSession sess = req.getSession(false);      // pobierz sesję (lub null)
        String user = sess != null ? (String)sess.getAttribute("username") : null; // login użytkownika z sesji
        if (user == null || !user.equals(author)) {    // jeśli nie zalogowany lub nie jest autorem
            res.sendRedirect("login.jsp");             // przekieruj na login
            return;
        }

        String appPath = getServletContext().getRealPath("/");                  // ścieżka do katalogu aplikacji
        File commentsFile = new File(appPath, "comments.txt");                  // plik z komentarzami
        File tempFile     = new File(appPath, "comments.tmp");                  // plik tymczasowy do nadpisania

        try (BufferedReader br = new BufferedReader(new FileReader(commentsFile)); // czytaj stary plik
             BufferedWriter bw = new BufferedWriter(new FileWriter(tempFile))) {   // zapisuj do tymczasowego

            String line;
            while ((line = br.readLine()) != null) {                              // dla każdej linii...
                // line = id||author||text
                if (!(line.startsWith(id + "||" + author + "||") && line.equals(id + "||" + author + "||" + text))) {
                    bw.write(line);                                               // jeśli linia to NIE ten komentarz – przepisz
                    bw.newLine();
                }
                // jeśli linia dokładnie pasuje (id, autor, tekst) – nie przepisuj, czyli usuwasz komentarz
            }
        }
        // zamiana pliku – usuń stary, nadaj tymczasowemu właściwą nazwę
        commentsFile.delete();
        tempFile.renameTo(commentsFile);

        res.sendRedirect("ogloszenia.jsp"); // wróć do listy ogłoszeń
    }
}
