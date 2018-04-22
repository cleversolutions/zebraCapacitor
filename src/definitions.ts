declare global {
  interface PluginRegistry {
    ZebraPlugin?: ZebraPlugin;
  }
}

export interface Printer {
  name: string;
  address: string;
}

export interface DiscoveryResult {
  printers: Array<Printer>;
}

export interface PrinterStatus{
  connected:boolean;
  isReadyToPrint?: boolean;
  isPaused?: boolean;
  isReceiveBufferFull?: boolean;
  isRibbonOut?: boolean;
  isPaperOut?: boolean;
  isHeadTooHot?: boolean;
  isHeadOpen?: boolean;
  isHeadCold?: boolean;
  isPartialFormatInProgress?: boolean;
}

export interface ZebraPlugin {
  echo(options: {value:string}):Promise<any>;
  test(): Promise<any>;
  print(options: { cpcl: string }): Promise<any>;
  isConnected(): Promise<boolean>;
  printerStatus(options: { MACAddress: string }): Promise<PrinterStatus>;
  connect(options: { MACAddress: string }): Promise<boolean>;
  disconnect(): Promise<boolean>;
  discover(): Promise<DiscoveryResult>;
}