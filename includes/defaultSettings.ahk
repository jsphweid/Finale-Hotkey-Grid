FileDelete, settings.ini
ConfigData=
(
[margins]
Top=0.3
Left=0.5
Right=0.5
Bottom=0.5

[scalings]
pagePercent=100
systemPercent=100
staffHeight=96e

[pagesizes]
ppageWidth=9
ppageHeight=12
spageWidth=11
spageHeight=17

[additionaloffset]
partp1offset=2.45
partp2onoffset=0.9
scorep1offset=1.4
scorep2onoffset=1.2

[pace]
keyDelay=10
)
FileAppend, %ConfigData%, settings.ini
return