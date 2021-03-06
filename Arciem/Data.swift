import Foundation

extension NSData {
    public func toByteArray() -> [UInt8] {
        var a = [UInt8](count: length, repeatedValue: 0)
        getBytes(&a, length: length)
        return a
    }
    
    public func toString() -> String? {
        return stringFromUTF8Bytes(toByteArray())
    }
    
    public convenience init(byteArray: [UInt8]) {
        self.init(bytes: byteArray, length: byteArray.count)
    }
}