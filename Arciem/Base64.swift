import Foundation

public func toBase64(bytes: [Byte]) -> String {
    return NSData(byteArray: bytes).base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
}

public func fromBase64(string: String) -> [Byte]? {
    return NSData(base64EncodedString: string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)?.toByteArray()
}

public func toBase64url(bytes: [Byte]) -> String {
    let s = toBase64(bytes)
    var s2 = ""
    for c in s {
        switch c {
        case Character("+"):
            s2.append(Character("_"))
        case Character("/"):
            s2.append(Character("-"))
        case Character("="):
            break
        default:
            s2.append(c)
        }
    }
    return s2
}

public func toBase64url(data: NSData) -> String {
    return toBase64url(data.toByteArray())
}