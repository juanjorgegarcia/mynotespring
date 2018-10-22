package mvc.model;

import com.google.gson.Gson;

public class Note {
	private Integer idNote;
	private String noteText;
	private String tag;
	private String color;
	private String icon;
	private Integer idUser;
	private String info;
	private String time;
	private String title;
	public Integer getIdNote() {
		return idNote;
	}
	public void setIdNote(Integer idNote) {
		this.idNote = idNote;
	}
	public String getNoteText() {
		return noteText;
	}
	public void setNoteText(String noteText) {
		this.noteText = noteText;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public Integer getIdUser() {
		return idUser;
	}
	public void setIdUser(Integer idUser) {
		this.idUser = idUser;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	public String getInfo() {
		Gson gson = new Gson();

//		String info = "{"+
//				"idNote:"+this.getIdNote()+
//				",noteText:"+this.getNoteText()+
//				",tag:"+this.getTag()+
//				",color:"+this.getColor()+
//				",icon:"+this.getIcon()+
//				",idUser:"+this.getIdUser()+
//				 "}";
		System.out.println(gson.toJson(this));
		return gson.toJson(this);
	}
	public void setInfo(String info) {
		this.info = info;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}


}
