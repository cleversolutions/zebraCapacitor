import { WebPlugin } from '@capacitor/core';

export class ZebraPluginWeb extends WebPlugin {
  constructor() {
    super({
      name: 'ZebraPlugin',
      platforms: ['web']
    });
  }
  print(cpcl:string) {
    console.log("ZebraPluginWeb::print", cpcl);
    return Promise.reject("Feature not Implemented");
  }
  isConnected() {
    console.log("ZebraPluginWeb::isConnected");
    return Promise.reject("Feature not Implemented");
  }
  connect(MACAddress: string) {
    console.log("ZebraPluginWeb::connect", MACAddress);
    return Promise.reject("Feature not Implemented");
  }
  disconnect() {
    console.log("ZebraPluginWeb::disconnect");
    return Promise.reject("Feature not Implemented");
  }
  discover() {
    console.log("ZebraPluginWeb::discover");
    return Promise.reject("Feature not Implemented");
  }
}

const MyPlugin = new ZebraPluginWeb();

export { MyPlugin };
