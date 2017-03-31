
Function getFiles()
	dim arrQueryFiles()
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	objStartFolder = "C:\OracleAQInDev\"
	Set objFolder = objFSO.GetFolder(objStartFolder)
	Set colFiles = objFolder.Files
	For Each objFile in colFiles
		if(objFSO.getExtensionName(objFile.Name)="txt" and ( InStr(objFile.Name,"ReadyQuery") > 0 or InStr(objFile.Name,"ExpiredQuery") > 0)) then 
			redim preserve arrQueryFiles(FileCntr)
			'msgbox objFile.Name
			arrQueryFiles(FileCntr)=objFile.Name
			FileCntr=FileCntr+1	
		end if
	Next
	getFiles=arrQueryFiles
	Set objFSO = Nothing
end Function

Function readData(strFile)
'msgbox  "in read file" &strFile
dim arrSettings()
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(strFile, ForReading)
Const ForReading = 1
Do Until objFile.AtEndOfStream
    redim preserve arrSettings(lineCntr)
    line=objFile.ReadLine
    arrSettings(lineCntr)= line
    lineCntr = lineCntr + 1
Loop
objFile.Close
readData = arrSettings
'msgbox ubound(arrSettings)
'msgbox ubound(readData)

set objFile = nothing
Set objFSO = nothing
end function

Function writeDataFromArray(FileArr,filenametowrite)
'msgbox "writeDataFromArray"&filenametowrite
	fileNamewr = split(filenametowrite,"_")
	if (InStr(filenametowrite,"ReadyQuery") > 0 ) then
		fileNameWrRes= fileNamewr(0)&"_"&"ReadyStatus.txt"
	else
		fileNameWrRes= fileNamewr(0)&"_"&"ExpiryStatus.txt"
	end if
	'msgbox "Cresting output file " &fileNameWrRes
	set objFSO = CreateObject("Scripting.FileSystemObject")
	set objFile= objFSO.createTextFile("C:\OracleAQInDev\"&fileNameWrRes,true)     
	For each line in FileArr
		objFile.writeline(line)
		'msgbox line
	Next
	objFile.close
End Function

Function getResultsInFile(filename)

dim arrValuessettings()	
sqlQueries=readData("C:\OracleAQInDev\"&filename)
''msgbox ubound(sqlQueries)
arrfilname=split(filename,"_")
oCon=arrfilname(0)
'msgbox oCon
Select case oCon
	case "SE21"
		dbqValue="QADB"
	case "SE19"
		dbqValue="SE19"
	case "SE48"
		dbqValue="SE48"			
end Select

'msgbox dbqValue
Set connection = CreateObject("adodb.connection") 
On error resume next
connection.open "Driver={Oracle in OraClient11g_home1};Dbq="&dbqValue&";Uid=TRAF_TITAN_OWNER;Pwd=TRAF_TITAN_OWNER_TTN"
'msgbox connection.State
If connection.State = 1 Then
	Set myRecord = CreateObject("ADODB.recordset")
	j=0
	For i  = 0 To ubound(sqlQueries) Step 1
		sql1 = sqlQueries(i)
		sql= sql1
		myRecord.Open sql, connection
		value  = myRecord.Fields.Item(0)
		
		if value > 0 then
			splitArr = split(sql," ")
			txt = splitArr(3) & ":"&value		
			redim preserve arrValuessettings(j)
			arrValuessettings(j)=txt
			j=j+1			
		end if	
		myRecord.Close
	next
	'msgbox "In data" &ubound(arrValuessettings)
		if ubound(arrValuessettings) > 0 then
			Call writeDataFromArray(arrValuessettings,filename)
		else
			'msgbox "In else"
			arrValuessettings(0)= "No values to display : 0"
			Call writeDataFromArray(arrValuessettings,filename)
		end if
	    Set connection = Nothing
		Set connection = Nothing
		Set recordset = Nothing
else
	'msgbox "Issue with Db Connection" &Err.Description
		
End if
End function

Function sendmail(referFileName)
	flagSendmail=false
	''msgbox "sendmail" &referFileName
	referFileNamearr = split(referFileName,"_")
	if (InStr(referFileName,"ReadyQuery") > 0 ) then
		sendMailFile= referFileNamearr(0)&"_"&"ReadyStatus.txt"
		subject="Ready"
	else
		sendMailFile= referFileNamearr(0)&"_"&"ExpiryStatus.txt"
		subject="Expired"
	end if
	'msgbox sendMailFile
	readyIssues=readData("C:\OracleAQInDev\"&sendMailFile)
	'on error resume next
	'msgbox ubound(readyIssues)
	if  IsInitialized(readyIssues) then
		For i  = 0 To ubound(readyIssues) Step 1
			readyAqArrayval=readyIssues(i)
			readyAqArray= split(readyIssues(i),":")
			AQvalue=readyAqArray(1)
			'''msgbox AQvalue
			if subject = "Ready" then
				if(AQvalue > 100) then
					MessageBody = MessageBody &readyIssues(i)& vbCrLf 
					flagSendmail = true
				end if 
			end if	
			if subject = "Expired" then
				if(AQvalue > 50) then
					MessageBody = MessageBody &readyIssues(i)& vbCrLf 
					flagSendmail = true
				end if 
			end if	
			
		Next
		if flagSendmail = true then
			ToAddress = "milind.divre@trafigura.com"
			MessageSubject = referFileNamearr(0)&"-"& subject & "-Oracle AQ Status"
			Set ol = CreateObject("Outlook.Application")
			Set newMail = ol.CreateItem(olMailItem)
			newMail.CC= "Prakash.Gupta@trafigura.com"
			newMail.Subject = MessageSubject
			newMail.Body = MessageBody & vbCrLf 
			newMail.RecipIents.Add(ToAddress)
			newMail.Send
		end if	
	end if	
	Set objFolder    = Nothing
	Set objNamespace = Nothing
	Set objOutlook   = Nothing
	''msgbox "mail sent"
end Function

Function executeBatch()
	filesToExe=getFiles()
	For k  = 0 To ubound(filesToExe) Step 1
		''msgbox "For File" & filesToExe(k)
		Call getResultsInFile(filesToExe(k))
		call sendmail(filesToExe(k))
	next
end function

 'Call getResultsInFile()
 call executeBatch()
''msgbox  "DOne"

Function IsInitialized(a)
	Err.Clear
	on Error resume  next
	Ubound(a)
	if (Err.number = 0) then
		IsInitialized = true
	else
		IsInitialized = false
	end if
end Function