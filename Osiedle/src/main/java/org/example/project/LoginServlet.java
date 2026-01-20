package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/login") // servlet pod tym adresem
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) // obsługa POST (logowanie)
            throws ServletException, IOException {

        String username = request.getParameter("username");              // pobierz login z formularza
        String password = request.getParameter("password");              // pobierz hasło z formularza
        String filePath = getServletContext().getRealPath("/") + "users.txt"; // ścieżka do pliku z użytkownikami

        boolean loggedIn = false;                                        // flaga – czy użytkownik został zalogowany

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) { // otwórz plik users.txt
            String line;
            while ((line = br.readLine()) != null) {                    // sprawdzaj każdą linię
                String[] credentials = line.split(":");                 // linia: login:hasło
                if (credentials.length == 2 &&
                        credentials[0].trim().equals(username) &&      // login się zgadza
                        credentials[1].trim().equals(password)) {      // hasło się zgadza
                    loggedIn = true;                                   // ustaw flagę
                    break;
                }
            }
        } catch (IOException e) {                                      // obsługa błędu pliku
            e.printStackTrace();
        }

        if (loggedIn) {                                                // jeśli dane poprawne
            HttpSession session = request.getSession();                // utwórz sesję
            session.setAttribute("username", username);                // zapisz login w sesji
            response.sendRedirect("index.jsp");                        // przekieruj na stronę główną
        } else {                                                       // jeśli złe dane logowania
            request.setAttribute("error", "Nieprawidłowy login lub hasło."); // komunikat o błędzie
            request.getRequestDispatcher("login.jsp").forward(request, response); // wróć do logowania
        }
    }
}
