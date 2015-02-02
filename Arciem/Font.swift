//
//  Font.swift
//  Arciem
//
//  Created by Robert McNally on 1/23/15.
//  Copyright (c) 2015 Arciem LLC. All rights reserved.
//

public extension UIFont {
    
    public func variantWithTraits(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        let desc: UIFontDescriptor = fontDescriptor().fontDescriptorWithSymbolicTraits(traits)
        return UIFont(descriptor: desc, size: 0.0)
    }

    public func boldVariant() -> UIFont {
        return variantWithTraits(.TraitBold)
    }

    public func italicVariant() -> UIFont {
        return variantWithTraits(.TraitItalic)
    }
    
    public func boldItalicVariant() -> UIFont {
        return variantWithTraits(.TraitBold | .TraitItalic)
    }
}
