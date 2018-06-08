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

enum GameState{
    case tapToPlay
    case gameOver
    case playing
}

enum MoveState{
    case canMove
    case isMoving
}
class GameViewController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var floarNode: SCNNode!
    var cameraNode: SCNNode!
    var lightNode: SCNNode!
    var cubeNode: SCNNode!
    var obstacleFactory: ObstacleFactory!
    let startCubePosition = SCNVector3(x: 0.0, y: 0.9, z: -14.0)
    let startObstaclePosition : SCNVector3 = SCNVector3(x: 0.0, y: 1.0, z: -100.0)
    let speed = 0.1
    let duration = 0.3
    let trackVectors: [Double] = [-2, -1, 0, 1, 2]
    var curentTrack: Int = 2
    var score = 0
    var play = false
    var gameOver = false
    var moveFlag = true
    var state: GameState = .tapToPlay
    var moveState: MoveState  = .isMoving
    var moveTime: TimeInterval = 0
    var spawnTime: TimeInterval = 0
    var obstacles: [SCNNode] = []
    var lblStart: UILabel!
    var lblScore: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        setFloar()
        setupLight()
        spawnCube()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //MARK:Setup
    func setupView(){
        self.scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        //scnView.allowsCameraControl = true
        scnView.delegate = self
        scnView.isPlaying = true
        setupLabels()
    }
    func setupScene(){
        self.scnScene = SCNScene()
        self.scnView.scene = scnScene
        scnScene.physicsWorld.contactDelegate = self
        let imageUrl = Bundle.main.url(forResource: "background", withExtension: "jpg")
        scnScene.background.contents = UIImage(named: "background.jpg")
    }
    func setupCamera(){
        self.cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        let constraint = SCNLookAtConstraint(target: cubeNode)
        cameraNode.position = SCNVector3(x: 0.0, y: 3.0, z: -3.0)
        cameraNode.constraints = [constraint]
        cameraNode.camera?.zFar = 70.0
        self.scnScene.rootNode.addChildNode(cameraNode)
    }
    func setupLight(){
        let light = SCNLight()
        light.type = .spot
        light.spotInnerAngle = 30.0
        light.spotOuterAngle = 80.0
        light.castsShadow = true
        self.lightNode = SCNNode()
        lightNode.position = SCNVector3(x: 3, y: 5.0, z: 0.0)
        let constraint = SCNLookAtConstraint(target: cubeNode)
        lightNode.constraints = [constraint]
        lightNode.light = light
        self.scnScene.rootNode.addChildNode(lightNode)
        let omniLight = SCNLight()
        omniLight.type = .omni
        omniLight.castsShadow = true
        omniLight.intensity = 2500.0
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(x: 10.0, y: 3.0, z: 0.0)
        self.scnScene.rootNode.addChildNode(omniLightNode)
    }
    func setFloar(){
        let floarGeometry = SCNBox(width: 5.0, height: 1.0, length: 100.0, chamferRadius: 0.0)
        self.floarNode = SCNNode(geometry: floarGeometry)
        floarNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floarNode.position = SCNVector3(x: 0.0, y:0.0, z: -50.0)
        self.scnScene.rootNode.addChildNode(floarNode)
    }
    func setupObstacleFactory(){
        self.obstacleFactory = ObstacleFactory()
    }
    func setupLabels(){
        self.lblStart = UILabel()
        lblStart.text = "Tap to start"
        lblStart.contentMode = .center
        let lblStartPosition = CGRect(x: 0.0, y: 55.0, width: self.view.bounds.width, height: 20.0)
        lblStart.frame = lblStartPosition
        lblStart.textAlignment = .center
        lblStart.textColor = UIColor.black
        lblStart.alpha = 1.0
        self.scnView.addSubview(self.lblStart)
        self.lblScore = UILabel()
        lblScore.text = String(score)
        lblScore.contentMode = .center
        let lblScorePosition = CGRect(x: 0.0, y: 75.0, width: self.view.bounds.width, height: 20.0)
        lblScore.frame = lblScorePosition
        lblScore.textAlignment = .center
        lblScore.textColor = UIColor.black
        lblScore.alpha = 1.0
        lblScore.isHidden = true
        self.scnView.addSubview(lblScore)
    }
    func spawnCube(){
        cubeNode = Cube.spawnCubeAt(startCubePosition)
        self.scnScene.rootNode.addChildNode(cubeNode)
    }
    //MARK: Obstacles
    func spawnPattern(){
        self.obstacleFactory = ObstacleFactory()
        for node in self.obstacleFactory.randomPattern(){
            node.geometry?.materials.first?.diffuse.contents = UIColor.darkGray
            node.position.z += -100
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            physicsBody.mass = 50.0
            physicsBody.contactTestBitMask = physicsBody.collisionBitMask
            node.physicsBody = physicsBody
            self.scnScene.rootNode.addChildNode(node)
            self.obstacles.append(node)
        }
    }
    func moveObstacle(_ obstacle: SCNNode){
        let position = obstacle.position
        let vector = SCNVector3(position.x, position.y, position.z + 1)
        let actionMove = SCNAction.move(to: vector, duration: self.speed)
        obstacle.runAction(actionMove)

    }
    //MARK: Cube operation
    func jump(){
        moveState = .isMoving
        cubeNode.physicsBody?.isAffectedByGravity = false
        let position = cubeNode.position
        let up = SCNAction.move(to: SCNVector3(Double(position.x), 3.0, Double(startCubePosition.z)), duration: 0.3)
        let down = SCNAction.move(to: SCNVector3(Double(position.x), 1.0, Double(startCubePosition.z)), duration: 0.3)
        up.timingMode = .easeOut
        down.timingMode = .easeIn
        let jump = SCNAction.sequence([up, down])
        let rotate = cubeRotation(direction: .forward)
        let action = SCNAction.group([rotate, jump])
        cubeNode.runAction(action, completionHandler: {
            () -> Void in
            self.moveState = .canMove
            self.cubeNode.physicsBody?.isAffectedByGravity = true
        })
    }
    func returnToTrack() -> SCNAction{
        let returnAction = SCNAction.move(to: SCNVector3(trackVectors[curentTrack], Double(startCubePosition.y), Double(startCubePosition.z)), duration: 0.01)
        return returnAction
    }
    func cubeRotation(direction: Direction) -> SCNAction{
        let position = cubeNode.position
        var around: SCNVector3
        var to: SCNVector3
        switch direction{
        case .forward:
            around = SCNVector3(-1.0, 0.0, 0.0)
            to = position
            break
        case .left:
            if curentTrack - 1 < 0{
                return SCNAction()
            } else {
                curentTrack -= 1
                around = SCNVector3(0.0, 0.0, 1.0)
                to = SCNVector3(trackVectors[curentTrack], Double(position.y), Double(position.z))
                break
            }
        case .right:
            if curentTrack + 1 > 4{
                return SCNAction()
            } else {
                curentTrack += 1
                around = SCNVector3(0.0, 0.0, -1.0)
                to = SCNVector3(trackVectors[curentTrack], Double(position.y), Double(position.z))
                break
            }
        }
        var rotate: SCNAction
        if direction == .forward{
            rotate = SCNAction.rotate(by: CGFloat(90 * Float.pi / 180), around: around, duration: 0.6)
        } else {
            rotate = SCNAction.rotate(by: CGFloat(90 * Float.pi / 180), around: around, duration: self.duration)
        }
        let move = SCNAction.move(to: to, duration: self.duration)
        let group = SCNAction.group([rotate, move])
        return group
    }
    //MARK: Reset
    func resetVariables(){
        curentTrack = 2
        score = 0
        play = false
        gameOver = false
        moveFlag = true
        state = .tapToPlay
        moveState = .isMoving
        moveTime = 0
        spawnTime = 0
        obstacles = [SCNNode]()
    }
    func resetFloar(){
        let floarGeometry = SCNBox(width: 5.0, height: 1.0, length: 100.0, chamferRadius: 0.0)
        self.floarNode = SCNNode(geometry: floarGeometry)
        floarNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floarNode.position = SCNVector3(x: 0.0, y:0.0, z: -50.0)
        self.scnScene.rootNode.addChildNode(floarNode)
    }
    func resetCube(){
        cubeNode.removeAllActions()
        spawnCube()
    }
    func resetCamera(){
        setupCamera()
    }
    func resetLight(){
        setupLight()
    }
    func resetLabels(){
        self.lblScore.text = ""
        self.lblStart.text = "Tap to start"
    }
    func resetScene() {
        for node in self.scnScene.rootNode.childNodes{
            node.removeFromParentNode()
        }
        resetCube()
        resetFloar()
        resetLight()
        resetCamera()
        resetLabels()
        resetVariables()
    }
    func reset(){
        resetScene()
    }
    func scale(node: SCNNode, size: CGFloat) -> Void{
        if let geometry = node.geometry as? SCNBox{
            geometry.height *= 0.5
            geometry.width *= 0.5
            geometry.length *= 0.5
        }
    }
    //MARK: @IBAction
    @IBAction func moveRight(_ sender: UISwipeGestureRecognizer) {
        if moveState == .canMove{
            moveState = .isMoving
            let rotate = self.cubeRotation(direction: .right)
            let returnToTrack = self.returnToTrack()
            let action = SCNAction.sequence([rotate, returnToTrack])
            cubeNode.runAction(action, completionHandler: {self.moveState = .canMove})
            print(cubeNode.position)
        }
    }
    @IBAction func moveLeft(_ sender: UISwipeGestureRecognizer) {
        if moveState == .canMove{
            moveState = .isMoving
            let rotate = self.cubeRotation(direction: .left)
            let returnToTrack = self.returnToTrack()
            let action = SCNAction.sequence([rotate, returnToTrack])
            cubeNode.runAction(action, completionHandler: {self.moveState = .canMove})
            print(cubeNode.position)
        }
    }
    @IBAction func tapStart(_ sender: UITapGestureRecognizer) {
        switch moveState {
        case .canMove:
            jump()
            break
        case .isMoving:
            break
        }
        
        switch state {
        case .tapToPlay:
            state = .playing
            moveState = .canMove
            spawnPattern()
            self.lblStart.isHidden = true
            self.lblScore.isHidden = false
            break
        case .gameOver:
            reset()
            break
        default:
            break
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if state == .playing {
            let moveTimeDif = time - moveTime
            if Double(moveTimeDif) > speed{
                DispatchQueue.main.async {
                    self.score += 1
                    self.lblScore.text = String(self.score)
                }
                for obstacle in obstacles{
                    moveObstacle(obstacle)
                }
                moveTime = time
            }
            if let obstacle = obstacles.last{
                if Double(obstacle.position.z) > -50.0{
                    spawnPattern()
                }
            }
            for node in self.scnScene.rootNode.childNodes {
                if node.position.z > 0{
                    node.removeFromParentNode()
                }
            }
            if let obstacle = obstacles.first{
                if Double(obstacle.position.z) > 0.0{
                }
                if obstacle.position.z > 0{
                    obstacles.removeFirst()
                }
            }
        }
    }

}

extension GameViewController: SCNPhysicsContactDelegate{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA == self.floarNode || contact.nodeB == self.floarNode){
            return
        } else {
            #if DEBUG
                //print("contact")
            #endif
            DispatchQueue.main.async {
                self.state = .gameOver
                self.moveState = .isMoving
                self.lblScore.isHidden = true
                self.lblStart.isHidden = false
                self.lblStart.text = "Game over"
            }
        }
    }
}



