<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>



<html>
<head>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
<link rel="stylesheet" type="text/css" href="./css/style.css" />
<script src="./js/index.js"></script>
<script>
console.log("importou o js")

function getNoteInfo(idNote){
    const note = document.getElementById("note"+idNote)

    
   	const title = note.children[0].children[0].innerText
    const color = rgb2hex(note.style.getPropertyValue("background-color"))
    let tag = note.children[2].children[0].innerText
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

	let noteInfo = document.getElementById("notinha" + idNote)

	let note = document.getElementById("tag" + idNote)
	note.addEventListener("input", debounce(() => {
		console.log('atualizando o bd')
		
		const url = "note"

		let tag = note.innerText
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
							<li><div onClick="removeNote(\${note.idNote})"
									style="display: flex; justify-content: flex-start; align-items: center;">
									<i class="material-icons">delete</i>Delete
								</div></li>
						</ul>
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

function onMakeNoteChange() {
	let noteContainer = document.getElementById("alou")
	let newNote = document.getElementById("newNote")

	console.log('Creating a new note...')

	const url = "note"
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
		setInterval(()=>{
			window.location.replace("/testespring");
		}, 200);

		

	})
	
}
</script>
<!-- <script src="https://unpkg.com/draggabilly@2/dist/draggabilly.pkgd.min.js"></script> -->

<!-- <script src="https://unpkg.com/packery@2/dist/packery.pkgd.min.js"></script> -->

<!-- <script src="./index.js"></script>
 -->
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
				<li><a href="/testespring" class="center" style="color: #1d87da">Sign
						Out</a></li>
			</ul>

		</div>
	</nav>


	<div class="container">

		<div class="row">
			<div class="input-field col s12 m12 l12" id=''>

				<input id="newNote" type="text" class="validate col s11 m11 l11">
				<label for="icon_prefix">Make a Note...</label> <a
					id='addNoteButton' onclick="onMakeNoteChange()"
					class="waves-effect waves btn-floating btn-small offset-s11 offset-m11 offset-l11 grey lighten-1"
					style="margin-left: 1%"><i class="material-icons">add</i></a>


			</div>



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
							<li><div onClick='removeNote(${note.idNote})'
									style="display: flex; justify-content: flex-start; align-items: center;">
									<i class="material-icons">delete</i>Delete
								</div></li>
						</ul>
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
