<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
	
<link rel="stylesheet" type="text/css" href="./css/style.css" />
<script>
function addUser() {
	const name = document.getElementById("name").value
	
	const username = document.getElementById("username").value
	const password = document.getElementById("password").value
	
	console.log('adding new user')

	const url = "user"

	const params = {
		"name": name,
		"username": username,
		"password": password
	}
	
	console.log(params)
	console.log(JSON.stringify(params))
	fetch(url, {
		method: "POST",
		body: JSON.stringify(params),
		headers: {
			"Content-Type": "application/json"
		}


	}).then(() => {
		M.toast({
			html: 'User created!!'
		})
		setInterval(()=>{
			window.location.replace("/testespring");
		}, 200);

		

	})
	
}
</script>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.0/css/materialize.min.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">

<title>Sign Up</title>
</head>
<body style="background-color: rgba(241, 247, 246, 0.836);">
	<nav class='row blue lighten-2'>
		<div class="nav-wrapper">
			<a href="/testespring" class="brand-logo center"><i
				class="large material-icons " id="mainIcon">assignment</i>myNote</a>
		</div>
	</nav>


	<div class="container">

		<div class="row">
			<div class="col s4 offset-s4">
				<br>
				<h4 class="center-align">Sign Up</h4>
				<br></br>  Name: <input
					id="name" type='text' name='name'> <br> Username: <input
					id="username" type='text' name='username'> <br>
				Password: <input id="password" type='password' name='password'>
				<br> <br>
				<div class="center-align">
					<button type='submit' onClick="addUser()"
						class="waves-effect waves-light btn center blue lighten-2"
						value='Sign In'>Sign Up</button>
				</div>
				<br>
				<p class="center-align">
					Already have an account? <a href="/testespring">Sign In!</a>
				</p>
			</div>
		</div>
	</div>
</body>
</html>