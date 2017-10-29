//
//  AnnotationView.swift
//  mitty
//
//  Created by gridscale on 2017/10/29.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AnnotationView : MKAnnotationView {
    var imageName = ""
    var display = ""
    var row : Row!
    var panel: Control = Control()
    init(img: String, label: String, ann: MKAnnotation) {
        super.init(annotation: ann, reuseIdentifier: "AnnotationView-Mitty")
        imageName = img.trimmingCharacters(in: .whitespacesAndNewlines)
        display = label.trimmingCharacters(in: .whitespacesAndNewlines)
        
        row = Row.LeftAligned()
        if (imageName != "") {
            row +++ MQForm.img(name: "pin-image", url: imageName).layout {
                i in
                i.imageView.contentMode = .scaleAspectFit
                i.leftMargin(5).verticalCenter().height(20).width(20)
                i.imageView.image = i.imageView.image?.af_imageRoundedIntoCircle()
            }
        }
        
        let l = MQForm.hilight(label: label, named: "pin-label").layout {
            l in
            l.width(80).leftMargin(5).verticalCenter()
            l.label.numberOfLines = 2
            l.label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
            l.label.adjustsFontSizeToFitWidth = true
        }
        row +++ l
        
        self.addSubview(row.view)
        row.layout{
            r in
            r.height(30).upper().leftMost(withInset:10).rightAlign(with: l)
        }
        
        row.configLayout()
        self.autoPinEdge(.left, to: .left, of: row.view)
        self.autoPinEdge(.right, to: .right, of: row.view)
        self.autoPinEdge(.top, to: .top, of: row.view)
        self.autoPinEdge(.bottom, to: .bottom, of: row.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCaloutPanel(_ c: Control) {
        panel = c
        self.addSubview(c.view)
        c.view.autoPinEdge(.bottom, to: .top, of: self, withOffset: 10)
        c.view.autoPinEdge(.left, to: .left, of: self)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds;
        var isInside: Bool = rect.contains(point);
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point);
                if isInside
                {
                    break;
                }
            }
        }
        return isInside;
    }
}
