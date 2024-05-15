import Foundation

@objcMembers
public class GMSDevice: NSObject, GMSClientAppDelegate, GMSDeviceInterface {
    public var gmsWrapper: GMSWrapper?
    public var deviceDelegate: GMSDeviceDelegate?
    public var transactionDelegate: GMSTransactionDelegate?
    public var peripherals = NSMutableArray()
    
    public var connectedDeviceInfo: HpsTerminalInfo? {
        if let wrapper = self.gmsWrapper {
            return wrapper.getDeviceInfo()
        }
        
        return nil
    }
    
    private var entryModes: [EntryMode] = []
    private var terminalType: TerminalType?
    
    internal init(config: HpsConnectionConfig, entryModes: [EntryMode], terminalType: TerminalType) {
        super.init()
        self.terminalType = terminalType
        self.entryModes = entryModes
        self.gmsWrapper = .init(
            .fromHpsConnectionConfig(config),
            delegate: self,
            entryModes: entryModes,
            terminalType: terminalType
        )
    }
    
    public func updateConfig(_ config: HpsConnectionConfig) {
        if let terminalType = terminalType {
            self.gmsWrapper = .init(.fromHpsConnectionConfig(config), delegate: self, entryModes: entryModes, terminalType: terminalType)
        }
    }
    
    public func initialize() {
        self.scan()
    }
    
    public func scan() {
        if let wrapper = self.gmsWrapper {
            wrapper.searchDevices()
        }
    }

    public func stopScan() {
        if let wrapper = self.gmsWrapper {
            wrapper.cancelSearch()
        }
    }
    public func getDeviceInfo() {}
    
    public func connectDevice(_ device: HpsTerminalInfo) {
        if let wrapper = self.gmsWrapper {
            wrapper.connectDevice(device)
        }
    }
    
    public func disconnectDevice() {
        if let wrapper = self.gmsWrapper {
            wrapper.disconnect()
        }
    }
    
    public func processTransactionWithRequest(_ builder: GMSBaseBuilder, withTransactionType transactionType: HpsTransactionType) {
        if let wrapper = self.gmsWrapper {
            wrapper.startTransaction(builder, withTransactionType: transactionType)
        }
    }
    public func confirmAmount(_ amount: Decimal) {
        if let wrapper = self.gmsWrapper {
            wrapper.confirmAmount(amount: amount)
        }
    }
    public func confirmApplication(_ application: AID) {
        if let wrapper = self.gmsWrapper {
            wrapper.selectAID(aid: application)
        }
    }

    // mark: GMSClientAppDelegate

    public func deviceConnected(_ terminal: HpsTerminalInfo) {
        self.deviceDelegate?.onConnected(terminal) //:(HpsTerminalInfo *)terminalInfo];
    }

    public func deviceDisconnected() {
        self.deviceDelegate?.onDisconnected()
    }

    public func searchComplete() {
        self.deviceDelegate?.onBluetoothDeviceList(self.peripherals)
    }

    public func deviceFound(_ device: NSObject) {
        peripherals.add(device)
    }

    public func onStatus(_ status: HpsTransactionStatus) {
        self.transactionDelegate?.onStatusUpdate(status)
    }


    public func onTransactionCancelled() {
        self.transactionDelegate?.onTransactionCancelled()
    }


    public func onTransactionComplete(_ result: String, response: HpsTerminalResponse) {
        self.transactionDelegate?.onTransactionComplete(response)
    }


    public func requestAIDSelection(_ applications: Array<AID>) {
        self.transactionDelegate?.onConfirmApplication(applications)
    }


    public func requestAmountConfirmation(_ amount: Decimal) {
        self.transactionDelegate?.onConfirmAmount(amount)
    }


    public func requestPostalCode(_ maskedPan: String, expiryDate: String, cardholderName: String) {
    }


    public func requestSaFApproval() {
    }

    public func onError(_ error: NSError) {
        self.transactionDelegate?.onError(error)
    }
}