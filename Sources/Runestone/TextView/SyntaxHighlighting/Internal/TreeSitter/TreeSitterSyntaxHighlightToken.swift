import UIKit

final class TreeSitterSyntaxHighlightToken {
    let range: NSRange
    let textColor: UIColor?
    let shadow: NSShadow?
    let strikethroughStyle: NSUnderlineStyle?
    let underlineStyle: NSUnderlineStyle?
    let underlineColor: UIColor?
    let font: UIFont?
    let fontTraits: FontTraits
    var isEmpty: Bool {
        range.length == 0 || (textColor == nil && font == nil && shadow == nil && strikethroughStyle == nil && underlineStyle == nil)
    }
    
    init(range: NSRange, textColor: UIColor?, shadow: NSShadow?, strikethroughStyle: NSUnderlineStyle?, underlineStyle: NSUnderlineStyle?, underlineColor: UIColor?, font: UIFont?, fontTraits: FontTraits) {
        self.range = range
        self.textColor = textColor
        self.shadow = shadow
        self.strikethroughStyle = strikethroughStyle
        self.underlineColor = underlineColor
        self.underlineStyle = underlineStyle
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
