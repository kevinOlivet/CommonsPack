//
//  UIDeviceExtension.swift
//  Commons
//
//  Copyright © Jon Olivet
//

// swiftlint:disable explicit_init identifier_name
import Foundation

public enum Model: String {
    case simulator     = "simulator/sandbox",
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPad5              = "iPad 5",
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPadMini1          = "iPad Mini 1",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadAir1           = "iPad Air 1",
    iPadAir2           = "iPad Air 2",
    iPadPro9_7         = "iPad Pro 9.7",
    iPadPro9_7_cell    = "iPad Pro 9.7 cellular",
    iPadPro12_9        = "iPad Pro 12.9",
    iPadPro12_9_cell   = "iPad Pro 12.9 cellular",
    iPadPro2_12_9      = "iPad Pro 2 12.9",
    iPadPro2_12_9_cell = "iPad Pro 2 12.9 cellular",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXR           = "iPhone XR",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhone11           = "iPhone 11",
    iPhone11Pro        = "iPhone 11 Pro",
    iPhone11ProMax     = "iPhone 11 Pro Max",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

/// UIDevice extensions
public extension UIDevice {
    ///public static var type
    static var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in String.init(validatingUTF8: ptr) }
        }
        let modelMap: [ String: Model ] = [
            "i386": .simulator,
            "x86_64": .simulator,
            "iPod1,1": .iPod1,
            "iPod2,1": .iPod2,
            "iPod3,1": .iPod3,
            "iPod4,1": .iPod4,
            "iPod5,1": .iPod5,
            "iPad2,1": .iPad2,
            "iPad2,2": .iPad2,
            "iPad2,3": .iPad2,
            "iPad2,4": .iPad2,
            "iPad2,5": .iPadMini1,
            "iPad2,6": .iPadMini1,
            "iPad2,7": .iPadMini1,
            "iPhone3,1": .iPhone4,
            "iPhone3,2": .iPhone4,
            "iPhone3,3": .iPhone4,
            "iPhone4,1": .iPhone4S,
            "iPhone5,1": .iPhone5,
            "iPhone5,2": .iPhone5,
            "iPhone5,3": .iPhone5C,
            "iPhone5,4": .iPhone5C,
            "iPad3,1": .iPad3,
            "iPad3,2": .iPad3,
            "iPad3,3": .iPad3,
            "iPad3,4": .iPad4,
            "iPad3,5": .iPad4,
            "iPad3,6": .iPad4,
            "iPhone6,1": .iPhone5S,
            "iPhone6,2": .iPhone5S,
            "iPad4,2": .iPadAir1,
            "iPad5,4": .iPadAir2,
            "iPad4,4": .iPadMini2,
            "iPad4,5": .iPadMini2,
            "iPad4,6": .iPadMini2,
            "iPad4,7": .iPadMini3,
            "iPad4,8": .iPadMini3,
            "iPad4,9": .iPadMini3,
            "iPad6,3": .iPadPro9_7,
            "iPad6,4": .iPadPro9_7_cell,
            "iPad6,12": .iPad5,
            "iPad6,7": .iPadPro12_9,
            "iPad6,8": .iPadPro12_9_cell,
            "iPad7,1": .iPadPro2_12_9,
            "iPad7,2": .iPadPro2_12_9_cell,
            "iPhone7,1": .iPhone6plus,
            "iPhone7,2": .iPhone6,
            "iPhone8,1": .iPhone6S,
            "iPhone8,2": .iPhone6Splus,
            "iPhone8,4": .iPhoneSE,
            "iPhone9,1": .iPhone7,
            "iPhone9,2": .iPhone7plus,
            "iPhone9,3": .iPhone7,
            "iPhone9,4": .iPhone7plus,
            "iPhone10,1": .iPhone8,
            "iPhone10,2": .iPhone8plus,
            "iPhone10,3": .iPhoneX,
            "iPhone10,4": .iPhone8,
            "iPhone10,5": .iPhone8plus,
            "iPhone10,6": .iPhoneX,
            "iPhone11,2": .iPhoneXS,
            "iPhone11,4": .iPhoneXSMax,
            "iPhone11,6": .iPhoneXSMax,
            "iPhone11,8": .iPhoneXR,
            "iPhone12,1": .iPhone11,
            "iPhone12,3": .iPhone11Pro,
            "iPhone12,5": .iPhone11ProMax
        ]

        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }

    ///public static func isIphoneX
    @available(*, unavailable, message: "isIphoneX is deprecated please use isIphoneXSeries.")
    static func isIphoneX() -> Bool {
        UIDevice.isIphoneXSeries()
    }

    ///public static func isIphoneXSeries
    static func isIphoneXSeries() -> Bool {
        (UIDevice.type == Model.iPhoneXR ||
            UIDevice.type == Model.iPhoneXS ||
            UIDevice.type == Model.iPhoneXSMax ||
            UIDevice.type == Model.iPhoneX ||
            UIDevice.type == Model.iPhone11 ||
            UIDevice.type == Model.iPhone11Pro ||
            UIDevice.type == Model.iPhone11ProMax)
    }

    ///public static func isIphoneSmalls
    static func isIphoneSmalls() -> Bool {
        if UIDevice.type == Model.iPhoneSE ||
            UIDevice.type == Model.iPhone5  ||
            UIDevice.type == Model.iPhone5C ||
            UIDevice.type == Model.iPhone5S ||
            UIDevice.type == Model.iPhone4 ||
            UIDevice.type == Model.iPhone4S {
            return true
        } else {
            return false
        }
    }

    ///public static func isIphonePlus
    static func isIphonePlus() -> Bool {
        (UIDevice.type == Model.iPhone6plus ||
            UIDevice.type == Model.iPhone6Splus ||
            UIDevice.type == Model.iPhone7plus ||
            UIDevice.type == Model.iPhone8plus)
    }
}
// swiftlint:enable explicit_init identifier_name
