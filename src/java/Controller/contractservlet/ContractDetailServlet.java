/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.contractservlet;

import dal.DAOContract;
import dal.DAORooms;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contracts;


@WebServlet(name="ContractDetailServlet", urlPatterns={"/contractdetail"})
public class ContractDetailServlet extends HttpServlet {
    private DAOContract daoC = new DAOContract(); // Thay bằng DAO phù hợp nếu bạn có DAO riêng cho Contracts

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int contractId;
        try {
            contractId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID hợp đồng không hợp lệ.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Lấy thông tin hợp đồng
        Contracts contract = daoC.getContractById(contractId); // Giả sử có phương thức này
        if (contract != null) {
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("Contract/ViewContracts.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Hợp đồng không tồn tại.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

}
