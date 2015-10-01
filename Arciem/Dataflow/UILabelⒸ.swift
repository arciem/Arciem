//
//  UILabelⒸ.swift
//  Arciem
//
//  Created by Robert McNally on 2/20/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

import UIKit

public class UILabelⒸ: Component {
    public private(set) var inText🅟: InPort<String>!
    
    private weak var label: UILabel?
    private var textColor: UIColor
    
    public init(_ name: String?, _ component: Component?, label: UILabel) {
        self.label = label
        textColor = label.textColor
        
        super.init(name: name ?? "UILabel", component)
        
        inText🅟 = InPort("inText", self) { [weak self] 🅥 in
            let _ = dispatchOnMain {
                if let slf = self, label = slf.label {
                    switch 🅥 {
                    case .😄(let 📫):
                        label.text = 📫
                        label.textColor = slf.textColor
                    case .😡(let 🚫):
                        label.text = "\(🚫)"
                        label.textColor = .redColor()
                    }
                }
            }
        }
    }
}

public func +>(🅛: OutPort<String>, 🅡: UILabel) -> Cable<String> {
    let label🅒 = UILabelⒸ("UILabel", 🅛.component, label: 🅡)
    let cable = 🅛 +> label🅒.inText🅟
    return cable
}