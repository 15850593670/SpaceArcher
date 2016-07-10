//
//  GameOverScene.swift
//  game2
//
//  Created by nju on 16/6/4.
//  Copyright © 2016年 NJU. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var score:Int = 0
    let RestartLabel = SKLabelNode(fontNamed:"Chalkduster")
    let quitLabel = SKLabelNode(fontNamed:"Chalkduster")
    let ScoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    let GGLabel = SKLabelNode(fontNamed:"Chalkduster")
    let bestScoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var historyBest: Int = 0
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        self.score = score
        //backgroundColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        //let background = BackGroundNode()
        //self.addChild(background)
        backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        runAction(SKAction.playSoundFileNamed("sounds/game_over.mp3", waitForCompletion: false))
        
        GGLabel.text = "Game Over :["
        GGLabel.fontSize = 45
        GGLabel.fontColor = SKColor.redColor()
        GGLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2+50)
        
        ScoreLabel.text = "Score: \(score)"
        ScoreLabel.fontSize = 30
        ScoreLabel.fontColor = SKColor.redColor()
        ScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        RestartLabel.text = "RESTART"
        RestartLabel.fontSize = 30
        RestartLabel.fontColor = SKColor.blueColor()
        RestartLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 50)
        
        quitLabel.text = "QUIT"
        quitLabel.fontSize = 30
        quitLabel.fontColor = SKColor.blueColor()
        quitLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        
        bestScoreLabel.fontSize = 30
        bestScoreLabel.fontColor = SKColor.greenColor()
        bestScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame) - 200, y:CGRectGetMidY(self.frame) + 100)
        bestScoreLabel.zRotation = 0.25
        
        self.addChild(GGLabel)
        self.addChild(ScoreLabel)
        self.addChild(RestartLabel)
        self.addChild(quitLabel)
        self.addChild(bestScoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView){
//    func setLabel(){
        //self.backgroundColor = SKColor(red:1.0, green:0, blue:1.0, alpha:1.0)
        
        
        presentScore()
    }
    
    func presentScore(){
        if score > historyBest{
            if let vc = fcontroller(self.view!){
                let vc1 = vc as! GameViewController
                vc1.updateHistoryBest(score)
            }
        }
        ScoreLabel.text = "Score: \(score)"
        bestScoreLabel.text = "Best Score: \(historyBest)"
        
    }
    
    func directorAction() {
        let actions: [SKAction] = [ SKAction.waitForDuration(3.0), SKAction.runBlock({
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: reveal)
        }) ]
        let sequence = SKAction.sequence(actions)
        
        self.runAction(sequence)
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            for touch: UITouch in touches {
            
            let tx :CGFloat = touch.locationInNode(self).x
            let ty :CGFloat = touch.locationInNode(self).y
            print("tx: \(tx) ty: \(ty) midx: \(CGRectGetMidX(self.frame) - 100)")
            if(tx >= CGRectGetMidX(self.frame) - 80 && tx <= CGRectGetMidX(self.frame) + 80 && ty >= CGRectGetMidY(self.frame) - 50 && ty <= CGRectGetMidY(self.frame) - 20){
                    if let vc = fcontroller(self.view!){
                        let vc1 = vc as! GameViewController
                        vc1.presentNewGameScene()
                    }
             //   }
            }
                if(tx >= CGRectGetMidX(self.frame) - 80 && tx <= CGRectGetMidX(self.frame) + 80 && ty >= CGRectGetMidY(self.frame) - 100 && ty < CGRectGetMidY(self.frame) - 70){
                    if let vc = fcontroller(self.view!){
                        let vc1 = vc as! GameViewController
                        vc1.presentStartScene()
                    }
                }

        }
    }
}
