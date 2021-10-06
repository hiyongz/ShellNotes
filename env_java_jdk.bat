@echo off
:: TODO:设置java环境变量
color 02

:: 输入Java JDK路径，回车默认路径为C:\Program Files (x86)\Java\jdk1.8.0_144
echo Please input the Java jdk path
echo Press Enter key to set the default path:
SET /P Java_Dir=(C:\Program Files (x86)\Java\jdk1.8.0_144):

IF NOT DEFINED Java_Dir SET "Java_Dir=C:\Program Files (x86)\Java\jdk1.8.0_144"

echo Java jdk path: %Java_Dir%

::如果有的话，先删除JAVA_HOME
wmic ENVIRONMENT where "name='JAVA_HOME'" delete

::如果有的话，先删除ClASS_PATH
wmic ENVIRONMENT where "name='CLASS_PATH'" delete

::创建JAVA_HOME
wmic ENVIRONMENT create name="JAVA_HOME",username="<system>",VariableValue="%Java_Dir%"

::创建CLASS_PATH
wmic ENVIRONMENT create name="CLASS_PATH",username="<system>",VariableValue=".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar;"

::在环境变量path中，剔除掉变量java_home中的字符，回显剩下的字符串
call set xx=%Path%;%JAVA_HOME%\jre\bin;%JAVA_HOME%\bin

::echo %xx%

::将返回显的字符重新赋值到path中
wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"

pause