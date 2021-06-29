//
//  ViewController.swift
//  macOS Virtual Machine
//
//  Created by Khaos Tian on 6/8/21.
//  Modified by Ming Chang on 6/29/21.
//

import Cocoa
import Virtualization

class ViewController: NSViewController, VZVirtualMachineDelegate {
    
    private var virtualMachine: VZVirtualMachine?
    private var installer: VZMacOSInstaller?

    override func loadView() {
        let view = VZVirtualMachineView()
        view.capturesSystemKeys = true
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapStartVM(_ sender: Any) {
        startVM()
    }
    
    private func startVM() {
        let restoreImageURL = URL(fileURLWithPath: "/Users/mingchang/Documents/UniversalMac_12.0_21A5268h_Restore.ipsw")
        VZMacOSRestoreImage.load(from: restoreImageURL) { result in
            switch result {
            case .success(let image):
                NSLog("Image: \(image)")
                DispatchQueue.main.async {
                    self.setupVM(with: image)
                }
            case .failure(let error):
                NSLog("Error: \(error)")
            }
        }
    }
    
    private func setupVM(with image: VZMacOSRestoreImage) {
        guard let supportedConfig = image.mostFeaturefulSupportedConfiguration else {
            NSLog("No supported config")
            return
        }
        
        
        let bootloader = VZMacOSBootLoader()
        let entropy = VZVirtioEntropyDeviceConfiguration()
        let networkDevice = VZVirtioNetworkDeviceConfiguration()
        networkDevice.attachment = VZNATNetworkDeviceAttachment()
        
        let graphics = VZMacGraphicsDeviceConfiguration()
        graphics.displays = [
            VZMacGraphicsDisplayConfiguration(
                widthInPixels: 2560,
                heightInPixels: 1600,
                pixelsPerInch: 220
            )
        ]
        
        let keyboard = VZUSBKeyboardConfiguration()
        let pointingDevice = VZUSBScreenCoordinatePointingDeviceConfiguration()
        
        var storages: [VZStorageDeviceConfiguration] = []
        do {
            let attachment = try VZDiskImageStorageDeviceAttachment(
                url: URL(fileURLWithPath: "/Users/mingchang/Documents/disk.dmg"),
                readOnly: false
            )
            
            let storage = VZVirtioBlockDeviceConfiguration(attachment: attachment)
            storages.append(storage)
        } catch {
            NSLog("Storage Error: \(error)")
        }
        
        
        let configuration = VZVirtualMachineConfiguration()
        configuration.bootLoader = bootloader
        
        let platform = VZMacPlatformConfiguration()
        platform.hardwareModel = supportedConfig.hardwareModel
        
        if let machineID = UserDefaults.standard.object(forKey: "machine_id") as? Data {
            if let identifier = VZMacMachineIdentifier(dataRepresentation: machineID) {
                platform.machineIdentifier = identifier
            } else {
                NSLog("Failed to recreate machine id")
            }
        } else {
            UserDefaults.standard.set(
                platform.machineIdentifier.dataRepresentation,
                forKey: "machine_id"
            )
        }
        
        if FileManager.default.fileExists(atPath: "/Users/mingchang/Documents/aux.img") {
            platform.auxiliaryStorage = VZMacAuxiliaryStorage(
                contentsOf: URL(fileURLWithPath: "/Users/mingchang/Documents/aux.img")
            )
        } else {
            platform.auxiliaryStorage = try? VZMacAuxiliaryStorage(
                creatingStorageAt: URL(fileURLWithPath: "/Users/mingchang/Documents/aux.img"),
                hardwareModel: platform.hardwareModel,
                options: []
            )
        }
        configuration.platform = platform
        
        configuration.cpuCount = 4
        configuration.memorySize = 8 * 1024 * 1024 * 1024
        configuration.entropyDevices = [entropy]
        configuration.networkDevices = [networkDevice]
        configuration.graphicsDevices = [graphics]
        configuration.keyboards = [keyboard]
        configuration.pointingDevices = [pointingDevice]
        configuration.storageDevices = storages
        
        do {
            try configuration.validate()
            
            let vm = VZVirtualMachine(configuration: configuration, queue: .main)
            vm.delegate = self
            
            if let view = view as? VZVirtualMachineView {
                view.virtualMachine = vm
            }
            
            vm.start { result in
                switch result {
                case .success:
                    NSLog("Success")
                case .failure(let error):
                    NSLog("Error: \(error)")
                }
            }
            
//            let installer = VZMacOSInstaller(virtualMachine: vm, restoreImage: image)
//            installer.install { result in
//                switch result {
//                case .success:
//                    NSLog("Success")
//                case .failure(let error):
//                    NSLog("Error: \(error)")
//                }
//            }
            
            self.virtualMachine = vm
//            self.installer = installer
        } catch {
            NSLog("Error: \(error)")
        }
    }
    
    func guestDidStop(_ virtualMachine: VZVirtualMachine) {
        NSLog("DidStop")
    }
    
    func virtualMachine(_ virtualMachine: VZVirtualMachine, didStopWithError error: Error) {
        NSLog("Stop with Error: \(error)")
    }
}

