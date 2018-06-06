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
    let startCubePosition = SCNVector3(x: 0.0, y: 1.0, z: -3.0)
    let startObstaclePosition : SCNVector3 = SCNVector3(x: 0.0, y: 1.0, z: -100.0)
    let speed = 0.3
    var start = true
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
    }
    
    func setupView(){
        self.scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        //scnView.allowsCameraControl = true
        scnView.delegate = self
        scnView.isPlaying = true
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
        lightNode.position = SCNVector3(x: 10.0, y: 3.0, z: 0.0)
        lightNode.light = light
        self.scnScene.rootNode.addChildNode(lightNode)
    }
    func setupObstacleFactory(){
        self.obstacleFactory = ObstacleFactory()
    }
    func spawnCube(){
//        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
//        boxGeometry.materials.first?.diffuse.contents = UIColor.green
//        self.cubeNode = SCNNode(geometry: boxGeometry)
//        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
//        cubeNode.position = self.startCubePosition
        cubeNode = Cube.spawnCubeAt(startCubePosition)
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
        print("Spawn pattern")
        self.obstacleFactory = ObstacleFactory()
        var startPosition = self.startObstaclePosition
        for node in self.obstacleFactory.randomPattern(){
            self.obstacles.append(node)
        }
        for node in obstacles{
            node.position.z += -100
            print(startPosition.z)
            node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//            if let box = node.geometry as? SCNBox{
//                startPosition.z -= Float(box.length) - 4.0
//            }
            self.scnScene.rootNode.addChildNode(node)
        }
//        let geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
//        let newNode = SCNNode(geometry: geometry)
//        newNode.position = startObstaclePosition
//        newNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        obstacles.append(newNode)
//        self.scnScene.rootNode.addChildNode(newNode)
    }
    func forceCube(){
        let force = SCNVector3(0.0, 1.5, 0.0)
        let position = SCNVector3(1.0, 0.0, 0.0)
        self.cubeNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
    }
    func moveObstacle(_ obstacle: SCNNode){
        let position = obstacle.position
        let vector = SCNVector3(position.x, position.y, position.z + 1)
        let actionMove = SCNAction.move(to: vector, duration: self.speed)
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
//        for index in 0..<obstacles.count{
//            if obstacles[index].position.z > 47.0{
//                obstacles[index].removeFromParentNode()
//                obstacles.remove(at: index)
//                print("Remove node")
//            }
//        }
        
//        if let obstacle = obstacles.first{
//            if Double(obstacle.position.z) > -10.0{
//                //print(obstacle.position.x.description + "\t" + obstacle.position.y.description + "\t" + obstacle.position.z.description)
//                print("Remove time")
//                for obstacle in obstacles{
//                    obstacle.removeFromParentNode()
//                }
//            }
//        }
        if let obstacle = obstacles.last{
            if Double(obstacle.position.z) > 0.0{
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
        floarNode.position = SCNVector3(x: 0.0, y:0.0, z: -50.0)
        self.scnScene.rootNode.addChildNode(floarNode)
    }
    @IBAction func moveRight(_ sender: UISwipeGestureRecognizer) {
        self.cubeRotation(direction: .right)
    }
    @IBAction func moveLeft(_ sender: UISwipeGestureRecognizer) {
        self.cubeRotation(direction: .left)
    }
    @IBAction func tapStart(_ sender: UITapGestureRecognizer) {
        //if start == true{
            //spawnPattern()
            //start = false
        //}
    }
}

extension GameViewController: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let moveTimeDif = time - moveTime
        let spawnTimeDif = time - spawnTime
        //print(spawnTimeDif)
        if Double(moveTimeDif) > speed{
            //cubeRotation(direction: .forward)
            for obstacle in obstacles{
                moveObstacle(obstacle)
//                if Double(obstacle.position.z) > 0.0{
//                    obstacle.removeFromParentNode()
//                    print(obstacles.count)
//                    obstacles.popLast()
//                    print(obstacles.count)
//                }
            }
            moveTime = time
        }
        if Double(spawnTimeDif) > 7.5{
            print("Spawn Time")
            spawnPattern()
            spawnTime = time
        }
//        if let obstacle = obstacles.first{
//            if Double(obstacle.position.z) > -24.0{
//                print("Spawn time")
//                spawnPattern()
//            }
//        }
        for node in self.scnScene.rootNode.childNodes {
            if node.position.z > 0{
                node.removeFromParentNode()
            }
        }
        if let obstacle = obstacles.last{
            if obstacle.position.z > 0{
                obstacles.popLast()
                print(obstacles.count)
            }
        }
    }

}



