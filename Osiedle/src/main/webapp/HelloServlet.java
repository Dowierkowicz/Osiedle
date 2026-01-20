package org.example.project; // pakiet projektu

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "helloServlet", value = "/hello-servlet") // servlet dostępny pod tym adresem
public class HelloServlet extends HttpServlet {
    private String message;                                  // pole na wiadomość

    public void init() {                                     // metoda inicjalizująca servlet
        message = "Hello World!";                            // ustawienie domyślnej wiadomości
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");                // ustaw typ odpowiedzi na HTML

        PrintWriter out = response.getWriter();              // pobierz writer do odpowiedzi
        out.println("<html><body>");                         // początek HTML
        out.println("<h1>" + message + "</h1>");             // wyświetl wiadomość w nagłówku
        out.println("</body></html>");                       // koniec HTML
    }

    public void destroy() {                                  // metoda wywoływana przy usuwaniu servletu
    }
}
