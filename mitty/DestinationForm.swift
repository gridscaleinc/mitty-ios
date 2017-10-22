//
//  DestinationForm.swift
//  mitty
//
//  Created by gridscale on 2017/10/22.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit


class DestinationForm : Section {
    private var destinationRow = Row.LeftAligned().layout {
        l in
        l.fillHolizon().height(40)
    }
    
    private var destinationLabel = MQForm.label(name: "destinationLabel", title: "-")
    private var destination = "-"
    
    private var distanceRow = Row.LeftAligned().layout {
        l in
        l.fillHolizon().height(40)
    }
    
    private var distanceLabel = MQForm.label(name: "distance", title: "-")
    private var distance = "-"
    
    private var checkinRow = Row.LeftAligned().layout {
        l in
        l.fillHolizon().height(40)
    }
    
    private var checkinEnabled = false

    func enable(checkin status: Bool) {
        if (checkinEnabled != status) {
            reload()
            if checkinEnabled {
                destinationLabel.label.isHighlighted = true
                distanceLabel.label.isHighlighted = true
                self.view.blink(duration: 10)
            }
        }
        checkinEnabled = status

    }
    
    func setDestination(_ dest: String) {
        destination = dest
        destinationLabel.label.text = dest
    }
    
    func setDistance (inMeter : Double) {
        if (inMeter < 1000) {
            distance = "ここから約\(String(format: "%d", inMeter))m"
            distanceLabel.label.isHighlighted = true
        } else {
           distance = "ここから約\(String(format: "%.1f", inMeter*1.21/1000))km"
        }
        
        distanceLabel.label.text = distance
        enable(checkin: inMeter < 200)
    }
    
    /// Reload
    /// 一旦リセットし、最高構築
    func reload() {
        reset()
        build()
        self.configLayout()
    }
    
    func build () {
        destinationRow = Row.LeftAligned().layout {
            l in
            l.fillHolizon().height(40)
        }
        destinationRow +++ MQForm.label(name: "location", title: "📍").layout {
            l in
            l.verticalCenter().leftMargin(10)
        }
        
        destinationLabel = MQForm.label(name: "destinationLabel", title: destination).layout {
            l in
            l.label.numberOfLines = 2
            l.label.textColor = UIColor.darkText
            l.label.highlightedTextColor = MittyColor.sunshineRed
            l.label.adjustsFontSizeToFitWidth = true
            l.verticalCenter().leftMargin(10).rightMost(withInset: 10)
        }
        
        destinationRow +++ destinationLabel
        self <<< destinationRow
        
        distanceRow = Row.LeftAligned().layout {
            l in
            l.fillHolizon().height(30)
        }
        
        distanceLabel = MQForm.label(name: "distance", title: distance).layout {
            l in
            l.label.highlightedTextColor = MittyColor.sunshineRed
            l.label.adjustsFontSizeToFitWidth = true
            l.verticalCenter().leftMargin(10).rightMost(withInset: 10)
        }
        distanceRow +++ distanceLabel
        self <<< distanceRow
        
        if (checkinEnabled) {
            checkinRow = Row.LeftAligned().layout {
                l in
                l.fillHolizon().height(30)
            }
            let checkinButton = MQForm.button(name: "checkinButton", title: "Check/In").layout {
                b in
                b.height(30).fillHolizon().verticalCenter().leftMargin(10)
            }
            checkinButton.bindEvent(.touchUpInside) { _ in
                if self.onCheckin != nil {
                    self.onCheckin!()
                }
            }
            checkinRow +++ checkinButton
            self <<< checkinRow
        }
    }
    
    var onCheckin : ( () -> Void )? = nil
    
}
