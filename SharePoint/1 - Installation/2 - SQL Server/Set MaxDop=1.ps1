## Sets the 'max degree of parallelism' value to 1 for the specified SQL server instance 
## Port 1433 is used if not specified 
## 2012-10-08 
## www.pointbeyond.com 
## NOTE: This function requires at least serveradmin level permissions within SQL server 
function SetMaxDegreeOfParallelism() 
{ 
    Param( 
        $server, 
        $port="1433") 
 
    $conn = new-object System.Data.SqlClient.SqlConnection 
 
    try 
    { 
        $connectionString = "Server="+$server+","+$port+";Database=master;Integrated Security=True;" 
 
        $conn.ConnectionString = $connectionString 
        $conn.Open() 
 
        $cmd = new-object System.Data.SqlClient.SqlCommand 
        $cmd.Connection = $conn 
 
        # Ensure advanced options are available 
        $commandText = "sp_configure 'show advanced options', 1;RECONFIGURE WITH OVERRIDE;"         
        $cmd.CommandText = $commandText 
        $r = $cmd.ExecuteNonQuery() 
 
        # Set the Max Degree of Parallelism value to 1 
        write-host "Setting 'max degree of parallelism' value to 1 for server $server..." 
        $commandText = "sp_configure 'max degree of parallelism', 1;RECONFIGURE WITH OVERRIDE"         
        $cmd.CommandText = $commandText 
        $r = $cmd.ExecuteNonQuery() 
 
        write-host "Success" 
    } 
    catch 
    { 
        write-host "An error occurred trying to set the MaxDegreeOfParallelism value to 1 for server $server" -Fore Red 
        write-host "Ensure that server and port parameters are correct and that the current user has at least serveradmin permissions within SQL" -Fore Red 
    } 
    finally 
    { 
        $conn.Close() 
    } 
} 
 
 
# Call the function passing in SQL server name/instance/alias and port number 
SetMaxDegreeOfParallelism -server "SPSQL" -port "1433"