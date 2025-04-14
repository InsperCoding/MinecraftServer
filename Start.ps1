$Host.UI.RawUI.WindowTitle = "Servidor de Testes"

$Dir = get-childitem .
$serverJar = $Dir | Where-Object {$_.extension -eq ".jar"}
$serverVersion = $serverJar -replace "\D+"

# Java 21 é necessário a partir do Minecraft 1.20.2+
$java21 = [int]$serverVersion -ge 1202

# Java 17 é usado de 1.16 até 1.20.1
$java17 = [int]$serverVersion -ge 1160

# Define se deve usar --nogui
$nogui = $java17 -or $java21

if ($java21)
{
	$env:JAVA_HOME = 'C:\Program Files\Java\jdk-21'
}
elseif ($java17)
{
	$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
}
else
{
	$env:JAVA_HOME = 'C:\Program Files\Java\jdk-11'
}
$env:PATH = $env:JAVA_HOME + "\bin;" + $env:PATH

#Seta modo UTF-8
chcp 65001
Clear-Host

#Inicia o servidor
& java `
'-Dfile.encoding=UTF-8' `
'-XX:+UseG1GC' `
'-XX:MaxGCPauseMillis=50' `
-jar $serverJar -W 'worlds' + ($nogui ? '--nogui' : '')