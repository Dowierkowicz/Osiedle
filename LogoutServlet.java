package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout") // servlet dostępny pod tym adresem
public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) // obsługa GET (wylogowanie)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);      // pobierz bieżącą sesję (lub null)

        if (session != null) {                               // jeśli sesja istnieje
            session.invalidate();                            // unieważnij ją (usuń wszystkie dane, wyloguj)
        }
        response.sendRedirect("index.jsp");                  // przekieruj na stronę główną
    }
}
