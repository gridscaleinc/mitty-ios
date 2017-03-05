//
//  Somitty.swift
//  mitty
//
//  Created by gridscale on 2017/03/04.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

//
//
//
open class Mitty : OperationSet {
    
    // define a protocol that can
    func forEach (_ selector: String, _ operation: (_ selected: Selectable) -> Void) -> Mitty {
        return self
    }
    
    // define a function that access all the values in selectable
    func val(_ value: Any) -> AnyObject  {
        return self
    }
    
    // event bind
    func bind (_selector: String, _ event: FormEvent, _ handler: EventHandler ) -> Mitty {
        return self
    }
    
    // Special for button
    func button(_ selector: String, onTap: EventHandler) -> Mitty {
        return self
    }
    
    // Special for button
    func textField(_ selector: (), onFocus: EventHandler) -> Mitty {
        return self
    }
    
    // Special for button
    func textField(_ selector: String, validator: EventHandler) -> Mitty {
        return self
    }
    
    //
    func animate(_ selector: String, animator: () -> Void, duration: Int) -> Mitty {
        return self
    }
    
    // enable
    // disable
    // hide
    // remove
    
    func ifThen(_ selector: String, _ ifTrue: () -> Bool, _ thenDo: EventHandler) -> Mitty {
        return self
    }

}

public func mitty(_ form: MittyForm) -> Mitty {
    return Mitty()
}

public func mitty(_ section: Section1) -> Mitty {
    return Mitty()
}

public func mitty(_ row: Row1) -> Mitty {
    return Mitty()
}

public func mitty(_ row: Col) -> Mitty {
    return Mitty()
}
