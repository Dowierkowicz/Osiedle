package org.example.project;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String filePath = getServletContext().getRealPath("/") + "users.txt";

        boolean loggedIn = false;

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] credentials = line.split(":");
                if (credentials.length == 2 &&
                        credentials[0].trim().equals(username) &&
                        credentials[1].trim().equals(password)) {
                    loggedIn = true;
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (loggedIn) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "Nieprawidłowy login lub hasło.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
