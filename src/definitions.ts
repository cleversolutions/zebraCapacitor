declare global {
  interface PluginRegistry {
    ZebraPlugin?: IZebraPlugin;
  }
}

export interface Printer {
  name: string;
  address: string;
}

export interface DiscoveryResult {
  printers: Array<Printer>;
}

export interface IZebraPlugin {
  print(options: { cpcl: string }): Promise<any>;
  isConnected(): Promise<boolean>;
  connect(options: { MACAddress: string }): Promise<boolean>;
  disconnect(): Promise<boolean>;
  discover(): Promise<DiscoveryResult>;
}