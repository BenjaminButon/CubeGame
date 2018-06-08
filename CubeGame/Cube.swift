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
        cubeGeometry.materials.first?.diffuse.contents = UIColor.random()
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = position
        let shape = SCNPhysicsShape(geometry: cubeGeometry, options: nil)
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        cubeNode.physicsBody?.contactTestBitMask = (cubeNode.physicsBody?.collisionBitMask)!
        cubeNode.castsShadow = true
        return cubeNode
    }
    
}
