package org.example.project; // pakiet projektu

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.charset.StandardCharsets;

@WebServlet("/zgloszenie") // servlet obsługujący zgłoszenia z formularza kontaktowego
public class ZgloszenieServlet extends HttpServlet {
    private String filePath;                                        // ścieżka do pliku z zapisanymi zgłoszeniami

    @Override
    public void init() {                                            // inicjalizacja servletu
        filePath = getServletContext().getRealPath("/") + "zgloszenia.txt"; // ustal ścieżkę do pliku zgłoszeń
        System.out.println("Zgłoszenia będą zapisywane w: " + filePath);    // info na konsolę (logowanie)
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) // obsługa POST (przesłanie zgłoszenia)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");                           // ustaw kodowanie na UTF-8 (obsługa polskich znaków)
        String imie = req.getParameter("imie");                      // pobierz imię i nazwisko z formularza
        String email = req.getParameter("email");                    // pobierz email z formularza
        String temat = req.getParameter("temat");                    // pobierz temat zgłoszenia
        String wiadomosc = req.getParameter("wiadomosc");            // pobierz treść zgłoszenia

        String linia = String.format("Imię i nazwisko: %s | Email: %s | Temat: %s | Wiadomość: %s | Data: %s%n",
                imie, email, temat, wiadomosc, new java.util.Date()); // przygotuj linię do pliku tekstowego

        synchronized (this) {                                        // synchronizacja na wypadek wielu zapisów jednocześnie
            try (Writer fw = new BufferedWriter(new OutputStreamWriter(
                    new FileOutputStream(filePath, true), StandardCharsets.UTF_8))) { // otwórz plik do dopisywania (UTF-8)
                fw.write(linia);                                     // dopisz zgłoszenie do pliku
            }
        }

        System.out.println("Zgłoszenie dopisane do pliku: " + filePath); // logowanie na konsolę

        req.setAttribute("sent", true);                               // ustaw atrybut informujący o wysłaniu zgłoszenia
        req.getRequestDispatcher("kontakt.jsp").forward(req, resp);   // wróć na stronę kontaktową z potwierdzeniem
    }
}
