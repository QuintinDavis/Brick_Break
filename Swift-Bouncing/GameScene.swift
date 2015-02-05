//
//  GameScene.swift
//  Swift-Bouncing
//
//  Created by Seung Kyun Nam on 2014. 6. 5..
//  Copyright (c) 2014년 litmuscube. All rights reserved.
//

import SpriteKit
import CoreMotion
import Foundation
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var ballList: [SKShapeNode] = []
    var skPaddles: [SKShapeNode] = []
    let motionManager: CMMotionManager = CMMotionManager()
    var ballSpeed: CGFloat = 400
    var paddleWidth: CGFloat = 0.0
    var level: [SKShapeNode] = []
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        paddleWidth = (self.size.width / 4)
        self.addChild(self.createFloor())
        skPaddles.append(self.createPaddle(CGPointMake(self.size.width / 2 - paddleWidth / 2 , self.size.height / 10 - 16)))
        self.addChild(skPaddles[0])
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        level = createLevel()
        for brick in level{
            self.addChild(brick)
        }
    }
    
    func createFloor() -> SKSpriteNode {
        let floor = SKSpriteNode(color: SKColor.purpleColor(), size: CGSizeMake(self.frame.size.width, 20))
        
        floor.anchorPoint = CGPointMake(0, 0)
        floor.name = "floor"
        floor.physicsBody?.restitution = 1.0
        floor.physicsBody?.friction = 0.0
        floor.physicsBody = SKPhysicsBody(edgeLoopFromRect: floor.frame)
        floor.physicsBody?.dynamic = false
        
        return floor
    }
    
    func createBall(position: CGPoint) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: self.size.width / 40)
        let positionMark = SKShapeNode(circleOfRadius: self.size.width / 100)
//        println("ball being created")
        ball.fillColor = SKColor.orangeColor()
        ball.position = position
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 40)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.affectedByGravity = false
        positionMark.fillColor = SKColor.blackColor()
        positionMark.position.y = CGFloat((rand()%4)*(-1+rand()%2*2))
        ball.addChild(positionMark)
        ball.physicsBody?.mass = 1000.0
//        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.contactTestBitMask = 5
        ball.physicsBody?.categoryBitMask = 0
        
        return ball
    }
    
    
    func createPaddle(position: CGPoint) -> SKShapeNode {
        let paddle = SKShapeNode(ellipseInRect: CGRectMake(0.0, 0.0, (self.size.width / 4) , (self.size.height / 25)))
        //        let paddle = SKShapeNode(rect: CGRectMake(0.0, 0.0, (self.size.width / 4) , (self.size.height / 25)))
        
        paddle.fillColor = SKColor.darkGrayColor()
        paddle.position = position
        paddle.name = "ball"
        
        var path: CGPathRef = CGPathCreateWithEllipseInRect( CGRectMake(0.0, 0.0, (self.size.width / 4) , (self.size.height / 25)) , nil)
        
        
        paddle.physicsBody = SKPhysicsBody(edgeLoopFromPath: path)
        
        
        //        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: (self.size.width / 4) , height: (self.size.height / 25)), center:(CGPointMake((self.size.width / 4) / 2, (self.size.height / 25) / 2)))
        paddle.physicsBody?.dynamic = false
        paddle.physicsBody?.friction = 0.0
        paddle.physicsBody?.restitution = 1.0
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.mass = 1.0
//        paddle.physicsBody?.categoryBitMask = 0
//        paddle.physicsBody?.contactTestBitMask = 0
//        paddle.physicsBody?.collisionBitMask = 2
        
        return paddle
    }
    
    
    func createLevel() -> [SKShapeNode] {
        var level: [SKShapeNode] = []
        
        for var r = 0; r < 4 ; r++ {
            for var c = 0 ; c < 6 ; c++ {
//                var spacer: CGFloat = CGFloat((UInt8(self.size.width)) >> UInt8(5))
                var spacer: CGFloat = (self.size.height / CGFloat(50.0))
                var width: CGFloat = (self.size.width / 6 - spacer - spacer / CGFloat(6))
                var height: CGFloat = (self.size.height / CGFloat(50.0))
                let brick = SKShapeNode(rect: CGRectMake(0.0, 0.0, width , height))
                brick.fillColor = SKColor.blueColor()
                brick.position = CGPointMake(CGFloat(CGFloat(c) * CGFloat(width + spacer)) + spacer, CGFloat(self.size.height) - CGFloat(r) * (height + spacer) - height * CGFloat(2) - spacer)
                brick.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize( width: width, height: height), center: CGPointMake( CGFloat(width / CGFloat(2)), CGFloat(height / CGFloat(2))))
                brick.physicsBody?.dynamic = false
                brick.physicsBody?.friction = 0.0
                brick.physicsBody?.restitution = 1.0
                brick.physicsBody?.angularDamping = 0.0
                brick.physicsBody?.linearDamping = 0.0
                brick.physicsBody?.affectedByGravity = false
                brick.physicsBody?.mass = 1000.0
                brick.physicsBody?.categoryBitMask = 5
                brick.physicsBody?.collisionBitMask = 0
                brick.physicsBody?.contactTestBitMask = 0
                
                
                level.append(brick)
            }
        }
        
        return level
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location:CGPoint = touch.locationInNode(self)
            let floor:SKNode? = self.childNodeWithName("floor")
            if floor?.containsPoint(location) != nil {
                ballList.append(self.createBall(location))
                ballList.last!.physicsBody?.velocity = CGVectorMake(0,-ballSpeed)
                self.addChild(ballList.last!)
            }
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        NSLog("contact%d", contact.bodyB.categoryBitMask)
                NSLog("contact%d", contact.bodyA.categoryBitMask)
//        contact.bodyA.dynamic = true
        if(contact.bodyA.categoryBitMask > 1){
            contact.bodyA.categoryBitMask = contact.bodyA.categoryBitMask - 1
        }
        if(contact.bodyB.categoryBitMask > 1){
            contact.bodyB.categoryBitMask = contact.bodyB.categoryBitMask - 1
        }
        
        for brick in level {
//            println("hola \(brick.physicsBody?.categoryBitMask)")
            if(brick.physicsBody?.categoryBitMask == 6){
                brick.fillColor = SKColor.purpleColor()
            }
            if(brick.physicsBody?.categoryBitMask == 5){
                brick.fillColor = SKColor.blueColor()
            }
            if(brick.physicsBody?.categoryBitMask == 4){
                brick.fillColor = SKColor.redColor()
            }
            if(brick.physicsBody?.categoryBitMask == 3){
                brick.fillColor = SKColor.greenColor()
            }
            if(brick.physicsBody?.categoryBitMask == 2){
                brick.removeFromParent()
            }
        }
    }

    
 
    
    override func update(currentTime: CFTimeInterval) {
        
        //        for ball in self.ballList{
        //            var xSpeed = ball.physicsBody?.velocity.dx
        //            var ySpeed = ball.physicsBody?.velocity.dy
        //            var ratio = xSpeed! / ySpeed!
        //            NSLog("xSpeed: %d", xSpeed!)
        //            NSLog("ySpeed: %d", ySpeed!)
        //            NSLog("ratio: %d", ratio)
        //            if(xSpeed < ySpeed) {
        //                ratio = ySpeed! / xSpeed!
        //            }
        //            NSLog("ratio2: %d", ratio)
        //            var slowerComponent:CGFloat = (((ballSpeed * ballSpeed) / ((ratio * ratio)+1)))
        //            ball.physicsBody?.velocity.dx = slowerComponent
        //            ball.physicsBody?.velocity.dy = slowerComponent * ratio
        //        }
        
        
        if (motionManager.accelerometerAvailable) {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data, error) in
                //                var newX = (self.skPaddles[0].position.x + (10 * CGFloat(data.acceleration.x)) * abs(10 * CGFloat(data.acceleration.x)))
                var newX = (self.skPaddles[0].position.x + (20 * CGFloat(data.acceleration.x)))
                if((self.size.width > newX + self.skPaddles[0].frame.width) && (0 < newX)){
                    self.skPaddles[0].position = CGPointMake( newX , self.skPaddles[0].position.y)
                }
                //                self.skPaddle[0].physicsBody?.velocity = CGVectorMake((50 * CGFloat(data.acceleration.x)) * abs(50 * CGFloat(data.acceleration.x)) , 0)
                
                
                //                self.skPaddle[0].physicsBody?.applyForce(CGVectorMake((CGFloat(98*2) * ,0))
                //                self.skPaddle[0].physicsBody?.applyForce(CGVectorMake((CGFloat(0*2) * CGFloat(data.acceleration.x)),0))
                
                //                self.skPaddle[0].physicsBody?.applyForce(CGVectorMake(0,(CGFloat(98*2) * -CGFloat(data.acceleration.x))))
                //                self.skPaddle[0].physicsBody?.applyForce(CGVectorMake(0,(CGFloat(98*2) * -CGFloat(data.acceleration.x))))
                
            }
        }
        /* Called before each frame is rendered */
    }
    
//    override func didSimulatePhysics() {
//        self.enumerateChildNodesWithName("ball", usingBlock: { (node: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
//            if node.position.y < 0 {
//                node.removeFromParent()
//            }
//        })
//    }
}


