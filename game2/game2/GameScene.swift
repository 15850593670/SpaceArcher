//
//  GameScene.swift
//  game2
//
//  Created by nju on 16/6/3.
//  Copyright (c) 2016年 NJU. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    var bow = SKSpriteNode(imageNamed: "texture/bow.png")
    var arrow = SKSpriteNode(imageNamed: "texture/arrow.png")
    var scorelabel = SKLabelNode(fontNamed:"Chalkduster")
    var turnlabel = SKLabelNode(fontNamed: "Chalkduster")
    var pauselabel = SKLabelNode(fontNamed: "Chalkduster")
    let resumeLabel = SKLabelNode(fontNamed:"Chalkduster")
    let titleLabel = SKLabelNode(fontNamed:"Chalkduster")
    let quitLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var helpPoint: SKShapeNode!
    var helpline:SKShapeNode?
    var height = 768
    var length = 1024
    var xBegin = 200
    var yBegin = 200
    var xMid = 800
    var lastK:Float = 0
    var touchBeginPoint: CGPoint!
    
    var arrowposition = CGPoint(x:200, y:200)
    //var rotateP: CGPoint = CGPoint(x: 36,y: 236)
    //var touchP: CGPoint = CGPoint(x:0, y:0)
    var touchbegin = false
    var touchdismiss = false
    
    let planeTexture = SKTexture(imageNamed: "texture/plane.png")
    let smallblowup = SKTexture(imageNamed: "texture/explosion.png")
    var blowup = [SKTexture]()
    let ArrowCategory:UInt32=1<<1
    let PlaneCategory:UInt32=1<<2
    let BomberCategory:UInt32=1<<3
    let UFOCategory:UInt32=1<<4
    var planenum = 6
    var lastTime:CFTimeInterval = 0
    var pauseTime:CFTimeInterval = 0
    var speedTime:CFTimeInterval = 0
    let remove=SKAction.removeFromParent()
    let wait=SKAction.moveBy(CGVectorMake(0, 0), duration: 4.5)
    
    var arrowrunbit: Bool = false
    var touchAllowbit: Bool = true
    var score:Int = 0
    var totalscore:Int = 0
    var turn:Int = 1
    var coin:Int = 0
    var gameover:Bool = false
    var speedup:Bool = false
    var isbomber = false
    var sizelevel:CGFloat = 1
    
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        //backgroundColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        //let background = BackGroundNode()
        //self.addChild(background)
        
        backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        scorelabel.fontSize = 20
        scorelabel.position = CGPoint(x: length - 200, y: height - 200)
        scorelabel.text = "SCORE: \(totalscore)"
        self.addChild(scorelabel)
        
        turnlabel.fontSize = 60
        turnlabel.position = CGPoint(x: length / 2, y: height - 150)
        turnlabel.text = "TURN: \(turn)"
        self.addChild(turnlabel)
        
        pauselabel.fontSize = 30
        pauselabel.position = CGPoint(x: 50, y: height - 130)
        pauselabel.text = "| |"
        self.addChild(pauselabel)
        
        srand48(Int(time(nil)))
        self.physicsWorld.contactDelegate=self
        self.physicsWorld.gravity=CGVectorMake(0, -2)
        
        blowup.append(SKTexture(imageNamed: "texture/firebomber.png"))
        blowup.append(SKTexture(imageNamed: "texture/firebomber2.png"))
        blowup.append(SKTexture(imageNamed: "texture/firebomber3.png"))
        blowup.append(SKTexture(imageNamed: "texture/explosion.png"))
        
        bow.anchorPoint = CGPoint(x:0, y:0)
        bow.setScale(2.0)
        bow.position = CGPoint(x: xBegin, y:yBegin)
        self.addChild(bow)
        
        arrow.anchorPoint = CGPoint(x:0, y:0)
        arrow.setScale(1.5)
        arrow.position = CGPoint(x:xBegin, y:yBegin)
        //let arrowsize = CGSize(width: 32, height: 5)
        arrow.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        arrow.physicsBody?.dynamic = false
        arrow.physicsBody?.categoryBitMask = ArrowCategory
        arrow.physicsBody?.collisionBitMask = 0
        arrow.physicsBody?.contactTestBitMask = PlaneCategory
        self.addChild(arrow)
        
        helpline = SKShapeNode(path: CGPathCreateMutable())
        self.addChild(helpline!)
        
        helpPoint = SKShapeNode(circleOfRadius: 10)
        helpPoint.fillColor = SKColor(red: 0.8, green: 0.6, blue: 0.6, alpha: 0.8)
        helpPoint.position = CGPoint(x:500, y: 400)
        
        runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("sounds/game_music.mp3", waitForCompletion: true)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      //  height = Int(CGRectGetMaxY(self.frame))
      //  length = Int(CGRectGetMaxX(self.frame))
        //print("heoght: \(height) length: \(length)")
        
        
        
        //self.addChild(myLabel)
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        let a=contact.bodyA.categoryBitMask
        let b=contact.bodyB.categoryBitMask
        var body=contact.bodyA
        if a < b {
            body=contact.bodyB
        }
        if a | b == ArrowCategory | PlaneCategory{
            print("eneny die")
            score += 1
            runAction(SKAction.playSoundFileNamed("sounds/enemy1_down.mp3", waitForCompletion: false))
            var sblowup = [SKTexture]()
            sblowup.append(planeTexture)
            sblowup.append(smallblowup)
            let sblow = SKAction.animateWithTextures(sblowup, timePerFrame: 0.08)
            body.node?.runAction(SKAction.sequence([sblow,remove]))
        }
        if a | b == ArrowCategory | BomberCategory{
            print("bomber die")
            score += 2
            runAction(SKAction.playSoundFileNamed("sounds/enemy2_down.mp3", waitForCompletion: false))
            //body.node?.removeFromParent()
            let blow = SKAction.animateWithTextures(blowup, timePerFrame: 0.12)
            body.node?.runAction(SKAction.sequence([blow,remove]))
            arrow.position=arrowposition
        }
        if a | b == ArrowCategory | UFOCategory{
            print("UFO die")
            runAction(SKAction.playSoundFileNamed("sounds/bullet.mp3", waitForCompletion: false))
            totalscore += Int(arc4random() % 15 + 1)
            coin += Int(arc4random() % 5) + 1
            let smaller = SKAction.scaleTo(0, duration: 0.15)
            body.node?.runAction(SKAction.sequence([smaller,remove]))
        }
    }
	
	func addscore(hit: Int) -> Int{
	    var total:Int = (hit + 1) * hit / 2
		if hit == planenum {
		    total += hit
		}
        if hit >= 2 {
            speedup=true;
            print("speed")
        }
        if hit >= 3 {
            coin += 1
        }
		return total
	}
    
    func freshScore(){
        totalscore += addscore(score)
        //score = 0
        scorelabel.text = "SCORE: \(totalscore)"
        //turn += 1
        turnlabel.text = "TURN: \(turn)"
        
        yBegin = (yBegin + 777) * 7 % (height - 400) + 200
        arrow.position = CGPointMake(CGFloat(xBegin), CGFloat(yBegin))
        bow.position = CGPointMake(CGFloat(xBegin), CGFloat(yBegin))
    }
    
    func drawhelpline(tpoint: CGPoint){
        let dx: Double = -Double(tpoint.x - CGFloat(touchBeginPoint.x))
        let dy: Double = -Double(tpoint.y - CGFloat(touchBeginPoint.y))
        //  if(dx > 0 && dy > 0){
        /*print("dx: \(dx) dy: \(dy)")
        let timex = Double(length - xBegin) / abs(dx)
        let timey = Double(height - yBegin) / abs(dy)
        let times = timex > timey ? timey : timex*/
        
        
        let path = UIBezierPath()
        /* CGPathMoveToPoint(path, nil, CGFloat(xBegin), CGFloat(yBegin))
         CGPathAddLineToPoint(path, nil , CGFloat(dx * times / 3 + Double(xBegin)), CGFloat(dy * times / 3 + Double(yBegin)))
         */
        path.moveToPoint(CGPointMake(CGFloat(xBegin), CGFloat(yBegin)))
        path.addLineToPoint(CGPointMake(CGFloat(300 / (abs(dx) + abs(dy)) * dx + Double(xBegin)), CGFloat(300 / (abs(dx) + abs(dy)) * dy + Double(yBegin))))
        //path.addLineToPoint(CGPointMake(CGFloat(dx * times / 3 + Double(xBegin)), CGFloat(dy * times / 3 + Double(yBegin))))
        let pattern:[CGFloat] = [10.0, 10.0]
        let dashed = CGPathCreateCopyByDashingPath(path.CGPath, nil, 0, pattern, 2)
        //print("\(")
        //helpline = SKShapeNode(path: path)
        helpline?.path = dashed
        //helpline!.glowWidth = 1
        helpline!.antialiased = true
        helpline?.fillColor = SKColor(red: 0.8, green: 0.6, blue: 0.6, alpha: 0.8)
        helpline?.lineWidth = CGFloat(2.0 * 2.0 / log2(Double(turn + 1)))
    }
    
    func calculateAngle(tpoint: CGPoint) -> CGFloat{
        let x:Int = Int(tpoint.x)
        let y:Int = Int(tpoint.y)
   
        let xb:Int = Int(touchBeginPoint.x)
        let yb:Int = Int(touchBeginPoint.y)
        
        let k:Float = (Float(y) - Float(touchBeginPoint.y))/(Float(x)-Float(touchBeginPoint.x))
        let ret = atan(k) - Float(45.0/180.0 * M_PI)
        if(x == xb){
            if(y >= yb){
                return CGFloat(Float(-135.0/180.0 * M_PI))
            }
            else{
                return CGFloat(Float(45.0/180.0 * M_PI))
            }
        }
        if(y == yb){
            if(x >= xb){
                return CGFloat(Float(135.0/180.0 * M_PI))
            }
            else{
                return CGFloat(Float(-45.0/180.0 * M_PI))
            }
        }
        if(x > xb){
            return CGFloat(ret + Float(M_PI))
        }
        return CGFloat(ret)

    }
    func back(){
        arrow.position = arrowposition
        arrowrunbit = false
        /*if(score == 0){
            if let vc = fcontroller(self.view!){
                let vc1 = vc as! GameViewController
                vc1.presentGameOverScene(totalscore)
            }
        }*/
        if(score>0){
            freshScore()
        }
    }
    
    func drawHelpPoint(){
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: UITouch in touches {
            let tx=Int(touch.locationInNode(self).x)
            let ty=Int(touch.locationInNode(self).y)
            if(self.paused == true){
                if(tx >= Int(CGRectGetMidX(self.frame)) - 50 && tx <= Int(CGRectGetMidX(self.frame)) + 50 && ty >= Int(CGRectGetMidY(self.frame)) - 45 && ty <= Int(CGRectGetMidY(self.frame)) - 15){
                    self.paused = false
                    titleLabel.removeFromParent()
                    resumeLabel.removeFromParent()
                    quitLabel.removeFromParent()
                    //self.backgroundColor = SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0)
                    lastTime=CACurrentMediaTime()-pauseTime
                }
                if(tx >= Int(CGRectGetMidX(self.frame)) - 50 && tx <= Int(CGRectGetMidX(self.frame)) + 50 && ty >= Int(CGRectGetMidY(self.frame)) - 95 && ty <= Int(CGRectGetMidY(self.frame)) - 65){
                    if let vc = fcontroller(self.view!){
                        let vc1 = vc as! GameViewController
                        vc1.presentStartScene()
                    }
                }
            }
            else{
                if(tx >= 10 && tx <= 100 && ty >= height - 160 && ty <= height - 90){
                    self.paused = true
                    pauseTime=CACurrentMediaTime()-lastTime
                    //self.backgroundColor = SKColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0)
                    titleLabel.text = "PAUSED"
                    titleLabel.fontSize = 40
                    titleLabel.fontColor = SKColor.blueColor()
                    titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 20)
                    resumeLabel.text = "Resume"
                    resumeLabel.fontSize = 30
                    resumeLabel.fontColor = SKColor.yellowColor()
                    resumeLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 30)
                    quitLabel.text = "Quit"
                    quitLabel.fontSize = 30
                    quitLabel.fontColor = SKColor.yellowColor()
                    quitLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 80)
                    self.addChild(titleLabel)
                    self.addChild(resumeLabel)
                    self.addChild(quitLabel)
                }
                else{
                /*if(tx >= xBegin){
                    continue
                }*/
                if(arrowrunbit == false){
                    touchBeginPoint = touch.locationInNode(self)
                    /*let an = calculateAngle(touch.locationInNode(self))
                    let action = SKAction.rotateToAngle(an, duration: 0)
                    bow.runAction(action)
                    arrow.runAction(action)*/
                    arrowposition = arrow.position
                    touchbegin = true
                    //drawhelpline(touch.locationInNode(self))
                    runAction(SKAction.playSoundFileNamed("sounds/pull.mp3", waitForCompletion: false))
                    helpPoint.position = touch.locationInNode(self)
                    helpPoint.removeFromParent()
                    self.addChild(helpPoint)
                }
                }
            }
    
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch: AnyObject in touches {
           /* if(Int(touch.locationInNode(self).x) > xBegin){
                continue
            }
                if(Int(touch.locationInNode(self).y) >= yBegin){
             continue
             }*/
            if(touchbegin == true){
                if(arrowrunbit == false){
                    let an = calculateAngle(touch.locationInNode(self))
                    //print("angle: \(an)")
                    let action = SKAction.rotateToAngle(an, duration: 0)
                    bow.runAction(action)
                    arrow.runAction(action)
                    drawhelpline(touch.locationInNode(self))
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches {
            if touchAllowbit == false || touchbegin == false{
                continue
            }
            let vec: CGVector
           /* if Int(touch.locationInNode(self).x) >= xBegin{
                if Int(touch.locationInNode(self).y) < yBegin{
                    vec = CGVector(dx: 0, dy: self.height)
                }
                else{
                    vec = CGVector(dx: 0, dy: -self.height)
                }
            }
            else{*/
                arrowposition = arrow.position
                let dx: Double = -Double(touch.locationInNode(self).x - CGFloat(touchBeginPoint.x))
                let dy: Double = -Double(touch.locationInNode(self).y - CGFloat(touchBeginPoint.y))
                /*let timex = Double(length - xBegin) / abs(dx)
                let timey = Double(height - yBegin) / abs(dy)
                let times = timex > timey ? timey : timex*/
            
                vec = CGVector(dx: 1000 / (abs(dx) + abs(dy)) * dx , dy: 1000 / (abs(dx) + abs(dy)) * dy )
           // }
            var traveltime:NSTimeInterval = 1.5
            if speedup == true {
                traveltime = 0.8
            }
            speedup = false
            runAction(SKAction.playSoundFileNamed("sounds/shoot.mp3", waitForCompletion: false))
            let action2 = SKAction.moveBy(vec, duration: traveltime)
            arrow.runAction(action2, completion: back)
            arrowrunbit = true
            touchAllowbit = false
            //     }
            touchbegin = false
            helpline?.path = CGPathCreateMutable()
            helpPoint.removeFromParent()
        }
        print("touch event end!")
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
    {
        print("event canceled!")
        helpPoint.removeFromParent()
        helpline?.path = CGPathCreateMutable()
        arrowrunbit = false
        touchAllowbit = true
        touchbegin = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(currentTime>=lastTime+5){
            //arrowrunbit = false
            touchAllowbit = true
            if(lastTime != 0 && score == 0){
                if let vc = fcontroller(self.view!){
                    let vc1 = vc as! GameViewController
                    vc1.presentGameOverScene(totalscore)
                }
            }
            score = 0
            let judge=drand48()
            if(judge<=0.8){
                isbomber=false
                planenum=Int(arc4random()%5)+2
                for i in 0..<planenum{
                    createplane(i)
                }
                let judge2=drand48()
                if(judge2>0.9){
                    createUFO()
                }
            }
            else{
                isbomber=true
                createbomber()
            }
            turn=turn+1
            if(turn%20==0&&turn<=100){
                sizelevel = 1-CGFloat(turn)/400
            }
            lastTime=currentTime
        }
        //if(currentTime>=speedTime+10)
    }
    
    func createplane(no:Int){
        let plane=SKSpriteNode(texture: planeTexture)
        plane.setScale(0.1*sizelevel)
        plane.position=CGPointMake(size.width*CGFloat((drand48()+Double(no))*0.6/Double(planenum)+0.4), 1)
        plane.physicsBody=SKPhysicsBody(rectangleOfSize: CGSizeMake(50*sizelevel, 25*sizelevel))
        plane.physicsBody?.categoryBitMask=PlaneCategory
        plane.physicsBody?.collisionBitMask=0
        plane.physicsBody?.contactTestBitMask=ArrowCategory
        let rdm=CGFloat(arc4random()%200+450)
        plane.physicsBody?.velocity=CGVectorMake(0, rdm)
        self.addChild(plane)
        plane.runAction(SKAction.sequence([wait,remove]))
        //plane.runAction()
    }
    
    func createbomber(){
        let bomber=SKSpriteNode(texture: SKTexture(imageNamed: "texture/bomber.png"))
        bomber.setScale(0.15*sizelevel)
        bomber.position=CGPointMake(size.width*0.99, CGFloat(arc4random()%300+300))
        bomber.physicsBody=SKPhysicsBody(rectangleOfSize: CGSizeMake(70*sizelevel, 35*sizelevel))
        bomber.physicsBody?.categoryBitMask=BomberCategory
        bomber.physicsBody?.collisionBitMask=0
        bomber.physicsBody?.contactTestBitMask=ArrowCategory
        bomber.physicsBody?.affectedByGravity=false
        self.addChild(bomber)
        let vec=CGVectorMake(-size.width*0.99, 0)
        let action=SKAction.moveBy(vec, duration: 4.5*CFTimeInterval(sizelevel))
        bomber.runAction(action,completion:back)
    }
    
    func createUFO(){
        let UFO=SKSpriteNode(texture: SKTexture(imageNamed: "texture/ufo.png"))
        UFO.setScale(0.25*sizelevel)
        UFO.position=CGPointMake(CGFloat(arc4random()%600+400), CGFloat(arc4random()%300+300))
        UFO.physicsBody=SKPhysicsBody(rectangleOfSize: CGSizeMake(60*sizelevel, 35*sizelevel))
        UFO.physicsBody?.categoryBitMask=UFOCategory
        UFO.physicsBody?.collisionBitMask=0
        UFO.physicsBody?.contactTestBitMask=ArrowCategory
        UFO.physicsBody?.affectedByGravity=false
        self.addChild(UFO)
        let vec=CGVectorMake(0, 0)
        let action=SKAction.moveBy(vec, duration: 3)
        UFO.runAction(SKAction.sequence([action,remove]))
        
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
