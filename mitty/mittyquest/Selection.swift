//
//  Selection.swift
//  mitty
//
//  Created by gridscale on 2017/03/11.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class Matching {
    var pattern : String
    var stack = Stack<Matcher>()
    
    init (_ s: String) {
        pattern = s.trimmingCharacters(in: CharacterSet.whitespaces)
        scanMatchers(pattern)
    }
    
    var selectors : [Selector] = []
    
    // 
    func matches (_ c: Control) -> Bool {
        for s in selectors {
            if s.matches(c) {return true}
        }
        return false
    }
    
    func scanMatchers(_ p: String) {
        let tokenizer = SelectorTokenizer(pattern)
        stack = Stack<Matcher>()
        scanMatchers(tokenizer)
    }
    
    func scanMatchers (_ tokenizer: SelectorTokenizer) {
        while (!tokenizer.EOF()) {
            let token = tokenizer.next()
            switch (token) {
            case let t where t!.isStartOfFilter() :
                let m = FilterMatch()
                stack.push(m)
                scanFilter(m, tokenizer)
                break
                
            case let t where t!.isStartOfAttribute():
                let m = AttributeMatch()
                stack.push(m)
                scanAttribute(m, tokenizer)
                break
                
            case let t where t!.isWhitespaces():
                break
                
            case let t where t!.isEndOfAttribute():
                onEndOfAttribute()
                
                
            default:
                break
            }
            
            onEndOfSelector()
        }
    }
    
    func onEndOfSelector() {
        
    }
    
    
    func onEndOfAttribute() {
        
    }
    
    func scanFilter(_ matcher: FilterMatch, _ tokenizer : SelectorTokenizer) {
        let name = nextNonWhitespace(tokenizer)
        if (name == nil) {
            return
        }
        matcher.name = (name?.token)!
    }
    
    func scanAttribute(_ matcher: AttributeMatch, _ tokenizer : SelectorTokenizer) {
        let name = nextNonWhitespace(tokenizer)
        if (name == nil) {
            return
        }
        matcher.name = (name?.token)!
        
        let compareOp = nextNonWhitespace(tokenizer)
        if (name == nil) {
            return
        } else {
            matcher.op = (compareOp?.token)!
        }
        
    }
    
    func nextNonWhitespace(_ tokenizer: SelectorTokenizer) -> Token? {
        if (tokenizer.EOF()) {
            return nil
        }
 
        let t = tokenizer.next()
        if (t?.isWhitespaces())! {
            if (tokenizer.EOF()) {
                return nil
            }
            return tokenizer.next()
        }
        return t

    }
}

protocol Matcher {
    func matches (_ c: Control) -> Bool
}

class Selector : Matcher {
    var container: String = ""
    var attributeMatchers : [AttributeMatch] = []
    var filterMatchers : [FilterMatch] = []
    
    func matches (_ c: Control) -> Bool {
        return true
    }
}

class AttributeMatch: Matcher {
    
    var name : String = ""
    var op : String = ""
    var value : String = ""
    
    func matches (_ c: Control) -> Bool {
        return c.name == name
    }
}

class FilterMatch : Matcher {
    var _name : String = ""
    var name : String {
        get{
            return _name
        }
        set(n) {
            _name = n
        }
    }
    
    func matches (_ c: Control) -> Bool {
        switch(name.lowercased()) {
        case "text":
            return type(of: c._view) is UITextField.Type
        case "button":
            return type(of: c._view) is UIButton.Type
        case "label":
            return type(of: c._view) is UILabel.Type
        case "stepper":
            return type(of: c._view) is UIStepper.Type
        case "textView":
            return type(of: c._view) is UITextView.Type
        case "img":
            return type(of: c._view) is UIImageView.Type
        case "slider":
            return type(of: c._view) is UISlider.Type
        case "textView":
            return type(of: c._view) is UITextView.Type
        case "switch":
            return type(of: c._view) is UISwitch.Type

        default:
            return false
        }
    }

}

class SectionMatch: Matcher {
    
    var name : String
    
    init (_ pattern: String) {
        name = ""
    }
    
    func matches (_ c: Control) -> Bool {
        return c.name == name
    }
}

class SelectorTokenizer {
    var patternString : String = ""
    var position = 0
    var endOfString = false
    init (_ s: String) {
        patternString = s
    }
    
    // Scan the next token
    func next() -> Token? {
        if (endOfString) {
            return nil
        }
        
        let start = position
        let ch = char()

        switch (ch) {
        case " ":
            advance()
            skipWhiteSpaces()
            return Token(" ")
        case "*", "[", ".", ":", "]":
            advance()
            return Token(ch)
        case "'":
            while(!endOfString) {
                advance()
                let ch1 = char()
                if (ch1 == "'") {
                    advance()
                    var str = patternString as NSString
                    str = str.substring(from: start) as NSString
                    str = str.substring(to: position) as NSString
                    return Token(str as String)
                }
            }
        default:
            break
        }
        
        while (!endOfString) {
            advance()
            let ch1 = char()
            if "*[.:]'".contains(ch1) {
                break
            }
        }
        var str = patternString as NSString
        str = str.substring(from: start) as NSString
        str = str.substring(to: position) as NSString
        return Token(str as String)

    }
    
    func advance(_ step: Int) {
        for _ in 1...step {
            if endOfString {
                break
            }
            
            advance()
        }
    }
    
    func advance() {
        if (position < patternString.characters.count) {
            position += 1
            if (position == patternString.characters.count) {
                endOfString = true
            }
        }
    }
    
    func skipWhiteSpaces() {
        let c = char()
        if c == " " {
            advance()
        }
    }
    
    func char() -> String {
        let ns = patternString as NSString
        if (ns.length>0) {
           return ns.substring(to: 1)
        }
        return ""
    }
    
    func EOF() ->Bool {
        return position >= patternString.characters.count
    }
}

// Selector Token
struct Token {
    var token: String

    // Initialize The Token String
    init(_ t: String) {
        token = t
    }
    
    // Is as String value
    func isValue() -> Bool {
        return token.hasPrefix("'")
    }
    
    // Is as Tag token
    func isStartOfTag() -> Bool {
        return token.hasPrefix("#")
    }
    
    // Is as Tag token
    func isNameOrId() -> Bool {
        let letters = CharacterSet.letters

        for uni in token.unicodeScalars {
            if letters.contains(uni) {
                return true
            }
        }
        return false
    }
    
    // is Start of a filter?
    func isStartOfFilter() -> Bool {
        return token.hasPrefix(":")
    }
    
    // is Start of an Attribute?
    func isStartOfAttribute() -> Bool {
        return token.hasPrefix("[")
    }
    
    // is End of an Attribute?
    func isEndOfAttribute() -> Bool {
        return token.hasPrefix("]")
    }
    // is End of an Attribute?
    func isStartOfClass() -> Bool {
        return token.hasPrefix(".")
    }
    
    func isWhitespaces() -> Bool {
        return token.hasPrefix(" ")

    }
}
