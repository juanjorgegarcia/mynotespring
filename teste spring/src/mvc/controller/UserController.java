package mvc.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import mvc.model.*;

@Controller
public class UserController {

	@RequestMapping("/")
	public String execute() {
		return "signIn";

	}

	@RequestMapping("/signUp")
	public String form() {
		return "signUp";
	}

	@RequestMapping(value = "/user", method = RequestMethod.POST)
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	public String addUser(@RequestBody String rawJson, HttpSession session) {
		
		System.out.println(rawJson);
		JSONObject parsedJson = new JSONObject(rawJson);
		System.out.println(parsedJson);

		DAO dao = new DAO();
		User user = new User();
		user.setName(parsedJson.getString("name"));
		user.setUsername((parsedJson.getString("username")));
		user.setPassword(parsedJson.getString("password"));
		dao.adicionaUser(user);


		dao.close();
		return "signIn";


	}
	@RequestMapping(value = "/user", method = RequestMethod.PUT)
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	public void changePass(@RequestBody String rawJson, HttpSession session) {

		Integer idUser = (Integer) session.getAttribute("idUser");

		System.out.println(idUser);
		JSONObject parsedJson = new JSONObject(rawJson);
		System.out.println(parsedJson);

		
		
		DAO dao = new DAO();
		String old_password = parsedJson.getString("oldPassword");
		String new_password = parsedJson.getString("newPassword");
		String confirm_password = parsedJson.getString("confirmPassword");
		
		System.out.println("ID DO USER");
		System.out.println(idUser);
		String isErrorHidden = "hidden";
		String isPassCheckHidden = "hidden";
				
		boolean isPassEqual = false;
		
		if (new_password.equals(confirm_password)){
			isPassEqual = true;
		}
		
		boolean old_pass_check = dao.checkPass(idUser, old_password);

		if(isPassEqual && old_pass_check) {
			dao.changePass(idUser, new_password);
			isErrorHidden = "hidden";
			isPassCheckHidden = "";
			session.setAttribute("isErrorHidden", isErrorHidden);
			session.setAttribute("isPassCheckHidden", isPassCheckHidden);
		}
		else {
			isErrorHidden = "";
			isPassCheckHidden = "hidden";
			session.setAttribute("isErrorHidden", isErrorHidden);
			session.setAttribute("isPassCheckHidden", isPassCheckHidden);
		}
		
	}

	@RequestMapping("/checkUser")
	public String checkUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		DAO dao = new DAO();
		String site = "signUpError";
		boolean userExists = false;
		User user = new User();
		String name = request.getParameter("name");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		user.setName(name);
		user.setUsername(username);
		user.setPassword(password);

		userExists = dao.checkUser(username);
		System.out.println("Estou dps do userExists");

		if (!userExists) {
			dao.adicionaUser(user);
			site = "signIn";
		}
		return site;

	}

	@RequestMapping("/verifyUser")
	public String verifyUser(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		DAO dao = new DAO();
		String site = "signInError";
		boolean verifyUser = false;
		String username = request.getParameter("username");
		String password = request.getParameter("password");

		String isErrorHidden = "hidden";
		String isPassCheckHidden = "hidden";

		HttpSession session = request.getSession();
		session.setAttribute("isPassCheckHidden", isPassCheckHidden);
		session.setAttribute("isErrorHidden", isErrorHidden);

		verifyUser = dao.verifyUser(username, password);

		if (verifyUser) {
			site = "index";
			Integer idUser = dao.getIdFromUsername(username);
			session.setAttribute("idUser", idUser);
		}
//		request.getRequestDispatcher("index.jsp").include(request, response);

		return site;
	}

	@RequestMapping(value = "/user", method = RequestMethod.DELETE)
	@ResponseBody
	@ResponseStatus(value = HttpStatus.OK)
	public void removeUser(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		DAO dao = new DAO();
		dao.removeUser(Integer.valueOf(request.getParameter("idUser")));
		PrintWriter out = response.getWriter();
		out.println("<html><body>");
		out.println("removido");
		out.println("</body></html>");
		dao.close();
	}

}
