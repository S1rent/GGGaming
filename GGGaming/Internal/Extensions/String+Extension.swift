//
//  String+Extension.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{8,}$]", options: .regularExpression) == nil
    }
}

extension NSAttributedString {
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.utf16.description.rangeOfCharacter(from: invertedSet)
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        let location = string.utf16.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.utf16.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        return attributedSubstring(from: range)
    }
}
