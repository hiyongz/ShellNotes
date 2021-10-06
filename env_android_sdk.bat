
@echo off
color 02
:: TODO:配置android sdk环境变量
echo Please input the android sdk path
echo Press Enter key to set the default path:
SET /P Android_Dir=(D:\android-sdk-windows):

IF NOT DEFINED Android_Dir SET "Android_Dir=D:\android-sdk-windows"

echo android sdk path: %Android_Dir%

::如果有的话，先删除ANDROID_SDK_HOME
wmic ENVIRONMENT where "name='ANDROID_SDK_HOME'" delete

::创建ANDROID_SDK_HOME
::wmic ENVIRONMENT create name="ANDROID_SDK_HOME",username="<system>",VariableValue="%Android_Dir%"

setx ANDROID_SDK_HOME %Android_Dir%
::setx PATH "%PATH%;%ANDROID_SDK_HOME%\bin";


call set xx=%Path%;%ANDROID_SDK_HOME%\platform-tools;%ANDROID_SDK_HOME%\build-tools;%ANDROID_SDK_HOME%\tools

::将返回显的字符重新赋值到path中
wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"

pause