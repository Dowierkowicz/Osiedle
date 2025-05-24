package org.example.project;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String filePath = getServletContext().getRealPath("/") + "users.txt";

        boolean exists = false;

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.split(":")[0].trim().equals(username)) {
                    exists = true;
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (!exists) {
            try (PrintWriter pw = new PrintWriter(new FileWriter(filePath, true))) {
                pw.println(username + ":" + password);
            }
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "Użytkownik już istnieje, spróbuj ponownie.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}