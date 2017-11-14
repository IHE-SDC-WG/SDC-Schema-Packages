REM The output filename (Class file) is the same as the Schema name; do not use extension xml/xsd
set XmlFilename=sr-template2015_SDCcompat_5
set WorkingFolder="C:\Users\rmoldwi\Desktop\ONC-SDC\SDC Schemas Phase 2\

set XmlExtension=.xml
set XsdExtension=.xsd

REM set XSD.EXE="C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6.1 Tools\xsd.exe"
set XSD.EXE="C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\x64\xsd.exe"

set XmlFilePath=%WorkingFolder%%XmlFilename%%XmlExtension%"
set XsdFilePath=%WorkingFolder%%XmlFilename%%XsdExtension%"

%XSD.EXE% %XmlFilePath% /out:%WorkingFolder%
REM For C#
REM %XSD.EXE% %XsdFilePath% /c /out:%WorkingFolder%
REM For VB
%XSD.EXE% %XsdFilePath% /c /l:vb /out:%WorkingFolder%
Pause