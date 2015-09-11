//
//  Font.swift
//  Arciem
//
//  Created by Robert McNally on 1/23/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    #elseif os(OSX)
    import Cocoa
#endif

public extension OSFont {
    
    public func variantWithTraits(traits: UIFontDescriptorSymbolicTraits) -> OSFont {
        let desc: UIFontDescriptor = fontDescriptor().fontDescriptorWithSymbolicTraits(traits)
        return OSFont(descriptor: desc, size: 0.0)
    }

    public func boldVariant() -> OSFont {
        return variantWithTraits(.TraitBold)
    }

    public func italicVariant() -> OSFont {
        return variantWithTraits(.TraitItalic)
    }
    
    public func boldItalicVariant() -> OSFont {
        return variantWithTraits([.TraitBold, .TraitItalic])
    }
}
