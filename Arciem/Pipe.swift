//
//  Pipe.swift
//  Arciem
//
//  Created by Robert McNally on 4/9/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

private let pipeLog = Logger(tag: "PIPE")

infix operator |> { associativity left precedence 170 }
infix operator |~> { associativity left precedence 170 }
infix operator ||> { associativity left precedence 170 }

public typealias Key = String
public typealias Value = Any
public typealias Pair = (Key, Value)
public typealias State = [Key:Value]
public typealias Transform = (Packet) -> Packet

public struct Packet {
    public let error: ErrorType?
    public let state: State
    
    public init(error: ErrorType? = nil, state: State = [:]) {
        self.error = error
        self.state = state
    }
    
    public var isOK: Bool { return error == nil }
    public var isError: Bool { return error != nil }
    
    public func get(key: Key) -> Any { return state[key] }
    public func put<V>(key: Key, _ value: V) -> Packet {
        var s = state; s[key] = value; return Packet(error: error, state: s)
    }
    public func delete(key: Key) -> Packet {
        var s = state; s.removeValueForKey(key); return Packet(error: error, state: s)
    }
    public func error(error: ErrorType) -> Packet {
        return Packet(error: error, state: state)
    }
}

extension Packet : CustomStringConvertible {
    public var description: String {
        let s: String
        if let error = error {
            s = "\(error)"
        } else {
            s = "ok"
        }
        return "{\"\(s)\", \(state)}"
    }
}

// P |> Transform -> unless stopped P2 else P
public func |>(🅛: Packet, 🅡: Transform) -> Packet {
    if 🅛.isOK { return 🅡(🅛) } else { return 🅛 }
}

// P |~> Transform -> if stopped P2 else P
public func |~>(🅛: Packet, 🅡: Transform) -> Packet {
    if 🅛.isError { return 🅡(🅛) } else { return 🅛 }
}

// P ||> Transform -> P2
public func ||>(🅛: Packet, 🅡: Transform) -> Packet {
    return 🅡(🅛)
}

// Packet |> (Key, Value) => put(Key, Value)(Packet)
public func |><V>(🅛: Packet, 🅡: (Key, V)) -> Packet {
    let (k, v) = 🅡; return 🅛.put(k, v)
}

// Packet |> [(Key, Value)...] => put(K1, V1)...(Packet)
public func |><V>(🅛: Packet, 🅡: [(Key, V)]) -> Packet {
    var packet = 🅛
    for pair in 🅡 {
        let (k, v) = pair;
        packet = packet.put(k, v)
    }
    return packet
}

// Packet |> Key => Value
public func |>(🅛: Packet, 🅡: Key) -> Value! {
    return 🅛.get(🅡)
}

// Packet |> (Key, Key) => (Value, Value)
public func |>(🅛: Packet, 🅡: [Key]) -> (Value!, Value!) {
    return ( 🅛.get(🅡[0]), 🅛.get(🅡[1]) )
}

// Packet |> (Key, Key, Key) => (Value, Value, Value)
public func |>(🅛: Packet, 🅡: [Key]) -> (Value!, Value!, Value!) {
    return ( 🅛.get(🅡[0]), 🅛.get(🅡[1]), 🅛.get(🅡[2]) )
}

// Packet |> (Key, Key, Key, Key) => (Value, Value, Value, Value)
public func |>(🅛: Packet, 🅡: [Key]) -> (Value!, Value!, Value!, Value!) {
    return ( 🅛.get(🅡[0]), 🅛.get(🅡[1]), 🅛.get(🅡[2]), 🅛.get(🅡[3]) )
}

// Packet |> (Key, Key, Key, Key, Key) => (Value, Value, Value, Value, Value)
public func |>(🅛: Packet, 🅡: [Key]) -> (Value!, Value!, Value!, Value!, Value!) {
    return ( 🅛.get(🅡[0]), 🅛.get(🅡[1]), 🅛.get(🅡[2]), 🅛.get(🅡[3]), 🅛.get(🅡[4]) )
}

// Packet |> Extractor(A) => A
public func |><A>(🅛: Packet, 🅡: (Packet) -> A) -> A {
    return 🅡(🅛)
}

// P |> log -> P // Printed to log.
public func log(p: Packet) -> Packet { pipeLog?.info("\(p)"); return p }

// P |> error(ErrorType) -> P2 // "error" set and stopped.
public func error(error: ErrorType)(_ p: Packet) -> Packet { return p.error(error) }

// P |> error(String) -> P2 // "error" set to Error(String).
public func error(reason: String)(_ p: Packet) -> Packet { return p |> error(NSError(reason)) }

// P |> getError -> Error
public func getError(p: Packet) -> ErrorType { return p |> "error" as! ErrorType }

// P |> getReason -> Error.localizedDescription
public func getReason(p: Packet) -> String { return "\(p |> getError)" }

// P |> notImplemented -> P2 // "error" set to Error("Not implemented.")
public func notImplemented(p: Packet) -> Packet { return p |> error("Not implemented.") }

// P |> {p in ...} -> P // Divides pipline into two separate pipelines.
// Modifications inside the closure are not reflected later in the initial stream.
public func tee(f: (Packet) -> Void)(_ p: Packet) -> Packet { f(p); return p }

// P |> {p in ... return P2} -> P2
public func group(f: (Packet) -> Packet)(_ p: Packet) -> Packet { return f(p) }

// P |> {p in ...} -> Canceler // Continues pipeline on background thread.
public func onBackground(f: (Packet) -> Void)(_ p: Packet) -> Canceler { return dispatchOnBackground {f(p)} }

// P |> {p in ...} -> Canceler // Continues pipeline on main thread.
public func onMain(f: (Packet) -> Void)(_ p: Packet) -> Canceler { return dispatchOnMain {f(p)} }

public func delete(k: Key)(_ p: Packet) -> Packet { return p.delete(k) }

//////

func testTransform(k: Key)(_ p: Packet) -> Packet {
    if let h = p |> "hello", let h2 = h as? Int {
        return p |> (k, h2 - 1)
    } else { return p }
}

public func testPipe() {
    logTags.insert("PIPE")
    
    pipeLog?.info("START")
    Packet()
        |> ("hello", 7)
        |> tee {
            let packet = $0
                |> [("cat", "Garfield"), ("dog", 77)]
                |> log
            
            let(cat, dog, giraffe) = packet |> ["cat", "dog", "giraffe"]
            print("cat: \(cat), dog: \(dog), giraffe: \(giraffe)")
        } |> onBackground {
            pipeLog?.info("BACKGROUND")
            $0
                |> ("background", 66)
                |> testTransform("goodbye")
                |> onMain {
                    pipeLog?.info("MAIN")
                    let p = $0
                        |> ("done", 100)
                        |> log
                        |> delete("hello")
                        |> error("Something happened.")
                        |~> tee {
                            pipeLog?.info("STOPPED: \($0)")
                    }
                        ||> log
                        |> "baz"
                    
                    pipeLog?.info("p: \(p)")
            }
    }
}
