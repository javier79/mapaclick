//
//  PracticeRandomGameScene.swift
//  mapaclick
//
//  Created by javier pizarro on 9/26/23.
//

import Foundation
import SpriteKit
//import UIKit
import AVFoundation

class PracticeRandomGameScene: SKScene{
    let mapRectangleGestureMGMT: SKSpriteNode = GameSceneObjects().mapRectangleGestureMGMTBezierPathToSKSpriteNode(bpRectangle: BezierPathsForMapNodesAndRectangles().createRectangle())//This Node is invisible, it works by parenting containeNode and applying handgestures as SKNode have no anchor point property which is needed to be set at 0.5 for the pinch gesture to be able to zoom and be centered
    
    let controlPanelSKSpriteNode = GameSceneObjects().initControlPanel()
    let skipButton = GameSceneObjects().skipBlueButton()//used in more than one function
    let exitRedButton = GameSceneObjects().redButton()//used in more than one function
    
    let containerNode = InitSetMapNodes().initSetcontainerNodeAndChildren()//Node container for map nodes and map frames. Used in more than one function
    let labelTimer = GameSceneObjects().labelForTimer()//used in more than one function
    let labelScores = GameSceneObjects().labelForScores()//Scores label(in fluorocent text)
    
    let timerBackgroundTwo = GameSceneObjects().timerBackGroundTwo()/*Background for timer(At one time the timer used two different size backgrounds, but later i opted out of doing that for eficiency and kept
    the bigger background(timerBackgroundTwo) as timer's only background along its life cycle */
    let municipioNameLabel = GameSceneObjects().labelForMunicipioNames()//Label rendering municipio name to look up, Used in more than one function
    let municipiosNameBackground = GameSceneObjects().labelMunicipiosNameBackground()//Background for most(shorter) municipio names. Used in more than one function
    let municipiosNameBackgroundTwo = GameSceneObjects().labelMunicipiosNameBackgroundTwo()//Background for longer municipio names. Used in more than one function
    let municipiosNameBackgroundThree = GameSceneObjects().labelMunicipiosNameBackgroundThree()
    let municipiosNameBackgroundFour = GameSceneObjects().labelMunicipiosNameBackgroundFour()
    
    var renderTime: TimeInterval = 0.0//marks the time being played to be compared with currentTime, only used on update(timer function)
    let changeTime: TimeInterval = 1//adds(update) to renderTime in order to keep renderTime running, only used on update(imer function)
    var seconds: Int = 0//seconds count, only used on update(imer function)
    var minutes: Int = 0//minutes count, only used on update(imer function)
    static var secondsGameOver:Int = 0 //gets number of seconds to render tracked time(renders on gameOverScene), static variables must be declared at the top
    static var minutesGameOver:Int = 0 //gets number of minutes to render tracked time(renders on gameOverScene), static variables must be declared at the top
    let skipButtonPenalty = 15//seconds added to timer when skip buttom is pressed
    let penalty = 3//seconds added to timer when wrong node is pressed
    
    static var completedGame = false/**flow control variable for timer once its value is true allows for timer to stop, and transition to gameOverScene*/
    var useLine2:Bool = false//used on splitTextIntoFields functions and touch function.(intrinsic to function mechanism, dev should not be too concerned with it)
    var twoLineText: String = ""//used on splitTextIntoFields, this is the text passed to splitTextIntoFields functions
    
    /** Array includes Adjuntas although it' is written from the function that sets the label for municipios to look up, this is due  if adjuntas is skipped when the array reach the end to go back to index 0, then it gets Adjuntas.
     This array contain the text elements for the municipios to look up*/
    var municipios_names_array = ["Adjuntas", "Aguada", "Aguadilla", "Aguas Buenas", "Aibonito", "Arecibo", "Arroyo", "Añasco", "Barceloneta", "Barranquitas", "Bayamón", "Cabo Rojo", "Caguas", "Camuy", "Canóvanas", "Carolina", "Cataño", "Cayey", "Ceiba", "Ciales", "Cidra", "Coamo", "Comerío", "Corozal", "Culebra", "Dorado", "Fajardo", "Florida", "Guayama", "Guayanilla", "Guaynabo","Gurabo", "Guánica", "Hatillo", "Hormigueros", "Humacao", "Isabela", "Jayuya", "Juana Díaz", "Juncos", "Lajas", "Lares", "Las Marías", "Las Piedras", "Loíza", "Luquillo", "Manatí", "Maricao", "Maunabo", "Mayagüez", "Moca", "Morovis", "Naguabo", "Naranjito", "Orocovis", "Patillas", "Peñuelas", "Ponce", "Quebradillas", "Rincón", "Rio Grande", "Sabana Grande", "Salinas", "San Germán", "San Juan", "San Lorenzo", "San Sebastián", "Santa Isabel", "Toa Alta", "Toa Baja", "Trujillo Alto", "Utuado", "Vega Alta", "Vega Baja", "Vieques", "Villalba", "Yabucoa", "Yauco"]
    
    var fail: Bool!//flow control var allow when true for penalty to be added at timer funtion. Used on more than one funtion
    var currentIndex: Int = 0 //refers to index currently diplayed on municipio name label declared at the top to be accesed by accesory functions
    var pressSKipButton:Bool = false//Flow control variables when true allows timer to add 15 penalty
    //var arrayOfMapSpriteNodes = [SKSpriteNode()]
    var scoreCount:Int = 0//variable represent the number of municipios identified rendered in the control bar to the right
    let totalScoreCount:String = "/78"
    
    let correctSound = SKAction.playSoundFileNamed("351566__bertrof__game-sound-correct-organic-violin", waitForCompletion: false)
    let incorrectSound = SKAction.playSoundFileNamed("351565__bertrof__game-sound-incorrect-organic-violin", waitForCompletion: false)
    var musicPlayer = AVAudioPlayer()//audio player
    let musicURL:URL? = Bundle.main.url(forResource:"predited", withExtension:"mp3")//reference to PR Himn
    
    var skipButtonPressed = false//flow control var allows to apply alpha animation to skipbuttom on Touches end

    var randomIndex: Int = 0
    
    var isScaled = false
    
    let screenSize = UIScreen.main.nativeBounds
    
    override func didMove(to view: SKView){
        
        self.backgroundColor = UIColor.init(red: 0.2588, green: 0.7608, blue: 1, alpha: 1.0)//blue background that resembles the ocean
        
        //mapRectangleGestureMGMT.zPosition = 0
        mapRectangleGestureMGMT.anchorPoint = CGPoint(x:0.5, y:0.5)
        //mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.8)
        /**The following  objects are the parent for all rendering objects, class positioning attributers are applied in order for objects to render the same independent of the screen size, In the case of containerNode it's positioning is set  based on its parent
         timerBackgroundTwo. The reason for not giving containerNode class positioning was due when class attributes were applied to containerNode it would render different in devices with smaller screen size(maybe something im not aware about, or a glitch of some kind).*/
        //containerNode.zPosition = -1
        containerNode.position = CGPoint(x:-280, y:-190)//CGPoint(x:self.size.width/2 - 285, y:self.size.height/2 - 175) /*CGPoint(x:-275 , y:-75 /*15*/)*//**Sknode containing(children) map sprites, desecheo cover(node whose only job is to hid desecheo island, rectangular frames)*/
        //timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 6)/**parent to labelTimer*/
        
        controlPanelSKSpriteNode.zPosition = 1//Set to one in order for the map to zoom and remain behind
        controlPanelSKSpriteNode.size = CGSize(width:self.size.width - 1, height: 50)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 16.5/*25*/)
        
        getFirstRandomMunicipioNameToLookUp()//Function gets first random municipio name and overwrites text attributes from TestClass().labelForMunicipioNames()(base attributes)
        //randomIndex = Int.random(in:0...77)//gets random index for first municipio name to look up
        //municipioNameLabel.text = municipios_names_array[randomIndex]//first municipio name to look up
        //municipioNameLabel = labelForMunicipioNamesRandomGame(NameMunicipioLabel: municipioNameLabel)
        
        //The following block reads device screen size in points, based on screen size a function will execute to asign scaling and positioning attributes
        //print("Screen size: \(screenSize)")
        switch (screenSize.width, screenSize.height) {
            
            case (2048.0, 2732.0):
                 //print("Set RandomGame gamePlay objts for: iPads Pro12.9(3gen), Pro12.9(4gen), Pro12.9(5gen), Pro12.9(6gen) ")
                 setScaleAndIndepRenderingPositioningForIpadsLargeScreenSizes()
           
            case (1536.0, 2048.0),(1488.0, 2266.0) :
                 //print("Set RandomGame gamePlay objts for: iPads 6Gen, Mini(5gen), Mini(6gen) ")
                 setScaleAndIndepRenderingPositioningForIpadsSmallScreenSizes()
            
            case (1668.0, 2224.0), (1668.0, 2388.0), (1620.0, 2160.0),(1640.0, 2360.0):
                //print("Set RandomGame gamePlay objts for: iPads Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen) ")
                setScaleAndIndepRenderingPositioningForIpadsMediumScreenSizes()
            
            case (750.0, 1334), (1080, 2340 ),(1125, 2436 ) :
                //print("Set RandomGame gamePlay objts for: iPhone SE3, SE2, 8, mini12, mini13, iPhone X, XS ,11PRO")
                setScaleAndIndepRenderingPositioningForSmallScreenSizes()
            
            case (1242.0, 2208.0), (828.0, 1792.0 ),(1242.0, 2688.0 ) :
                //print("Set RandomGame gamePlay objts for: iPhone 8plus, XR, 11, XSMax, 11ProMax")
                setScaleAndIndepRenderingPositioningForMediumLargeScreenSizes()
            
           case (1170.0, 2532.0), (1179.0, 2556.0):
                //print("Set RandomGame gamePlay objts for:iPhone 12, 12Pro, 13, 13Pro, 14, 14Pro")
                setScaleAndIndepRenderingPositioningForLargeScreenSizes()
            
           case (1284.0, 2778.0), (1290.0, 2796.0):
                //print("Set RandomGame gamePlay objts for:iPhone 12ProMax, 13ProMax, 14plus, 13Pro, 14ProMax")
                setScaleAndIndepRenderingPositioningForXtraLargeScreenSizes()
        
            default:
                //print("Set RandomGame gamePlay objts for: Other IOS devices")
               setScaleAndIndepRenderingPositioningForSmallScreenSizes()//This line will catch any device which screen measure is none of the above
                break
        }
        
        /**Following objects are related to goldBackground SKSPriteNode*/
        //Attention the following two statements were commented due municipioNamesBackground and municipioNameLabel are added at getFirstRandomMunicipioNameToLookUp()
        //addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackground, children: municipioNameLabel)
        //addChildSKSpriteNodeToParentSKSpriteNode(parent: goldBackgroundSKSpriteNode, children: municipiosNameBackground)
        addChildSKLabelNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: labelScores)
        addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: skipButton)
        addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: exitRedButton)
        addChildSKSpriteNodeToParentself(children: controlPanelSKSpriteNode)
        addChildSKNodeToParentSKSpriteNode(parent:mapRectangleGestureMGMT, children:containerNode)
        //containerSKSPriteNode.addChild(containerNode)
        addChildSKSpriteNodeToParentself(children:mapRectangleGestureMGMT)
        //self.addChild(containerSKSPriteNode)
        //addChildSKNodeToParentself(children: containerNode)
        //addChildSKNodeToParentSKSpriteNode(parent: timerBackgroundTwo, children: containerNode)
        addChildSKLabelNodeToParentSKSpriteNode(parent: timerBackgroundTwo, children: labelTimer)
        addChildSKSpriteNodeToParentself(children: timerBackgroundTwo)
        
        //set an call hand gesture recognizers
        let pinchRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target:self, action: #selector(self.handlePinchFrom(_:)))
        self.view!.addGestureRecognizer(pinchRecognizer)
        
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        // Add the gesture recognizer to the scene's view
        self.view!.addGestureRecognizer(panGestureRecognizer)
        
        /**Play background music*/
        if StartMenuScene.backgroundMusicOn == true{
            //self.addChild(StartScene.backgroundMusic)
            initMusic()
        }
        //sleep(1)
    }
    
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForIpadsLargeScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPads Pro12.9(3gen), Pro12.9(4gen), Pro12.9(5gen), Pro12.9(6gen)")
        //print("Ipads Large Screen Sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)
        //mapRectangleGestureMGMT.setScale(1.90)//1.38
        mapRectangleGestureMGMT.setScale(2.4)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 12.0)/**parent to labelTimer*/
        
        labelScores.position = CGPoint(x:440/*300*/, y:-7)
        labelScores.fontSize = 25.5
        
        controlPanelSKSpriteNode.size = CGSize(width:self.size.width - 1, height:70)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 20.5) //14.8)
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 28.5)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 4.5) //14.8)
        //controlPanelSKSpriteNode.setScale(1.5)
        
        skipButton.setScale(2.1)
        skipButton.position = CGPoint(x:320, y:-0.5)
        exitRedButton.setScale(2.1)
        exitRedButton.position = CGPoint(x:-370, y:-0.5)
        
        timerBackgroundTwo.setScale(1.9)
        
        municipiosNameBackground.setScale(1.9)
    }
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForIpadsSmallScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPad 6Gen, Mini(5gen), Mini(6gen)")
        //print("Ipads Small Screen Sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)
        //mapRectangleGestureMGMT.setScale(1.90)//1.38
        mapRectangleGestureMGMT.setScale(1.85)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 9.5 )/**parent to labelTimer*/
        
        labelScores.position = CGPoint(x:440/*300*/, y:-7)
        labelScores.fontSize = 22.5
        
        controlPanelSKSpriteNode.size = CGSize(width:self.size.width - 1, height:64)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 20.5) //14.8)
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 22.5)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 4.5) //14.8)
        //controlPanelSKSpriteNode.setScale(1.5)
        
        skipButton.setScale(1.90)
        skipButton.position = CGPoint(x:320, y:-0.5)
        exitRedButton.setScale(1.90)
        exitRedButton.position = CGPoint(x:-370, y:-0.5)
        
        timerBackgroundTwo.setScale(1.85)
        
        municipiosNameBackground.setScale(1.75)
    }
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForIpadsMediumScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPad Pro 10.5, Pro11(1gen), Air(3gen), 7Gen, Pro11(2gen), 8Gen, 9Gen, Air(4gen), PRO11(3gen), Air(5gen), 10Gen, Pro11(4gen)")
        //print("Ipads Medium Screen Sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 2.00/*1.8*/)
        //mapRectangleGestureMGMT.setScale(1.90)//1.38
        mapRectangleGestureMGMT.setScale(1.85)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 9.5)/**parent to labelTimer*/
        
        labelScores.position = CGPoint(x:440/*300*/, y:-7)
        labelScores.fontSize = 22.5
        
        controlPanelSKSpriteNode.size = CGSize(width:self.size.width - 1, height:70)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 20.5) //14.8)
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 22.5)
        //controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 4.5) //14.8)
        //controlPanelSKSpriteNode.setScale(1.5)
        
        skipButton.setScale(2.00)
        skipButton.position = CGPoint(x:320, y:-0.5)
        exitRedButton.setScale(2.00)
        exitRedButton.position = CGPoint(x:-370, y:-0.5)
        
        timerBackgroundTwo.setScale(1.85)
        
        municipiosNameBackground.setScale(1.75)
    }
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForSmallScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPhone SE3, SE2, 8, mini12, mini13, iPhone X, XS ,11PRO")
        //print("iPhone small screen sizes")
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.755/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 6.4)/**parent to labelTimer*/
        
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 14.8) //14.8)
        
        
        skipButton.setScale(1.50)
        exitRedButton.setScale(1.50)
        
        municipiosNameBackground.setScale(1.20)
    }
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForMediumLargeScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPhone 8plus, XR, 11, XSMax, 11ProMax enter MediumLargeScreenSizes scaling and positioning func")
        //print("iPhone medium-large screen sizes")
        
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.906/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 6.7)/**parent to labelTimer*/
        
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 14.8) //14.8)
        
        skipButton.setScale(1.50)
        exitRedButton.setScale(1.50)
        
        municipiosNameBackground.setScale(1.20)
    }
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForLargeScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPhone 12, 12Pro, 13, 13Pro, 14, 14Pro enter LargeScreenSizes scaling and positioning func")
        //print("iPhone large screen sizes")
        
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.811/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 6.5)/**parent to labelTimer*/
        
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 14.8) //14.8)
        
        skipButton.setScale(1.50)
        exitRedButton.setScale(1.50)
        
        municipiosNameBackground.setScale(1.20)
    }
    //Execute attributes for scaling and positioning based on device screen size
    func setScaleAndIndepRenderingPositioningForXtraLargeScreenSizes(){
        //print("Set RandomGame gamePlay objts scaling and positioning for: iPhone 12ProMax, 13ProMax, 14plus, 14ProMax enter XtraLargeScreenSizes scaling and positioning func")
        //print("iPhone Xtralarge screen sizes")
        
        mapRectangleGestureMGMT.position = CGPoint(x:self.size.width / 2, y:self.size.height / 1.975/*1.8*/)
        mapRectangleGestureMGMT.setScale(1.33)//1.38
        
        timerBackgroundTwo.setScale(1.20)
        timerBackgroundTwo.position = CGPoint(x:self.size.width / 2/*333.5*/, y:self.size.height / 7.0)/**parent to labelTimer*/
        
        controlPanelSKSpriteNode.position = CGPoint(x:self.size.width / 2, y:self.size.height / 16) //14.8)
        
        skipButton.setScale(1.50)
        exitRedButton.setScale(1.50)
        
        municipiosNameBackground.setScale(1.20)
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
    
    @objc func handleTapFrom(_ sender: UITapGestureRecognizer){
        
        
        if sender.state == .recognized {//execute code as soon as gesture is recognized
            
            var touchLocation: CGPoint = sender.location(in: sender.view)//convert UIView coordinates to SpriteKit
            touchLocation = self.convertPoint(fromView: touchLocation)//Defines the space where touch is taking effect, in this case StartScene
            let touchedNode = self.physicsWorld.body(at:touchLocation)//Defines that touch will take effect when it gets in contact with an SKphysics body
            
            if (touchedNode != nil){//This line controls the flow by evaluating if a SKphysics body was touch or not, touchNode will return nil when the screen is touched but no SKphysics body was touched
                if (municipioNameLabel.text == touchedNode?.node?.name){//Evaluates touch by matching the label text attribute with node's name attributes
                    let spritenode = touchedNode?.node as! SKSpriteNode//pass touchedNode node attribute to spritenode, to apply changes
                    spritenode.physicsBody = nil
                    playCorrectSound()
                    //setLabelForMunicipioNameAndAddToNode(nodeSprite: spritenode)
                    paintNode(spriteNode: spritenode)//color SKSpriteNode green
                    /**Set labels and add them to map texture(node)*/
                    //setLabelForMunicipioNameAndAddToNode(nodeSprite: spritenode)
                    /**Element identified is removed from names array, Evaluates for game complition and removal of Skip button*/
                    removeIdentifiedElementEvaluateCompleteGameAndSkipButtonRemoval()
                    /**set new municipio to look after*/
                    setNewMunicipioNameToLookUp()
                    /**add one to number of municipios located*/
                    addToScoreCountWriteToLabel()
                    
                }
                
                /*Skip button touch action**/
                else if (skipButton.name == touchedNode?.node?.name){//Es lo mismo que preguntar si el physics body tocado se llama (name) como skipButton, la condicion quiere saber si tocamos skipButton basicamente
                    addOneTocurrentIndexSetNameToLookUp()
                }
                /**Exit button touch action*/
                else if (exitRedButton.name == touchedNode?.node?.name){
                    goToStartMenu()
                }
               
                //else statement will execute whenever a wrong municipio node is touched
                else{
                    playIncorrectSound()
                    
                    return fail = true//variable updates to apply 3 seconds penalty at timer function
                }
            }
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
    
    func getFirstRandomMunicipioNameToLookUp(){
        //setNewMunicipioNameToLookUp()
        randomIndex = Int.random(in:0...77)//gets random index for first municipio name to look up
        municipioNameLabel.text = municipios_names_array[randomIndex]//first municipio name to look up
        
        switch(municipioNameLabel.text){
            case "Aguas Buenas", "Hormigueros", "San Sebastián", "Sabana Grande" :
                scaleMunicipioNameBackgroundTwoForScreenSizes()
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundTwo, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundTwo)
            
            case "Barceloneta", "Canóvanas", "Juana Díaz", "Las Marías", "Las Piedras", "Rio Grande", "San Germán", "San Lorenzo", "Santa Isabel", "Barranquitas", "Quebradillas":
                scaleMunicipioNameBackgroundFourForScreenSizes()
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundFour, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundFour)
            
            case  "Cabo Rojo", "Bayamón", "Guayanilla", "Guaynabo", "Guayama", "Humacao", "Mayagüez", "Maunabo", "Naguabo", "Peñuelas", "San Juan", "Vega Alta", "Vega Baja", "Naranjito", "Orocovis", "Trujillo Alto":
                scaleMunicipioNameBackgroundThreeForScreenSizes()
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundThree, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundThree)
            
        default:
            
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackground, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackground)
            break
        }
        
        
    }
    
    /*@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
             if isScaled == true {
                 //let translation = gesture.translation(in: gesture.view)
                 
                 // Limit the position of the node to within the desired bounds
                 if containerSKSPriteNode.position.x > maxX {
                     containerSKSPriteNode.position.x = maxX
                 } else if containerSKSPriteNode.position.x < minX {
                     containerSKSPriteNode.position.x = minX
                 }
                 if containerSKSPriteNode.position.y > maxY {
                     containerSKSPriteNode.position.y = maxY
                 } else if containerSKSPriteNode.position.y < minY {
                     containerSKSPriteNode.position.y = minY
                 }
                 
                 let velocity = gesture.velocity(in: gesture.view)
                 filteredVelocity = CGPoint(x: filteredVelocity.x * 0.9 + velocity.x * 0.01,
                                            y: filteredVelocity.y * 0.9 + velocity.y * 0.01)

                 containerSKSPriteNode.position = CGPoint(x: containerSKSPriteNode.position.x + filteredVelocity.x, y: containerSKSPriteNode.position.y - filteredVelocity.y)
                 gesture.setTranslation(.zero, in: view)
             }
         }*/

         /*@objc func handlePan(_ gesture: UIPanGestureRecognizer) {
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
         
         @objc func handleTapFrom(_ sender: UITapGestureRecognizer){
             
             
            if sender.state == .recognized {//execute code as soon as gesture is recognized
                 
                 var touchLocation: CGPoint = sender.location(in: sender.view)//convert UIView coordinates to SpriteKit
                 touchLocation = self.convertPoint(fromView: touchLocation)//Defines the space where touch is taking effect, in this case StartScene
                 let touchedNode = self.physicsWorld.body(at:touchLocation)//Defines that touch will take effect when it gets in contact with an SKphysics body
                 
                 if (touchedNode != nil){//This line controls the flow by evaluating if a SKphysics body was touch or not, touchNode will return nil when the screen is touched but no SKphysics body was touched
                     if (municipioNameLabel.text == touchedNode?.node?.name){//Evaluates touch by matching the label text attribute with node's name attributes
                         let spritenode = touchedNode?.node as! SKSpriteNode//pass touchedNode node attribute to spritenode, to apply changes
                         spritenode.physicsBody = nil
                         playCorrectSound()
                         paintNode(spriteNode: spritenode)//color SKSpriteNode green
                         /**Set labels and add them to map texture(node)*/
                         //setLabelForMunicipioNameAndAddToNode(nodeSprite: spritenode)
                         /**Element identified is removed from names array, Evaluates for game complition and removal of Skip button*/
                         removeIdentifiedElementEvaluateCompleteGameAndSkipButtonRemoval()
                         /**set new municipio to look after*/
                         setNewMunicipioNameToLookUp()
                         /**add one to number of municipios located*/
                         addToScoreCountWriteToLabel()
                         
                     }
                     
                     /*Skip button touch action**/
                     else if (skipButton.name == touchedNode?.node?.name){//Es lo mismo que preguntar si el physics body tocado se llama (name) como skipButton, la condicion quiere saber si tocamos skipButton basicamente
                         addOneTocurrentIndexSetNameToLookUp()
                     }
                     /**Exit button touch action*/
                     else if (exitRedButton.name == touchedNode?.node?.name){
                         goToStartMenu()
                     }
                    
                     //else statement will execute whenever a wrong municipio node is touched
                     else{
                         playIncorrectSound()
                         
                         return fail = true//variable updates to apply 3 seconds penalty at timer function
                     }
                 }
             }
         }
         
         @objc func handlePinchFrom(_ sender: UIPinchGestureRecognizer) {
             
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
    
    /*func getFirstRandomMunicipioNameToLookUp(){
        setNewMunicipioNameToLookUp()
        //randomIndex = Int.random(in:0...77)//gets random index for first municipio name to look up
        //municipioNameLabel.text = municipios_names_array[randomIndex]//first municipio name to look up
    }*/
    
    func addChildSKSpriteNodeToParentSKSpriteNode(parent:SKSpriteNode, children:SKSpriteNode){
        if children.parent == nil{
        parent.addChild(children)
        }
    }
    
    func addChildSKLabelNodeToParentSKSpriteNode(parent:SKSpriteNode, children:SKLabelNode){
        if children.parent == nil{
        parent.addChild(children)
        }
    }
    
    func addChildSKSpriteNodeToParentself(children:SKSpriteNode){
        if children.parent == nil{
        self.addChild(children)
        }
    }
    
    func addChildSKLabelNodeToParentself(children:SKLabelNode){
        if children.parent == nil{
        self.addChild(children)
        }
    }
    
    func addChildSKNodeToParentself(children:SKNode){
        if children.parent == nil{
        self.addChild(children)
        }
    }
    func addChildSKNodeToParentSKSpriteNode(parent:SKSpriteNode, children:SKNode){
        if children.parent == nil{
        parent.addChild(children)
        }
    }
    
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
    
    
    override public func update(_ currentTime: TimeInterval) {/*Function execute every second, for timer functionality*/
        
        
       if PracticeRandomGameScene.completedGame == false{//Control variable to keep the timer running, once condition is true the timer is stopped
            /* currentTime refers to the pc running clock and renderTime refers to the passing time while the game is running*/
            if currentTime > renderTime {/**currentTime  value is bigger than renderTime only when a second is added, later on renderTime value updates to a future time measure bigger than currentTime, due currenTime is continuously running when it becomes bigger than renderTime value, the execution enters the next block to sum seconds and minutes*/
            
                /**following block is where seconds and minuteds are added*/
                if renderTime > 0{/**In its first iteration renderTime value  is 0.0, so that the execution will go  to the next Else If statement, after the first iteration its value will always be bigger than 0*/
                    timerManagement()
                }
                /**Next block will execute only when renderTime value is 0 and it just formats and render 00(timer) at the beginning of the game, it will only execute once as renderTime value keep increasing*/
                else if renderTime == 0.0{
                    formatCastZeroToStringAndWriteToLabel()
                   
                    //For dev use ONLY
                     /**ATTENTION DUE THIS BLOCK EXECUTE ONCE(SECOND 00). I  PLACE HERE THE RESET FOR PERSISTENT MEMORY WHERE I STORE THE VALUES TO EVALUATE  TIME RECORDS ON GAMEOVERSCENE
                     IN ORDER TO WIPE(reset) PERSISTEN MEMORY UNCOMMENT THE FOLLOWING STATEMENTS RUN THE GAME A FEW SECONDS STOP THE GAME, AND WHEN YOU LAUNCH THE GAME NEXT TIME  PERSISTENT MEMORY WILL BE
                     CLEAN AS WHEN THE GAME IS PLAYED FOR THE FIRST TIME WHEN DOWNLOADED*/
                    //UserDefaults.standard.removeObject(forKey: "secondsRandom")
                    //UserDefaults.standard.removeObject(forKey: "minutesRandom")
                }
                
                renderTime = currentTime + changeTime//updates renderTime value, when this happens renderTime value is bigger than currentTime
            }
            
        }
        /** This block  will execute when completedGame equals true(meaning all nodes were correctly identified), the function below will get gameOverScene. The reason to place here the game transition to gameOverScene is due Touch function needs "space" in order to perform without much lagging as scene transitioning and
         Touch function both require a lot of resouces that can compromise the flow of the game(so basically thats why the scene transition is not placed on Touch function)*/
        
        if PracticeRandomGameScene.completedGame == true{
            goToGameOverScene()
        }
        
    }
    //Function adds seconds and minute, also adds penalties when wrong node or skip button is pressed
    func timerManagement(){
            addSecond()
            //seconds += 1
            if seconds == 60 {
                resetSecondsAddMinutes()

            }
            
            //Este bloque solo se ejecuta cuando se presiona sobre el municipio incorrecto, anadiendo 3 segundos al reloj
            if(fail == true){
                
                addPenaltyToSeconds()
                
                //El if statement abajo substituye(0 resume) los proximos if statements comentados,si los segundos al sumarle el penalty sobrepasan 59, dentro del if se convierte a la cantidad de segundos correspondientes osea 60 a 0, 61 a 1 etc....
                if seconds >= 60{
                    resetSecondsAfterPenaltyAddMinutes()
                }
                fail = false
                
            }
            
            if (pressSKipButton == true){
                addSkipButtonPenaltyToSeconds()
                
                
                //El if statement abajo substituye(0 resume) los proximos if statements comentados,si los segundos al sumarle el penalty sobrepasan 59, dentro del if se convierte a la cantidad de segundos correspondientes osea 60 a 0, 61 a 1 etc....
                if seconds >= 60{
                    resetSecondsAfterPenaltyAddMinutes()
                }
                pressSKipButton = false
            }
            
            formatCastToStringAndWriteSecondsAndMinutesToLabel()

    }
    
    func addSecond(){
        seconds += 1
    }
    
    func resetSecondsAddMinutes(){
        seconds = 0
        minutes += 1
    }
    
    func addPenaltyToSeconds(){
        //let penalty = 3
        //print("inside")
        seconds = seconds + penalty
    }
    
    func resetSecondsAfterPenaltyAddMinutes(){
        seconds = seconds - 60//Subastracting 60 from seconds gets the number of seconds while seconds are reinitiated
        minutes += 1//adding minutes once seconds count reach 59
    }
    
    func addSkipButtonPenaltyToSeconds(){
        //print("15 more seconds")
        seconds = seconds + skipButtonPenalty
    }
    
    func formatCastToStringAndWriteSecondsAndMinutesToLabel(){
        let secondsText = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        let minutesText = "\(minutes)"
        //"0\(minutes)" : "\(minutes)"//this line of code is to show a 0(01,02,03...minutes) on the minutes counter
        if minutes >= 1 {
              labelTimer.text = "\(minutesText):\(secondsText)"
              
          }
        
          else{
              labelTimer.text = "\(secondsText)"
              
          }
    }
    //Function will only execute during second 00
    func formatCastZeroToStringAndWriteToLabel(){
        let secondsText = (seconds < 10) ?
        "0\(seconds)" : "\(seconds)"
        labelTimer.text = "\(secondsText)"
        //timerBackground.size = labelTimer.frame.size//size para el background del timer para acomodar 00
        //print("rendertime = 0")//Esta linea es solo para indicar al programador cuando se ejecuta este bloque
    }
    
    func goToGameOverScene(){
        //musicPlayer.stop()
        
        //StartScene.secondsGameOver = seconds
        //StartScene.minutesGameOver = minutes
        //musicPlayer.stop()
        //self.removeAllActions()
        //self.removeAllChildren()
        
        let gameOverScene = GameOverScene(size: self.size)
        let transition = SKTransition.fade(withDuration: 2.0)//withDuration: 1.5)
    
        self.view?.presentScene(gameOverScene, transition: transition)/*si anado una transicion con 1.0 segundos o hasta 0.5 permite que el ultimo mnicipio se cambie de color antes de cambiar la vista pero ocurre cierto laggin que de cierta forma interfiere con el ritmo que llevaba el juego y afecta un poco la experiencia pero puedo volver a tratar mas adelante ajustando esto hasta dar con la experiencia que busco*/
    }
    
    func getSecondsAndMinutes(){
        PracticeRandomGameScene.secondsGameOver = seconds
        PracticeRandomGameScene.minutesGameOver = minutes
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//Touch function
         
        let touch = touches.first!//store touch
        let touchLocation = touch.location(in: self)//Defines the space where touch is taking effect, in this case StartScene
        let touchedNode = self.physicsWorld.body(at:touchLocation)//Defines that touch will take effect when it gets in contact with an SKphysics body
        
        
        if (touchedNode != nil){//This line controls the flow by evaluating if a SKphysics body was touch or not, touchNode will return nil when the screen is touched but no SKphysics body was touched
            if (municipioNameLabel.text == touchedNode?.node?.name){//Evaluates touch by matching the label text attribute with node's name attributes
                let spritenode = touchedNode?.node as! SKSpriteNode//pass touchedNode node attribute to spritenode, to apply changes
                paintNode(spriteNode: spritenode)//color SKSpriteNode green
                playCorrectSound()
                
                /**Element identified is removed from names array, Evaluates for game complition and removal of Skip button*/
                removeIdentifiedElementEvaluateCompleteGameAndSkipButtonRemoval()
                /**set new municipio to look after*/
                setNewMunicipioNameToLookUp()
                /**add one to number of municipios located*/
                addToScoreCountWriteToLabel()
                
            }
            
            /*Skip button touch action**/
            else if (skipButton.name == touchedNode?.node?.name){//Es lo mismo que preguntar si el physics body tocado se llama (name) como skipButton, la condicion quiere saber si tocamos skipButton basicamente
                addOneTocurrentIndexSetNameToLookUp()
            }
            /**Exit button touch action*/
            else if (exitRedButton.name == touchedNode?.node?.name){
                goToStartMenu()
            }
           
            //else statement will execute whenever a wrong municipio node is touched
            else{
                playIncorrectSound()
                
                return fail = true//variable updates to apply 3 seconds penalty at timer function
            }
        }
    }*/
    
    func paintNode(spriteNode:SKSpriteNode){
        spriteNode.color = UIColor.init(red: 0, green: 1, blue: 0.949, alpha: 1.0)
        spriteNode.colorBlendFactor = 1.0
        //spriteNode.physicsBody = nil
    }
    
    func playCorrectSound(){
        if StartMenuScene.gamePlaySoundOn == true{
            run(/*StartScene.*/correctSound)//correctSound
        }
    }
    
    func removeIdentifiedElementEvaluateCompleteGameAndSkipButtonRemoval(){
        let countOfIndexes = municipios_names_array.count - 1//Gets the number of indexes in array
        
        //If condition is true means that two elemens are left in array, it removes skipButton due second to last(penultimo elemento) element is about to be removed next
        if countOfIndexes == 1  {
            //print("skip button out")
            skipButton.removeFromParent()
        }

        //removes element while more than 1 element are left in array
        if countOfIndexes > 0 {
            municipios_names_array.remove(at:randomIndex)//removes element identified that is at index(remember taht this variable updates in the following block))
            
        }
            
        //Este else statement va a ejecutar solo cuando currentIndex y countIndex == 0
        else{
            //self.removeAllActions()//It catches the last correctSound in order for transition to gameOverScene to flow smoother with less laggin
            getSecondsAndMinutes()
            PracticeRandomGameScene.completedGame = true//Se actualiza la variable completedGame para detener el reloj
            

        }
    }
    
    func setNewMunicipioNameToLookUp(){
        let countOfIndexes = municipios_names_array.count - 1
        //print(countOfIndexes)
        //loop keeps next skipped municipio name from repeating, meaning any time you press skip it will return a different municipio, and not the same one.
        if pressSKipButton == true{
            //print("inside while")
            repeat{
                randomIndex = Int.random(in:0...countOfIndexes)
            }
            while municipioNameLabel.text == municipios_names_array[randomIndex] && countOfIndexes != 0
        }
        
        else{
            randomIndex = Int.random(in:0...countOfIndexes)
        }
        
        municipioNameLabel.text = municipios_names_array [randomIndex] //Writes to label the next municipio name to be located by player
       //Switch reveals the name of the next municipio to look out for
        switch(municipioNameLabel.text){
            //This block manage the longest two word names
            case "Aguas Buenas", "Hormigueros", "San Sebastián", "Sabana Grande" ://This municipio names will use municipiosNameBackgroundTwo
                //Removes current background to add municipiosNameBackgroundTwo to the scene if its not already present on the scene
                if municipiosNameBackgroundTwo.parent == nil{// Checks if municipiosNameBackgroundTwo is already in the scene, if municipioNameBackgroundTwo is already on the scene the following block is ignored
                    switch(municipioNameLabel.parent?.name){//returns the background currently in use that is not municipiosNameBackgroundTwo and that needs to be removed in order to add municipiosNameBackgroundTwo to fit "Aguas Buenas", "Hormigueros", "San Sebastián", "Sabana Grande"
                        
                        case "MunicipiosNameBackground"://Background to be removed in order for municipiosNameBackgroundTwo to be added
                            municipioNameLabel.removeFromParent()//municipioNameLabel is removed in order to be added(as child) to municipiosNameBackgroundTwo
                            municipiosNameBackground.removeFromParent()//If municipiosNameBackground.parent != nil true municipiosNameBackgroundis removed to put in its place municipiosNameBackgroundTwo
                            scaleMunicipioNameBackgroundTwoForScreenSizes()//scaling for municipiosNameBackgroundTwo is set according to screen size
                        
                        case "MunicipiosNameBackgroundThree":
                            municipioNameLabel.removeFromParent()
                            municipiosNameBackgroundThree.removeFromParent()
                            scaleMunicipioNameBackgroundTwoForScreenSizes()
                            
                        case "MunicipiosNameBackgroundFour":
                            municipioNameLabel.removeFromParent()
                            municipiosNameBackgroundFour.removeFromParent()
                            scaleMunicipioNameBackgroundTwoForScreenSizes()
                            
                            
                        default:
                           
                        break
                        
                    }
                    addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundTwo, children: municipioNameLabel)
                    addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundTwo)
                }
        
            //Block manages short two words municipio names and longer one word names(CHECK COMMENTS ON FIRST BLOCK OF THE SWITCH CASE AS THEY FOLLOW THE SAME LOGIC)
        case "Barceloneta", "Canóvanas", "Juana Díaz", "Las Marías", "Las Piedras", "Rio Grande", "San Germán", "San Lorenzo", "Santa Isabel", "Barranquitas", "Quebradillas"://This municipio names will use municipiosNameBackgroundFour
            if municipiosNameBackgroundFour.parent == nil{
                switch(municipioNameLabel.parent?.name){
                    case "MunicipiosNameBackground":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackground.removeFromParent()
                        scaleMunicipioNameBackgroundFourForScreenSizes()
                    
                    case "MunicipiosNameBackgroundTwo":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundTwo.removeFromParent()
                        scaleMunicipioNameBackgroundFourForScreenSizes()
                    
                    case "MunicipiosNameBackgroundThree":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundThree.removeFromParent()
                        scaleMunicipioNameBackgroundFourForScreenSizes()
                    
                    default:
                    break
            }
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundFour, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundFour)
        }
            //Block manages long single words and short two words municipio names(CHECK COMMENTS ON FIRST BLOCK OF THE SWITCH CASE AS THEY FOLLOW THE SAME LOGIC)
        case  "Cabo Rojo", "Bayamón", "Guayanilla", "Guaynabo", "Guayama", "Humacao", "Mayagüez", "Maunabo", "Naguabo", "Peñuelas", "San Juan", "Vega Alta", "Vega Baja", "Naranjito", "Orocovis", "Trujillo Alto"://This municipio names will use municipiosNameBackgroundThree
            if municipiosNameBackgroundThree.parent == nil{
                switch(municipioNameLabel.parent?.name){
                    case "MunicipiosNameBackground":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackground.removeFromParent()
                        scaleMunicipioNameBackgroundThreeForScreenSizes()
                        
                    case "MunicipiosNameBackgroundTwo":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundTwo.removeFromParent()
                        scaleMunicipioNameBackgroundThreeForScreenSizes()
                        
                    case "MunicipiosNameBackgroundFour":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundFour.removeFromParent()
                        scaleMunicipioNameBackgroundThreeForScreenSizes()
                        
                    default:
                        break
                }
                
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundThree, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundThree)
            }
            
            //Following block receive most municipio names(shorter ones)This municipio names will use municipiosNameBackground (CHECK COMMENTS ON FIRST BLOCK OF THE SWITCH CASE AS THEY FOLLOW THE SAME LOGIC)
          default:
            if municipiosNameBackground.parent == nil{
                switch(municipioNameLabel.parent?.name){
                    case "MunicipiosNameBackgroundTwo":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundTwo.removeFromParent()
                    
                    case "MunicipiosNameBackgroundThree":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundThree.removeFromParent()
                    
                    case "MunicipiosNameBackgroundFour":
                        municipioNameLabel.removeFromParent()
                        municipiosNameBackgroundFour.removeFromParent()
                    
                    default:
                   
                    break
                    
                }
                addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackground, children: municipioNameLabel)
                addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackground)
            }
           
            break
        }
    }
    
    /*func setNewMunicipioNameToLookUp(){
        let countOfIndexes = municipios_names_array.count - 1
        randomIndex = Int.random(in:0...countOfIndexes)
        municipioNameLabel.text = municipios_names_array[randomIndex]//Se desplega el nuevo municipio a ser localizado por el jugador
        if municipioNameLabel.text == "Aguas Buenas" || municipioNameLabel.text == "Barceloneta" || municipioNameLabel.text == "Barranquitas" || municipioNameLabel.text == "Cabo Rojo"
        || municipioNameLabel.text == "Canóvanas" || municipioNameLabel.text == "Guayanilla" || municipioNameLabel.text == "Guaynabo" || municipioNameLabel.text == "Hormigueros"
        || municipioNameLabel.text == "Juana Díaz" || municipioNameLabel.text == "Las Marías" || municipioNameLabel.text == "Las Piedras" || municipioNameLabel.text == "Mayagüez"
        || municipioNameLabel.text == "Quebradillas" || municipioNameLabel.text == "Rio Grande" || municipioNameLabel.text == "Sabana Grande" || municipioNameLabel.text == "San Germán"
        || municipioNameLabel.text == "San Lorenzo" || municipioNameLabel.text == "San Sebastián" || municipioNameLabel.text == "Santa Isabel" || municipioNameLabel.text == "Trujillo Alto"{
            if municipiosNameBackgroundTwo.parent == nil{
            municipioNameLabel.removeFromParent()
            municipiosNameBackground.removeFromParent()
            addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackgroundTwo, children: municipioNameLabel)
            addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackgroundTwo)
            }
            //if else municipiosNameBackgroundTwo.parent
        }
        else {
            if municipiosNameBackground.parent == nil{
            municipioNameLabel.removeFromParent()
            municipiosNameBackgroundTwo.removeFromParent()
            addChildSKLabelNodeToParentSKSpriteNode(parent: municipiosNameBackground, children: municipioNameLabel)
            addChildSKSpriteNodeToParentSKSpriteNode(parent: controlPanelSKSpriteNode, children: municipiosNameBackground)
            }
        }
    }*/
    
    func scaleMunicipioNameBackgroundTwoForScreenSizes(){
        
        if screenSize.width == 2048.0 && screenSize.height == 2732.0{
            municipiosNameBackgroundTwo.setScale(1.9)
        }
        
        else if screenSize.width == 1668.0 && screenSize.height == 2224.0 || screenSize.width == 1536.0 && screenSize.height == 2048.0 || screenSize.width == 1668.0 && screenSize.height == 2388.0 || screenSize.width == 2048.0 && screenSize.height == 2732.0 || screenSize.width == 1620.0 && screenSize.height == 2160.0 || screenSize.width == 1640.0 && screenSize.height == 2360.0 || screenSize.width == 1488.0 && screenSize.height == 2266.0 {
            municipiosNameBackgroundTwo.setScale(1.75)
        }
        else{
            municipiosNameBackgroundTwo.setScale(1.20)
        }
    }
    
    func scaleMunicipioNameBackgroundThreeForScreenSizes(){
        
        if screenSize.width == 2048.0 && screenSize.height == 2732.0{
            municipiosNameBackgroundThree.setScale(1.9)
        }
        
        else if screenSize.width == 1668.0 && screenSize.height == 2224.0 || screenSize.width == 1536.0 && screenSize.height == 2048.0 || screenSize.width == 1668.0 && screenSize.height == 2388.0 || screenSize.width == 2048.0 && screenSize.height == 2732.0 || screenSize.width == 1620.0 && screenSize.height == 2160.0 || screenSize.width == 1640.0 && screenSize.height == 2360.0 || screenSize.width == 1488.0 && screenSize.height == 2266.0 {
            municipiosNameBackgroundThree.setScale(1.75)
        }
        else{
            municipiosNameBackgroundThree.setScale(1.20)
        }
    }
    
    func scaleMunicipioNameBackgroundFourForScreenSizes(){
        
        if screenSize.width == 2048.0 && screenSize.height == 2732.0{
            municipiosNameBackgroundFour.setScale(1.9)
        }
        
        else if screenSize.width == 1668.0 && screenSize.height == 2224.0 || screenSize.width == 1536.0 && screenSize.height == 2048.0 || screenSize.width == 1668.0 && screenSize.height == 2388.0 || screenSize.width == 2048.0 && screenSize.height == 2732.0 || screenSize.width == 1620.0 && screenSize.height == 2160.0 || screenSize.width == 1640.0 && screenSize.height == 2360.0 || screenSize.width == 1488.0 && screenSize.height == 2266.0 {
            municipiosNameBackgroundFour.setScale(1.75)
        }
        else{
            municipiosNameBackgroundFour.setScale(1.20)
        }
    }
    
    //function updates the label rendering the number of municipios identified already at the bottom right of screen
       func addToScoreCountWriteToLabel(){
           scoreCount += 1
           labelScores.text = "\(scoreCount)" + totalScoreCount//totalScoreCount es un constant string solo sirve al rendering del score
       }
       
       func addOneTocurrentIndexSetNameToLookUp(){
           skipButton.alpha = 0.9//efecto para skipButton al presionarlo, esta linea es solo una prueba y debo al menos sujetarlo a una condicion en el futuro como un if
           skipButtonPressed = true
           pressSKipButton = true
           setNewMunicipioNameToLookUp()
           //print("Skip Button touched")
       }
       
       func goToStartMenu(){
           let startMenuScene = StartMenuScene(size: self.size)//definitio
           //let transition = SKTransition.doorsOpenVertical(withDuration: 1.5)
           self.view?.presentScene(startMenuScene)/*present scene and execut transitions*/
       }
    
       func playIncorrectSound(){
           if StartMenuScene.gamePlaySoundOn == true{
               run(/*StartScene.*/incorrectSound)
           }
       }
       
    //function detects when the touch on screen have ended in order to complete alpha effect that started at addOneTocurrentIndexSetNameToLookUp()
      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          //Efecto para el skipButton cuando se suelta el boton
          if skipButtonPressed == true{
              skipButton.alpha = 1.0//Ojo esto se veria mejor dentro de un if sin embargo  si utilizo una condicion como if skipButton.alpha == 1.0 causa un glitch, pero puedo hacer una condicion con una variable boolean
              skipButtonPressed = false
          }
          //Exit button does not have alpha effect as it goes out of view when pressed
      }
    
    func labelForMunicipioNames(NameMunicipioLabel: SKLabelNode) -> SKLabelNode {//child of labelMunicipiosNameBackground()
         NameMunicipioLabel.position = CGPoint(x:0.5 /*self.size.width/2*/, y:-6.5 /*self.size.height/2 * 0.14*/)
         NameMunicipioLabel.fontName = "Helvetica"
         NameMunicipioLabel.fontSize = 18
         NameMunicipioLabel.fontColor = UIColor.init(red: 0.898, green: 0.9765, blue: 0, alpha: 1.0)
         randomIndex = Int.random(in:0...77)
         NameMunicipioLabel.text = municipios_names_array[randomIndex]
         municipiosNameBackground.size = NameMunicipioLabel.frame.size
         //NameMunicipioLabel.zPosition = 2
         return NameMunicipioLabel
     }
    
    func labelMunicipiosNameBackground() -> SKSpriteNode{
        let background = SKSpriteNode()
        background.color = UIColor.init(red: 0.8078, green: 0.6039, blue: 0, alpha: 1.0)//#ce9a00
        background.size = CGSize(width:CGFloat(75), height:CGFloat(17))
        background.position = CGPoint(x:0.5/*goldenBackground().size.width/200*/, y:-0.5/*goldenBackground().size.height/2 * 0.18*/)
        background.size = municipioNameLabel.frame.size
        //background.addChild(labelForMunicipioNames(NameMunicipioLabel: municipioNameLabel))
        //background.zPosition = 5
        return background
    }
    
    /*func splitTextIntoFields(theText:SKLabelNode)->String{
        useLine2 = false//Esta linea resetea la variable que es necesario para no crear redundancia cuando se pasa el texto a label(ej:aguas aguas buenas)
        twoLineText = theText.text!//texto que necesitamos dividir en dos lineas
        //var i: Int = 0
        var line1:String = ""//declaracion de las variables que se van a devolver
        var line2:String = ""
            
            
        for letter in twoLineText{//Cada letra contenida en el String es desglosada por el for loop
            if (String(letter) == " "){
                useLine2 = true
            }
                
            if(useLine2 == false){
                line1 = line1 + String(letter)//casting of letter to String
            }
            else {
                line2 = line2 + String(letter)
            }
                
            //i += 1
        }
        return line1
    }

    func splitTextIntoFieldsTwo(theText:SKLabelNode)->String{
        useLine2 = false
        twoLineText = theText.text!
        //var i: Int = 0
        var line1:String = ""
        var line2:String = ""
            
            
        for letter in twoLineText{
            if (String(letter) == " "){
                useLine2 = true
            }
                
            if(useLine2 == false){
                line1 = line1 + String(letter)
            }
            else {
                line2 = line2 + String(letter)
            }
                
            //i += 1
            }
        return line2
    }*/
    
    
    
}
