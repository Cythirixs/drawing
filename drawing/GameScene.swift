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
        case draw, move
    }
    
    var touch : UITouch!
    var lastPoint : CGPoint!
    var currentPoint : CGPoint!

    var path : CGMutablePath! = nil
    
    var paths = [SKShapeNode]()
    var count = 0
    
    var square : SKSpriteNode!
    var changeButton : MSButtonNode!
    
    var currentState:state = .draw
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        square = childNodeWithName("square") as! SKSpriteNode
        changeButton = childNodeWithName("switch") as! MSButtonNode
        changeButton.selectedHandler = {
            self.square.physicsBody?.velocity = CGVectorMake(0, 0)
            
            self.square.physicsBody?.applyImpulse(CGVectorMake(0, 30))
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
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
        shape.strokeColor = UIColor.blackColor()
        shape.lineWidth = 2
        paths.append(shape)
        shape.physicsBody = SKPhysicsBody(edgeFromPoint: currentPoint, toPoint: lastPoint)
        addChild(shape)
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        print("enter")
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        /* Did our hero pass through the 'goal'? */
        if nodeA.name == "goal" || nodeB.name == "goal" {
            print("you win")
        }
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
