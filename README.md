# zebraCapacitor
Capacitor (v2.0) plugin for Zebra printers (ios and android)

## Limitations
iOS has been tested on device with a real printer. Android has had no testing yet. I had access to printers at my previous employer; however, I have recently moved on. I can test on real hardware if somone is able to loan me with hardware to test on :) 

This is all a port of a plugin I built for Cordova (which was well tested), so I'm reasonably sure it should all work.

I had plans to port this to Capacitor 3, and still may, but my time is quite limited at the moment.

## iOS
After installing this, you may have to drag the libZSDK_API.a library into the ZebraCapacitor target of the Pods Project. Then update your build settings Library Search Paths with: "${PODS_ROOT}/../../../node_modules/zebra-capacitor/ios/Plugin/Plugin"
I've updated the podspec so this may not be necessary anymore, but I havn't tested it yet.

Also for iOS update your apps Info.plist file with Supported external accessory protocols as an array with the value com.zebra.rawport. 

Add this to your plist
```
<key>UISupportedExternalAccessoryProtocols</key>
<array>
    <string>com.zebra.rawport</string>
</array>
```

I'll experiment with trying to automate this via the podspec as well. If anybody can help with this, please submit a PR :)

## Android
Add the following to your AndroidManifest.xml
```
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
```

and register the plugin in your MainActivity.java for example:
```
import ca.cleversolutions.zebracapacitor.ZebraCapacitorPlugin;
...
public class MainActivity extends BridgeActivity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    // Initializes the Bridge
    this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
      // Additional plugins you've installed go here
      // Ex: add(TotallyAwesomePlugin.class);
      add(ZebraCapacitorPlugin.class);
    }});
  }
}
```