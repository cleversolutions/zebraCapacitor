import { WebPlugin } from '@capacitor/core';
import { ZebraPlugin, DiscoveryResult } from '.';

export class ZebraPluginWeb extends WebPlugin implements ZebraPlugin {
  constructor() {
    super({
      name: 'ZebraPlugin',
      platforms: ['web']
    });
  }
  print(cpcl: string): Promise<any> {
    console.log("ZebraPluginWeb::print", cpcl);
    return Promise.reject("Feature not Implemented");
  }
  isConnected(): Promise<boolean> {
    console.log("ZebraPluginWeb::isConnected");
    return Promise.reject("Feature not Implemented");
  }
  connect(MACAddress: string): Promise<any> {
    console.log("ZebraPluginWeb::connect", MACAddress);
    return Promise.reject("Feature not Implemented");
  }
  disconnect(): Promise<boolean> {
    console.log("ZebraPluginWeb::disconnect");
    return Promise.reject("Feature not Implemented");
  }
  discover(): Promise<DiscoveryResult> {
    console.log("ZebraPluginWeb::discover");
    return Promise.reject("Feature not Implemented");
  }
}

const MyPlugin  = new ZebraPluginWeb();
export { MyPlugin  };
