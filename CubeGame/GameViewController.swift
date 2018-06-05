//
//  GameViewController.swift
//  CubeGame
//
//  Created by Benko Ostap on 05.06.18.
//  Copyright © 2018 Ostap Benko. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var cubeNode: SCNNode!
    var obstacleFactory: ObstacleFactory!
    var obstacles: [SCNNode] = []
    var moveTime: TimeInterval = 0
    var spawnTime: TimeInterval = 0
    let startCubePosition = SCNVector3(x: 0.0, y: 1.0, z: 43.0)
    let startObstaclePosition : SCNVector3 = SCNVector3(x: 0.0, y: 0.0, z: 15.0)
    let trackVectors: [SCNVector3] = [SCNVector3(x: -2.0, y: 1.0, z: 43.0),
                                      SCNVector3(x: -1.0, y: 1.0, z: 43.0),
                                      SCNVector3(x: 0.0, y: 1.0, z: 43.0),
                                      SCNVector3(x: 1.0, y: 1.0, z: 43.0),
                                      SCNVector3(x: 2.0, y: 1.0, z: 43.0)]
    var curentTrack: Int = 2
    let duration = 0.3
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        setFloar()
        setupLight()
        spawnCube()
        setupObstacleFactory()
        spawnPattern()
    }
    
    func setupView(){
        self.scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        //scnView.allowsCameraControl = true
        scnView.delegate = self
    }
    func setupScene(){
        self.scnScene = SCNScene()
        self.scnView.scene = scnScene
        scnScene.background.contents = UIColor.cyan
    }
    func setupCamera(){
        self.cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0.0, 3.0, 50.0)
        self.scnScene.rootNode.addChildNode(cameraNode)
    }
    func setupLight(){
        let light = SCNLight()
        light.type = .omni
        light.intensity = 5000.0
        let lightNode = SCNNode()
        lightNode.position = SCNVector3(x: 10.0, y: 3.0, z: 50.0)
        lightNode.light = light
        self.scnScene.rootNode.addChildNode(lightNode)
    }
    func setupObstacleFactory(){
        self.obstacleFactory = ObstacleFactory()
    }
    func spawnCube(){
        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        boxGeometry.materials.first?.diffuse.contents = UIColor.green
        self.cubeNode = SCNNode(geometry: boxGeometry)
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cubeNode.position = self.startCubePosition
        self.scnScene.rootNode.addChildNode(cubeNode)
    }
    func spawnObstacle(){
        let geometry = SCNBox(width: 2.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        geometry.materials.first?.diffuse.contents = UIColor.blue
        let obstacle = SCNNode(geometry: geometry)
        obstacle.position = SCNVector3(x: -1.5, y: 1.0, z: 30.0)
        obstacle.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        self.obstacles.append(obstacle)
        self.scnScene.rootNode.addChildNode(obstacle)
    }
    func spawnPattern(){
        var startPosition = self.startObstaclePosition
        self.obstacles = self.obstacleFactory.randomPattern()
        for node in obstacles{
            node.position.z += startPosition.z
            node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            if let box = node.geometry as? SCNBox{
                startPosition.z += Float(box.length) + 4.0
            }
            self.scnScene.rootNode.addChildNode(node)
        }
    }
    func forceCube(){
        let force = SCNVector3(0.0, 1.5, 0.0)
        let position = SCNVector3(1.0, 0.0, 0.0)
        self.cubeNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
    }
    func moveObstacle(_ obstacle: SCNNode){
        let position = obstacle.position
        let vector = SCNVector3(position.x, position.y, position.z + 1)
        let actionMove = SCNAction.move(to: vector, duration: self.duration)
        obstacle.runAction(actionMove)
    }
    func cubeRotation(direction: Direction){
        let position = cubeNode.position
        var around: SCNVector3
        var to: SCNVector3
        switch direction{
        case .forward:
            around = SCNVector3(1.0, 0.0, 0.0)
            to = position
            break
        case .left:
            if curentTrack - 1 < 0{
                return
            } else {
                curentTrack -= 1
                around = SCNVector3(0.0, 0.0, 1.0)
                to = trackVectors[curentTrack]
                break
            }
        case .right:
            if curentTrack + 1 > 4{
                return
            } else {
                curentTrack += 1
                around = SCNVector3(0.0, 0.0, -1.0)
                to = trackVectors[curentTrack]
                break
            }
        }
        let rotate = SCNAction.rotate(by: CGFloat(90 * Float.pi / 180), around: around, duration: self.duration)
        let move = SCNAction.move(to: to, duration: self.duration)
        if direction == .left || direction == .right{
            self.cubeNode.removeAllActions()
        }
        let group = SCNAction.group([rotate, move])
        cubeNode.runAction(group)
    }
    func cleaneScene(){
        for obstacle in obstacles{
            if obstacle.position.z > 47.0{
                obstacle.removeFromParentNode()
            }
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func setFloar(){
        let floarGeometry = SCNBox(width: 5.0, height: 1.0, length: 100.0, chamferRadius: 0.0)
        let floarNode = SCNNode(geometry: floarGeometry)
        floarNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        self.scnScene.rootNode.addChildNode(floarNode)
    }
    @IBAction func moveRight(_ sender: UISwipeGestureRecognizer) {
        self.cubeRotation(direction: .right)
    }
    @IBAction func moveLeft(_ sender: UISwipeGestureRecognizer) {
        self.cubeRotation(direction: .left)
    }
}

extension GameViewController: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let moveTimeDif = time - moveTime
        let spawnTimeDif = time - spawnTime
        if Double(moveTimeDif) > duration{
            //cubeRotation(direction: .forward)
            for obstacle in obstacles{
                moveObstacle(obstacle)
            }
            moveTime = time
        }
        if Double(spawnTimeDif) > 1.5{
            //spawnObstacle()
            spawnTime = time
        }
        cleaneScene()
    }
}



