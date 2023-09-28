//
//  GameOverScene.swift
//  mapaclick
//
//  Created by javier pizarro on 9/25/23.
//

import Foundation
import SpriteKit
//import UIKit
import AVFoundation

class GameOverScene: SKScene{
    //var arrayOfMapSpriteNodes = [SKSpriteNode()]
    //var twoLineText: String = ""//se usa solo en las dos funciones splitTextIntoFields puedo declararla en ambas funciones de manera local
    //var useLine2:Bool = false//se usa en mas de una funcion
    let mapRectangleGestureMGMT: SKSpriteNode = GameSceneObjects().mapRectangleGestureMGMTBezierPathToSKSpriteNode(bpRectangle: BezierPathsForMapNodesAndRectangles().createRectangle())//This Node is invisible, it works by parenting containeNode and applying handgestures as SKNode have no anchor point property which is needed to be set at 0.5 for the pinch gesture to be able to zoom and be centered
    let containerNode = InitSetMapNodes().initSetcontainerNodeAndChildren()
    var gameOverSceneWasAdded = true
    let endGameRectangle = GameOverObjects().endGameRectangleBezierPathToSKSpriteNode(bpEndGameRectangle: GameOverObjects().createEndGameRectangle())
    let endGameRectangleButton = GameOverObjects().endGameRectangleMapButtonBezierPathToSKSpriteNode(bpEndGameRectangleButton:GameOverObjects().createEndGameRectangleSidesButtons())
    let endGameRectangleButtonTwo = GameOverObjects().endGameRectangleJugarOtraButtonBezierPathToSKSpriteNode(bpEndGameRectangleButton:GameOverObjects().createEndGameRectangleMiddleButton())
    let endGameRectangleButtonThree = GameOverObjects().endGameRectangleSalirButtonBezierPathToSKSpriteNode(bpEndGameRectangleButton:GameOverObjects().createEndGameRectangleSidesButtons())
    let resultadosButton = GameOverObjects().redButtonBpDrawToSKSpriteNode()
    let labelOne = SKLabelNode(); let labelTwo = SKLabelNode(); let labelThree = SKLabelNode(); let labelFour = SKLabelNode();  let labelFive = SKLabelNode();  let labelSix = SKLabelNode()
    let labelSeven = SKLabelNode(); let labelEight = SKLabelNode(); let labelNine = SKLabelNode(); let labelTen = SKLabelNode()
    var playagain: Bool = false
    var exited:Bool = false
    let fanfair = SKAction.playSoundFileNamed("cartoon_success_fanfair 1", waitForCompletion: false)
    //let backgroundMusic = SKAudioNode(fileNamed: "predited.mp3")
    var musicPlayer = AVAudioPlayer()
    let musicURL:URL? = Bundle.main.url(forResource:"predited", withExtension:"mp3")//reference to PR Himn
    var isScaled = false
    
    let screenSize = UIScreen.main.nativeBounds
    
    override func didMove(to view: SKView) {
        //PracticeAlphabeticGame.completedGame = true
        
        if StartMenuScene.gamePlaySoundOn == true{
            run(fanfair)
        }
        
        self.backgroundColor = UIColor.init(red: 0.2588, green: 0.7608, blue: 1, alpha: 1.0)
        
        //mapRectangleGestureMGMT.zPosition = 0
        mapRectangleGestureMGMT.anchorPoint = CGPoint(x:0.5, y:0.5)
        //mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.8)
        
        //containerNode.zPosition = -1
        containerNode.position = CGPoint(x:-280, y:-190)//CGPoint(x:self.size.width/2 - 285, y:self.size.height/2 - 175) /*CGPoint(x:-275 , y:-75 /*15*/)*//**Sknode containing(children) map sprites, desecheo cover(node whose only job is to hid desecheo island, rectangular frames)*/
        
        //endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 16)
        endGameRectangle.zPosition = 1
        setEndgameRectangleLabels()
        //containerNode.position = CGPoint(x:self.size.width/2 - 285, y:self.size.height/2 - 175)
        //setEndGameRectangleMapButtonAndLabels()
        //resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 102)
        
        //print("Screen size: \(screenSize)")
        switch (screenSize.width, screenSize.height) {
            
            case (2048.0, 2732.0):
                 //print("Pro12.9(3gen), Pro12.9(4gen), Pro12.9(5gen), Pro12.9(6gen) ")
                 setScaleAndIndepRenderingPositioningForIpadsLargeScreenSizes()
           
            case (1536.0, 2048.0),(1488.0, 2266.0) :
                 //print("iPad 6Gen, Mini(5gen), Mini(6gen) ")
                 setScaleAndIndepRenderingPositioningForIpadsSmallScreenSizes()
            
            case (1668.0, 2224.0), (1668.0, 2388.0), (1620.0, 2160.0),(1640.0, 2360.0):
                //print("iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen) ")
                setScaleAndIndepRenderingPositioningForIpadsMediumScreenSizes()
            
            case (750.0, 1334), (1080, 2340 ),(1125, 2436 ) :
                //print("iPhoneSE3, SE2, 8, mini12, mini13, iPhone X, XS ,11PRO")
                setScaleAndIndepRenderingPositioningForSmallScreenSizes()
            
            case (1242.0, 2208.0), (828.0, 1792.0 ),(1242.0, 2688.0 ) :
                //print("iPhone 8plus, XR, 11, XSMax, 11ProMax")
                setScaleAndIndepRenderingPositioningForMediumLargeScreenSizes()
            
           case (1170.0, 2532.0), (1179.0, 2556.0):
                //print("iPhone 12, 12Pro, 13, 13Pro, 14, 14Pro")
                setScaleAndIndepRenderingPositioningForLargeScreenSizes()
            
           case (1284.0, 2778.0), (1290.0, 2796.0):
                //print("iPhone 12ProMax, 13ProMax, 14plus, 13Pro, 14ProMax")
                setScaleAndIndepRenderingPositioningForXtraLargeScreenSizes()
        
            default:
               setScaleAndIndepRenderingPositioningForSmallScreenSizes()//This line will catch any device which screen measure is none of the above
                break
        }
        
        
        if RandomGameScene.completedGame == true{
            secondsAndMinutesBestTimesAssesmentAndRecordStatusAndTimesRenderingRandom(second:RandomGameScene.secondsGameOver,minute:RandomGameScene.minutesGameOver)
        }
        else if AlphabeticGameScene.completedGame{
            secondsAndMinutesBestTimesAssesmentAndRecordStatusAndTimesRenderingAlphabetic(second:AlphabeticGameScene.secondsGameOver,minute:AlphabeticGameScene.minutesGameOver)
        }
        
        
        endGameRectangle.addChild(endGameRectangleButton)
        endGameRectangle.addChild(endGameRectangleButtonTwo)
        endGameRectangle.addChild(endGameRectangleButtonThree)
        
        addChildSKNodeToParentSKSpriteNode(parent:mapRectangleGestureMGMT, children:containerNode)
        addChildSKSpriteNodeToParentself(children:mapRectangleGestureMGMT)
        //self.addChild(containerNode)
        self.addChild(endGameRectangle)
        
        //set an call hand gesture recognizers
        let pinchRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action: #selector(self.handlePinchFrom(_:)))
        self.view!.addGestureRecognizer(pinchRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        // Add the gesture recognizer to the scene's view
        self.view!.addGestureRecognizer(panGestureRecognizer)
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRecognizer)
        
        
        //musicURL = Bundle.main.url(forResource:"predited", withExtension:"mp3")
        if StartMenuScene.backgroundMusicOn == true{
            //self.addChild(StartScene.backgroundMusic)
            initMusic()
        }
    }
    
    func setScaleAndIndepRenderingPositioningForIpadsLargeScreenSizes(){
        //print("Set gameOverScene objts scaling and positioning for: iPads Pro12.9(3gen), Pro12.9(4gen), Pro12.9(5gen), Pro12.9(6gen) IpadsLargeScreenSizes scaling and positioning func")
        //print("Ipads Large Screen Sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)
        //mapRectangleGestureMGMT.setScale(1.90)//1.38
        mapRectangleGestureMGMT.setScale(2.4)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 18)
        endGameRectangle.setScale(2.5)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 303)
        resultadosButton.setScale(2.8)
    }
    
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForIpadsSmallScreenSizes(){
        //print("Set gameOverScene objts scaling and positioning for: iPad 6Gen, Mini(5gen), Mini(6gen) entering IpadsSmallScreenSizes scaling and positioning func")
        //print("Ipads Small Screen Sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)
        //mapRectangleGestureMGMT.setScale(1.90)//1.38
        mapRectangleGestureMGMT.setScale(1.85)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 10)
        endGameRectangle.setScale(1.8)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 240)
        resultadosButton.setScale(2.1)
        
        
    }
    
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForIpadsMediumScreenSizes(){
        //print("Set gameOverScene objts scaling and positioning for: iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen) entering iPad Medium size scaling and positioning func")
        //print("Ipads Medium Screen Sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)
        //mapRectangleGestureMGMT.setScale(1.90)//1.38
        mapRectangleGestureMGMT.setScale(1.85)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 10)
        endGameRectangle.setScale(2.0)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 240)
        resultadosButton.setScale(2.3)
        
        
    }
    
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForSmallScreenSizes(){
        //print("Set gameOverScene objts scaling and positioning for: iPhone SE3, SE2, 8, mini12, mini13, iPhone X, XS ,11PRO enter SmallScreenSizes scaling and positioning func")
        //print("iPhone small screen sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.755/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 18)
        endGameRectangle.setScale(1.25)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 133)
        resultadosButton.setScale(1.4)
    }
    
    func setScaleAndIndepRenderingPositioningForMediumLargeScreenSizes(){
        //print("Set  gameOverScene objts scaling and positioning for: iPhone 8plus, XR, 11, XSMax, 11ProMax enter MediumLargeScreenSizes scaling and positioning func")
        //print("iPhone medium-large screen sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.906/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 18)
        endGameRectangle.setScale(1.25)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 152)
        resultadosButton.setScale(1.4)
    }
    
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForLargeScreenSizes(){
        //print("Set gameOverScene objts scaling and positioning for: iPhone 12, 12Pro, 13, 13Pro, 14, 14Pro enter LargeScreenSizes scaling and positioning func")
        //print("iPhone large screen sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.811/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 18)
        endGameRectangle.setScale(1.25)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 142)
        resultadosButton.setScale(1.4)
    }
    
    func setScaleAndIndepRenderingPositioningForXtraLargeScreenSizes(){
        //print("Set gameOverScene objts scaling and positioning for: iPhone 12ProMax, 13ProMax, 14plus, 14ProMax enter XtraLargeScreenSizes scaling and positioning func ")
        //print("iPhone Xtralarge screen sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.975/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        endGameRectangle.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 18)
        endGameRectangle.setScale(1.25)
        
        resultadosButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 158)
        resultadosButton.setScale(1.4)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        //Asses screen
        let screenSize = self.view?.bounds.size
        let screenWidth = screenSize?.width ?? 0
        let screenHeight = screenSize?.height ?? 0
        
        //Apply min and max value to limit panning based on screen size
        let minX = screenWidth * 0.02
        let maxX = screenWidth * 0.99
        let minY = screenHeight * 0.1
        let maxY = screenHeight * 1.0//0.6
        
        //Flag variable allows pan only when zoom in have taken place
        if isScaled == true{
            /*var touchLocation: CGPoint = gesture.location(in: gesture.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            let moveAction = SKAction.move(to: touchLocation, duration: 0.5)
            moveAction.timingMode = .linear//.easeInEaseOut
            containerSKSPriteNode.run(moveAction)*/
            
            //Contraints for limiting panning
            let translation = gesture.translation(in: gesture.view)
            if mapRectangleGestureMGMT.position.x > maxX {
                mapRectangleGestureMGMT.position.x = maxX
            } else if mapRectangleGestureMGMT.position.x < minX {
                mapRectangleGestureMGMT.position.x = minX
            }

            if mapRectangleGestureMGMT.position.y > maxY {
                mapRectangleGestureMGMT.position.y = maxY
            } else if mapRectangleGestureMGMT.position.y < minY {
                mapRectangleGestureMGMT.position.y = minY
            }
            //pan execution
            mapRectangleGestureMGMT.position = CGPoint(x: mapRectangleGestureMGMT.position.x + translation.x, y: mapRectangleGestureMGMT.position.y - translation.y)
            gesture.setTranslation(.zero, in: view)
            
        }
       
    }
    
    @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        
        //The following block limits the scaling(Zoom effect) from 2.4(default size) and no larger than 3.0 for device iPad Pro12.9
        if screenSize.width == 2048.0 && screenSize.height == 2732.0{
            //print("iPad Pro12.9 entering handlePinch func")
            if mapRectangleGestureMGMT.xScale * sender.scale < 2.4 {
                sender.scale = 2.4 / mapRectangleGestureMGMT.xScale
            } else if mapRectangleGestureMGMT.xScale * sender.scale > 3.0 {
                sender.scale = 3.0 / mapRectangleGestureMGMT.xScale
            }
        
            if mapRectangleGestureMGMT.yScale * sender.scale < 2.4 {
                sender.scale = 2.4 / mapRectangleGestureMGMT.yScale
            } else if mapRectangleGestureMGMT.yScale * sender.scale > 3.0 {
            sender.scale = 3.0 / mapRectangleGestureMGMT.yScale
            }
        }
        //The following block limits the scaling(Zoom effect) from 1.85(default size) and no larger than 3.0 for device iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen), iPad 6Gen, Mini(5gen), Mini(6gen)
        else if screenSize.width == 1668 && screenSize.height == 2224 || screenSize.width == 1536.0 && screenSize.height == 2048.0 || screenSize.width == 1668.0 && screenSize.height == 2388.0 || screenSize.width == 2048.0 && screenSize.height == 2732.0 || screenSize.width == 1620.0 && screenSize.height == 2160.0 || screenSize.width == 1640.0 && screenSize.height == 2360.0 || screenSize.width == 1536.0 && screenSize.height == 2048.0 || screenSize.width == 1488.0 && screenSize.height == 2266.0{
            //print("iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen), iPad 6Gen, Mini(5gen), Mini(6gen) entering handlePinch func")
            if mapRectangleGestureMGMT.xScale * sender.scale < 1.85 {
                sender.scale = 1.85 / mapRectangleGestureMGMT.xScale
            } else if mapRectangleGestureMGMT.xScale * sender.scale > 3.0 {
                sender.scale = 3.0 / mapRectangleGestureMGMT.xScale
            }

            if mapRectangleGestureMGMT.yScale * sender.scale < 1.85 {
               sender.scale = 1.85 / mapRectangleGestureMGMT.yScale
            } else if mapRectangleGestureMGMT.yScale * sender.scale > 3.0 {
            sender.scale = 3.0 / mapRectangleGestureMGMT.yScale
            }
        }
        //The following block limits the scaling(Zoom effect) from 1.33(default size) and no larger than 3.0 for device
        else{
            //print("iPhone entering handlePinch func")
            if mapRectangleGestureMGMT.xScale * sender.scale < 1.33 {
                sender.scale = 1.33 / mapRectangleGestureMGMT.xScale
            } else if mapRectangleGestureMGMT.xScale * sender.scale > 3.0 {
                sender.scale = 3.0 / mapRectangleGestureMGMT.xScale
            }
            
            if mapRectangleGestureMGMT.yScale * sender.scale < 1.33 {
                sender.scale = 1.33 / mapRectangleGestureMGMT.yScale
            } else if mapRectangleGestureMGMT.yScale * sender.scale > 3.0 {
                sender.scale = 3.0 / mapRectangleGestureMGMT.yScale
            }
        }
        
        //Set scaling action
        let pinch = SKAction.scale(by: sender.scale, duration: 0.0)
        mapRectangleGestureMGMT.run(pinch)
        sender.scale = 1.00
        
        //Asses if the node is scaled or not(scaled to default size)
        if sender.state == .ended{
            
            if screenSize.width == 2048.0 && screenSize.height == 2732.0{
                if mapRectangleGestureMGMT.xScale > 2.4 && mapRectangleGestureMGMT.yScale > 2.4 {
                    isScaled = true
                    //print("iPad Pro12.9(3 to 6 Gen)(BIGGER Screen) scaled bigger")
                }
            }
            
            else if screenSize.width == 1668.0 && screenSize.height == 2224.0 || screenSize.width == 1536.0 && screenSize.height == 2048.0 || screenSize.width == 1668.0 && screenSize.height == 2388.0 || screenSize.width == 1620.0 && screenSize.height == 2160.0 || screenSize.width == 1640.0 && screenSize.height == 2360.0 || screenSize.width == 1488.0 && screenSize.height == 2266.0 {
                if mapRectangleGestureMGMT.xScale > 1.85 && mapRectangleGestureMGMT.yScale > 1.85{
                    isScaled = true
                    //print("iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen), 6Gen, Mini(5gen), Mini(6gen) (MEDIUM/SMALL Screen) scaled bigger")
                }
            }
            else{
                if mapRectangleGestureMGMT.xScale > 1.33 && mapRectangleGestureMGMT.yScale > 1.33 {
                    isScaled = true
                    //print("iPhone scaled bigger")
                }
            }
            
            
            let tolerance: CGFloat = 0.001
            
            //print("Last Screen size: \(screenSize)")
            switch (screenSize.width, screenSize.height) {
             // checking if the absolute difference between the current scaling factor and the target scaling factor is smaller than the tolerance value. If it is, it means that the scaling factor is very close to the target value, indicating that the node has been scaled back to the normal size
                case (2048.0, 2732.0):
                     //print("iPad Pro 12.9")
                     if abs(mapRectangleGestureMGMT.xScale - 2.4) < tolerance && abs(mapRectangleGestureMGMT.yScale - 2.4) < tolerance {
                        isScaled = false
                        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                        //print("iPad Pro 12.9 Bigger Screen scaled back to normal")
                    }
               
              
                case (1668.0, 2224.0), (1536.0, 2048.0), (1668.0,2388.0), (2048.0, 2732.0), (1620.0, 2160.0), (1640.0, 2360.0), (1488.0, 2266.0),(1488.0, 2266.0),(2048.0, 2732.0):
                    //print("iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen), iPad 6Gen, Mini(5gen), Mini(6gen)")
                    if abs(mapRectangleGestureMGMT.xScale - 1.85) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.85) < tolerance {
                        isScaled = false
                        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                        //print("iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen), iPad 6Gen, Mini(5gen), Mini(6gen) small/medium screen scaled back to normal")
                    }
                    
                case (750.0, 1334), (1080, 2340 ),(1125, 2436 ) :
                    //print("iPhoneSE3, SE2, 8, mini12, mini13, iPhone X, XS ,11PRO")
                    if abs(mapRectangleGestureMGMT.xScale - 1.33) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.33) < tolerance {
                        isScaled = false
                        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.755/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                        //print("iPhoneSE3, SE2, 8, mini12, mini13, iPhone X, XS ,11PRO scaled back to normal")
                    }
                case (1242.0, 2208.0), (828.0, 1792.0 ),(1242.0, 2688.0 ) :
                    //print("iPhone 8plus, XR, 11, XSMax, 11ProMax")
                    if abs(mapRectangleGestureMGMT.xScale - 1.33) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.33) < tolerance {
                        isScaled = false
                        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.906/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                        //print("iPhone 8plus, XR, 11, XSMax, 11ProMax scaled back to normal")
                    }
                    
                case (1170.0, 2532.0), (1179.0, 2556.0):
                     //print("iPhone 12, 12Pro, 13, 13Pro, 14, 14Pro")
                     if abs(mapRectangleGestureMGMT.xScale - 1.33) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.33) < tolerance {
                        isScaled = false
                        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.811/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                        //print("iPhone 12, 12Pro, 13, 13Pro, 14, 14Pro scaled back to normal")
                    }
                    
                case (1284.0, 2778.0), (1290.0, 2796.0):
                     //print("iPhone 12ProMax, 13ProMax, 14plus, 13Pro, 14ProMax")
                     if abs(mapRectangleGestureMGMT.xScale - 1.33) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.33) < tolerance {
                        isScaled = false
                        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.975/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                        //print("iPhone 12ProMax, 13ProMax, 14plus, 13Pro, 14ProMax scaled back to normal")
                    }
                    
                    
                default:
                    if abs(mapRectangleGestureMGMT.xScale - 1.33) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.33) < tolerance {
                    isScaled = false
                    mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.755/*1.8*/)//Whenever node is scaled back to default size the node is repositioned at default position or center
                    //print("scaled back to normal")
                    }
                    break
                
            }
        }
    }
    
    /*@objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
        
        //Constraints for limiting the scaling  of the node
        if mapRectangleGestureMGMT.xScale * sender.scale < 1.0 {
            sender.scale = 1.0 / mapRectangleGestureMGMT.xScale
        } else if mapRectangleGestureMGMT.xScale * sender.scale > 1.7 {
            sender.scale = 1.7 / mapRectangleGestureMGMT.xScale
        }

        if mapRectangleGestureMGMT.yScale * sender.scale < 1.0 {
            sender.scale = 1.0 / mapRectangleGestureMGMT.yScale
        } else if mapRectangleGestureMGMT.yScale * sender.scale > 1.7 {
            sender.scale = 1.7 / mapRectangleGestureMGMT.yScale
        }
        
        //Set scaling action
        let pinch = SKAction.scale(by: sender.scale, duration: 0.0)
        mapRectangleGestureMGMT.run(pinch)
        sender.scale = 1.0
        
        //Asses if the node is scaled or not(scaled to default size)
        if sender.state == .ended{
        
            if mapRectangleGestureMGMT.xScale > 1.0 && mapRectangleGestureMGMT.yScale > 1.0 {
                isScaled = true
                print("scaled bigger")
            }
            let tolerance: CGFloat = 0.001

            if abs(mapRectangleGestureMGMT.xScale - 1.0) < tolerance && abs(mapRectangleGestureMGMT.yScale - 1.0) < tolerance {
                isScaled = false
                mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.8)//Whenever node is scaled back to default size the node is repositioned at default position or center
                print("scaled back to normal")
            }
        }
    }*/
    
     override public func update(_ currentTime: TimeInterval) {
        
           if playagain == true{
                if  AlphabeticGameScene.completedGame == true{
                    //self.removeAllChildren()
                    //self.removeAllActions()
                    AlphabeticGameScene.completedGame = false
                    //playagain = false
                    let alphabeticGameScene = AlphabeticGameScene(size: self.size)//definitio
                    //let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(alphabeticGameScene/*, transition: transition*/)/*present scene and execut transitions*/
                    
                }
                else if RandomGameScene.completedGame == true{
                    //self.removeAllChildren()
                    //self.removeAllActions()
                    RandomGameScene.completedGame = false
                    //playagain = false
                    let randomGame = RandomGameScene(size: self.size)//definitio
                    //let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(randomGame/*, transition: transition*/)/*present scene and execut transitions*/
                    
                    
                }
                else if PracticeAlphabeticGameScene.completedGame == true{
                    //self.removeAllChildren()
                    //self.removeAllActions()
                    PracticeAlphabeticGameScene.completedGame = false
                    //playagain = false
                    StartMenuScene.playPracticeAlphabeticGame = true/*Flow control variable that allows when play again is selected to execute adding name labels to the map nodes when initSetcontainerNodeAndChildren() is called by PracticeAlphabeticGame when game reloads(play again)*/
                    let practiceAlphabeticGame = PracticeAlphabeticGameScene(size: self.size)//definitio
                    //let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(practiceAlphabeticGame/*, transition: transition*/)/*present scene and execut transitions*/
                    
                    
                }
                else if PracticeRandomGameScene.completedGame == true{
                    //self.removeAllChildren()
                    //self.removeAllActions()
                    PracticeRandomGameScene.completedGame = false
                    //playagain = false
                    StartMenuScene.playPracticeRandomGame = true/*Flow control variable that allows when play again is selected to execute adding name labels to the map nodes when initSetcontainerNodeAndChildren() is called by PracticeRandomGame when game reloads(play again)*/
                    let practiceRandomGame = PracticeRandomGameScene(size: self.size)//definitio
                    //let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(practiceRandomGame/*, transition: transition*/)/*present scene and execut transitions*/
                }
                playagain = false
            }
        
        if exited == true{
            /*Los if statements van a devolver completedGame a false, de lo contrario si oprimo salir en GameOverScene, cuando vuelvo a comenzar un juego
            va hacer el rendering de GameOverScene ya que completedGame tendria como valor true*/
            if AlphabeticGameScene.completedGame == true{
                AlphabeticGameScene.completedGame = false
            }
            if RandomGameScene.completedGame == true{
                RandomGameScene.completedGame = false
            }
            if PracticeRandomGameScene.completedGame == true{
                PracticeRandomGameScene.completedGame = false
            }
            if PracticeAlphabeticGameScene.completedGame == true{
                PracticeAlphabeticGameScene.completedGame = false
            }
            
           //self.removeAllActions()
           //self.removeAllChildren()
            
           exited = false
            
           let startMenuScene = StartMenuScene(size: self.size)//definitio
           //let transition = SKTransition.fade(withDuration: 1.0)
           self.view?.presentScene(startMenuScene/*, transition: transition*/)/*present scene and execut transitions*/
           
       }
    }
    
    @objc func handleTapFrom(_ sender: UITapGestureRecognizer){
        
        
        if sender.state == .recognized {//execute code as soon as gesture is recognized
            
            let touchLocation = sender.location(in: sender.view)//convert UIView coordinates to SpriteKit
            let location = self.convertPoint(fromView: touchLocation)//Defines the space where touch is taking effect, in this case StartScene
            let touchedNode = self.physicsWorld.body(at:location)//Defines that touch will take effect when it gets in contact with an SKphysics body
            
            if (touchedNode != nil){
                if (endGameRectangleButton.name == touchedNode?.node?.name){
                    endGameRectangle.removeFromParent()
                    self.addChild(resultadosButton)

                }
                    
                else if (resultadosButton.name == touchedNode?.node?.name){
                    resultadosButton.removeFromParent()
                    self.addChild(endGameRectangle)

                }
                
                else if (endGameRectangleButtonTwo.name == touchedNode?.node?.name){
                    playagain = true
                }
                
                else if(endGameRectangleButtonThree.name == touchedNode?.node?.name){
                    exited = true
                   
                }
                
            }
        }
    }
    
     /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!//Guarda toque de pantalla
        let touchLocation = touch.location(in: self)//Define el espacio en donde van a tomar efecto los toques de pantalla en este caso la vista StartScene
        let touchedNode = self.physicsWorld.body(at:touchLocation)//Se define que el toque de pantalla tomara efecto cuando el mismo entre en contacto con un SKphysics body, dentro de la vista StartScene
        
        if (touchedNode != nil){
            if (endGameRectangleButton.name == touchedNode?.node?.name){
                endGameRectangle.removeFromParent()
                self.addChild(resultadosButton)

            }
                
            else if (resultadosButton.name == touchedNode?.node?.name){
                resultadosButton.removeFromParent()
                self.addChild(endGameRectangle)

            }
            
            else if (endGameRectangleButtonTwo.name == touchedNode?.node?.name){
                playagain = true
            }
            
            else if(endGameRectangleButtonThree.name == touchedNode?.node?.name){
                exited = true
               
            }
            
        }
        
    }*/
    
    func initMusic() {
        guard let url = musicURL else { return }
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: url)/*exe what is inside url**/
        }catch{
            print("error")
            }
        
        musicPlayer.numberOfLoops = -1/*negative numbers will make it loop continuously until stopped*/
        musicPlayer.prepareToPlay()//ready to play musicPlayer
        musicPlayer.play()//
    }
    
    func setEndgameRectangleLabels(){
        
        
        if AlphabeticGameScene.completedGame == true || RandomGameScene.completedGame == true{
            /*Abajo se otorga la propiedad de nombre a los labels, propiedad que se utiliza en el proximo bloque , El unico propsito de esto es aislar cada label aprovechando cada iteracion del for loop para asignarles a cada uno propiedades en una misma y unica ejecucion de la funcion */
            labelOne.name = "labelOne"; labelTwo.name = "labelTwo"; labelThree.name = "labelThree"; labelFour.name = "labelFour"; labelFive.name = "labelFive"; labelSix.name = "labelSix"
            
            let arrayOflabelsChallenge = [labelOne, labelTwo, labelThree, labelFour, labelFive, labelSix]/*Poner los elementos a iterar en un for loop por medio de un array me permite reusar codigo, en vez de escribir un bloque por label donde por ejempl
              propiedades como fontName,fontSize y fontColor se escribirian 6 veces*/
            
            for label in arrayOflabelsChallenge {
                /*Ojo en el primer bloque estan las propiedades que quiero afecte a todos mis objetos o que son default por llamarlos de algua forma*/
                label.fontName = "AvenirNext-Bold"
                label.fontSize = 15
                label.fontColor = UIColor.white//init(red: 0.7922, green: 0.8353, blue: 0.8863, alpha: 1.0)/*init(red: 0.88, green: 0.90, blue: 1.00, alpha: 1.00)*/
                //label.zPosition = 3
                
                if label.name == "labelOne"{
                    label.position = CGPoint(x:-0, y:60)
                }
                if label.name == "labelTwo"{
                    label.position = CGPoint(x:-0, y:40)
                }
                if label.name == "labelThree"{
                    label.position = CGPoint(x:-0, y:10)
                }
                if label.name == "labelFour"{
                    label.position = CGPoint(x:-5, y:-10)
                }
                if label.name == "labelFive"{
                    label.position = CGPoint(x:65, y:50)
                }
                if label.name == "labelSix"{
                    label.position = CGPoint(x:65, y:0)
                }
                endGameRectangle/*Node*/.addChild(label)//se anaden los labels como hijos de endGameRectangle
           }
        }
        
        else if PracticeAlphabeticGameScene.completedGame == true || PracticeRandomGameScene.completedGame {
            labelSeven.name = "labelSeven"; labelEight.name = "labelEight"; labelNine.name = "labelNine"; labelTen.name = "labelTen"
            
            let arrayOflabelsPractice = [labelSeven, labelEight, labelNine, labelTen]
            
            for label in arrayOflabelsPractice {
                /*Ojo en el primer bloque estan las propiedades que quiero afecte a todos mis objetos o que son default por llamarlos de algua forma*/
                label.fontName = "AvenirNext-Bold"
                label.fontColor = UIColor.white//init(red: 0.7922, green: 0.8353, blue: 0.8863, alpha: 1.0)/*init(red: 0.88, green: 0.90, blue: 1.00, alpha: 1.00)*/

                if label.name == "labelSeven"{
                label.fontSize = 15
                label.text = "Tu Tiempo (Your Time):"
                label.position = CGPoint(x:0, y:90)
                }
                
                if label.name == "labelEight"{
                label.fontSize = 16
                label.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
                
                if PracticeAlphabeticGameScene.completedGame == true{
                    if PracticeAlphabeticGameScene.secondsGameOver < 10{
                    label.text = "\(PracticeAlphabeticGameScene.minutesGameOver) : 0\(PracticeAlphabeticGameScene.secondsGameOver)"
                    }
                    else{
                     label.text = "\(PracticeAlphabeticGameScene.minutesGameOver) : \(PracticeAlphabeticGameScene.secondsGameOver)"
                    }
                }
                    
                else if PracticeRandomGameScene.completedGame{
                    if PracticeRandomGameScene.secondsGameOver < 10{
                    label.text = "\(PracticeRandomGameScene.minutesGameOver) : 0\(PracticeRandomGameScene.secondsGameOver)"
                    }
                    else{
                     label.text = "\(PracticeRandomGameScene.minutesGameOver) : \(PracticeRandomGameScene.secondsGameOver)"
                    }
                }
                    
                label.position = CGPoint(x:0, y:55)

                }
                if label.name == "labelNine"{
                label.fontSize = 10
                label.fontColor = UIColor.init(red: 0.7922, green: 0.8353, blue: 0.8863, alpha: 1.0)
                label.numberOfLines = 2
                label.preferredMaxLayoutWidth = 220
                label.text = "Inténtalo en Modo de Reto para que tu mejor \n\t\ttiempo sea grabado"
                label.position = CGPoint(x:0, y:5)

                }
                if label.name == "labelTen"{
                label.fontSize = 10
                label.fontColor = UIColor.init(red: 0.7922, green: 0.8353, blue: 0.8863, alpha: 1.0)
                label.numberOfLines = 2
                label.preferredMaxLayoutWidth = 220
                label.text = "Try it in Challenge Mode so that your best \n\t\ttime can be recorded"
                label.position = CGPoint(x:0, y:-40)

                }
             
                endGameRectangle/*Node*/.addChild(label)//se anaden los labels como hijos de endGameRectangle
            }
            
            
        }
        
        //return endGameRectangleNode
    }
    
    func addChildSKNodeToParentSKSpriteNode(parent:SKSpriteNode, children:SKNode){
        if children.parent == nil{
        parent.addChild(children)
        }
    }
    
    func addChildSKSpriteNodeToParentself(children:SKSpriteNode){
        if children.parent == nil{
        self.addChild(children)
        }
    }
    
    func secondsAndMinutesBestTimesAssesmentAndRecordStatusAndTimesRenderingAlphabetic(second:Int, minute:Int){
         /*Este primer bloque if va a ejecutar siempre que un usuario instala el juego y juega por primera vez o si se borra la data para el juego en el telefono, tambien ejecuta cuando el usuario obtiene una mejor marca de tiempo que quedara registrada en memoria persistente*/
         if  UserDefaults.standard.integer(forKey: "minutesAlphabetic") == 0 && UserDefaults.standard.integer(forKey: "secondsAlphabetic") == 0 || minute < UserDefaults.standard.integer(forKey: "minutesAlphabetic") || minute == UserDefaults.standard.integer(forKey: "minutesAlphabetic") && AlphabeticGameScene.secondsGameOver < UserDefaults.standard.integer(forKey: "secondsAlphabetic") {
             /*Ojo el siguiente bloque es el unico donde se va a ejecutar el alamacenamiento en memoria persistente**/
             UserDefaults.standard.set(minute, forKey:"minutesAlphabetic")
             UserDefaults.standard.set(second, forKey:"secondsAlphabetic")
             
             labelOne.text = "¡NUEVO RECORD!"
             labelTwo.text = "(NEW RECORD!)"
             labelThree.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
             //format casting and rendering of new best record
             let secondsText = (second < 10) ?
             "0\(second)" : "\(second)"
             let minutesText = "\(minute)"
             
             if minute >= 1 {
                 labelThree.text = "\(minutesText):\(secondsText)"
             }
             else{
                 labelThree.text = "\(secondsText)"
                 //timerBackground.size = labelTimer.frame.size Aqui se utiliza el label de forma transparente por eso no se utiliza esta propiedad
                 
             }

             
             //labelFour.text = labelTimer.text esto lo use para probar q en efecto estaba obteniendo el tiempo correcto
         }
         
         else if minute > UserDefaults.standard.integer(forKey: "minutesAlphabetic") || minute == UserDefaults.standard.integer(forKey: "minutesAlphabetic") && second > UserDefaults.standard.integer(forKey: "secondsAlphabetic")||minute == UserDefaults.standard.integer(forKey: "minutesAlphabetic") && second == UserDefaults.standard.integer(forKey: "secondsAlphabetic"){
             //este bloque se va a encargar del rendering de la marca actual cuando no ocurre un nuevo record
             labelOne.text = "Tu Tiempo"
             labelTwo.text = "(Your Time)"
             labelThree.text = "Mejor Tiempo"
             labelFour.text = "(Best Time)"
             labelFive.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
             labelSix.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
             //labelFive.text = labelTimer.text
             let secondText = (second < 10) ?/*Ojo la variable aqui se llama secondText SIN "S", La razon para el cambio de nombre en la variable es pq ambas(secondText/secondsText) son constantes de modo que en el mismo bloque no podrian ejecutar como constantes(con el mismo nombre) y dado que ambas variables cumplen el mismo proposito no se queria cambiar demasiado el nombre. MAS ADELANTE SE VA A CREAR UNA FUNCION UNIVRSAL PARA LIDIAR SOLO CON EL CASTING Y EL RENDERING YA QUE ESTE CODIGO SE REPITE VARIAS VECES*/
             "0\(second)" : "\(second)"
             let minuteText = "\(minute)" //Ojo la variable aqui se llama minuteText SIN "S"
             
             if minute >= 1 {
                 labelFive.text = ":\(minuteText):\(secondText)"
             }
             else{
                 labelFive.text = ":\(secondText)"
                 //timerBackground.size = labelTimer.frame.size
                 
             }
             //este bloque se va a encargar de imprimir la mejor marca que en este caso seria la encontrada en memoria persistente
             let secondsText = (UserDefaults.standard.integer(forKey: "secondsAlphabetic") < 10) ?
             "0\(UserDefaults.standard.integer(forKey: "secondsAlphabetic"))" : "\(UserDefaults.standard.integer(forKey: "secondsAlphabetic"))"
             let minutesText = "\(UserDefaults.standard.integer(forKey: "minutesAlphabetic"))"
             
             if UserDefaults.standard.integer(forKey: "minutesAlphabetic") >= 1 {
                 labelSix.text = ":\(minutesText):\(secondsText)"
             }
             else{
                 labelSix.text = ":\(secondsText)"
                 //timerBackground.size = labelTimer.frame.size
                 
             }
             
         }
        
     }
    
    func secondsAndMinutesBestTimesAssesmentAndRecordStatusAndTimesRenderingRandom(second:Int, minute:Int){
         /*Este primer bloque if va a ejecutar siempre que un usuario instala el juego y juega por primera vez o si se borra la data para el juego en el telefono, tambien ejecuta cuando el usuario obtiene una mejor marca de tiempo que quedara registrada en memoria persistente*/
         if  UserDefaults.standard.integer(forKey: "minutesRandom") == 0 && UserDefaults.standard.integer(forKey: "secondsRandom") == 0 || minute < UserDefaults.standard.integer(forKey: "minutesRandom") || minute == UserDefaults.standard.integer(forKey: "minutesRandom") && RandomGameScene.secondsGameOver < UserDefaults.standard.integer(forKey: "secondsRandom") {
             /*Ojo el siguiente bloque es el unico donde se va a ejecutar el alamacenamiento en memoria persistente**/
             UserDefaults.standard.set(minute, forKey:"minutesRandom")
             UserDefaults.standard.set(second, forKey:"secondsRandom")
             
             labelOne.text = "¡NUEVO RECORD!"
             labelTwo.text = "(NEW RECORD!)"
             labelThree.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
             //format casting and rendering of new best record
             let secondsText = (second < 10) ?
             "0\(second)" : "\(second)"
             let minutesText = "\(minute)"
             
             if minute >= 1 {
                 labelThree.text = "\(minutesText):\(secondsText)"
             }
             else{
                 labelThree.text = "\(secondsText)"
                 //timerBackground.size = labelTimer.frame.size Aqui se utiliza el label de forma transparente por eso no se utiliza esta propiedad
                 
             }

             
             //labelFour.text = labelTimer.text esto lo use para probar q en efecto estaba obteniendo el tiempo correcto
         }
         
         else if minute > UserDefaults.standard.integer(forKey: "minutesRandom") || minute == UserDefaults.standard.integer(forKey: "minutesRandom") && second > UserDefaults.standard.integer(forKey: "secondsRandom")||minute == UserDefaults.standard.integer(forKey: "minutesRandom") && second == UserDefaults.standard.integer(forKey: "secondsRandom"){
             //este bloque se va a encargar del rendering de la marca actual cuando no ocurre un nuevo record
             labelOne.text = "Tu Tiempo"
             labelTwo.text = "(Your Time)"
             labelThree.text = "Mejor Tiempo"
             labelFour.text = "(Best Time)"
             labelFive.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
             labelSix.fontColor = UIColor.init(red: 0/255, green: 134/255, blue: 252/255, alpha: 1.0)
             //labelFive.text = labelTimer.text
             let secondText = (second < 10) ?/*Ojo la variable aqui se llama secondText SIN "S", La razon para el cambio de nombre en la variable es pq ambas(secondText/secondsText) son constantes de modo que en el mismo bloque no podrian ejecutar como constantes(con el mismo nombre) y dado que ambas variables cumplen el mismo proposito no se queria cambiar demasiado el nombre. MAS ADELANTE SE VA A CREAR UNA FUNCION UNIVRSAL PARA LIDIAR SOLO CON EL CASTING Y EL RENDERING YA QUE ESTE CODIGO SE REPITE VARIAS VECES*/
             "0\(second)" : "\(second)"
             let minuteText = "\(minute)" //Ojo la variable aqui se llama minuteText SIN "S"
             
             if minute >= 1 {
                 labelFive.text = ":\(minuteText):\(secondText)"
             }
             else{
                 labelFive.text = ":\(secondText)"
                 //timerBackground.size = labelTimer.frame.size
                 
             }
             //este bloque se va a encargar de imprimir la mejor marca que en este caso seria la encontrada en memoria persistente
             let secondsText = (UserDefaults.standard.integer(forKey: "secondsRandom") < 10) ?
             "0\(UserDefaults.standard.integer(forKey: "secondsRandom"))" : "\(UserDefaults.standard.integer(forKey: "secondsRandom"))"
             let minutesText = "\(UserDefaults.standard.integer(forKey: "minutesRandom"))"
             
             if UserDefaults.standard.integer(forKey: "minutesRandom") >= 1 {
                 labelSix.text = ":\(minutesText):\(secondsText)"
             }
             else{
                 labelSix.text = ":\(secondsText)"
                 //timerBackground.size = labelTimer.frame.size
                 
             }
             
         }
        
     }
    
}
