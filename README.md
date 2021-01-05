# zebraCapacitor
Capacitor plugin for Zebra printers (ios and android)

## Limitations
None of version 0.1.0 has been tested on real hardware yet. iOS has been tested on device, but with no printer. Android has had no testing.

## But
I do intend to develop and support an app that uses this plugin, so this will eventually be completed and working (at least with for the printers I have access to test with).

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

I'll experiment with trying to automate this via the podspec as well.

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