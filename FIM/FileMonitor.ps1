

Write-Host "File Integrity Monitor"
Write-Host "What would you like to do?"
Write-Host "PLEASE UPDATE Baseline when starting a new Program"
Write-Host "    A) Collect new Baseline"
Write-Host "    B) Begin monitioring files with saved Baseline"
$response = Read-Host "Please enter 'A' or 'B'"
Write-Host "User entered $($response))"

Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash


}
Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path ./baseline.txt

    if ($baselineExists) {
        #delete old baseline
        Remove-Item -Path ./baseline.txt
    }
    }


if ($response -eq "A".ToUpper()) {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    # Calculate Hash from the target files and store in baseline.txt
    # Collect all files in the target folder

    $files = Get-ChildItem -Path ./Alphabet


 Write-Host "Updating baseline.txt" -ForegroundColor Green


foreach ($f in $files) {
    $hash = Calculate-File-Hash $f.FullName
    "$($hash.Path)|$($hash.Hash)"|Out-File -FilePath .\baseline.txt -Append

}

}

elseif  ($response -eq "B". ToUpper()) {

    $fileHashDictionary =@{}

    # Load file|hash from baseline.txt and store in dictionary
    $filesPathesAndHashes = Get-Content -Path ./baseline.txt

    foreach ($f in $filesPathesAndHashes){
        $fileHashDictionary.Add($f.Split("|")[0],$f.Split("|")[1])
    }

    #Begin(continuous) monitoring of files with saved baseline.txt
    while ($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path ./Alphabet

        Write-Host "Updating baseline.txt" -ForegroundColor Blue

       foreach ($f in $files) {
           $hash = Calculate-File-Hash $f.FullName
           "$($hash.Path)|$($hash.Hash)"|Out-File -FilePath .\baseline.txt -Append
           # Notify if a new file has been created
        if ($fileHashDictionary[$hash.Path] -eq $null) {
           # A new File has been created!
        Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
        }

        else { # Notify if a new file has been changed
            if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                #File has been changed
            }
            else {
                # File has been compromised, Immediately Notify the user
                Write-Host "$($hash.Path) Has changed!!" -ForegroundColor Yellow
            }

            foreach ($key in $fileHashDictionary.Keys){
                $baselineFileStillExists = Test-Path -Path $key
                if (-Not $baselineFileStillExists){
                # One of the baseline files was deleted
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed
                }
                }
               }
        }
    }


    #Begin monitoring files with saved Baseline

    Write-Host "Read existing baseline.txt, start monitoring files." -ForegroundColor DarkYellow
}

