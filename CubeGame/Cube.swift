//
//  Cube.swift
//  CubeGame
//
//  Created by Benko Ostap on 06.06.18.
//  Copyright © 2018 Ostap Benko. All rights reserved.
//

import Foundation
import SceneKit


let size: CGFloat = 0.8
let color = UIColor.green

class Cube{
    
    static func spawnCubeAt(_ position: SCNVector3) -> SCNNode{
        let cubeGeometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0.0)
        cubeGeometry.materials.first?.diffuse.contents = color
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = position
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        return cubeNode
    }
}
