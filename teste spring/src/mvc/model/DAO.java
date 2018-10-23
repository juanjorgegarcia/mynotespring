package mvc.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;



public class DAO {
	private Connection connection = null;

	public DAO() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			connection = DriverManager.getConnection(
					"jdbc:mysql://localhost/projeto2?useSSL=false&useTimezone=true&serverTimezone=UTC", "root", "");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public List<Note> getListaNota(Integer idUser) {
		List<Note> notes = new ArrayList<Note>();
		PreparedStatement stmt = null;
		try {
			stmt = connection.prepareStatement("SELECT * FROM note WHERE id_user =? ORDER BY date DESC ");
			stmt.setInt(1, idUser);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ResultSet rs = null;
		try {
			rs = stmt.executeQuery();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			while (rs.next()) {
				Note note = new Note();
				note.setIdNote(rs.getInt("id_note"));
				note.setNoteText(rs.getString("note_text"));

				note.setTag(rs.getString("tag"));
				note.setIcon(rs.getString("icon"));
				note.setColor(rs.getString("color"));
				note.setIdUser(rs.getInt("id_user"));
				note.setTime(rs.getString("date"));
				note.setTitle(rs.getString("title"));
				notes.add(note);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return notes;
	}

	public List<Note> searchNotesByText(String query, Integer idUser) {
		List<Note> notes = new ArrayList<Note>();
		PreparedStatement stmt = null;
		try {

			stmt = connection.prepareStatement(
					"SELECT * FROM note WHERE id_user=? AND (note_text LIKE ? OR tag LIKE ? OR title LIKE ?) ORDER BY date DESC ");
			stmt.setInt(1, idUser);

			stmt.setString(2, "%" + query + "%");
			stmt.setString(3, "%" + query + "%");
			stmt.setString(4, "%" + query + "%");


		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ResultSet rs = null;
		try {
			rs = stmt.executeQuery();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			while (rs.next()) {
				Note note = new Note();
				note.setIdNote(rs.getInt("id_note"));
				note.setNoteText(rs.getString("note_text"));

				note.setTag(rs.getString("tag"));
				note.setIcon(rs.getString("icon"));
				note.setColor(rs.getString("color"));
				note.setIdUser(rs.getInt("id_user"));
				note.setTime(rs.getString("date"));
				note.setTitle(rs.getString("title"));


				notes.add(note);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return notes;
	}

	public Note getNote(Integer noteId, Integer idUser) {
		String sql = "SELECT * from note WHERE id_note = ? AND id_user=?";
		PreparedStatement stmt;
		List<Note> notes = new ArrayList<Note>();
		Note note = new Note();
		try {
			stmt = connection.prepareStatement(sql);

			stmt.setInt(1, noteId);
			stmt.setInt(2, idUser);

			ResultSet result = stmt.executeQuery();

			while (result.next()) {

				note.setIdNote(result.getInt("id_note"));
				note.setColor(result.getString("color"));
				note.setTag(result.getString("tag"));
				note.setNoteText(result.getString("note_text"));
				note.setIcon(result.getString("icon"));
				note.setIdUser(result.getInt("id_user"));
				note.setTime(result.getString("date"));
				note.setTitle(result.getString("title"));

				notes.add(note);
			}

			stmt.close();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return note;
	}

	public Integer getLastInsertedId() {
		String sql = "SELECT LAST_INSERT_ID()";
		PreparedStatement stmt;
		Integer idNote = null;
		try {
			stmt = connection.prepareStatement(sql);

			ResultSet result = stmt.executeQuery();

			if (result.next()) {
				idNote = result.getInt(1);

			}
			System.out.print(idNote);
			stmt.close();

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return idNote;
	}

	public void adicionaNota(Note note) {
		String sql = "INSERT INTO note" + "(note_text ,tag, color, icon, id_user, date, title) values(?,?,?,?,?,?,?)";
		PreparedStatement stmt;
		try {
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm MM/dd");
			LocalDateTime now = LocalDateTime.now();
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, note.getNoteText());
			stmt.setString(2, note.getTag());
			stmt.setString(3, note.getColor());
			stmt.setString(4, note.getIcon());
			stmt.setInt(5, note.getIdUser());
			stmt.setString(6, dtf.format(now));
			System.out.println(dtf.format(now));
			stmt.setString(7, note.getTitle());


			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void alteraNota(Note note) {
		String sql = "UPDATE note SET " + "note_text=?, tag=?, color=? ,icon=?, date=?,title=? WHERE id_note=?";
		PreparedStatement stmt;
		try {

			stmt = connection.prepareStatement(sql);

			stmt.setString(1, note.getNoteText());
			stmt.setString(2, note.getTag());
			stmt.setString(3, note.getColor());
			stmt.setString(4, note.getIcon());
			stmt.setString(5, note.getTime());
			stmt.setString(6, note.getTitle());

			stmt.setInt(7, note.getIdNote());
			
			System.out.println(note.getTime());
			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void removeNota(Integer id) {
		PreparedStatement stmt;
		try {
			stmt = connection.prepareStatement("DELETE FROM note WHERE id_note=?");
			stmt.setLong(1, id);
			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public List<User> getListaUser() {
		List<User> users = new ArrayList<User>();
		PreparedStatement stmt = null;
		try {
			stmt = connection.prepareStatement("SELECT * FROM user");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ResultSet rs = null;
		try {
			rs = stmt.executeQuery();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			while (rs.next()) {
				User user = new User();
				user.setIdUser(rs.getInt("id_user"));
				user.setName(rs.getString("name"));

				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));

				users.add(user);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return users;
	}

	public void adicionaUser(User user) {
		String sql = "INSERT INTO user" + "(name, username, password) values(?,?,?)";
		PreparedStatement stmt;
		try {
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, user.getName());
			stmt.setString(2, user.getUsername());
			stmt.setString(3, user.getPassword());

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void alteraUser(User user) {
		String sql = "UPDATE user SET " + "name=?, username=?, password=? WHERE id_user=?";
		PreparedStatement stmt;
		try {
			stmt = connection.prepareStatement(sql);

			stmt.setString(1, user.getName());
			stmt.setString(2, user.getUsername());
			stmt.setString(3, user.getPassword());
			stmt.setInt(4, user.getIdUser());

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void removeUser(Integer id) {
		PreparedStatement stmt;
		try {
			stmt = connection.prepareStatement("DELETE FROM user WHERE id_user=?");
			stmt.setLong(1, id);
			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public boolean verifyUser(String username, String password) {
		PreparedStatement stmt;
		String passCheck = null;
		try {
			stmt = connection.prepareStatement("SELECT password FROM user WHERE username=?");
			stmt.setString(1, username);

			ResultSet rs = null;
			try {
				rs = stmt.executeQuery();
				while (rs.next()) {
					passCheck = rs.getString("password");
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (password.equals(passCheck)) {
			return true;
		} else {
			return false;
		}

	}

	public boolean checkUser(String username) {
		PreparedStatement stmt;
		Integer count = 1;
		try {
			stmt = connection.prepareStatement("SELECT COUNT(username) FROM user WHERE username= ?");
			stmt.setString(1, username);

			ResultSet rs = null;
			try {
				rs = stmt.executeQuery();
				while (rs.next()) {
					count = rs.getInt("COUNT(username)");
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (count != 0) {
			return true;
		} else {
			return false;
		}

	}

	public boolean checkPass(Integer idUser, String password) {
		PreparedStatement stmt;
		String pass = null;
		try {
			stmt = connection.prepareStatement("SELECT password FROM user WHERE id_user= ?");
			stmt.setInt(1, idUser);

			ResultSet rs = null;
			try {
				rs = stmt.executeQuery();
				while (rs.next()) {
					pass = rs.getString("password");
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (password.equals(pass)) {
			return true;
		} else {
			return false;
		}

	}

	public void changePass(Integer idUser, String password) {
		String sql = "UPDATE user SET " + "password=? WHERE id_user=?";
		PreparedStatement stmt;
		try {
			stmt = connection.prepareStatement(sql);

			stmt.setString(1, password);
			stmt.setInt(2, idUser);

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public int getIdFromUsername(String username) {
		PreparedStatement stmt;
		Integer idUser = null;
		try {
			stmt = connection.prepareStatement("SELECT id_user FROM user WHERE username=?");
			stmt.setString(1, username);

			ResultSet rs = null;
			try {
				rs = stmt.executeQuery();
				while (rs.next()) {
					idUser = rs.getInt("id_user");
				}

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			stmt.execute();
			stmt.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return idUser;

	}

	public void close() {
		// TODO Auto-generated method stub
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
