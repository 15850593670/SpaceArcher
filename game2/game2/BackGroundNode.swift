//
//  backGroundNode.swift
//  game2
//
//  Created by nju on 16/7/9.
//  Copyright © 2016年 NJU. All rights reserved.
//

import Foundation
import SpriteKit

class BackGroundNode: SKNode{
    let bg1=SKSpriteNode(imageNamed: "texture/bg_galaxy.png")
    let bg2=SKSpriteNode(imageNamed: "texture/bg_planetsunrise.png")
    let bg3=SKSpriteNode(imageNamed: "texture/bg_spacialanomaly.png")
    let bg4=SKSpriteNode(imageNamed: "texture/bg_spacialanomaly2.png")
    override init(){
        super.init()
        initBackGround()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initBackGround(){
        
        //fightPlane.setScale(0.15)
        bg1.position=CGPointMake(CGFloat(1300), CGFloat(600))
        self.addChild(bg1)
        let vec=CGVectorMake(-1500, 0)
        let action1=SKAction.moveBy(vec, duration: 20)
        bg1.runAction(action1, completion: adjustPosition1)
        
        bg2.position=CGPointMake(CGFloat(0), CGFloat(300))
        self.addChild(bg2)
        let vec2=CGVectorMake(1500, 0)
        let action2=SKAction.moveBy(vec2, duration: 15)
        bg2.runAction(action2, completion: adjustPosition2)
        
        bg3.position=CGPointMake(CGFloat(1000), CGFloat(500))
        self.addChild(bg3)
        let vec3=CGVectorMake(-500, 0)
        let action3=SKAction.moveBy(vec3, duration: 10)
        bg3.runAction(action3, completion: adjustPosition3)
        
        bg4.position=CGPointMake(CGFloat(500), CGFloat(200))
        self.addChild(bg4)
        let vec4=CGVectorMake(300, 0)
        let action4=SKAction.moveBy(vec4, duration: 10)
        bg4.runAction(action4, completion: adjustPosition4)
    }
    
    func adjustPosition1(){
        let action12 = SKAction.moveTo(CGPointMake(CGFloat(1300), CGFloat(600)), duration: 0)
        bg1.runAction(action12)
        let vec=CGVectorMake(-1500, 0)
        let action1=SKAction.moveBy(vec, duration: 20)
        bg1.runAction(action1, completion: adjustPosition1)
    }
    func adjustPosition2(){
        let action22 = SKAction.moveTo(CGPointMake(CGFloat(0), CGFloat(300)), duration: 0)
        bg2.runAction(action22)
        let vec2=CGVectorMake(1500, 0)
        let action2=SKAction.moveBy(vec2, duration: 15)
        bg2.runAction(action2, completion: adjustPosition2)
    }
    func adjustPosition3(){
        let action32 = SKAction.moveTo(CGPointMake(CGFloat(arc4random()%1000 + 300), CGFloat(arc4random()%500+100)), duration: 0)
        bg3.runAction(action32)
        let vec3=CGVectorMake(-500, 0)
        let action3=SKAction.moveBy(vec3, duration: 10)
        bg3.runAction(action3, completion: adjustPosition3)
    }
    func adjustPosition4(){
        let action42 = SKAction.moveTo(CGPointMake(CGFloat(arc4random()%1000 + 300), CGFloat(arc4random()%500+100)), duration: 0)
        bg4.runAction(action42)
        let vec4=CGVectorMake(300, 0)
        let action4=SKAction.moveBy(vec4, duration: 10)
        bg4.runAction(action4, completion: adjustPosition4)
    }
}