import Foundation
import Capacitor
import ExternalAccessory

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(ZebraCapacitor)
public class ZebraCapacitor: CAPPlugin {
    typealias JSObject = [String:Any]
    typealias JSArray = [JSObject]
    
//    override init(){
//        super.init()
//    }
    
    var printerConnection = MfiBtPrinterConnection()
    
    @objc func echo(_ call: CAPPluginCall) {
        //TODO
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
    
    @objc func print(_ call: CAPPluginCall) {
        //TODO
        let cpcl = call.getString("cpcl") ?? ""
        if( printerConnection.isConnected()){
            let data = cpcl.data(using: .utf8)
            var error: NSError?
            printerConnection.write(data, error:&error)
            if let actualError = error{
                call.error("An Error Occurred: \(actualError)")
            }
        }
        call.success()
    }
    
    @objc func isConnected(_ call: CAPPluginCall){
        //TODO
        call.success([
            "connected": true
        ])
    }
    
    @objc func printerStatus(_ call:CAPPluginCall){
        //TODO
        //let address = call.getString("MACAddress") ?? ""
        //Return status
        call.success([
            "connected": true,
            "isReadyToPrint": false,
            "isPaused": false,
            "isReceiveBufferFull": false,
            "isRibbonOut": false,
            "isPaperOut": false,
            "isHeadTooHot": false,
            "isHeadOpen": false,
            "isHeadCold": false,
            "isPartialFormatInProgress": false,
        ])
    }
    
    @objc func connect(_  call:CAPPluginCall){
        //TODO
        let address = call.getString("MACAddress") ?? ""
        
        printerConnection = MfiBtPrinterConnection(serialNumber: address)
        if(printerConnection.open()){
            let printer = try? ZebraPrinterFactory.getInstance(printerConnection)
            
            if(printer == nil)
            {
                call.error("Error connecting to printer")
            }
        }else{
            call.error("Could not connect to printer")
        }
        
        call.success([
            "success": true
        ])
        
    }
    
    @objc func disconnect(_ call:CAPPluginCall){
        //TODO
        call.success()
    }
    
    @objc func discover(_ call:CAPPluginCall){
        //TODO return printers
        let manager = EAAccessoryManager.init()
        let accessories = manager.connectedAccessories
        
        var devices = JSArray()
        accessories.forEach { (accessory) in
            let name = accessory.name
//            let ser = accessory.serialNumber
            var device = JSObject()
            device["name"] = name
            device["address"] = accessory.serialNumber
            devices.append(device)
        }
        
        call.success(["printers": devices])
    }
    
}
