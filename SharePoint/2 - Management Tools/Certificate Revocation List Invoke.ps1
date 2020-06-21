#Prepare the environment, we want a folder in our D:\Box folder 
$check = (Test-Path -PathType Container -Path D:\BOX\CRL) 
IF ($check -eq 0) 
{ 
    New-Item -ItemType Directory -Force -Path D:\BOX\CRL 
} 
#Files we want to get 
$source = 
            "http://crl.microsoft.com/pki/crl/products/microsoftrootcert.crl", 
            "http://crl.microsoft.com/pki/crl/products/CSPCA.crl", 
            "http://crl.microsoft.com/pki/crl/products/MicCodSigPCA_08-31-2010.crl", 
            "http://ctldl.windowsupdate.com/msdownload/update/v3/static/trustedr/en/disallowedcertstl.cab", 
            "http://ctldl.windowsupdate.com/msdownload/update/v3/static/trustedr/en/authrootstl.cab",
            "http://crl.quovadisglobal.com/qvrca.crl",
            "http://crl.quovadisglobal.com/qvrca2.crl",
            "http://crl.quovadisglobal.com/qvrca3.crl",
            "http://crl.quovadisglobal.com/qvrcag3.crl",
            "http://crl.quovadisglobal.com/qvrca2g3.crl",
            "http://crl.quovadisglobal.com/qvrca3g3.crl",
            "http://crl.quovadisglobal.com/qvbecag1.crl",
            "http://crl.quovadisglobal.com/qvcscag1.crl",
            "http://crl.quovadisglobal.com/qvdcaG1.crl",
            "http://crl.quovadisglobal.com/qveldvg1.crl",
            "http://crl.quovadisglobal.com/qveuqica.crl",
            "http://crl.quovadisglobal.com/qveucag1.crl",
            "http://crl.quovadisglobal.com/qveucag2.crl",
            "http://crl.quovadisglobal.com/qveucag3.crl",
            "http://crl.quovadisglobal.com/qveussl1.crl",
            "http://crl.quovadisglobal.com/qvevssl1.crl",
            "http://crl.quovadisglobal.com/qvsslica.crl",
            "http://crl.quovadisglobal.com/qvsslg2.crl",
            "http://crl.quovadisglobal.com/qvsslg3.crl",
            "http://crl.quovadisglobal.com/qvgridg1.crl",
            "http://crl.quovadisglobal.com/qvicag3.crl",
            "http://crl.quovadisglobal.com/qvicag4.crl",
            "http://crl.quovadisglobal.com/qvica1g3.crl",
            "http://crl.quovadisglobal.com/qvica3g3.crl",
            "http://crl.quovadisglobal.com/qvpssg1.crl",
            "http://crl.quovadisglobal.com/qvqica1.crl",
            "http://crl.quovadisglobal.com/qvsidag1.crl",
            "http://crl.quovadisglobal.com/qvsidqg1.crl",
            "http://crl.quovadisglobal.com/qvchadg1.crl",
            "http://crl.quovadisglobal.com/qvchadg2crl",
            "http://crl.quovadisglobal.com/qvtsagca.crl",
            "http://crl.quovadisglobal.com/bekbcag1.crl",
            "http://crl.quovadisglobal.com/bekbcag2.crl",
            "http://crl.quovadisglobal.com/fmhicag1.crl",
            "http://crl.quovadisglobal.com/hinicag1.crl",
            "http://crl.quovadisglobal.com/hydclig1.crl",
            "http://crl.quovadisglobal.com/hydevcg1.crl",
            "http://crl.quovadisglobal.com/hydsslg1.crl",
            "http://crl.quovadisglobal.com/hydsslg2.crl",
            "http://crl.quovadisglobal.com/inticag1.crl",
            "http://crl.quovadisglobal.com/qvocag2.crl",
            "http://crl.quovadisglobal.com/qvoburg2.crl",
            "http://crl.quovadisglobal.com/pkioevca.crl",
            "http://crl.quovadisglobal.com/pkioevg2.crl",
            "http://crl.quovadisglobal.com/qvtarg1.crl",
            "http://crl.quovadisglobal.com/qvtarg2.crl",
            "http://crl.quovadisglobal.com/qvtacag1.crl",
            "http://crl.quovadisglobal.com/qvtacag2.crl"            
#Save location 
$dest = "D:\BOX\CRL\" 
#Prepare the web session 
$WebClient = New-Object System.Net.WebClient 
$WebProxy = New-Object System.Net.WebProxy("http://collabtr.local:8080",$true) 
$WebClient.Proxy = $WebProxy 
#Get the files 
Foreach ($file in $source) 
{ 
    if ($file -match "http://crl.microsoft.com") 
    { 
        $location = $dest + (($file -split "products/")[1].substring(0)) 
        $WebClient.DownloadFile($file,$location) 
    } 
    elseif ($file -match "collabtr.local") 
    { 
        $location = $dest + (($file -split "collabtr.local/")[1].substring(0)) 
        $WebClient.DownloadFile($file,$location) 
    } 
    elseif ($file -match "trustedr/en/") 
    { 
        $location = $dest + (($file -split "en/")[1].substring(0)) 
        $WebClient.DownloadFile($file,$location) 
    } 
    elseif ($file -match "http://crl.quovadisglobal.com")
    {
        $location = $dest + (($file -split "quovadisglobal.com/")[1].substring(0)) 
        $WebClient.DownloadFile($file,$location) 
    }
} 
#Clean CRL List
$regLoc = "HKLM:\SOFTWARE\Microsoft\SystemCertificates\CA\CRLs"
Remove-Item -Path $regLoc -recurse
#Upload to Certificate Store 
$certfiles = Get-ChildItem $dest  
Foreach ($crlfile in $certfiles) 
{ 
    $addIt=$dest+$crlfile.Name 
    Certutil -addstore CA $addIt 
} 
# CleanUp 
$cleaner = $dest+"*" 
Remove-item -Path $cleaner -Recurse -Force  