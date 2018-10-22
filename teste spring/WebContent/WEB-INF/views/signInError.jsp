<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
<link rel="stylesheet" type="text/css" href="./css/style.css" />
<script src="./js/index.js"></script>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.0/css/materialize.min.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<title>Sign In</title>
</head>
<body style="background-color: rgba(241, 247, 246, 0.836);">
	<nav class='row blue lighten-2'>
		<div class="nav-wrapper">
			<a class="brand-logo center" ><i class="large material-icons " id="mainIcon">assignment</i>myNote</a>
		</div>
	</nav>
	

<div class="container">

<div class="row">
<div class="col s4 offset-s4">
<br>
<h4 class="center-align">Sign In</h4>
<br></br>
<form method='post' action="/testespring/verifyUser">
	Username: <input type='text' name='username'>
	<br>
	Password: <input type='password' name='password'>
	<br>
<br>
<div class="center-align">
<button type='submit' class="waves-effect waves-light btn center blue lighten-2" value='Sign In'>Sign In</button>
</div>
<br>
<p class="center-align"><a style=color:red>Invalid username or password</a></p>
<br>
<p class="center-align">Don't have an account yet? <a href="signUp">Sign Up!</a></p>
</form>
</div>
</div>
</div>

</body>
</html>