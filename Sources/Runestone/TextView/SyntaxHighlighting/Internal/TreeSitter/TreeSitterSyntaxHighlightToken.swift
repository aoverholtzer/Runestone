import UIKit

final class TreeSitterSyntaxHighlightToken {
    let range: NSRange
    let textColor: UIColor?
    let shadow: NSShadow?
    let font: UIFont?
    let fontTraits: FontTraits
    let otherAttributes: [TreeSitterSyntaxHighlightTokenAttribute]
    var isEmpty: Bool {
        range.length == 0 || (textColor == nil && font == nil && shadow == nil && otherAttributes.isEmpty)
    }
    
    init(range: NSRange, textColor: UIColor?, shadow: NSShadow?, font: UIFont?, fontTraits: FontTraits, other: [TreeSitterSyntaxHighlightTokenAttribute]) {
        self.range = range
        self.textColor = textColor
        self.shadow = shadow
        self.otherAttributes = other
        self.font = font
        self.fontTraits = fontTraits
    }
}

extension TreeSitterSyntaxHighlightToken: Equatable {
    static func == (lhs: TreeSitterSyntaxHighlightToken, rhs: TreeSitterSyntaxHighlightToken) -> Bool {
        lhs.range == rhs.range && lhs.textColor == rhs.textColor && lhs.font == rhs.font
    }
}

extension TreeSitterSyntaxHighlightToken {
    static func locationSort(_ lhs: TreeSitterSyntaxHighlightToken, _ rhs: TreeSitterSyntaxHighlightToken) -> Bool {
        if lhs.range.location != rhs.range.location {
            return lhs.range.location < rhs.range.location
        } else {
            return lhs.range.length < rhs.range.length
        }
    }
}

extension TreeSitterSyntaxHighlightToken: CustomDebugStringConvertible {
    var debugDescription: String {
        "[TreeSitterSyntaxHighlightToken: \(range.location) - \(range.length)]"
    }
}

// MARK: -

public typealias TokenAttribute = TreeSitterSyntaxHighlightTokenAttribute

public struct TreeSitterSyntaxHighlightTokenAttribute {
    let key: NSAttributedString.Key
    let value: Any
    let subrange: Subrange?
    
    public init(_ key: NSAttributedString.Key, _ value: Any, subrange: TreeSitterSyntaxHighlightTokenAttribute.Subrange? = nil) {
        self.key = key
        self.value = value
        self.subrange = subrange
    }
    
    public enum Subrange {
        case inset(leading: Int, trailing: Int)
        case fromStart(length: Int)
        case fromEnd(length: Int)
    }
    
    func subrange(for range: NSRange) -> NSRange {
        switch subrange {
        case .inset(let leading, let trailing):
            return NSRange(location: range.location + leading,
                           length: range.length - leading - trailing).nonNegativeLength
        case .fromStart(let length):
            return NSRange(location: range.location, length: length).nonNegativeLength
        case .fromEnd(let length):
            return NSRange(location: range.location + range.length - length,
                           length: length).nonNegativeLength
        case nil:
            return range
        }
    }
    
    var dictionary: [NSAttributedString.Key: Any] {
        if let value = value as? (any RawRepresentable) {
            return [key: value.rawValue]
        } else {
            return [key: value]
        }
    }
}
