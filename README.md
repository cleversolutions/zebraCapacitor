# zebraCapacitor
Capacitor plugin for Zebra printers (ios and android)

## Limitations
Currently the iOS implementation is empty... but it will be implemented soon.
Also, the Android implementation is not well tested and likely missing important things.
Also, the web implementation which is just a stub is broken.
Also, this is built using alpha.35 version of Capacitor

## But
I do intend to develop and support an app that uses this plugin, so this will eventually be completed and working (at least with for the printers I have access to test with).

##Wow
THis is super hacky at the moment. Android is working okay. iOS is a hack. After installing this, you have to drag the libZSDK_API.a library into the ZebraCapacitor target of the Pods Project. Then update your build settings Library Search Paths with: "${PODS_ROOT}/../../../node_modules/zebra-capacitor/ios/Plugin/Plugin"

I suspect if I mess with the podspec a bit I should be able to set this automatically.