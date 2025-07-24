package Controller.maintenance;

import dal.DAOMaintenance;
import dal.DAORooms;
import dal.DAORentalArea;
import model.MaintenanceLog;
import model.Room;
import model.RentalArea;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/maintenanceList")
public class MaintenanceListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DAOMaintenance dao = new DAOMaintenance();
        DAORooms daoRoom = new DAORooms();
        DAORentalArea daoArea = new DAORentalArea();
        // Lấy user từ session (giả sử đã đăng nhập)
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        List<MaintenanceLog> maintenanceLogs = new java.util.ArrayList<>();
        List<RentalArea> rentalAreas = new java.util.ArrayList<>();
        List<model.Rooms> rooms = new java.util.ArrayList<>();
        if (user != null && user.getRoleId() == 3) { // Tenant
            model.Rooms room = daoRoom.getCurrentRoomByTenant(user.getUserId());
            if (room != null) {
                rooms.add(room);
                RentalArea area = new RentalArea();
                area.setRentalAreaId(room.getRentalAreaId());
                area.setName(room.getRentalAreaName());
                rentalAreas.add(area);
                // Lấy lịch sử bảo trì của khu trọ này
                maintenanceLogs.addAll(dao.getLogsByRentalAreaId(room.getRentalAreaId()));
            }
        } else {
            int managerId = (user != null) ? user.getUserId() : -1;
            rentalAreas = daoArea.getRentalAreasByManagerId(managerId);
            List<Integer> areaIds = new java.util.ArrayList<>();
            for (RentalArea area : rentalAreas) {
                areaIds.add(area.getRentalAreaId());
            }
            for (Integer areaId : areaIds) {
                maintenanceLogs.addAll(dao.getLogsByRentalAreaId(areaId));
            }
            rooms = daoRoom.getAllRooms();
        }
        request.setAttribute("maintenanceLogs", maintenanceLogs);
        request.setAttribute("rentalAreas", rentalAreas);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/Maintenance/list.jsp").forward(request, response);
    }
}
