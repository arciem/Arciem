public protocol DataflowValue {
    func setValue(Any)
    func getValue() -> Any
    func hasValue() -> Bool
    func doOperate()
    func addOutput((Any) -> Void)
}

private var dataflowLogger : Logger? = Logger(tag: "DATAFLOW", enabled: true)

public class Dataflow<V> : DataflowValue, Debuggable {
    typealias ValueType = V
    typealias OutputFunc = (ValueType) -> Void

    public var debugName: String?
    var inputs = [String : DataflowValue]()
    var _inputsSet: Int = 0
    var outputs = [OutputFunc]()
    public var error: NSError?
    var _value: [ValueType]?
    public var value: ValueType! {
        get {
            let v: ValueType? = _value?[0]
            return v
        }
        set {
            log?.trace("\(identifier) will set value: \(newValue)")
            _value = [newValue]
            log?.trace("\(identifier) did set value")

            var outputIndex = 0
            for output in outputs {
                log?.trace("\(identifier) calling output \(++outputIndex) of \(outputs.count)")
                output(_value![0])
            }
        }
    }
    var log: Logger? { get { return dataflowLogger } }
    
    func incrementInputsSet() {
        log?.trace("\(identifier) got input \(_inputsSet + 1) of \(inputs.count)")
        if ++_inputsSet == inputs.count {
            log?.trace("\(identifier) got all inputs")
            doOperate()
        }
    }
    
    public init(inputs: [(String, DataflowValue)], debugName: String? = nil) {
        self.debugName = debugName
        log?.trace("\(identifier) init with inputList:\(inputs.description)")
        for (let name, let input) in inputs {
            self.inputs[name] = input
            input.addOutput() { v in
                let n: String = name
                let val: ValueType = v as ValueType
                self.log?.trace("\(self.identifier) executing output block to set input:\(name) to value: \(val)")
                self.setInputNamed(name, value: v)
            }
        }
        for (_, let input) in self.inputs {
            if input.hasValue() {
                incrementInputsSet()
            }
        }
    }
    
    public init(value: ValueType, debugName: String? = nil) {
        self.debugName = debugName
        log?.trace("\(identifier) init with value: \(value)")
        self.value = value
    }
    
    public init(debugName: String? = nil) {
        self.debugName = debugName
        log?.trace("\(identifier) init with nothing")
    }
    
    func setInputNamed<T>(name: String, value: T) {
        if let input = inputs[name]? {
            if !input.hasValue() {
                input.setValue(value)
                incrementInputsSet()
            }
        }
    }
    
    func getInputNamed<T>(name: String) -> T {
        return inputs[name]!.getValue() as T
    }
    
    func operate() -> (ValueType!, NSError?) {
        return (nil, NSError("Unimplemented operate() function."))
    }
}

extension Dataflow {
    var identifier: String {
        get {
            return "\(identifierOfValue(self)) value:\(value) inputs:\(inputs) outputsCount:\(outputs.count)"
        }
    }
}

extension Dataflow : DataflowValue {
    public func setValue(v: Any) {
        value = v as ValueType
    }
    
    public func getValue() -> Any {
        return value
    }
    
    public func hasValue() -> Bool {
        return value != nil
    }
    
    public func doOperate() {
        (value, error) = operate()
    }
    
    public func addOutput(output: (Any) -> Void) {
        self.log?.trace("\(identifier) adding output block")
        outputs.append(output)
        if hasValue() {
            self.log?.trace("\(identifier) added input has value: \(getValue()), so calling output")
            output(value)
        }
    }
}

extension Dataflow : Printable {
    public var description: String {
        get {
            return "\(identifierOfValue(self)) value:\(value)"
        }
    }
}

public class DFInfix<V> : Dataflow<V> {
    var lhs: V {
        get { return getInputNamed("lhs") }
        set { setInputNamed("lhs", value: newValue) }
    }
    
    var rhs: V {
        get { return getInputNamed("rhs") }
        set { setInputNamed("rhs", value: newValue) }
    }
    
    public init(lhs: Dataflow<V>, rhs: Dataflow<V>, debugName: String? = nil) {
        super.init(inputs: [("lhs", lhs), ("rhs", rhs)], debugName: debugName)
    }
}

public class DFAdd<V: ImmutableArithmeticable> : DFInfix<V> {
    public override init(lhs: Dataflow<V>, rhs: Dataflow<V>, debugName: String? = nil) {
        super.init(lhs: lhs, rhs: rhs, debugName: debugName)
    }
    
    override func operate() -> (ValueType!, NSError?) {
        return (self.lhs + self.rhs, nil)
    }
}

public class DFSubtract<V: ImmutableArithmeticable> : DFInfix<V> {
    public override init(lhs: Dataflow<V>, rhs: Dataflow<V>, debugName: String? = nil) {
        super.init(lhs: lhs, rhs: rhs, debugName: debugName)
    }
    
    override func operate() -> (ValueType!, NSError?) {
        return (self.lhs - self.rhs, nil)
    }
}

public class DFMultiply<V: ImmutableArithmeticable> : DFInfix<V> {
    public override init(lhs: Dataflow<V>, rhs: Dataflow<V>, debugName: String? = nil) {
        super.init(lhs: lhs, rhs: rhs, debugName: debugName)
    }
    
    override func operate() -> (ValueType!, NSError?) {
        return (self.lhs * self.rhs, nil)
    }
}

public class DFDivide<V: ImmutableArithmeticable> : DFInfix<V> {
    public override init(lhs: Dataflow<V>, rhs: Dataflow<V>, debugName: String? = nil) {
        super.init(lhs: lhs, rhs: rhs, debugName: debugName)
    }
    
    override func operate() -> (ValueType!, NSError?) {
        return (self.lhs / self.rhs, nil)
    }
}

public class DFRemainder<V: ImmutableArithmeticable> : DFInfix<V> {
    public override init(lhs: Dataflow<V>, rhs: Dataflow<V>, debugName: String? = nil) {
        super.init(lhs: lhs, rhs: rhs, debugName: debugName)
    }
    
    override func operate() -> (ValueType!, NSError?) {
        return (self.lhs % self.rhs, nil)
    }
}

public class DFConcatenate<V> : DFInfix<String> {
    public override init(lhs: Dataflow<String>, rhs: Dataflow<String>, debugName: String? = nil) {
        super.init(lhs: lhs, rhs: rhs, debugName: debugName)
    }
    
    override func operate() -> (ValueType!, NSError?) {
        let s1 = self.lhs as NSString
        let s2 = self.rhs as NSString
        let s3 = (s1 + s2) as String
        return (s3, nil)
    }
}

public func + <V: ImmutableArithmeticable>(lhs: Dataflow<V>, rhs: Dataflow<V>) -> Dataflow<V> {
    return DFAdd(lhs: lhs, rhs: rhs)
}

public func - <V: ImmutableArithmeticable>(lhs: Dataflow<V>, rhs: Dataflow<V>) -> Dataflow<V> {
    return DFSubtract(lhs: lhs, rhs: rhs)
}

public func * <V: ImmutableArithmeticable>(lhs: Dataflow<V>, rhs: Dataflow<V>) -> Dataflow<V> {
    return DFMultiply(lhs: lhs, rhs: rhs)
}

public func / <V: ImmutableArithmeticable>(lhs: Dataflow<V>, rhs: Dataflow<V>) -> Dataflow<V> {
    return DFDivide(lhs: lhs, rhs: rhs)
}

public func % <V: ImmutableArithmeticable>(lhs: Dataflow<V>, rhs: Dataflow<V>) -> Dataflow<V> {
    return DFRemainder(lhs: lhs, rhs: rhs)
}

public func + (lhs: Dataflow<String>, rhs: Dataflow<String>) -> Dataflow<String> {
    return DFConcatenate<AnyClass>(lhs: lhs, rhs: rhs)
}

