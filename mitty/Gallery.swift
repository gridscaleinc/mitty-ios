//
//  Gallery.swift
//  mitty
//
//  Created by gridscale on 2017/09/17.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class GalleryContent {
    var galleryID: Int64 = 0
    var seq: Int = 0
    var caption: String = ""
    var briefInfo: String = ""
    var freeText: String = ""
    var contentId: Int64 = 0
    var mime: String = ""
    
    var name: String = ""
    var linkURL: String = ""
    var thumbnailURL: String = ""
    var width: Int = 0
    var height: Int = 0
    var size: Int = 0
    var ownerID: Int = 0
    var created: Date = .nulldate
    var updated: Date = .nulldate
}
