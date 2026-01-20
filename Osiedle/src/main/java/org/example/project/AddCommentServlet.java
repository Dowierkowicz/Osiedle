package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

// Servlet obsługujący dodawanie komentarza do ogłoszenia
@WebServlet("/addComment")
public class AddCommentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)    // obsługa POST (wysłanie formularza)
            throws ServletException, IOException {
        HttpSession sess = req.getSession(false);                             // pobierz sesję (lub null)
        String user = sess != null ? (String) sess.getAttribute("username") : null; // sprawdź użytkownika z sesji
        String id = req.getParameter("id");                                   // pobierz ID ogłoszenia

        if (user == null) {                                                   // jeśli nie zalogowany
            res.sendRedirect("login.jsp");                                    // przekieruj na logowanie
            return;
        }
        String comment = req.getParameter("comment");                         // pobierz treść komentarza
        if (comment != null && !comment.trim().isEmpty()) {                   // jeśli nie pusty
            String path = getServletContext().getRealPath("/") + "comments.txt"; // ścieżka do pliku z komentarzami
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(path, true))) { // otwórz plik do dopisania
                bw.write(id + "||" + user + "||" + comment.trim());           // wpisz w formacie id||autor||komentarz
                bw.newLine();                                                 // przejdź do nowej linii
            }
        }
        res.sendRedirect("ogloszenia.jsp");                                   // po dodaniu komentarza wróć do ogłoszeń
    }
}
