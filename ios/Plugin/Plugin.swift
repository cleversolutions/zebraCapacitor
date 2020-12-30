import Foundation
import Capacitor

/**
 * Capacitor Plugin for Zebra Thermal Printers
 */
@objc(ZebraCapacitorPlugin)
public class ZebraCapacitorPlugin: CAPPlugin {

    var printerConnection: ZebraPrinterConnection?
    var printer: ZebraPrinter?

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        NSLog(value)
        call.resolve([
            "value": value
        ])
    }
    
    /**
     * Discover connectable zebra printers
     *
     */
    @objc func discover(_ call:CAPPluginCall){
        let manager = EAAccessoryManager.shared()
        let accessories = manager.connectedAccessories
        
        var devices = [Any]()
        
        for accessory in accessories{
            if accessory.protocolStrings.contains("com.zebra.rawport"){
                let name = accessory.name
                var device = [String: Any]()
                device["name"] = name
                device["address"] = accessory.serialNumber
                device["manufacturer"] = accessory.manufacturer
                device["modelNumber"] = accessory.modelNumber
                device["connected"] = accessory.isConnected
                devices.append(device)
            }
        }
    
//        accessories.forEach { (accessory) in
//            let name = accessory.name
//            var device = [String: Any]()
//            device["name"] = name
//            device["address"] = accessory.serialNumber
//            device["manufacturer"] = accessory.manufacturer
//            device["modelNumber"] = accessory.modelNumber
//            device["connected"] = accessory.isConnected
//            devices.append(device)
//        }
//
        call.resolve(["printers": devices])
    }

    /**
     * Get the status of the printer we are currently connected to
     *
     */
    @objc func printerStatus(_ call:CAPPluginCall){
        var status = [String: Any]()
        status["connected"] = false
        status["isReadyToPrint"] = false
        status["isPaused"] = false
        status["isReceiveBufferFull"] = false
        status["isRibbonOut"] = false
        status["isPaperOut"] = false
        status["isHeadTooHot"] = false
        status["isHeadOpen"] = false
        status["isHeadCold"] = false
        status["isPartialFormatInProgress"] = false
        
        if(self.printerConnection != nil && self.printerConnection!.isConnected() && self.printer != nil){
            let zebraPrinterStatus = try? self.printer?.getCurrentStatus()
            if(zebraPrinterStatus != nil){
                NSLog("Got Printer Status")
                if(zebraPrinterStatus!.isReadyToPrint) { NSLog("Read To Print"); }
                else {
                    let message = PrinterStatusMessages.init(printerStatus: zebraPrinterStatus)
                    if(message != nil)
                    {
                        NSLog("Printer Not Ready. " + (message!.getStatusMessage() as! [String]).joined(separator: ", "))
                    }else{
                        NSLog("Printer Not Ready.")
                    }
                }
                
                status["connected"] = true
                status["isReadyToPrint"] = zebraPrinterStatus?.isReadyToPrint
                status["isPaused"] = zebraPrinterStatus?.isPaused
                status["isReceiveBufferFull"] = zebraPrinterStatus?.isReceiveBufferFull
                status["isRibbonOut"] = zebraPrinterStatus?.isRibbonOut
                status["isPaperOut"] = zebraPrinterStatus?.isPaperOut
                status["isHeadTooHot"] = zebraPrinterStatus?.isHeadTooHot
                status["isHeadOpen"] = zebraPrinterStatus?.isHeadOpen
                status["isHeadCold"] = zebraPrinterStatus?.isHeadCold
                status["isPartialFormatInProgress"] = zebraPrinterStatus?.isPartialFormatInProgress
                
                NSLog("ZebraPrinter:: returning status")
                call.resolve(status)

                return
            }else{
                // printer has no status... this happens when the printer turns off, but the driver still thinks it is connected
                NSLog("ZebraPrinter:: Got a printer but no status. Sadness.")
                call.reject("Printer Has No Status")
                return
            }
        }else{
            NSLog("ZebraPrinter:: status of disconnected printer")
            call.resolve(status)
            return
        }
    }
    
    /**
     * Print the cpcl
     *
     */
    @objc func print(_ call:CAPPluginCall) {
        let cpcl = call.getString("cpcl") ?? ""
        if( self.isConnected()){
            let data = cpcl.data(using: .utf8)
            var error: NSError?
            // it seems self.isConnected() can lie if the printer has power cycled
            // a workaround is to close and reopen the connection
            self.printerConnection!.close()
            self.printerConnection!.open()
            self.printerConnection!.write(data, error:&error)
            if error != nil{
                NSLog("ZebraPrinter:: error printing -> " + (error?.localizedDescription ?? "Unknonwn Error"))
                call.reject("ZebraPrinter:: error printing -> " + (error?.localizedDescription ?? "Unknonwn Error"))
            }else{
                NSLog("ZebraPrinter:: print completed")
                call.resolve();
            }
        }else{
            NSLog("ZebraPrinter:: not connected")
            call.reject("Printer Not Connected")
        }
    }
    
    /**
     * Check if we are connectd to the printer or not
     *
     */
    @objc func isConnected(_ call:CAPPluginCall){
        let connected = self.isConnected();
        NSLog("ZebraPrinter::isConnected {0}", connected)
        call.resolve([
            "connected": connected
            ])
    }

    /**
     * Check if we are connectd to the printer or not
     *
     */
    private func isConnected() -> Bool{
        //printerConnection!.isConnected lies, it says it's open when it isn't
        return self.printerConnection != nil && (self.printerConnection?.isConnected() ?? false)
    }

    /**
     * Connect to a printer by serialNumber
     *
     */
    @objc func connect(_  call:CAPPluginCall){
        
        let address = call.getString("MACAddress") ?? ""
        if(address == ""){
            NSLog("ZebraPrinter:: empty printer address")
            call.reject("Invalid Address")
            return
        }
        
        NSLog("ZebraPrinter:: connecting to " + address)
        
        //try to close an existing connection
        if(self.printerConnection != nil){
            self.printerConnection?.close()
        }
        
        //clear out our existing printer & connection
        self.printerConnection = nil;
        self.printer = nil;
        
        //create and open a new connection
        self.printerConnection = MfiBtPrinterConnection(serialNumber: address)
        NSLog("ZebraPrinter:: got connection. opening...")
        self.printerConnection?.open()
        NSLog("ZebraPrinter:: opened connection")
        
        if( self.isConnected()){
            NSLog("ZebraPrinter:: getting printer")
            self.printer = try? ZebraPrinterFactory.getInstance(self.printerConnection as? NSObjectProtocol & ZebraPrinterConnection)
            NSLog("ZebraPrinter:: got printer")
            
            if(self.printer == nil)
            {
                NSLog("ZebraPrinter:: nil printer")
                call.reject("Printer Null")
            }else{
                NSLog("ZebraPrinter:: connected")
                call.resolve([
                    "success": true
                ])
            }
        }else{
            NSLog("ZebraPrinter:: not connected")
            call.reject("Printer Not Connected")
        }
    }

    /**
     * Disconnect fromt the currently connected printer
     *
     */
    @objc func disconnect(_ call:CAPPluginCall){
        //close the connection and set it to nil
        if(self.printerConnection != nil){
            self.printerConnection?.close()
            self.printerConnection = nil
            self.printer = nil
        }
        
        call.resolve([
            "success": true
        ])
    }
    
}
