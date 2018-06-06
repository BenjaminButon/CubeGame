//
//  SCNNode + Extension.swift
//  CubeGame
//
//  Created by Benko Ostap on 06.06.18.
//  Copyright © 2018 Ostap Benko. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode{
    static func == (nodeA: SCNNode, nodeB: SCNNode) -> Bool {
        let positionA = nodeA.position
        let positionB = nodeB.position
        var result = false
        if (positionA.x == positionB.x && positionA.y == positionB.y && positionA.z == positionB.z){
            result = true
        }
        return result
    }
}
