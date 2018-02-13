Title: Progress on Windows 
Slug: progress-on-windows-  
Date: 2018-02-13 17:20:53  
Category: Blog 
               
Ok, I have figured out how to get date the Makefile in Windows, using powershell and a powershell script.
The script is simple
    
    get-date -UFormat '%Y-%m-%d %H:%M:%S'
    
yes, that is all. From the Makefile, I run it as 
    
    powershell -File .\ScriptDate.ps1
    
the Makefile fragment looks like this
    
    DATE := $(shell powershell -File .\ScriptDate.ps1)
    
very satisfying to finally figure this out.

The problem with extra dashes ('-') still exists, the only improvement I have managed is to remove the dash in front.