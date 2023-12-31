//
//  ViewController.swift
//  mapaclick
//
//  Created by javier pizarro on 9/21/23.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let practiceRandomGame = PracticeRandomGame(size: view.bounds.size)
        //let gameOverScene = GameOverScene(size: view.bounds.size)
        //let practiceAlphabeticGame = PracticeAlphabeticGame(size: view.bounds.size)
        //let randomGame = RandomGame(size: view.bounds.size)
        let startMenu = StartMenuScene(size: view.bounds.size)
        //let instructions = Instructions(size: view.bounds.size)
        //let startScene = StartScene(size: view.bounds.size)/*startScene() call object size to be same as the view and assigned to*/
        let skView = view as! SKView/*it cast(change) default view(UIView) to an SKView. For this line to work we needed before hand to define under
         custom class the class SKView as we already do. Otherwise the app will crash.*/
        
        //skView.showsFPS = true//frame per seconds indicator
        //skView.showsPhysics = true//enables the usage of SKPhysicsBody properties,without this SKPhysicsBody will not work
        //skView.showsNodeCount = true
        //skView.presentScene(startMenu)//present scene on a skView    }
        skView.presentScene(startMenu)
    }


}

