//
//  MittyImage.swift
//  mitty
//
//  Created by gridscale on 2017/05/23.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


extension UIImageView {
    func setMittyImage(url: String, _ circle: Bool? = false, callback: (()->Void)? = {}) {
        if url == "" {
            callback!()
            return
        }
        
        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        self.af_setImage(withURL: URL(string: url)!, placeholderImage: UIImage(named: "downloading"), completion: { image in
            if (image.result.isSuccess) {
                if (circle!) {
                    self.image = image.result.value?.af_imageRoundedIntoCircle()
                } else {
                    self.image = image.result.value
                }
                callback!()
            }
        }
        )
    }
}

extension UIButton {
    func setMittyImage(url: String) {
        if url == "" {
            return
        }
        DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
        self.af_setImage(for: .normal, url: URL(string: url)!, completion: { image in
            if (image.result.isSuccess) {
                self.imageView?.contentMode = .scaleAspectFit
                self.setImage(image.result.value, for: .normal)
            }
        }
        )
    }
}
