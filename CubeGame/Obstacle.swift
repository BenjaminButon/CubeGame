//
//  Obstacle.swift
//  CubeGame
//
//  Created by Benko Ostap on 06.06.18.
//  Copyright © 2018 Ostap Benko. All rights reserved.
//

import Foundation
import SceneKit


class ObstacleFactory{
    var firstPattern : [SCNNode] = []
    var secondPattern : [SCNNode] = []
    var patterns : [[SCNNode]]
    init(){
        patterns = [[SCNNode]]()
        setupFirstPattern()
        patterns.append(firstPattern)
        patterns.append(secondPattern)
    }
    
    func randomPattern() -> [SCNNode]{
        //let index = arc4random_uniform(UInt32(patterns.count))
        //return patterns[Int(index)]
        return patterns[0]
    }
    
    func setupFirstPattern(){
        let obstacle1 = SCNNode(geometry: SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle1.position = SCNVector3(x: -1.5, y: 1.0, z: 20.0)
        let obstacle2 = SCNNode(geometry: SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle2.position = SCNVector3(x: 1.5, y: 1.0, z: 16.0)
        let obstacle3 = SCNNode(geometry: SCNBox(width: 3.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle3.position = SCNVector3(x: 1.0, y: 1.0, z: 12.0)
        let obstacle4 = SCNNode(geometry: SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle4.position = SCNVector3(x: 2.0, y: 1.0, z: 8.0)
        let obstacle5 = SCNNode(geometry: SCNBox(width: 3.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle5.position = SCNVector3(x: 0.0, y: 1.0, z: 4.0)
        let obstacle6 = SCNNode(geometry: SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle6.position = SCNVector3(x: -1.5, y: 1.0, z: 0.0)
        let obstacle7 = SCNNode(geometry: SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0))
        obstacle7.position = SCNVector3(x: 1.5, y: 1.0, z: 0.0)
        firstPattern = [SCNNode]()
        firstPattern.append(obstacle1)
        firstPattern.append(obstacle2)
        firstPattern.append(obstacle3)
        firstPattern.append(obstacle4)
        firstPattern.append(obstacle5)
        firstPattern.append(obstacle6)
        firstPattern.append(obstacle7)
    }
}
