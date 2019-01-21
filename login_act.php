<?php 
  $title="Welcome User";
  include 'cus_head.php';
?>

  
<div class="row">
<center>
<?php
include("conn.php");
$errflag=FALSE;
// radio button choice and username and password sent from form
$user=$_POST['user'];        
$id=$_POST['lid'];			 //get by 'name'
$pass=$_POST['pass']; 


	if($user=="Admin" && $id=="Admin" && $pass=="Admin")           //if choice is Admin
	{
		$wel = "WELCOME: $user";
		echo "<script type='text/javascript'>window.location.href='index.php'; alert('{$wel}');</script>";	

	}
	
	else if($user=="user")            //if choice is Customer
	{
	$SQL = "SELECT * FROM `customers` WHERE cname='$id' AND password='$pass'";	
	$result = mysql_query($SQL);
$count=mysql_num_rows($result);
while($row=mysql_fetch_array($result))
{
    $cid=$row[0];
	$nm=$row[1];
}
// If result matched $myusername and $mypassword, table row must be 1 row
if($count==1){


$wel = "WELCOME: $nm";
echo "<script type='text/javascript'>alert('{$wel}');</script>";	
?>


<a href="cus_index.php?cid=<?php echo $cid; ?>">Proceed to Shopping</a>.........


<?php
}

 
 else {
    
echo "<script type='text/javascript'>alert('Wrong Username or Password'); window.location.href='first.php'; </script>";
$errflag=TRUE; 
 }
 }
 
 //This is what i added new
 else{
	$wel = "Wrong username or password.";
	echo "<script type='text/javascript'>window.location.href='first.php'; alert('{$wel}');</script>";
	$errflag=TRUE;
 }

 
session_write_close();
ob_end_flush();
?>

</center>
</div>  

<?php 
include 'footer.php'; 
?>