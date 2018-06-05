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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
    }
    
    func setupView(){
        self.scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
    }
    func setupScene(){
        self.scnScene = SCNScene()
        self.scnView.scene = scnScene
        scnScene.background.contents = UIColor.cyan
    }
    func setupCamera(){
        self.cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 10)
        self.scnScene.rootNode.addChildNode(cameraNode)
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}
