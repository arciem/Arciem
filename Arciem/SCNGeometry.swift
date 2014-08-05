//
//  GLKGeometry.swift
//  Arciem
//
//  Created by Robert McNally on 6/18/14.
//  Copyright (c) 2014 Arciem LLC. All rights reserved.
//


import SceneKit

public extension SCNVector3 {
    public var distanceSquared: CFloat {
    get {
        return Arciem.distanceSquared(x: x, y: y, z: z)
    }
    }
    
    public var distance: CFloat {
    get {
        return Arciem.distance(x: x, y: y, z: z)
    }
    }
    
    public var volume: CFloat {
    get {
        return Arciem.volume(x: x, y: y, z: z)
    }
    }
    
//    public var normalize: SCNVector3 {
//    get {
//        let t = Arciem.normalize(x: x, y: y, z: z)
//        return SCNVector3(x: t.x, y: t.y, z: t.z)
//    }
//    }
    
    public func dot(d: SCNVector3) -> CFloat {
        return Arciem.dot(x1: x, y1: y, z1: z, x2: d.x, y2: d.y, z2: d.z)
    }
    
    public func cross(d: SCNVector3) -> SCNVector3 {
        let t = Arciem.cross(x1: x, y1: y, z1: z, x2: d.x, y2: d.y, z2: d.z)
        return SCNVector3(x: t.x, y: t.y, z: t.z)
    }

    public func scale(#sx: CFloat, sy: CFloat, sz: CFloat) -> SCNVector3 {
        let t = Arciem.scale(x: x, y: y, z: z, sx: sx, sy: sy, sz: sz)
        return SCNVector3(x: t.x, y: t.y, z: t.z)
    }
}


// Vector + Vector -> Vector
public func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

// Vector - Vector -> Vector
public func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

// Vector . Vector -> Float
infix operator .. {}
public func .. (left: SCNVector3, right: SCNVector3) -> CFloat {
    return left.dot(right);
}

// Vector X Vector -> Vector
infix operator ** {}
public func ** (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return left.cross(right);
}

// Vector + Float -> Vector
public func + (left: SCNVector3, right: CFloat) -> SCNVector3 {
    return SCNVector3(x: left.x + right, y: left.y + right, z: left.z + right)
}

// Vector - Float -> Vector
public func - (left: SCNVector3, right: CFloat) -> SCNVector3 {
    return SCNVector3(x: left.x - right, y: left.y - right, z: left.z - right)
}

// Vector * Float -> Vector
public func * (left: SCNVector3, right: CFloat) -> SCNVector3 {
    return SCNVector3(x: left.x * right, y: left.y * right, z: left.z * right)
}

// Vector / Float -> Vector
public func / (left: SCNVector3, right: CFloat) -> SCNVector3 {
    return SCNVector3(x: left.x / right, y: left.y / right, z: left.z / right)
}


// -Vector -> Vector
prefix public func - (v: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: -v.x, y: -v.y, z: -v.z)
}


// Vector += Vector
public func += (inout left: SCNVector3, right: SCNVector3) {
    left.x += right.x
    left.y += right.y
    left.z += right.z
}

// Vector -= Vector
public func -= (inout left: SCNVector3, right: SCNVector3) {
    left.x -= right.x
    left.y -= right.y
    left.z -= right.z
}


// Vector += Float
public func += (inout left: SCNVector3, right: CFloat) {
    left.x += right
    left.y += right
    left.z += right
}

// Vector -= Float
public func -= (inout left: SCNVector3, right: CFloat) {
    left.x -= right
    left.y -= right
    left.z -= right
}

// Vector *= Float
public func *= (inout left: SCNVector3, right: CFloat) {
    left.x *= right
    left.y *= right
    left.z *= right
}

// Vector /= Float
public func /= (inout left: SCNVector3, right: CFloat) {
    left.x /= right
    left.y /= right
    left.z /= right
}
