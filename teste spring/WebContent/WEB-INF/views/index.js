console.log("importou o js")

function load(url, element)
{
    req = new XMLHttpRequest();
    req.open("GET", url, false);
    req.send(null);

    element.innerHTML = req.responseText; 
}
function debounce(func, wait, immediate) {
	var timeout;
	return function() {
		var context = this, args = arguments;
		var later = function() {
			timeout = null;
			if (!immediate) func.apply(context, args);
		};
		var callNow = immediate && !timeout;
		clearTimeout(timeout);
		timeout = setTimeout(later, wait);
		if (callNow) func.apply(context, args);
	};
};
function onNoteTextChange(idNote){
	let note = document.getElementById("editor"+idNote)
	note.addEventListener("input", debounce(()=>{
		console.log('atualizando o bd')

		const url = "/mynote/EditNoteText"
		let noteText = note.innerText

		let params = {
				"noteText":encodeURIComponent(noteText),
				"idNote":encodeURIComponent(idNote)
		}
		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
		    method : "POST",
		    body: 'note='+JSON.stringify(params),
		    headers:    {
		        "Content-Type": "application/x-www-form-urlencoded"
		    }


		}).then((res) =>{
			(res.json().then((data)=>{
				note.setAttribute("style", "color:white");
				note.innerText = data.noteText
				M.toast({html: 'Note updated!!'})

			}))
		}
	)
	},1000*2), false);
}


function onQuerySubmit(){
	let note = document.getElementById("search")
	note.addEventListener("input", debounce(()=>{
		console.log('enviando a query')
//
//		const url = "/mynote/EditNoteTag"
//		let tag = note.innerText
//
//		let params = {
//				"tag":encodeURIComponent(tag),
//				"idNote":encodeURIComponent(idNote)
//		}
//		console.log(idNote)
//		console.log('request enviado')
//		fetch(url, {
//		    method : "POST",
//		    body: 'note='+JSON.stringify(params),
//		    headers:    {
//		        "Content-Type": "application/x-www-form-urlencoded"
//		    }
//
//
//		}).then((res) =>{
//					(res.json().then((data)=>{
//						note.setAttribute("style", "color:white");
//						note.innerText = '#'+data.tag
//						M.toast({html: 'Tag updated!!'})
////						let url = window.location.pathname + window.location.search + window.location.hash
////						load(url, document.getElementById("tag"+idNote));
//
//					}))
//				}
//			)
	},1000), false)	

}

function onTagChange(idNote){
	let note = document.getElementById("tag"+idNote)
	note.addEventListener("input", debounce(()=>{
		console.log('atualizando o bd')

		const url = "/mynote/EditNoteTag"
		let tag = note.innerText

		let params = {
				"tag":encodeURIComponent(tag),
				"idNote":encodeURIComponent(idNote)
		}
		console.log(idNote)
		console.log('request enviado')
		fetch(url, {
		    method : "POST",
		    body: 'note='+JSON.stringify(params),
		    headers:    {
		        "Content-Type": "application/x-www-form-urlencoded"
		    }


		}).then((res) =>{
					(res.json().then((data)=>{
						note.setAttribute("style", "color:white");
						note.innerText = '#'+data.tag
						M.toast({html: 'Tag updated!!'})
//						let url = window.location.pathname + window.location.search + window.location.hash
//						load(url, document.getElementById("tag"+idNote));

					}))
				}
			)
	},1000*2), false)	
}

function createNote(note){
	card = 				
        `<div class='col s12 m4 l3 notinha'>
		<div class="card indigo hoverable">
			<div class="card-content">
				<span class="card-title activator grey-text text-darken-4">Card
					Title<i class="material-icons right tooltipped"
					data-position="left" data-tooltip="Customize!">more_vert</i>
				</span>
				<p>
					<i class="material-icons">check</i> ${note.icon}
				</p>

				<div contenteditable="true" id="editor${note.idNote}"
					class="card-panel indigo lighten-1"
					onfocus="onNoteTextChange(${note.idNote})">

					<span id='noteText${note.idNote}' class="white-text">${note.noteText}
					</span>
				</div>

			</div>

			<div class="card-reveal">
				<div>
					<span class="card-title grey-text text-darken-4">Card
						Title<i class="material-icons right">close</i>
					</span> <span class="card-title grey-text text-darken-4">delete
						note<i class="material-icons right">close</i>
					</span>

				</div>
			</div>

			<div contenteditable="true" id="tag${note.idNote}"
				class="card-panel indigo lighten-1"
				onfocus="onTagChange(${note.idNote})">

				<span id='note${note.idNote}' class="white-text">#${note.tag}
				</span>
			</div>
		</div>
	</div>`
	
return card
	
}

document.addEventListener('DOMContentLoaded', function() {
	console.log("importou o js")
	
	var iconPicker = document.querySelectorAll('select');
    var instIcon= M.FormSelect.init(iconPicker, {});
    
	var sidenav = document.querySelectorAll('.sidenav');
    var inst = M.Sidenav.init(sidenav, {});
    
    var chips = document.querySelectorAll('.chips');
    var instChips = M.Chips.init(chips, {'limit':3});
    
    var collap = document.querySelectorAll('.collapsible');
    var instCollap = M.Collapsible.init(collap, {});
//	var elems = document.querySelectorAll('.tooltipped');
//	var instances = M.Tooltip.init(elems, {});
	document.getElementById('editor1').addEventListener('input',()=>{
		console.log('to clicando na tecla')
	},false)
	let newNote = document.getElementById("newNote")
	newNote.addEventListener("keyup", function(event) {
		  // Cancel the default action, if needed
		  event.preventDefault();
		  // Number 13 is the "Enter" key on the keyboard
		  if (event.keyCode === 13) {
		    // Trigger the button element with a click
		    document.getElementById("addNoteButton").click();
		  }
		});
});

function onMakeNoteChange(){
	let noteContainer = document.getElementById("alou")
	let newNote = document.getElementById("newNote")

	console.log('Creating a new note...')

		const url = "/mynote/AddNote"
		let noteText = newNote.value

		let params = {
				"noteText":encodeURIComponent(noteText),
				
		}
		console.log('request enviado')
		fetch(url, {
		    method : "POST",
		    body: 'note='+JSON.stringify(params),
		    headers:    {
		        "Content-Type": "application/x-www-form-urlencoded"
		    }

		}).then((res) =>{
			(res.json().then((data)=>{
				console.log(data)
				card = createNote(data)
				noteContainer.insertAdjacentHTML( 'afterbegin', card)
				newNote.value = ""
			}))
		}
	)


}

