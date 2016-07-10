//
//  GameViewController.swift
//  game2
//
//  Created by nju on 16/6/3.
//  Copyright (c) 2016年 NJU. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var gameStartScene :startScene!
    var gameScene: GameScene!
    var gameOverScene: GameOverScene!
    var skView: SKView!
    var highscore:UserSave = UserSave(Score: 0)
    let background = BackGroundNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.multipleTouchEnabled = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        gameStartScene = startScene(size: CGSizeMake(1024, 768))
        /* Set the scale mode to scale to fit the window */
        gameStartScene.scaleMode = .AspectFill
        
        gameOverScene = GameOverScene(size: CGSizeMake(1024, 768), score: 0)
        gameOverScene.scaleMode = .AspectFill
        gameScene = GameScene(size: CGSizeMake(1024, 768))
        
        read()
        background.zPosition = -1.0
        presentStartScene()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func print123(){
        print(123)
    }
    func presentStartScene(){
        background.removeFromParent()
        gameStartScene.addChild(background)
        skView.presentScene(gameStartScene)
    }
    func presentNewGameScene(){
        gameScene = GameScene(size: CGSizeMake(1024, 768))
        gameScene.scaleMode = .AspectFill
        background.removeFromParent()
        gameScene.addChild(background)
        skView.presentScene(gameScene)
    }
    func presentGameOverScene(score: Int){
        gameOverScene.score = score
        gameOverScene.historyBest = highscore.score
        background.removeFromParent()
        gameOverScene.addChild(background)
        skView.presentScene(gameOverScene)
    }
    
    
    
    func read() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        //let documentsDirectory = paths[0] as String
        //let path = String(NSURL(fileURLWithPath: documentsDirectory).URLByAppendingPathComponent("HighScores.plist"))
        let documentsDirectory = paths.objectAtIndex(0) as! NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist");
        print(path)
        
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if !fileManager.fileExistsAtPath(path) {
            // create an empty file if it doesn't exist
            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
                do{
                    try fileManager.copyItemAtPath(bundle, toPath: path)
                }catch let err as NSError{
                    print(err.description)
                }
            }
        }
        
        if let rawData = NSData(contentsOfFile: path) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let scoreArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
            self.highscore = (scoreArray as? UserSave)!;
        }
    }
    

    func save() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.highscore);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as! NSString;
        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist");
        
        saveData.writeToFile(path, atomically: true);
    }
    
    func updateHistoryBest(score: Int){
        self.highscore.score = score
        save()
        gameOverScene.historyBest = score
    }
    
}
