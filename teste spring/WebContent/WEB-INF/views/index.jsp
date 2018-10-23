<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>



<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>

<!-- <link rel="stylesheet" type="text/css" href="./css/style.css" />
<script src="./js/index.js"></script> -->
<script>
//Client ID and API key from the Developer Console
var CLIENT_ID = '707975249507-jaoe25kaupse1c9lba97og4hll37hk18.apps.googleusercontent.com';
var API_KEY = 'AIzaSyC5VMPR01zRwEvVFlE1L3ToyBwgXRiFcuc';
 //Array of API discovery doc URLs for APIs used by the quickstart
var DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];
 //Authorization scopes required by the API; multiple scopes can be
//included, separated by spaces.
var SCOPES =
  "https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar.events https://www.googleapis.com/auth/calendar.events";
 /**
*  On load, called to load the auth2 library and API client library.
*/
function handleClientLoad() {
  gapi.load('client:auth2', initClient);
}
 /**
*  Initializes the API client library and sets up sign-in state
*  listeners.
*/
function initClient() {
   gapi.client.init({
      apiKey: API_KEY,
      clientId: CLIENT_ID,
      discoveryDocs: DISCOVERY_DOCS,
      scope: SCOPES
  }).then(function () {
	  var authorizeButton = document.getElementById("authorize_button");
	  var signoutButton = document.getElementById("signout_button");
      // Listen for sign-in state changes.
      gapi.auth2.getAuthInstance().isSignedIn.listen(updateSigninStatus);
       // Handle the initial sign-in state.
      updateSigninStatus(gapi.auth2.getAuthInstance().isSignedIn.get());
      authorizeButton.onclick = handleAuthClick;
      signoutButton.onclick = handleSignoutClick;
  });
}
 /**
*  Called when the signed in status changes, to update the UI
*  appropriately. After a sign-in, the API is called.
*/
function updateSigninStatus(isSignedIn) {
	var authorizeButton = document.getElementById("authorize_button");
	var signoutButton = document.getElementById("signout_button");
  if (isSignedIn) {
      authorizeButton.style.display = 'none';
      signoutButton.style.display = 'block';
//       listUpcomingEvents();
      console.log(gapi.client)
 /*         var request = gapi.client.calendar.events.insert({
          'calendarId': 'primary',
          'resource': event
      });
      console.log(request)
      request.execute(function (event) {
          appendPre('Event created: ' + event.htmlLink);
      }); */
      console.log('rerer')
      // sendAuthorizedApiRequest(request)
   } else {
      authorizeButton.style.display = 'block';
      signoutButton.style.display = 'none';
  }
}
 /**
*  Sign in the user upon button click.
*/
function handleAuthClick(event) {
  gapi.auth2.getAuthInstance().signIn();
}
 /**
*  Sign out the user upon button click.
*/
function handleSignoutClick(event) {
  gapi.auth2.getAuthInstance().signOut();
}
 /**
* Append a pre element to the body containing the given message
* as its text node. Used to display the results of the API call.
*
* @param {string} message Text to be placed in pre element.
*/
function appendPre(message,idNote) {
  var pre = document.getElementById('tag'+idNote);
  var textContent = document.createTextNode(message + '\n');
  pre.appendChild(textContent);
}
 /**
* Print the summary and start datetime/date of the next ten events in
* the authorized user's calendar. If no events are found an
* appropriate message is printed.
*/
 function listUpcomingEvents() {
  gapi.client.calendar.events.list({
      'calendarId': 'primary',
      'timeMin': (new Date()).toISOString(),
      'showDeleted': false,
      'singleEvents': true,
      'maxResults': 10,
      'orderBy': 'startTime'
  }).then(function (response) {
      var events = response.result.items;
      appendPre('Upcoming events:');
       if (events.length > 0) {
          for (i = 0; i < events.length; i++) {
              var event = events[i];
              var when = event.start.dateTime;
              if (!when) {
                  when = event.start.date;
              }
              appendPre(event.summary + ' (' + when + ')')
          }
      } else {
          appendPre('No upcoming events found.');
      }
  });
}
function createEvent(idNote){
	console.log(idNote)
	const timepicker = document.getElementById("timePicker"+idNote).value
    const datepicker = document.getElementById("datePicker"+idNote).value
	const noteInfo = getNoteInfo(idNote)
	console.log(noteInfo)
	var event = {
		  'summary': noteInfo.title,
		  'description': noteInfo.noteText,
		  'start': {
		    'dateTime': datepicker+"T"+timepicker+":00",
		    'timeZone': 'America/Sao_Paulo'
		  },
		  'reminders': {
		    'useDefault': false,
		    'overrides': [
		      {'method': 'email', 'minutes': 24 * 60},
		      {'method': 'popup', 'minutes': 10}
		    ]
		  }
		};
	
}
function addEvent(idNote){
	console.log(idNote)
	const timepicker = document.getElementById("timePicker"+idNote).value
    var datepicker = document.getElementById("datePicker"+idNote).value
	const noteInfo = getNoteInfo(idNote)
	console.log((timepicker))
	let minutes= parseInt(timepicker.substring(3,5))+30
	var hours = parseInt(datepicker.substring(0,2))
	if (minutes>=60){
		
		hours = parseInt(timepicker.substring(0,2))+1
		minutes = "00"
			console.log(hours)
 		if (hours>=24){
			var days = parseInt(datepicker.substring(8,10))+1
			hours = "00"
			console.log(hours)
			
		}
		
	}
	console.log(hours)
 	const datetime= datepicker+"T"+timepicker+":00"
	console.log(minutes)
	console.log(datepicker+"T"+hours+":"+minutes+":00")
	var event = {
		  'summary': noteInfo.title,
		  'description': noteInfo.noteText,
		  'start': {
		    'dateTime': datepicker+"T"+timepicker+":00",
		    'timeZone': 'America/Sao_Paulo'
		  },
          'end': {
              'dateTime': datepicker+"T"+hours+":"+minutes+":00",
              'timeZone': 'America/Sao_Paulo'
          },
		  'reminders': {
		    'useDefault': false,
		    'overrides': [
		      {'method': 'email', 'minutes': 24 * 60},
		      {'method': 'popup', 'minutes': 10}
		    ]
		  }
		};
     var request = gapi.client.calendar.events.insert({
		     'calendarId': 'primary',
		     'resource': event
		 });
	 console.log(request) 
     request.execute(function (event) {
         appendPre('Event created: ' + event.htmlLink,idNote);
     });
 }
</script>
<script>
console.log("importou o js")

function getNoteInfo(idNote){
    const note = document.getElementById("note"+idNote)

    
   	const title = note.children[0].children[0].innerText
    const color = rgb2hex(note.style.getPropertyValue("background-color"))
    let tag = note.children[3].children[0].innerText
	if(tag[0]=='#'){
		tag = tag
	}
	else{
		tag ='#'+ tag
	}
	
    const noteText = note.children[1].innerText
    return {
    	"title":title,
    	"color":color,
    	"tag":tag,
    	"noteText":noteText,
    	"idNote":idNote
    		
    }

}
function rgb2hex(rgb) {
    if (/^#[0-9A-F]{6}$/i.test(rgb)) return rgb;

    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    function hex(x) {
        return ("0" + parseInt(x).toString(16)).slice(-2);
    }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}

function debounce(func, wait, immediate) {
	var timeout;
	return function () {
		var context = this,
			args = arguments;
		var later = function () {
			timeout = null;
			if (!immediate) func.apply(context, args);
		};
		var callNow = immediate && !timeout;
		clearTimeout(timeout);
		timeout = setTimeout(later, wait);
		if (callNow) func.apply(context, args);
	};
};


function onNoteTextChange(idNote) {
	let noteContainer = document.getElementById("alou")
	
	let note = document.getElementById("editor" + idNote)
	let notezin = document.getElementById('note' + idNote)
	let noteInfo = document.getElementById("notinha" + idNote)
	
	

	note.addEventListener("input", debounce(() => {
		console.log('atualizando o bd')

		const url = "note"
		const noteText = note.innerText

		const params = getNoteInfo(idNote)
		
		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
			method: "PUT",
			body: JSON.stringify(params),
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			}


		}).then((res) => {
			(res.json().then((data) => {
				note.setAttribute("style", "color:black");
				note.innerText = data.noteText
				noteInfo.style="order:-1;"
				let time = document.getElementById('time'+idNote)
				time.innerText = 'Last edited: '+ data.time
				M.toast({
					html: 'Note updated!!'
				})

			}))
		})
	}, 1000), false);
}


function onQuerySubmit(userId) {
	let noteContainer = document.getElementById("alou")

	let note = document.getElementById("search")
	note.addEventListener("input", debounce(() => {
		console.log('enviando a query')

		const query = note.value
		
		const params = new URLSearchParams(Object.entries({
		      text: query
		    }))

	    const url =  "note/q?"+ params
	    		
	    console.log(url)


		console.log('request enviado')
		fetch(url, {
			method: "GET",
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			}


		}).then((res) => {
			(res.json().then((data) => {


				console.log(data)

				noteContainer.innerHTML = ""

				data.forEach((note) => {
					console.log(note.idNote)
					let noteInfo = document.createElement('div')
					noteInfo.id = "notinha" + note.idNote
					noteInfo.className = 'col s12 m4 l3 notinha grid-item'
					card = createNote(note)
					noteInfo.innerHTML = card

					console.log(noteInfo)
					
					noteContainer.appendChild(noteInfo);
												

					var elems = document.querySelectorAll('.dropdown-trigger');
				    var instDrop = M.Dropdown.init(elems, {'closeOnClick':false});
				})

			}))
		})
	}, 1000), false)

}

function onTagChange(idNote) {
	let noteContainer = document.getElementById("alou")
	const nots = document.getElementById("note"+idNote)

	let noteInfo = document.getElementById("notinha" + idNote)

	let note = document.getElementById("tag" + idNote)
	note.addEventListener("input", debounce(() => {
		console.log('atualizando o bd')
		
		const url = "note"

		let tag = nots.children[3].children[0].innerText
		const params = getNoteInfo(idNote)

		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
			method: "PUT",
			body: JSON.stringify(params),
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			}


		}).then((res) => {
			(res.json().then((data) => {

				if(tag[0]=='#'){
					note.innerText = tag
				}
				else{
					note.innerText ='#'+ tag
				}
				
				noteInfo.style="order:-1;"
				let time = document.getElementById('time'+idNote)
				time.innerText = 'Last edited: '+ data.time
				M.toast({
					html: 'Tag updated!!'
				})
			}))
		})
	}, 1500), false)
}


function onTitleChange(idNote) {
	let noteContainer = document.getElementById("alou")

	let noteInfo = document.getElementById("notinha" + idNote)

	let note = document.getElementById("noteTitle" + idNote)
	note.addEventListener("input", debounce(() => {
		console.log('atualizando o bd')

		
		const url = "note"

		
		const params = getNoteInfo(idNote)

		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
			method: "PUT",
			body: JSON.stringify(params),
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			}


		}).then((res) => {
			(res.json().then((data) => {

				noteInfo.style="order:-1;"
				let time = document.getElementById('time'+idNote)
				time.innerText = 'Last edited: '+ data.time
				M.toast({
					html: 'Title Updated!!'
				})
			}))
		})
	}, 1500), false)
}



function onColorPicker(idNote) {
	let colorPicker = document.getElementById("colorPicker" + idNote)
	let note = document.getElementById('note' + idNote)
	let noteContainer = document.getElementById("alou")
	let noteInfo = document.getElementById("notinha" + idNote)
	
	console.log(idNote)
	colorPicker.addEventListener("input", debounce(() => {
		console.log('atualizando a cor')


		const color = colorPicker.value
		
		const url = "note"
		const params = getNoteInfo(idNote)

		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
			method: "PUT",
			body:  JSON.stringify(params),
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			}


		}).then((res) => {
			(res.json().then((data) => {
/* 				console.log(color)
 *///				card = createNote(data)
//				noteInfo.innerHTML = card
				note.style.backgroundColor = color
//				noteInfo.style="order:-1;"
				let time = document.getElementById('time'+idNote)
				time.innerText = 'Last edited: '+ data.time
//				noteContainer.insertBefore(noteInfo, document.getElementById("notinha" + (data.idNote - 1)))

				M.toast({
					html: 'Color updated!!'
				})


			}))
		})
	}, 100), false)
}


function removeNote(idNote) {
	console.log(idNote)
	let note = document.getElementById('note' + idNote)
	let noteInfo = document.getElementById('notinha'+idNote)
	let noteContainer = document.getElementById('alou')
	console.log('Removendo nota')

	const url = "note"

	let params = {
		"idNote": (idNote)
	}
	console.log(idNote)
	console.log('request enviado')
	fetch(url, {
		method: "DELETE",
		body: JSON.stringify(params),
		headers: {
			"Content-Type": "application/x-www-form-urlencoded"
		}


	}).then(() => {
		noteContainer.removeChild(noteInfo)
		M.toast({
			html: 'Note removed!!'
		})

	}
	)

}


function createNote(note) {
	card =
		`					<div class="card hoverable" id="note\${note.idNote}"
						style="background-color:\${note.color};">
						<div class="card-content noteHeader" id="noteHeader\${note.idNote}"
							style="background-color: transparent; padding: 10px;">
							<span contenteditable="true"
								class="card-title activator grey-text text-darken-4 "
								id="noteTitle\${note.idNote}"
								onfocus="onTitleChange(\${note.idNote})">\${note.title}</span><i
								class="material-icons dropdown-trigger " href='#'
								data-target='dropdown\${note.idNote}' style="margin-left: 8px;">more_vert
							</i>
						</div>
						<div class="noteText" contenteditable="true"
							id="editor\${note.idNote}"
							onfocus="onNoteTextChange(\${note.idNote})"
							style="background-color: transparent;">
							<span id="noteText\${note.idNote}">\${note.noteText} </span>
						</div>
						<ul id="dropdown\${note.idNote}" class="dropdown-content">
							<li><div>
									<i class="material-icons">color_lens</i> <input type="color"
										id="colorPicker\${note.idNote}" name="color"
										value="\${note.color}" onclick="onColorPicker(\${note.idNote})">
								</div></li>
							<li><div onClick='translateText(\${note.idNote})'
									style="display: flex; justify-content: flex-start; align-items: center;">
									<i class="material-icons">language</i>Translate
								</div></li>
							<li><div onClick="removeNote(\${note.idNote})"
									style="display: flex; justify-content: flex-start; align-items: center;">
									<i class="material-icons">delete</i>Delete
								</div></li>
						</ul>
						<div>
						<div class="input-field col s12"
							style="display: flex; margin-right: 15px; align-items: center;">
							<input style="max-width: 70%;" id="datePicker\${note.idNote}"
								type="text" class="datepicker"><label
								style="max-width: 70%;" for="autocomplete-input">Choose
								a day</label><i class="material-icons"
								style="display: flex; align-items: flex-end; margin-left: 20px;">calendar_today</i>
						</div>
						<div class="input-field col s12"
							style="display: flex; margin-right: 15px; align-items: center;">
							<input style="max-width: 70%;" id="timePicker\${note.idNote}"
								type="text" class="timepicker"><label
								style="max-width: 70%;" for="autocomplete-input">Choose
								the time</label><i class="material-icons"
								style="display: flex; align-items: flex-end; margin-left: 20px;">schedule</i>
						</div>
						<div>
							<a class="waves-effect waves btn" id="addEvent${note.idNote}"
								onClick="addEvent(\${note.idNote})"
								style="color: black; background-color: transparent; display: flex; justify-content: center; margin: 2px;">Create Event</a>
						</div>
 					</div>
						<div id="noteFooter">
							<div id="noteTag">
								<div contenteditable="true" class="tag" id="tag\${note.idNote}"
									class="card-panel " onfocus="onTagChange(\${note.idNote})">
									<span id="note\${note.idNote}"">\${note.tag} </span>
								</div>
							</div>
							<div id="time\${note.idNote}" class="time" style="padding: 5px;">Last
								edited: \${note.time}</div>
						</div>
					</div>
					`

	return card

}

function showDropdown(){
	console.log('cliquei no change pass')
	let dropInst = document.getElementById('accountIcon')
	setTimeout(()=>{
	    dropInst.M_Dropdown.recalculateDimensions();

	},350)
	
}

function datePicker(){
	console.log("ronaldo")
}
document.addEventListener('DOMContentLoaded', function () {
	console.log("importou o js")


	var iconPicker = document.querySelectorAll('select');
	var instIcon = M.FormSelect.init(iconPicker, {});

	var sidenav = document.querySelectorAll('.sidenav');
	var inst = M.Sidenav.init(sidenav, {});

	var chips = document.querySelectorAll('.chips');
	var instChips = M.Chips.init(chips, {
		'limit': 3
	});
    var datepicker = document.querySelectorAll('.datepicker');
    var date_inst = M.Datepicker.init(datepicker, {"format": "yyyy-mm-dd"});
	
    var timepicker = document.querySelectorAll('.timepicker');
    var time_inst = M.Timepicker.init(timepicker, {"twelveHour": false});
    
	var collap = document.querySelectorAll('.collapsible');
	var instCollap = M.Collapsible.init(collap, {});
	// var elems = document.querySelectorAll('.tooltipped');
	// var instances = M.Tooltip.init(elems, {});
	
    var elems = document.querySelectorAll('.dropdown-trigger');
    var instDrop = M.Dropdown.init(elems, {'closeOnClick':false});
    
	let newNote = document.getElementById("newNote")
	newNote.addEventListener("keyup", function (event) {
		// Cancel the default action, if needed
		event.preventDefault();
		// Number 13 is the "Enter" key on the keyboard
		if (event.keyCode === 13) {
			// Trigger the button element with a click
			document.getElementById("addNoteButton").click();
		}
	});
	

});

function onMakeNoteChange(text = false) {
	let noteContainer = document.getElementById("alou")
	let newNote = document.getElementById("newNote")

	console.log('Creating a new note...')

	const url = "note"
	if(text){
		let noteText = text

	}else{
		let noteText = newNote.value

	}
	let noteText = newNote.value

	let params = {
		"noteText": (noteText),

	}
	console.log('request enviado')
	fetch(url, {
		method: "POST",
		body: JSON.stringify(params),


	}).then((res) => {
		(res.json().then((data) => {
			newNote.value = ""
			let noteInfo = document.createElement('div')
			noteInfo.id = "notinha" + data.idNote
			noteInfo.className = 'col s12 m4 l3 notinha'

			card = createNote(data)
			noteInfo.innerHTML = card
			noteInfo.style="order:-1;"
			console.log('esse eh id'+data.idNote)


			let firstChild = document.getElementById("alou").firstChild.innerHTML;

			noteContainer.insertBefore(noteInfo,noteContainer.firstElementChild)

			let time = document.getElementById('time'+data.idNote)
			time.innerText = 'Created: '+ data.time

			console.log(time)

			var elems = document.querySelectorAll('.dropdown-trigger');
		    var instDrop = M.Dropdown.init(elems, {'closeOnClick':false});
		    var datepicker = document.querySelectorAll('.datepicker');
		    var date_inst = M.Datepicker.init(datepicker, {"format": "yyyy-mm-dd"});
			
		    var timepicker = document.querySelectorAll('.timepicker');
		    var time_inst = M.Timepicker.init(timepicker, {"twelveHour": false});

		}))
	})


}

function changePass(idUser) {
	const oldPass = document.getElementById("oldPassword").value
	
	const newPass = document.getElementById("newPassword").value
	const conPass = document.getElementById("confirmPassword").value
	
	console.log('updating password')

	const url = "user"

	const params = {
		"oldPassword": oldPass,
		"newPassword": newPass,
		"confirmPassword": conPass
	}
	
	console.log(params)
	console.log(JSON.stringify(params))
	fetch(url, {
		method: "PUT",
		body: JSON.stringify(params),
		headers: {
			"Content-Type": "application/json"
		}


	}).then(() => {
		M.toast({
			html: 'Password Updated!!'
		})

		

	})
	
}

function translateText(idNote) {
	const noteInfo = getNoteInfo(idNote)
	const texto = noteInfo.noteText
	
	let language = document.querySelector('input[name="language"]:checked').value;
	
	console.log('translating')
	
	const url = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyDFu_r7HYx7OX4Vs977wvoWkF6fv9RMtzE"

	const params = {
			//"source" : "pt",
			"format" : "text",
			"q": [texto],
			"target" : language

			
	}
	
	console.log(texto)
	console.log(JSON.stringify(params))
	fetch(url, {
		method: "POST",
		body: JSON.stringify(params),
		headers: {
			"Content-Type": "application/json"
		}
	
}).then((res)=>{
	res.json().then((data)=>{
		console.log(data)
		LanguageChange(idNote, data.data.translations["0"].translatedText)
	})
})
}

function LanguageChange(idNote, translate) {
	let noteContainer = document.getElementById("alou")
	
	let note = document.getElementById("editor" + idNote)
	let notezin = document.getElementById('note' + idNote)
	let noteInfo = document.getElementById("notinha" + idNote)

		console.log('atualizando o bd')
		const url = "note"

		let params = getNoteInfo(idNote)
		
		params.noteText = translate
		
		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
			method: "PUT",
			body: JSON.stringify(params),
			headers: {
				"Content-Type": "application/x-www-form-urlencoded"
			}


		}).then((res) => {
			(res.json().then((data) => {
				note.setAttribute("style", "color:black");
				note.innerText = data.noteText
				noteInfo.style="order:-1;"
				let time = document.getElementById('time'+idNote)
				time.innerText = 'Last edited: '+ data.time
				M.toast({
					html: 'Note updated!!'
				})

			}))
		})
	
}

</script>

<script async defer src="https://apis.google.com/js/api.js"
	onload="this.onload=function(){};handleClientLoad()"
	onreadystatechange="if (this.readyState === 'complete') this.onload()">
</script>
<style>
#logoName {
	padding-left: 2%;
}

#mainIcon {
	size: 500rem;
}

#accountIcon {
	size: 50px;
	padding-right: 20px;
	padding-left: 20px;
}

#accountIcon:hover {
	size: 50px;
	padding-right: 20px;
	padding-left: 20px;
	background-color: #1d87da !important;
	cursor: pointer;
}

#searchBar {
	padding-top: 30px;
}

.note {
	display: flex;
	flex-wrap: wrap;
	margin: 0% !important;
}

.notinha {
	margin: 0% !important;
}

#nav {
	display: flex;
	justify-content: space-between;
}

.navcontainer {
	display: flex;
}

#addNoteButton:hover {
	background-color: #bbbbbb !important;
}

#addNoteButton {
	background-color: #dedcdc !important;
}

#deleteButton:hover {
	background-color: #dedcdc;
	box-shadow: 0.05em 0.05em #bbbbbb;
}

.tag {
	background-color: #aba8a8;
	border-radius: 0.8em;
	padding: 3px;
	margin: 3px;
	width: fit-content;
	max-width: 100%;
}

#noteTag {
	max-width: 50%;
	width: fit-content;
	padding: 5%;
	margin: 5%;
}

.noteText {
	padding: 10px;
	margin: 10px;
}

.noteHeader {
	padding: 10px;
	display: flex;
	justify-content: space-between;
}
</style>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.0/css/materialize.min.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<meta charset="UTF-8">
<title>Notes</title>
</head>
<body>
<body style="background-color: rgba(241, 247, 246, 0.836);">

	<nav class='row blue lighten-2'>
		<div class="nav-wrapper">
			<a href="#" class="brand-logo col s3 m3 l3 left" id="logoName"><i
				class="large material-icons" id="mainIcon">assignment</i>myNote</a>

			<div
				class="input-field col s6 m6 l6 offset-s3 offset-m3 offset-l3 center">
				<input id="search" type="search" required onFocus="onQuerySubmit(1)">
				<label class="label-icon" for="search"><i
					class="material-icons">search</i></label> <i class="material-icons">close</i>
			</div>
			<%
				Integer id_User = (Integer) request.getSession().getAttribute("idUser");
				String isErrorHidden = (String) request.getSession().getAttribute("isErrorHidden");
				String isPassChangeHidden = (String) request.getSession().getAttribute("isPassChangeHidden");

				pageContext.setAttribute("isPassChangeHidden", isPassChangeHidden);
				pageContext.setAttribute("isErrorHidden", isErrorHidden);
				pageContext.setAttribute("idUser", id_User);
			%>

			<i class="col s3 m3 l3 center large material-icons dropdown-trigger"
				href=# id="accountIcon" data-target='dropdown1'>account_circle</i>

			<ul id='dropdown1' class='dropdown-content'>
				<ul class="collapsible" id='teste'>
					<li>
						<div class="collapsible-header" onClick='showDropdown()'>
							<a href="#!" class="center" style="color: #1d87da">Change
								Password</a>
						</div>
						<div class="collapsible-body">
							Old password: <input type='password' name='old_password'
								id="oldPassword"> <br> New password: <input
								type='password' name='new_password' id="newPassword"> <br>
							Confirm new password: <input type='password'
								name='confirm_password' id="confirmPassword"> <br>
							<div class="center-align">
								<button type='submit' onClick="changePass(${idUser})"
									class="waves-effect waves-light btn center blue lighten-2"
									value='Submit'>Submit</button>
								<br>
								<p class="center-align">
									<a style="color: red" ${isErrorHidden}>Passwords do not
										match</a>
								</p>
								<p class="center-align">
									<a style="color: green" ${isPassCheckHidden}>Successfully
										changed password</a>
								</p>
							</div>
						</div>
					</li>
				</ul>
				<li><a href="/testespring" class="center"
					style="color: #1d87da">Sign Out</a></li>
			</ul>

		</div>
	</nav>

	<pre id="content"></pre>
	<div class="container">
		<p>Google Calendar API</p>
		<!--Add buttons to initiate auth sequence and sign out-->
		<button id="authorize_button" style="display: none;">Authorize</button>
		<button id="signout_button" style="display: none;">Sign Out</button>
		<pre id="content"></pre>
		<div class="row">
			<div class="input-field col s12 m12 l12" id=''>

				<input id="newNote" type="text" class="validate col s11 m11 l11">
				<label for="icon_prefix">Make a Note...</label> <a
					id='addNoteButton' onclick="onMakeNoteChange()"
					class="waves-effect waves btn-floating btn-small offset-s11 offset-m11 offset-l11 grey lighten-1"
					style="margin-left: 1%"><i class="material-icons">add</i></a>

			</div>
			&nbsp;&nbsp;&nbsp;<span>TRANSLATION OPTIONS : </span>&nbsp;&nbsp;&nbsp;<label>
				<input class="with-gap" name="language" type="radio" value="en"
				id="radio" checked /> <span>English</span>
			</label> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <label> <input
				class="with-gap" name="language" type="radio" value="fr" id="radio" />
				<span>French</span>
			</label> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;<label> <input
				class="with-gap" name="language" type="radio" value="de" id="radio" />
				<span>German</span>
			</label> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <label> <input
				class="with-gap" name="language" type="radio" value="pt" id="radio" />
				<span>Portuguese</span>
			</label> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <label> <input
				class="with-gap" name="language" type="radio" value="es" id="radio" />
				<span>Spanish</span>
			</label>



		</div>

		<div class="row note grid" id='alou'>
			<jsp:useBean id="dao" class="mvc.model.DAO" />
			<c:forEach var="note" items="${dao.getListaNota(idUser)}"
				varStatus="idNote">
				<div class='col s12 m4 l3 notinha grid-item'
					id='notinha${note.idNote}'>
					<div class="card hoverable" id='note${note.idNote}'
						style="background-color:${note.color};">
						<div class="card-content noteHeader" id='noteHeader${note.idNote}'
							style="background-color: transparent; padding: 10px;">

							<span contenteditable="true"
								class="card-title activator grey-text text-darken-4 "
								id='noteTitle${note.idNote}'
								onfocus="onTitleChange(${note.idNote})">${note.title}</span><i
								class="material-icons dropdown-trigger " href='#'
								data-target='dropdown${note.idNote}' style='margin-left: 8px;'>more_vert
							</i>




						</div>
						<div class='noteText' contenteditable="true"
							id="editor${note.idNote}"
							onfocus="onNoteTextChange(${note.idNote})"
							style="background-color: transparent;">

							<span id='noteText${note.idNote}'>${note.noteText} </span>
						</div>

						<ul id='dropdown${note.idNote}' class='dropdown-content'>
							<li><div>
									<i class="material-icons">color_lens</i> <input type="color"
										id="colorPicker${note.idNote}" name="color"
										value="${note.color}" onclick='onColorPicker(${note.idNote})'>

								</div></li>
							<li><div onClick='translateText(${note.idNote})'
									style="display: flex; justify-content: flex-start; align-items: center;">
									<i class="material-icons">language</i>Translate
								</div></li>
							<li><div onClick='removeNote(${note.idNote})'
									style="display: flex; justify-content: flex-start; align-items: center;">
									<i class="material-icons">delete</i>Delete
								</div></li>
						</ul>
						<div>
							<div class="input-field col s12"
								style="display: flex; margin-right: 15px; align-items: center;">
								<input style="max-width: 70%;" id="datePicker${note.idNote}"
									type="text" class="datepicker"><label
									style="max-width: 70%;" for="autocomplete-input">Choose
									a day</label><i class="material-icons"
									style="display: flex; align-items: flex-end; margin-left: 20px;">calendar_today</i>
							</div>
							<div class="input-field col s12"
								style="display: flex; margin-right: 15px; align-items: center;">
								<input style="max-width: 70%;" id="timePicker${note.idNote}"
									type="text" class="timepicker"><label
									style="max-width: 70%;" for="autocomplete-input">Choose
									the time</label><i class="material-icons"
									style="display: flex; align-items: flex-end; margin-left: 20px;">schedule</i>
							</div>
							<div>
								<a class="waves-effect waves btn" id="addEvent${note.idNote}"
									onClick="addEvent(${note.idNote})"
									style="color: black; background-color: transparent; display: flex; justify-content: center; margin: 2px;">Create
									Event</a>
							</div>
						</div>
						<div id='noteFooter'>
							<div id='noteTag'>
								<div contenteditable="true" class='tag' id="tag${note.idNote}"
									class="card-panel " onfocus="onTagChange(${note.idNote})">

									<span id='note${note.idNote}'>${note.tag} </span>
								</div>
							</div>
							<div id='time${note.idNote}' class='time' style='padding: 5px;'>Last
								edited: ${note.time}</div>

						</div>
					</div>
				</div>
			</c:forEach>


		</div>
	</div>
</body>
</html>
