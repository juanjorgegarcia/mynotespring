package mvc.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import mvc.model.*;

@Controller
public class NoteController {

	@RequestMapping(value = "/note", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
	public String addNote(@RequestBody String rawJson, HttpSession session) {

		Integer idUser = (Integer) session.getAttribute("idUser");

		System.out.println(idUser);
		JSONObject parsedJson = new JSONObject(rawJson);
		System.out.println(parsedJson);


		DAO dao = new DAO();
		Note note = new Note();
		note.setNoteText(parsedJson.getString("noteText"));
		note.setIcon((("icon")));
		note.setColor(("#ffec9d"));
		note.setTag(("#tag"));
		note.setTitle("Title");
		System.out.println((note.getInfo()));

		note.setIdUser(idUser);
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm MM/dd");
		LocalDateTime now = LocalDateTime.now();
		note.setTime(dtf.format(now));

		dao.adicionaNota(note);
		note.setIdNote(dao.getLastInsertedId());
		dao.close();

		return note.getInfo();
	}

	
	@RequestMapping(value = "/note", method = RequestMethod.PUT, produces = "application/json")
	@ResponseBody
	public String editNote(@RequestBody String rawJson, HttpSession session)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

//		Gson gson = new Gson();
		Integer idUser = (Integer) session.getAttribute("idUser");

		System.out.println(idUser);
		JSONObject parsedJson = new JSONObject(rawJson);
		System.out.println(parsedJson);


		Integer idNote =  parsedJson.getInt("idNote");
		String color =  parsedJson.getString("color");
		String tag =  parsedJson.getString("tag");
		String title =  parsedJson.getString("title");
		String icon =  parsedJson.getString("color");
		String noteText =  parsedJson.getString("noteText");


		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm MM/dd");
		LocalDateTime now = LocalDateTime.now();

		System.out.println(idNote);

		DAO dao = new DAO();
		Note note = dao.getNote(idNote, idUser);
		note.setTime(dtf.format(now));
		note.setColor(color);
		note.setIcon(icon);
		note.setTag(tag);
		note.setTitle(title);
		note.setNoteText(noteText);
		dao.alteraNota(note);

		dao.close();

		return note.getInfo();
	}




	@RequestMapping(value = "/note", method = RequestMethod.DELETE)
	@ResponseStatus(value = HttpStatus.OK)
	public void removeNote(@RequestBody String rawJson, HttpSession session)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		Integer idUser = (Integer) session.getAttribute("idUser");

		System.out.println(idUser);
		JSONObject parsedJson = new JSONObject(rawJson);
		System.out.println(parsedJson);
		


		System.out.println(parsedJson.getInt("idNote"));

		DAO dao = new DAO();

		dao.removeNota(parsedJson.getInt("idNote"));

		dao.close();

	}
	
	@RequestMapping(value = "/note/q", method = RequestMethod.GET)
	@ResponseBody
	public String searchNote(@RequestParam(value="text", required=false) String text, HttpSession session)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		System.out.println(text);
		
		Gson gson = new Gson();

		Integer idUser = (Integer) session.getAttribute("idUser");
		
		DAO dao = new DAO();
		List<Note> notes = dao.searchNotesByText(text, idUser);

		dao.close();

		return gson.toJson(notes);
		
	}
}
