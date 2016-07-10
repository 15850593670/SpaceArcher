//
//  startScene.swift
//  game2
//
//  Created by nju on 16/6/7.
//  Copyright © 2016年 NJU. All rights reserved.
//

import UIKit
import SpriteKit


class startScene: SKScene {
    var historyBest:Int = 0
    let startLabel = SKLabelNode(fontNamed:"Chalkduster")
    let welcomeLabel = SKLabelNode(fontNamed:"Chalkduster")
    let titleLabel = SKLabelNode(fontNamed:"Chalkduster")
    let UFO=SKSpriteNode(imageNamed: "texture/ufo.png")
    let fightPlane=SKSpriteNode(imageNamed: "texture/bomber.png")
    
    override init(size: CGSize) {
        super.init(size: size)
        //backgroundColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        //let background = BackGroundNode()
        //self.addChild(background)
        
        backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        welcomeLabel.text = "Welcome to"
        welcomeLabel.fontSize = 40
        welcomeLabel.fontColor = SKColor.yellowColor()
        welcomeLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 100)
        titleLabel.text = "Space Archer"
        titleLabel.fontSize = 80
        titleLabel.fontColor = SKColor.redColor()
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        startLabel.text = "START"
        startLabel.fontSize = 30
        startLabel.fontColor = SKColor.whiteColor()
        startLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 75)
        self.addChild(welcomeLabel)
        self.addChild(titleLabel)
        self.addChild(startLabel)
        
        UFO.setScale(0.3)
        UFO.anchorPoint = CGPoint(x:0.5, y:0.5)
        UFO.position=CGPointMake(CGFloat(800), CGFloat(450))
        self.addChild(UFO)
        adjustPosition()
        
        
        fightPlane.setScale(0.15)
        fightPlane.position=CGPointMake(CGFloat(1300), CGFloat(600))
        self.addChild(fightPlane)
        let vec=CGVectorMake(-1500, 0)
        let action3=SKAction.moveBy(vec, duration: 2)
        let action4 = SKAction.moveToX(1300, duration: 0)
        fightPlane.runAction(SKAction.repeatActionForever(SKAction.sequence([action3, action4])))
    }
    
    
    func adjustPosition(){
        let action22 = SKAction.moveTo(CGPointMake(CGFloat(arc4random()%800+100), CGFloat(arc4random()%500+100)), duration: 0)
        UFO.runAction(action22)
        let action=SKAction.scaleTo(0.5, duration: 2.0)
        let action2=SKAction.scaleTo(0.3, duration: 1.5)
        
        UFO.runAction(SKAction.sequence([action,action2]), completion: adjustPosition)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView){
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        for touch: UITouch in touches {
            
            let tx :CGFloat = touch.locationInNode(self).x
            let ty :CGFloat = touch.locationInNode(self).y
            print("tx: \(tx) ty: \(ty) midx: \(CGRectGetMidX(self.frame) - 100)")
            if(tx >= CGRectGetMidX(self.frame) - 90 && tx <= CGRectGetMidX(self.frame) + 90 && ty >= CGRectGetMidY(self.frame) - 110 && ty <= CGRectGetMidY(self.frame) - 40){
                
                if let vc = fcontroller(self.view!){
                    let vc1 = vc as! GameViewController
                    vc1.presentNewGameScene()
                }
            }

        }
    }
    func fcontroller(view: UIView) -> UIViewController?{
        var next:UIView? = view
        repeat{
            if let nextR = next?.nextResponder() where nextR.isKindOfClass(UIViewController.self){
                return (nextR as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }

}
