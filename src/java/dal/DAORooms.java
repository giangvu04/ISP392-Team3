package dal;

import jakarta.servlet.http.HttpServletRequest;
import model.Rooms;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Users;

public class DAORooms {

    public static final DAORooms INSTANCE = new DAORooms();
    protected Connection connect;

    public DAORooms() {
        connect = new DBContext().connect; // Initialize connection
    }

    public static long millis = System.currentTimeMillis();
    public static Date today = new Date(millis);

    // Get all rooms that aren't deleted
    public ArrayList<Rooms> getAllRooms() {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE isDelete = 0";

        try (PreparedStatement statement = connect.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("roomID"));
                room.setAddress(rs.getString("address"));
                room.setDescription(rs.getString("Description"));
                room.setImageLink(rs.getString("ImageLink"));
                room.setStatus(rs.getBoolean("Status"));
                room.setPrice(rs.getDouble("Price"));
                room.setRoomType(rs.getString("RoomType"));
                room.setRentalAreaid(rs.getInt("rentalArea_id"));
                room.setCreateAt(rs.getDate("CreateAt"));
                room.setUpdateAt(rs.getDate("UpdateAt"));
                room.setCreateBy(rs.getInt("CreateBy"));
                room.setIsDelete(rs.getInt("isDelete"));
                room.setDeletedAt(rs.getDate("deletedAt"));
                room.setDeleteBy(rs.getInt("deleteBy"));

                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Soft delete a room (set isDelete = 1)
    public void deleteRooms(int deleteId, int userId) {
        String sql = "UPDATE Rooms SET isDelete = ?, DeleteBy = ?, DeletedAt = ? WHERE roomID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, 1); // Mark as deleted
            ps.setInt(2, userId);
            ps.setDate(3, today);
            ps.setInt(4, deleteId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update room information
    public void updateRooms(Rooms room) {
        String sql = "UPDATE Rooms SET Address = ?, Description = ?, ImageLink = ?, Status = ?, "
                + "Price = ?, RoomType = ?, rentalArea_id = ?, UpdateAt = ? WHERE roomID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, room.getAddress());
            ps.setString(2, room.getDescription());
            ps.setString(3, room.getImageLink());
            ps.setBoolean(4, room.isStatus());
            ps.setDouble(5, room.getPrice());
            ps.setString(6, room.getRoomType());
            ps.setInt(7, room.getRentalAreaid());
            ps.setDate(8, today);
            ps.setInt(9, room.getRoomID());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Add a new room and return the generated roomID
    public int addRooms(Rooms room, int userId) {
        String sql = "INSERT INTO Rooms (Address, Description, ImageLink, Status, Price, RoomType, "
                + "rentalArea_id, CreateAt, CreateBy, UpdateAt, isDelete) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, room.getAddress());
            ps.setString(2, room.getDescription());
            ps.setString(3, room.getImageLink());
            ps.setBoolean(4, room.isStatus());
            ps.setDouble(5, room.getPrice());
            ps.setString(6, room.getRoomType());
            ps.setInt(7, room.getRentalAreaid());
            ps.setDate(8, today);
            ps.setInt(9, userId);
            ps.setDate(10, today);
            ps.setInt(11, 0); // isDelete = 0

            ps.executeUpdate();

            ResultSet generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1); // Return new room ID
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Return -1 if error occurs
    }

    // Get room by ID
    public Rooms getRoomsByID(int ID) throws Exception {
        String query = "SELECT * FROM Rooms WHERE roomID=?";
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, ID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Rooms r = new Rooms();
                r.setRoomID(rs.getInt("roomID"));
                r.setAddress(rs.getString("Address"));
                r.setDescription(rs.getString("Description"));
                r.setImageLink(rs.getString("ImageLink"));
                r.setStatus(rs.getBoolean("Status"));
                r.setPrice(rs.getDouble("Price"));
                r.setRoomType(rs.getString("RoomType"));
                r.setRentalAreaid(rs.getInt("rentalArea_id"));
                r.setCreateAt(rs.getDate("CreateAt"));
                r.setUpdateAt(rs.getDate("UpdateAt"));
                r.setCreateBy(rs.getInt("CreateBy"));
                r.setIsDelete(rs.getInt("isDelete"));
                r.setDeletedAt(rs.getDate("deletedAt"));
                r.setDeleteBy(rs.getInt("deleteBy"));
                return r;
            }
        }
        return null; // Return null if room not found
    }

    // Get rooms by page (for pagination)
    public ArrayList<Rooms> getRoomsByPage(int page, int roomsPerPage) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE isDelete = 0 ORDER BY roomID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * roomsPerPage);
            ps.setInt(2, roomsPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("roomID"));
                room.setAddress(rs.getString("Address"));
                room.setDescription(rs.getString("Description"));
                room.setImageLink(rs.getString("ImageLink"));
                room.setStatus(rs.getBoolean("Status"));
                room.setPrice(rs.getDouble("Price"));
                room.setRoomType(rs.getString("RoomType"));
                room.setRentalAreaid(rs.getInt("rentalArea_id"));
                room.setCreateAt(rs.getDate("CreateAt"));
                room.setUpdateAt(rs.getDate("UpdateAt"));
                room.setCreateBy(rs.getInt("CreateBy"));
                room.setIsDelete(rs.getInt("isDelete"));

                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Alternative version of getRoomsByPage (similar to getProductsByPage2)
    public ArrayList<Rooms> getRoomsByPage2(int page, int roomsPerPage) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE IsDelete = 0 ORDER BY roomID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * roomsPerPage);
            ps.setInt(2, roomsPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("roomID"));
                room.setAddress(rs.getString("Address"));
                room.setDescription(rs.getString("Description"));
                room.setImageLink(rs.getString("ImageLink"));
                room.setStatus(rs.getBoolean("Status"));
                room.setPrice(rs.getDouble("Price"));
                room.setRoomType(rs.getString("RoomType"));
                room.setRentalAreaid(rs.getInt("rentalArea_id"));
                room.setCreateAt(rs.getDate("CreateAt"));
                room.setUpdateAt(rs.getDate("UpdateAt"));
                room.setCreateBy(rs.getInt("CreateBy"));
                room.setIsDelete(rs.getInt("isDelete"));

                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Search rooms by any information (similar to getProductsBySearch)
    public ArrayList<Rooms> getRoomsBySearch(String information) {
        information = information.toLowerCase();
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE isDelete = 0";

        try (PreparedStatement statement = connect.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("roomID"));
                room.setAddress(rs.getString("Address"));
                room.setDescription(rs.getString("Description"));
                room.setImageLink(rs.getString("ImageLink"));
                room.setStatus(rs.getBoolean("Status"));
                room.setPrice(rs.getDouble("Price"));
                room.setRoomType(rs.getString("RoomType"));
                room.setRentalAreaid(rs.getInt("rentalArea_id"));
                room.setCreateAt(rs.getDate("CreateAt"));
                room.setUpdateAt(rs.getDate("UpdateAt"));
                room.setCreateBy(rs.getInt("CreateBy"));
                room.setIsDelete(rs.getInt("isDelete"));

                // Create string with all room information for searching
                String roomData = (room.getAddress() + " "
                        + room.getDescription() + " "
                        + room.getRoomType() + " "
                        + room.getPrice() + " ").toLowerCase();

                if (roomData.contains(information)) {
                    rooms.add(room);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Search rooms by address (similar to searchProductsByName)
    public ArrayList<Rooms> searchRoomsByAddress(String address) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE isDelete = 0 AND Address LIKE ?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + address + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("roomID"));
                room.setAddress(rs.getString("Address"));
                room.setDescription(rs.getString("Description"));
                room.setImageLink(rs.getString("ImageLink"));
                room.setStatus(rs.getBoolean("Status"));
                room.setPrice(rs.getDouble("Price"));
                room.setRoomType(rs.getString("RoomType"));
                room.setRentalAreaid(rs.getInt("rentalArea_id"));
                room.setCreateAt(rs.getDate("CreateAt"));
                room.setUpdateAt(rs.getDate("UpdateAt"));
                room.setCreateBy(rs.getInt("CreateBy"));
                room.setIsDelete(rs.getInt("isDelete"));

                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Optional: Get total count of rooms (for pagination)
    public int getTotalRooms() {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE isDelete = 0";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static void main(String[] args) {
        DAORooms dao = DAORooms.INSTANCE;
    }
}
