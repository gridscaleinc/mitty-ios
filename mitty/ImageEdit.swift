//
//  ImageEdit.swift
//  mitty
//
//  Created by gridscale on 2016/11/12.
//  Copyright © 2016年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit

class ImageEdit {
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage? {
    
        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        let frame = CGRect(x:0, y:0,  width: inImage.size.width, height:inImage.size.height)
        inImage.draw(in: frame)
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x:atPoint.x, y:atPoint.y, width:inImage.size.width, height:inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage
    }
}
