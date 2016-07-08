//
//  GameScene.swift
//  drawing
//
//  Created by synaptics on 7/6/16.
//  Copyright (c) 2016 Amino. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    enum state{
        case playing, ended
    }
    
    var touch : UITouch!
    var lastPoint : CGPoint!
    var currentPoint : CGPoint!

    var path : CGMutablePath! = nil
    
    var paths = [SKShapeNode]()
    var count = 0
    
    var square : SKSpriteNode!
    var jumpButton : MSButtonNode!
    var restartButton : MSButtonNode!
    var goal1 : SKSpriteNode!
    var goal2 : SKSpriteNode!
    
    var currentState:state = .playing
    
    var goalNum = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        physicsWorld.contactDelegate = self
        
        square = childNodeWithName("square") as! SKSpriteNode
        jumpButton = childNodeWithName("jump") as! MSButtonNode
        jumpButton.selectedHandler = {
            if self.currentState == .ended {return}
            self.square.physicsBody?.velocity = CGVectorMake(0, 0)
            self.square.physicsBody?.applyImpulse(CGVectorMake(0, 40))
        }
        
        restartButton = childNodeWithName("restartButton") as! MSButtonNode
        restartButton.selectedHandler = {
            
            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            
            /* Restart game scene */
            skView.presentScene(scene)
            
        }
        
        goal1 = childNodeWithName("goal1") as! SKSpriteNode
        goal2 = childNodeWithName("goal2") as! SKSpriteNode

        
        restartButton.state = .Hidden
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if currentState != .playing {return}
        
        if count > 3{
            removeChildrenInArray(paths)
            count = 0
        }
        count += 1
        path = CGPathCreateMutable()
        touch = touches.first
        lastPoint = touch.locationInNode(self)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentState != .playing {return}

        touch = touches.first
        currentPoint = lastPoint
        lastPoint = touch.locationInNode(self)
        drawRect()
    }
    
    func drawRect(){

        CGPathMoveToPoint(path, nil, lastPoint.x, lastPoint.y)
        CGPathAddLineToPoint(path, nil, currentPoint.x, currentPoint.y)
        
        let shape = SKShapeNode()
        shape.path = path
        shape.strokeColor = UIColor.blueColor()
        shape.lineWidth = 2
        paths.append(shape)
        shape.physicsBody = SKPhysicsBody(edgeFromPoint: currentPoint, toPoint: lastPoint)
        addChild(shape)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        
        if currentState != .playing {return}
        
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if ((nodeA.name == "goal1" || nodeA.name == "goal2") && nodeB.name == "square") || ((nodeB.name == "goal1" || nodeB.name == "goal2") && nodeA.name == "square") {
           
           if (nodeA.name == "goal1" || nodeB.name == "goal1") && !goal1.hasActions(){
            goal1.runAction(SKAction(named: "Winning")!)
            goalNum += 1

            }
           else if (nodeA.name == "goal2" || nodeB.name == "goal2") && !goal2.hasActions(){
            goal2.runAction(SKAction(named: "Winning")!)
            goalNum += 1

            }
            
            
        }
        
        if goalNum == 2{
            currentState = .ended
            restartButton.state = .Active
        }
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if square.position.x < -10 || square.position.x > 578{
            restartButton.state = .Active
        }
        
    }
}
