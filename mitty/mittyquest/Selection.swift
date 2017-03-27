//
//  Selection.swift
//
//  MittyQuest
//
//  Created by gridscale on 2017/03/04.
//  Copyright © 2017 GridScale Inc. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation
import UIKit

class Matching {
    
    var pattern : String
    var stack = Stack<Matcher>()
    var hasError: Bool = false
    
    init (_ s: String) {
        pattern = s.trimmingCharacters(in: CharacterSet.whitespaces)
        scanMatchers()
    }
    
    var selector : Selector = Selector()

    
    func scanMatchers() {
        let tokenizer = SelectorTokenizer(pattern)
        stack = Stack<Matcher>()
        scanMatchers(tokenizer)
    }
    
    func scanMatchers (_ tokenizer: SelectorTokenizer) {
        while (!tokenizer.EOF()) {
            let token = tokenizer.next()
            
            switch (token) {
            case let t where t!.isNameOrId() :
                let s = Selector()
                s.tagOrName = (t?.token)!
                newSelector(s)

                break
            case let t where t!.isCommar():
                prepareUnion()
                
            case let t where t!.isColon() :
                let m = FilterMatch()
                stack.push(m)
                scanFilter(m, tokenizer)
                break
                
            case let t where t!.isLeftBracket():
                let m = AttributeMatch()
                stack.push(m)
                scanAttribute(m, tokenizer)
                break
                
            case let t where t!.isWhitespaces():
                break
                
            case let t where t!.isRightParentheses():
                onEndOfAttribute()
                
            
            default:
                break
            }
            
        }
        
        onEndOfSelector()
    }
    
    func newSelector(_ s: Selector) {
        if (stack.isEmpty) {
            stack.push(s)
        } else {
            let e = stack.peek()
            if (e is JointSelector) {
                (e as! JointSelector).add(s)
            } else {
                // error
                hasError = true
            }
        }
    }
    
    func prepareUnion() {
        if (stack.isEmpty) {
            return
        } else {
            let e = stack.pop()
            let jointSelector = JointSelector()
            jointSelector.leftSelector = (e as! Selector)
            jointSelector.selectOp = .Union
        }

    }
    
    func onEndOfSelector() {
        if !stack.isEmpty {
            selector = stack.pop() as! Selector
        }
    }

    func onEndOfAttribute() {
        let matcher = stack.pop()
        if let selector = stack.peek() {
            if selector is Selector {
                (selector as! Selector).attributeMatchers.append(matcher as! AttributeMatch)
                return
            }
        }
        let selector = Selector()
        selector.attributeMatchers.append(matcher as! AttributeMatch)
        newSelector(selector)
    }
    
    func scanFilter(_ matcher: FilterMatch, _ tokenizer : SelectorTokenizer) {
        let name = nextNonWhitespace(tokenizer)
        if (name == nil) {
            hasError = true
            return
        }
        matcher.name = (name?.token)!
    }
    
    func scanAttribute(_ matcher: AttributeMatch, _ tokenizer : SelectorTokenizer) {
        let name = nextNonWhitespace(tokenizer)
        if (name == nil) {
            hasError = true
            return
        }
        matcher.name = (name?.token)!
        
        let compareOp = nextNonWhitespace(tokenizer)
        if (name == nil) {
            hasError = true
            return
        } else {
            matcher.attOp = (compareOp?.token)!
        }
        let value = nextNonWhitespace(tokenizer)
        if (value == nil) {
            hasError = true
            return
        } else {
            matcher.value = (value?.token)!
        }
        let end = nextNonWhitespace(tokenizer)
        if (end == nil) {
            hasError = true
            return
        } else {
            if (!(end?.isRightBracket())!) {
                hasError = true
            }
            onEndOfAttribute()
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
    func matchAll (_ controlSet: Set<Control>) -> Set<Control>
}

class Selector : Matcher {
    var tagOrName: String = ""
    var attributeMatchers : [AttributeMatch] = []
    var filterMatchers : [FilterMatch] = []
    
    func matchAll(_ controlSet: Set<Control>) -> Set<Control> {
        var matched = Set<Control> ()
        
        for  c in controlSet {
            if (checkTagOrName(c)) {
                matched.insert(c)
            }
        }
        
        matched = filterAttribute(matched)
        
        matched = filter(matched)
        
        return matched
    }
    
    func checkTagOrName(_ c: Control) -> Bool {
        if (tagOrName == "") {
            return true
        }
        return false
    }
    
    func filterAttribute(_ matched: Set<Control>)  -> Set<Control> {
        var result = matched
        for a in attributeMatchers {
            result = a.matchAll(result)
        }
        return result
    }
    
    func filter(_ matched: Set<Control>) -> Set<Control> {
        var result = matched
        for a in filterMatchers {
            result = a.matchAll(result)
        }
        return result
    }
}

enum SelectorOp {
    case Decent
    case Children
    case Union
}

// TODO
class JointSelector : Selector {


    var leftSelector : Selector? = nil
    var selectOp : SelectorOp = .Union
    var rightSelector : Selector? = nil
    
    override func matchAll(_ controlSet: Set<Control>) -> Set<Control> {
        return Set<Control>()
    }
    
    func add(_ s: Selector) {
        rightSelector = s
    }
}


class AttributeMatch: Matcher {
    
    var name : String = ""
    var attOp : String = ""
    var value : String = ""
    
    func matchAll(_ controlSet: Set<Control>) -> Set<Control> {
        var matched = Set<Control>()
        for c in controlSet {
            if (matches(c)) {
                matched.insert(c)
            }
        }
        return matched
    }
    
    func matches (_ c: Control) -> Bool {
        if (name == "name") {
            return c.name == value
        } else {
            return false
        }
    }
}


class FilterMatch : Matcher {
    
    var _name : String = ""
    
    var parmater : String = ""
    
    var selector : Selector? = nil
    
    var name : String {
        get{
            return _name
        }
        set(n) {
            _name = n
        }
    }
    
    func matchAll(_ controlSet: Set<Control>) -> Set<Control> {
        var matched = Set<Control>()
        for c in controlSet {
            if (matches(c)) {
                matched.insert(c)
            }
        }
        return matched
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
        case "*", "[", ".", "=", ":", "]":
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
            if " [.:],='".contains(ch1) {
                break
            }
        }
        var str = patternString as NSString
        if (start < position) {
            str = str.substring(with:NSRange(location: start, length:position-start)) as NSString
        } else {
            return nil
        }
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
        if (ns.length > position) {
            return ns.substring(with: NSRange(location: position, length: 1))
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
    func isColon() -> Bool {
        return token == ":"
    }
    
    // is Start of an Attribute?
    func isLeftBracket() -> Bool {
        return token == "["
    }
    
    // is End of an Attribute?
    func isRightBracket() -> Bool {
        return token == "]"
    }
    
    // is End of an Attribute?
    func isDot() -> Bool {
        return token == "."
    }
    
    func isWhitespaces() -> Bool {
        return token == " "
    }
    
    func isCommar() -> Bool {
        return token == ","
    }
    
    func isLeftParentheses() -> Bool {
        return token == "("
    }
    
    func isRightParentheses() -> Bool {
        return token == ")"
    }
}
