import Foundation

extension NSData {
    public func toByteArray() -> [Byte] {
        var a = [Byte](count: length, repeatedValue: 0)
        getBytes(&a)
        return a
    }
    
    public convenience init(byteArray: [Byte]) {
        self.init(bytes: byteArray, length: byteArray.count)
    }
}