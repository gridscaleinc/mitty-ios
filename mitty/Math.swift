//
//  Math.swift
//  mitty
//
//  Created by gridscale on 2017/11/02.
//  Copyright © 2017年 GridScale Inc. All rights reserved.
//

import Foundation

class Point {
    var lat: Double = 0
    var lon: Double = 0
    init(_ la: Double, _ lo: Double) {
        lat = la
        lon = lo
    }
}

class Bound {
    var near: Point
    var far: Point
    
    init(_ lat0: Double, _ long0: Double, _ lat1: Double, _ long1: Double  ) {
        near = Point(lat0, long0)
        far = Point(lat1, long1)
    }
    
    var center : Point {
        return Point((near.lat + far.lat ) / 2 , (near.lon + far.lon) / 2)
    }
    
    var northWest : Bound {
        let c = center
        return Bound(c.lat, near.lon, far.lat, c.lon)
    }
    
    var northEast : Bound {
        let c = center
        return Bound(c.lat, c.lon, far.lat, far.lon)
    }
    
    
    var southWest : Bound {
        let c = center
        return Bound(near.lat, near.lon, c.lat, c.lon)
    }
    
    
    var southEast : Bound {
        let c = center
        return Bound(near.lat, c.lon, c.lat, far.lon)
    }
    
    func contains(_ p:Point) -> Bool {
        return p.lat >= near.lat && p.lat <= far.lat && p.lon >= near.lon && p.lon <= far.lon
    }
}

class QuadTree {
    let maxLevel = 21
    var id: Int64 = 0
    var level: Int = 0
    var bound: Bound!
    var grid0: QuadTree? = nil
    var grid1: QuadTree? = nil
    var grid2: QuadTree? = nil
    var grid3: QuadTree? = nil
    
    init (_ id: Int64, _ level: Int, _ bound: Bound) {
        self.id = id
        self.level = level
        self.bound = bound
    }

    func subId(pid: Int64, subId: Int) -> Int64 {
        return pid*4 + Int64(subId)
    }
    
    func divide() {
        if level == maxLevel {
            return
        }
        // if aleady divided , return
        if grid0 != nil {
            return
        }
        
        grid0 = QuadTree(subId(pid: id, subId: 0), level + 1, bound.northWest)
        grid1 = QuadTree(subId(pid: id, subId: 1), level + 1, bound.northEast)
        grid2 = QuadTree(subId(pid: id, subId: 2), level + 1, bound.southWest)
        grid3 = QuadTree(subId(pid: id, subId: 3), level + 1, bound.southEast)
    
    }
    
    static var EARTH = QuadTree(0,0, Bound(-90, -180, 90, 180))
    
    static var NORTH_WEST = QuadTree(0, 1, Bound(0, -180, 90, 0))
    static var NORTH_EAST = QuadTree(1, 1, Bound(0, 0, 90, 180))
    static var SOUTH_WEST = QuadTree(2, 1, Bound(-90, -180, 0, 0))
    static var SOUTH_EAST = QuadTree(3, 1, Bound(-90, 0, 0, 180))
    
    static func GEN_HASH_ID(_ lat: Double, _ lon: Double, _ level: Int) -> Int64 {
        let p = Point(lat, lon)
        
        return EARTH.hashId(p, level)
    }
    
    func hashId (_ p: Point, _ level: Int) -> Int64 {
        
        if !bound.contains(p) {
            return -1
        }
        
        if (self.level == level) {
            return self.id
        }
        
        divide()
        if grid0 == nil {
            return -1
        }
        
        var id = grid0!.hashId(p, level)
        if (id != -1) {
            return id
        }
        
        id = grid1!.hashId(p, level)
        if (id != -1) {
            return id
        }
        
        id = grid2!.hashId(p, level)
        if (id != -1) {
            return id
        }
        
        id = grid3!.hashId(p, level)
        if (id != -1) {
            return id
        }
        return -1
    }
}
