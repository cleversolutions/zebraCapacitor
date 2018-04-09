declare global {
  interface PluginRegistry {
    ZebraPrinter?: ZebraPlugin;
  }
}

export interface Printer {
  name: string;
  address: string;
}

export interface DiscoveryResult {
  printers: Array<Printer>;
}

export interface ZebraPlugin {
  print(args: any): Promise<any>;
  isConnected(): Promise<boolean>;
  connect(args: any): Promise<boolean>;
  disconnect(): Promise<boolean>;
  discover(): Promise<DiscoveryResult>;
}

