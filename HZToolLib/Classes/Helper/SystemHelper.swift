//
//  SystemHelper.swift
//  GifEditor
//
//  Created by quanhai on 2022/3/17.
//

import Foundation

@objcMembers class SystemInfo: NSObject {

	/// 获取ip地址
	///
	/// - Returns: ip address
	class func KipAddress() -> String {
		var addresses = [String]()
		var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
		if getifaddrs(&ifaddr) == 0 {
			var ptr = ifaddr
			while (ptr != nil) {
				let flags = Int32(ptr!.pointee.ifa_flags)
				var addr = ptr!.pointee.ifa_addr.pointee
				if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
					if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
						var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
						if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
							if let address = String(validatingUTF8:hostname) {
								addresses.append(address)
							}
						}
					}
				}
				ptr = ptr!.pointee.ifa_next
			}
			freeifaddrs(ifaddr)
		}
		return addresses.first ?? "0.0.0.0"
	}
    
    class func isOldDevice() -> Bool{
        if let device = iosDeviceVersion(){
            switch device{
            case "iPhone XR",
                "iPhone X",
                "iPhone 8 Plus",
                "iPhone 7 Plus",
                "iPhone 7",
                "iPhone SE 1",
                "iPhone 6s Plus",
                "iPhone 6s",
                "iPhone 6 Plus",
                "iPhone 6":
                return true
            default:
                break
            }
        }
        return false
    }
	
	/// 获取iOS 全部的设备硬件信息
	/// reference： https://www.theiphonewiki.com/wiki/Models
	class func iosDeviceVersion() -> String? {
		var systemInfo = utsname()
		uname(&systemInfo)
		let machineMirror = Mirror(reflecting: systemInfo.machine)
		let identifier = machineMirror.children.reduce("") { identifier, element in
			guard let value = element.value as? Int8, value != 0 else { return identifier }
			return identifier + String(UnicodeScalar(UInt8(value)))
		}
		
		switch identifier {
		case "iPod1,1":                                 return "iPod Touch 1"
		case "iPod2,1":                                 return "iPod Touch 2"
		case "iPod3,1":                                 return "iPod Touch 3"
		case "iPod4,1":                                 return "iPod Touch 4"
		case "iPod5,1":                                 return "iPod Touch 5"
		case "iPod7,1":                                 return "iPod Touch 6"
		case "iPod9,1":                                 return "iPod Touch 7"
			
		case "iPhone1,1":     							return "iPhone"
		case "iPhone1,2":     							return "iPhone 3G"
		case "iPhone2,1":     							return "iPhone 3GS"
		case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
		case "iPhone4,1":                               return "iPhone 4s"
		case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
		case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
		case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
		case "iPhone7,2":                               return "iPhone 6"
		case "iPhone7,1":                               return "iPhone 6 Plus"
		case "iPhone8,1":                               return "iPhone 6s"
		case "iPhone8,2":                               return "iPhone 6s Plus"
		case "iPhone8,4":     							return "iPhone SE 1"
		case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
		case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
		case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
		case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
		case "iPhone10,3", "iPhone10,6":                return "iPhone X"
		// updated 2019.11.6 @quanhai
		case "iPhone11,8":                              return "iPhone XR"
		case "iPhone11,2":                              return "iPhone XS"
		case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
		case "iPhone12,1":                              return "iPhone 11"
		case "iPhone12,3":                              return "iPhone 11 Pro"
		case "iPhone12,5":                              return "iPhone 11 Pro Max"
		case "iPhone12,8":								return "iPhone SE 2"
		/// updated iphone 12*
		case "iPhone13,1":								return "iPhone 12 mini"
		case "iPhone13,2":								return "iPhone 12"
		case "iPhone13,3":								return "iPhone 12 Pro"
		case "iPhone13,4":								return "iPhone 12 Pro Max"
		/// updated iphone 13*
		case "iPhone14,4":								return "iPhone 13 mini"
		case "iPhone14,5":								return "iPhone 13"
		case "iPhone14,2":								return "iPhone 13 Pro"
		case "iPhone14,3":								return "iPhone 13 Pro Max"
		case "iPhone14,6":								return "iPhone SE 3"
		
		case "iPad1,1":                              	return "iPad"
		case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
		case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
		case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
		case "iPad6,11", "iPad6,12":           			return "iPad 5"
		case "iPad7,5", "iPad7,6":           			return "iPad 6"
		case "iPad7,11", "iPad7,12":           			return "iPad 7"
		case "iPa11,6", "iPad11,7":           			return "iPad 8"
		case "iPad12,1", "iPad12,2":           			return "iPad 9"
		
		
		case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
		case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
		case "iPad11,3", "iPad11,4":           			return "iPad Air 3"
		case "iPad13,1", "iPad13,2":           			return "iPad Air 4"
		
		case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
		case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
		case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
		case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
		case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
		case "iPad14,1", "iPad14,2":                    return "iPad Mini 6"
		
		case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9-inch"
		case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7-inch"
		case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9-inch 2"
		case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5-inch"
		case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro 11-inch"
		case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro 12.9-inch 3"
		case "iPad8,9", "iPad8,10":                     return "iPad Pro 11-inch 2"
		case "iPad8,11", "iPad8,12":                    return "iPad Pro 12.9-inch 4"
		case "iPad13,4", "iPad13,5":        return "iPad Pro 11-inch 3"
		case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro 12.9-inch 5"
		// 不知道为什么两个设备编号一样？wiki错误还是Apple其实设备是一样的
		case "iPad13,6", "iPad13,7":								return "iPad Air 5/iPad Pro 11-inch 3"
			
		// watch
		case "Watch1,1", "Watch1,2":					return "Apple Watch 1"
		case "Watch2,6", "Watch2,7":					return "Apple Watch Series 1"
		case "Watch2,3", "Watch2,4":					return "Apple Watch Serries 2"
		case "Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4":								    return "Apple Watch Watch Serries 3"
		case "Watch4,1", "Watch4,2", "Watch4,3", "Watch4,4":								    return "Apple Watch Watch Serries 4"
		case "Watch5,1", "Watch5,2", "Watch5,3", "Watch5,4":								    return "Apple Watch Watch Serries 5"
		case "Watch5,9", "Watch5,10", "Watch5,11", "Watch5,12":								    return "Apple Watch Watch SE"
		case "Watch6,1", "Watch6,2", "Watch6,3", "Watch6,4":								    return "Apple Watch Watch Serries 6"
		case "Watch6,6", "Watch6,7", "Watch6,8", "Watch6,9":								    return "Apple Watch Watch Serries 7"
			
		case "AppleTV1,1":                              return "Apple TV 1"
		case "AppleTV2,1":                              return "Apple TV 2"
		case "AppleTV3,1", "AppleTV3,2":                return "Apple TV 3"
		case "AppleTV5,3":                              return "Apple TV 4"
		case "AppleTV6,2":                              return "Apple TV 4K"
		case "AppleTV11,1":                             return "Apple TV 4K 2"

		case "i386", "x86_64":                          return "Simulator"
		default:                                        return identifier
		}
	}
}
