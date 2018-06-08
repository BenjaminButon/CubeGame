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
    let height: CGFloat = 0.8
    let length: CGFloat = 0.5
    var pattern01 : [SCNNode] = []
    var pattern02 : [SCNNode] = []
    var patterns : [[SCNNode]]
    init(){
        patterns = [[SCNNode]]()
        setupPattern01()
        setupPattern02()
        patterns.append(pattern01)
        patterns.append(pattern02)
    }
    
    func randomPattern() -> [SCNNode]{
//        let index = arc4random_uniform(UInt32(patterns.count))
//        return patterns[Int(index)]
        return patterns[0]
    }
    
    func setupPattern01(){
        let obstacle1 = SCNNode(geometry: SCNBox(width: 2.0, height: height, length: length, chamferRadius: 0.0))
        obstacle1.position = SCNVector3(x: -1.5, y: Float(height), z: 40.0)
        let obstacle2 = SCNNode(geometry: SCNBox(width: 2.0, height: height, length: length, chamferRadius: 0.0))
        obstacle2.position = SCNVector3(x: 1.5, y: Float(height), z: 32.0)
        let obstacle3 = SCNNode(geometry: SCNBox(width: 3.0, height: height, length: length, chamferRadius: 0.0))
        obstacle3.position = SCNVector3(x: 1.0, y: Float(height), z: 24.0)
        let obstacle4 = SCNNode(geometry: SCNBox(width: 1.0, height: height, length: length, chamferRadius: 0.0))
        obstacle4.position = SCNVector3(x: 2.0, y: Float(height), z: 16.0)
        let obstacle5 = SCNNode(geometry: SCNBox(width: 3.0, height: height, length: length, chamferRadius: 0.0))
        obstacle5.position = SCNVector3(x: 0.0, y: Float(height), z: 8.0)
        let obstacle6 = SCNNode(geometry: SCNBox(width: 2.0, height: height, length: length, chamferRadius: 0.0))
        obstacle6.position = SCNVector3(x: -1.5, y: Float(height), z: 0.0)
        let obstacle7 = SCNNode(geometry: SCNBox(width: 2.0, height: height, length: length, chamferRadius: 0.0))
        obstacle7.position = SCNVector3(x: 1.5, y: Float(height), z: 0.0)
        pattern01 = [SCNNode]()
        pattern01.append(obstacle1)
        pattern01.append(obstacle2)
        pattern01.append(obstacle3)
        pattern01.append(obstacle4)
        pattern01.append(obstacle5)
        pattern01.append(obstacle6)
        pattern01.append(obstacle7)
    }
    
    func setupPattern02(){
        let obstacle1 = SCNNode(geometry: SCNBox(width: 2.0, height: height, length: length, chamferRadius: 0.0))
        obstacle1.position = SCNVector3(x: -1.5, y: Float(height), z: 40.0)
        let obstacle2 = SCNNode(geometry: SCNBox(width: 2.0, height: height, length: length, chamferRadius: 0.0))
        obstacle2.position = SCNVector3(x: 1.5, y: Float(height), z: 40.0)
        let obstacle3 = SCNNode(geometry: SCNBox(width: 5.0, height: height, length: length, chamferRadius: 0.0))
        obstacle3.position = SCNVector3(x: 0.0, y: Float(height), z: 32.0)
        let obstacle4 = SCNNode(geometry: SCNBox(width: 1.0, height: height, length: length, chamferRadius: 0.0))
        obstacle4.position = SCNVector3(x: -2.0, y: Float(height), z: 24.0)
        let obstacle5 = SCNNode(geometry: SCNBox(width: 1.0, height: height, length: length, chamferRadius: 0.0))
        obstacle5.position = SCNVector3(x: 0.0, y: Float(height), z: 24.0)
        let obstacle6 = SCNNode(geometry: SCNBox(width: 1.0, height: height, length: length, chamferRadius: 0.0))
        obstacle6.position = SCNVector3(x: 2.0, y: Float(height), z: 24.0)
        let obstacle7 = SCNNode(geometry: SCNBox(width: 3.0, height: height, length: length, chamferRadius: 0.0))
        obstacle7.position = SCNVector3(x: -1.0, y: Float(height), z: 16.0)
        let obstacle8 = SCNNode(geometry: SCNBox(width: 3.0, height: height, length: length, chamferRadius: 0.0))
        obstacle8.position = SCNVector3(x: 0.75, y: Float(height), z: 16.0)
        let obstacle9 = SCNNode(geometry: SCNBox(width: 5.0, height: height, length: length, chamferRadius: 0.0))
        obstacle9.position = SCNVector3(x: 0.0, y: Float(height), z: 8.0)
        let obstacle10 = SCNNode(geometry: SCNBox(width: 5.0, height: height, length: length, chamferRadius: 0.0))
        obstacle10.position = SCNVector3(x: 0.0, y: Float(height), z: 0.0)
        pattern02 = [SCNNode]()
        pattern02.append(obstacle1)
        pattern02.append(obstacle2)
        pattern02.append(obstacle3)
        pattern02.append(obstacle4)
        pattern02.append(obstacle5)
        pattern02.append(obstacle6)
        pattern02.append(obstacle7)
        pattern02.append(obstacle8)
        pattern02.append(obstacle9)
        pattern02.append(obstacle10)
    }
}

