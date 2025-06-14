package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/register") // servlet pod tym adresem
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) // obsługa POST (rejestracja)
            throws ServletException, IOException {

        String username = request.getParameter("username");            // pobierz login z formularza
        String password = request.getParameter("password");            // pobierz hasło z formularza
        String filePath = getServletContext().getRealPath("/") + "users.txt"; // ścieżka do pliku z użytkownikami

        boolean exists = false;                                        // flaga – czy taki użytkownik już istnieje

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) { // otwórz plik users.txt
            String line;
            while ((line = br.readLine()) != null) {                  // sprawdź każdą linię
                if (line.split(":")[0].trim().equals(username)) {     // login już istnieje
                    exists = true;
                    break;
                }
            }
        } catch (IOException e) {                                     // obsługa błędu pliku
            e.printStackTrace();
        }

        if (!exists) {                                                // jeśli użytkownik nie istnieje
            try (PrintWriter pw = new PrintWriter(new FileWriter(filePath, true))) { // otwórz plik do dopisywania
                pw.println(username + ":" + password);                // dopisz nowego użytkownika
            }
            HttpSession session = request.getSession();               // utwórz sesję
            session.setAttribute("username", username);               // zapisz login w sesji
            response.sendRedirect("index.jsp");                       // przekieruj na stronę główną
        } else {                                                      // jeśli login już istnieje
            request.setAttribute("error", "Użytkownik już istnieje, spróbuj ponownie."); // komunikat o błędzie
            request.getRequestDispatcher("register.jsp").forward(request, response);     // wróć do rejestracji
        }
    }
}
