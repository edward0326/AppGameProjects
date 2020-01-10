//
//  GameScene.swift
//  FlappyBird
//
//  Created by Edward Chien on 1/3/20.
//  Copyright © 2020 Edward Chien. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsThing{
    static let ghost: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
    static let scoreWall: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var wallPair = SKNode()
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    
    var score = Int()
    let scoreLbl = SKLabelNode()
    var restartButton = SKSpriteNode()
    
    var gameOver = Bool()
    
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene(){
        
        //print(UIFont.familyNames)
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2{
            let background = SKSpriteNode(imageNamed: "background2")
            //background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = CGSize(width: self.frame.width, height: self.frame.height)
            self.addChild(background)
        }
        
        scoreLbl.position = CGPoint(x: 0, y: self.frame.height/2.7 + 0)
        scoreLbl.text = "Score: \(score)"
        scoreLbl.zPosition = 4
        scoreLbl.fontSize = 72
        scoreLbl.fontName = "FlappyBirdy"
        self.addChild(scoreLbl)
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(1)
        ground.position = CGPoint(x: 0, y: 0 - self.frame.height/2 + ground.frame.height/2)
        self.addChild(ground)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsThing.ground
        //line below tells physics engine what the "ground" object will collide with
        //since we don't want the ground to collide with the walls we dont set it here
        ground.physicsBody?.collisionBitMask = PhysicsThing.ghost
        ground.physicsBody?.contactTestBitMask = PhysicsThing.ghost
        ground.physicsBody?.affectedByGravity = false
        //"is an unmoving character; will not move even when collided with"
        ground.physicsBody?.isDynamic = false
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost.setScale(0.65)
        //ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: 0 - ghost.frame.width, y: 0)
        self.addChild(ghost)
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.height/2)
        ghost.physicsBody?.categoryBitMask = PhysicsThing.ghost
        ghost.physicsBody?.collisionBitMask = PhysicsThing.wall | PhysicsThing.ground
        ghost.physicsBody?.contactTestBitMask = PhysicsThing.wall | PhysicsThing.ground | PhysicsThing.scoreWall
        ghost.physicsBody?.affectedByGravity = false
        ghost.physicsBody?.isDynamic = true
        
        //since ground zPosition is set to 3 while wall zPosition is set to 1
        //ground will always be in front of wall
        ground.zPosition = 3
        ghost.zPosition = 2
        
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func createButton(){
        //restartButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: self.frame.width/1.8, height: self.frame.width/3.6))
        restartButton = SKSpriteNode(imageNamed: "RestartBtn")
        restartButton.size = CGSize(width: self.frame.width/1.8, height: self.frame.width/3.6)
        restartButton.position = CGPoint(x: 0, y: 0)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to: 1, duration: 0.3))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == PhysicsThing.scoreWall && secondBody.categoryBitMask == PhysicsThing.ghost) || (firstBody.categoryBitMask == PhysicsThing.ghost && secondBody.categoryBitMask == PhysicsThing.scoreWall)){
            
            score += 1
            scoreLbl.text = "Score: \(score)"
            
        }
        
        if ((firstBody.categoryBitMask == PhysicsThing.ghost && secondBody.categoryBitMask == PhysicsThing.wall) || (firstBody.categoryBitMask == PhysicsThing.wall && secondBody.categoryBitMask == PhysicsThing.ghost)){
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            if gameOver == false{
                gameOver = true
                createButton()
            }
        }
        
        if ((firstBody.categoryBitMask == PhysicsThing.ghost && secondBody.categoryBitMask == PhysicsThing.ground) || (firstBody.categoryBitMask == PhysicsThing.ground && secondBody.categoryBitMask == PhysicsThing.ghost)){
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            }))
            if gameOver == false{
                gameOver = true
                createButton()
            }
        }
    }
    
    
    func createWalls(){
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: 0 + self.frame.width/2 + topWall.frame.width/2, y: 0 + self.frame.height/1.75)
        btmWall.position = CGPoint(x: 0 + self.frame.width/2 + btmWall.frame.width/2, y: 0 - self.frame.height/1.75)
        
        topWall.setScale(1)
        topWall.zRotation = CGFloat(Double.pi)
        btmWall.setScale(1)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsThing.wall
        topWall.physicsBody?.collisionBitMask = PhysicsThing.ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsThing.ghost
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsThing.wall
        btmWall.physicsBody?.collisionBitMask = PhysicsThing.ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsThing.ghost
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: (self.frame.height/1.75)*2 - 1000)
        //525
        scoreNode.position = CGPoint(x: 0 + self.frame.width/2 + topWall.frame.width/2, y: 0)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsThing.scoreWall
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsThing.ghost
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        wallPair.addChild(scoreNode)
        
        wallPair.zPosition = 1

        let randomPosition = CGFloat.random(min: -300, max: 300)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.run(moveAndRemove)
        
        self.addChild(wallPair)
    }
    
    //when touching the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false{
            
            gameStarted = true
            ghost.physicsBody?.affectedByGravity = true
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let spawnDelay = SKAction.sequence([spawn,delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + 200)
            let movePipes = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(0.004 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes,removePipes])
            
            //jump at start of game
            ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.frame.height/3))
            
        }else{
            if gameOver == true{
                
            }else{
                ghost.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                ghost.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.frame.height/3))
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if gameOver == true{
                if restartButton.contains(location){
                    restartScene()
                }
            }
        }
        
        
    }
    

    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted == true{
            if gameOver == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let background = node as! SKSpriteNode
                    background.position = CGPoint(x: background.position.x-3, y: background.position.y)
                    
                    if background.position.x <= -background.size.width{
                        background.position = CGPoint(x: background.position.x + background.size.width * 2, y: background.position.y)
                    }
                    
                }))
                
            }
        }
        
    }
}
