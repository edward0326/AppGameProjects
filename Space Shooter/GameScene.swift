//
//  GameScene.swift
//  Space Shotter
//
//  Created by Edward Chien on 1/5/20.
//  Copyright © 2020 Edward Chien. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    static let Enemy: UInt32 = 1
    static let Player: UInt32 = 2
    static let PlayerLaser: UInt32 = 3
    static let EnemyType2: UInt32 = 4
    static let EnemyType2Laser: UInt32 = 5
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "Player")
    var basicEnemy = SKSpriteNode(imageNamed: "BasicEnemy")
    var enemyType2 = SKSpriteNode(imageNamed: "EnemyType2")
    var enemyType2Laser = SKSpriteNode(imageNamed: "EnemyType2Laser")
    
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    var explosion = SKSpriteNode()
    
    var score = Int()
    var scoreTracker = SKLabelNode()
    var gameOver = Bool()
    var gameStart = Bool()
    
    var title = SKLabelNode()
    var playButton = SKSpriteNode()
    
    var gameOverScore = SKLabelNode()
    var gameOverTitle = SKLabelNode()
    var continueButton = SKSpriteNode()
    
    //menu screen
    func menu(){
        title.position = CGPoint(x: 0, y: self.frame.height/3.2 + 0)
        title.text = "Space Pew Pew!"
        title.zPosition = -1
        title.fontSize = 72
        title.fontName = "Rockwell"
        title.color = UIColor.gray
        //print(UIFont.familyNames)
        self.addChild(title)
        
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.size = CGSize(width: self.frame.width/2, height: self.frame.width/3.8)
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.zPosition = 6
        self.addChild(playButton)
        
        enemyType2.position = CGPoint(x: 0, y: -300)
        enemyType2.size = CGSize(width: self.frame.width/6, height: self.frame.width/10)
        enemyType2.zPosition = 20
        self.addChild(enemyType2)
        
        enemyType2Laser.position = CGPoint(x: 0, y: -400)
        enemyType2Laser.zRotation = CGFloat(Double.pi)
        self.addChild(enemyType2Laser)
        
        //let sinus = sin(90.0 * Double.pi / 180)
    }
    
    //Game Over Screen
    func gameOverScreen(){
        title.position = CGPoint(x: 0, y: self.frame.height/3.2 + 0)
        title.text = "Game Over :/"
        title.zPosition = -1
        title.fontSize = 72
        title.fontName = "Rockwell"
        title.color = UIColor.red
        self.addChild(title)
        
        continueButton = SKSpriteNode(imageNamed: "ContinueButton")
        continueButton.size = CGSize(width: self.frame.width/2, height: self.frame.width/5)
        continueButton.position = CGPoint(x: 0, y: 0 - self.frame.width/6)
        continueButton.zPosition = 6
        self.addChild(continueButton)
        
        gameOverScore.position = CGPoint(x: 0, y: 0 + self.frame.width/8)
        gameOverScore.text = "Your Score was: \(score)"
        gameOverScore.zPosition = -1
        gameOverScore.fontSize = 60
        self.addChild(gameOverScore)
    }
    
    //level 1
    func createScene1(){
        gameOver = false
        score = 0
        player.position = CGPoint(x: 0, y: 0 - (self.frame.height/2) + (player.frame.height * 2))
        self.addChild(player)
        
        scoreTracker.position = CGPoint(x: 0, y: self.frame.height/2.7 + 0)
        scoreTracker.text = "Score: \(score)"
        scoreTracker.zPosition = -1
        scoreTracker.fontSize = 72
        //alpha is transparency
        scoreTracker.alpha = 0.4
        self.addChild(scoreTracker)

        //start infinite timer for player laser firing
        _ = Timer.scheduledTimer(withTimeInterval: 0.25*(1), repeats: true){playerLaserTimer in
            if self.gameOver == true{
                playerLaserTimer.invalidate()
            }else{
                self.createLaser()
            }
        }
        
        //start infinite timer for enemyType2 laser firing
        _ = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true){enemyLaserTimer in
            if self.gameOver == true{
                enemyLaserTimer.invalidate()
            }else{
                self.enumerateChildNodes(withName: "enemyType2", using: ({
                    (node, error) in
                    //let enemyNode = node as! SKSpriteNode
                    //let randomDelay = Double.random(in: 0.0..<0.5)
                    let randomDelay = 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay){
                        if self.gameOver != true{
                            self.createEnemyType2Laser(enmType2: node as! SKSpriteNode)
                        }
                    }
                }))
            }
        }

        scene1wave1()
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5){
            if self.gameOver != true{
                self.scene1wave2()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 19.5){
            if self.gameOver != true{
                self.scene1wave3()
            }
        }
    }
    
    
    //level 1 wave 1
    func scene1wave1(){
        let action1 = SKAction.moveTo(x: self.frame.width/2 + enemyType2.frame.width, duration: 7)
        let action2 = SKAction.removeFromParent()
        
        var enemiesSpawned = 0
        _ = Timer.scheduledTimer(withTimeInterval: 1.5*(1), repeats: true){wave1Enemies in
            if (self.gameOver == true) || (enemiesSpawned >= 5){
                wave1Enemies.invalidate()
            }else{
                enemiesSpawned += 1
                self.spawnEnemyType2(startX: 0 - self.frame.width/2 - self.enemyType2.frame.width, startY: self.frame.height/4, actionSequence: [action1, action2], enemyHealth: 200)
            }
        }
    }
    //level 1 wave 2
    func scene1wave2(){
        var enemiesSpawned = 0
        _ = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true){basicEnemyTimer in
            if self.gameOver == true || enemiesSpawned >= 20{
                basicEnemyTimer.invalidate()
            }else{
                enemiesSpawned += 1
                self.spawnBasicEnemy()
            }
        }
    }
    //level 1 wave 3
    func scene1wave3(){
        var enemiesSpawned = 0
        _ = Timer.scheduledTimer(withTimeInterval: 1.5*(1), repeats: true){wave1Enemies in
            if (self.gameOver == true) || (enemiesSpawned >= 5){
                wave1Enemies.invalidate()
            }else{
                var actionArray = [SKAction]()
                for _ in 1...50{
                    let rand = CGFloat.random(min: -25, max: 25)
                    actionArray.append(SKAction.moveBy(x: self.frame.width/50, y: rand, duration: 0.07))
                }
                actionArray.append(SKAction.removeFromParent())
                
                enemiesSpawned += 1
                self.spawnEnemyType2(startX: 0 - self.frame.width/2 - self.enemyType2.frame.width, startY: self.frame.height/3.5, actionSequence: actionArray, enemyHealth: 200)
            }
        }
    }
    
    
    //app initialization
    override func didMove(to view: SKView) {
        gameStart = false
        gameOver = false
        
        TextureAtlas = SKTextureAtlas(named: "Explosions.atlas")
        for i in 1...8{
            let name = "Explosion\(i).png"
            TextureArray.append(SKTexture(imageNamed: name))
        }
        
        self.physicsWorld.contactDelegate = self
        
        player.size = CGSize(width: self.frame.width/5.6, height: self.frame.height/10.37)
        player.zPosition = 5
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        
        menu()
    }
    
    //responsible for contact between all objects
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //enemy-playerLaser contact
        if (firstBody.categoryBitMask == PhysicsCategory.Enemy && secondBody.categoryBitMask == PhysicsCategory.PlayerLaser){
            enemyCollisionWithLaser(enemy: firstBody.node as! SKSpriteNode, laser: secondBody.node as! SKSpriteNode)
        }
        else if (firstBody.categoryBitMask == PhysicsCategory.PlayerLaser && secondBody.categoryBitMask == PhysicsCategory.Enemy){
            enemyCollisionWithLaser(enemy: secondBody.node as! SKSpriteNode, laser: firstBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask == PhysicsCategory.EnemyType2 && secondBody.categoryBitMask == PhysicsCategory.PlayerLaser){
            enemyCollisionWithLaser(enemy: firstBody.node as! SKSpriteNode, laser: secondBody.node as! SKSpriteNode)
        }
        else if (firstBody.categoryBitMask == PhysicsCategory.PlayerLaser && secondBody.categoryBitMask == PhysicsCategory.EnemyType2){
            enemyCollisionWithLaser(enemy: secondBody.node as! SKSpriteNode, laser: firstBody.node as! SKSpriteNode)
        }
        
        //player-enemy contact
        if (firstBody.categoryBitMask == PhysicsCategory.Enemy && secondBody.categoryBitMask == PhysicsCategory.Player){
            playerEnemyCollision(player: secondBody.node as! SKSpriteNode, enemy: firstBody.node as! SKSpriteNode)
        }
        else if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Enemy){
            playerEnemyCollision(player: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask == PhysicsCategory.EnemyType2 && secondBody.categoryBitMask == PhysicsCategory.Player){
            playerEnemyCollision(player: secondBody.node as! SKSpriteNode, enemy: firstBody.node as! SKSpriteNode)
        }
        else if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.EnemyType2){
            playerEnemyCollision(player: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        
        //player-enemyLaser contact
        if (firstBody.categoryBitMask == PhysicsCategory.EnemyType2Laser && secondBody.categoryBitMask == PhysicsCategory.Player){
            playerEnemyLaserCollision(player: secondBody.node as! SKSpriteNode, enemyLaser: firstBody.node as! SKSpriteNode)
        }
        else if (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.EnemyType2Laser){
            playerEnemyLaserCollision(player: firstBody.node as! SKSpriteNode, enemyLaser: secondBody.node as! SKSpriteNode)
        }
    }
    
    //determine what happens when enemy and laser collides
    func enemyCollisionWithLaser(enemy: SKSpriteNode, laser: SKSpriteNode){
        let tempX = laser.position.x
        let tempY = laser.position.y
        laser.removeFromParent()
        laserExplosion(laserX: tempX, laserY: tempY)
        if var health = enemy.userData?.value(forKey: "Health") as? Int{
            health -= 50
            enemy.userData?.setValue(health, forKey: "Health")
            if health <= 0{
                addScore(enemy: enemy)
                scoreTracker.text = "Score: \(score)"
                enemy.removeFromParent()
            }
        }
    }
    
    //add score
    func addScore(enemy: SKSpriteNode){
        if enemy.name == "basicEnemy"{
            score += 1
        }
        if enemy.name == "enemyType2"{
            score += 5
        }
    }
    
    //determine what happens when player and enemy collides
    func playerEnemyCollision(player: SKSpriteNode, enemy: SKSpriteNode){
        enemy.removeFromParent()
        player.removeFromParent()
        
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = true
        gameOverScreen()
    }
    
    //determine what happens when player and enemyLaser collides
    func playerEnemyLaserCollision(player: SKSpriteNode, enemyLaser: SKSpriteNode){
        enemyLaser.removeFromParent()
        player.removeFromParent()
        
        self.removeAllChildren()
        self.removeAllActions()
        gameOver = true
        gameOverScreen()
    }
    
    //instantiate a laser from player, and have the laser fly upwards
    func createLaser(){
        let laser = SKSpriteNode(imageNamed: "Laser")
        laser.name = "name"
        laser.zPosition = 0
        laser.position = CGPoint(x: player.position.x, y: player.position.y + player.frame.height/2 + laser.frame.height/2)
        
        let flyForward = SKAction.moveTo(y: self.size.height + 30, duration: Double((self.frame.height-laser.position.y)/self.frame.height)*(0.7)*(1))
        let removeLaser = SKAction.removeFromParent()
        
        laser.run(SKAction.sequence([flyForward, removeLaser]))
        
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.categoryBitMask = PhysicsCategory.PlayerLaser
        laser.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.affectedByGravity = false
        
        self.addChild(laser)
    }
    
    func createEnemyType2Laser(enmType2: SKSpriteNode){
        let enemyType2Laser = SKSpriteNode(imageNamed: "EnemyType2Laser")
        enemyType2Laser.zPosition = 0
        enemyType2Laser.position = CGPoint(x: enmType2.position.x, y: enmType2.position.y)
        
        let xDiff = player.position.x - enmType2.position.x
        let yDiff = player.position.y - enmType2.position.y
        let distance = (pow(xDiff, 2) + pow(yDiff, 2)).squareRoot()
        let temp = -atan(xDiff/yDiff)
        enemyType2Laser.zRotation = temp

        let flyToPlayer = SKAction.moveBy(x: xDiff * (self.frame.height/distance), y: yDiff * (self.frame.height/distance) , duration: Double(self.frame.height*2/distance)*(0.5)*(1))
        let removeLaser = SKAction.removeFromParent()
        
        enemyType2Laser.run(SKAction.sequence([flyToPlayer, removeLaser]))
        
        enemyType2Laser.physicsBody = SKPhysicsBody(rectangleOf: enemyType2Laser.size)
        enemyType2Laser.physicsBody?.categoryBitMask = PhysicsCategory.EnemyType2Laser
        enemyType2Laser.physicsBody?.collisionBitMask = PhysicsCategory.Player
        enemyType2Laser.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        enemyType2Laser.physicsBody?.isDynamic = false
        enemyType2Laser.physicsBody?.affectedByGravity = false
        
        self.addChild(enemyType2Laser)
    }
    
    //instantiate a basic enemy at top of frame, and have the enemy fly downwards
    func spawnBasicEnemy(){
        let basicEnemy = SKSpriteNode(imageNamed: "BasicEnemy")
        basicEnemy.name = "basicEnemy"
        basicEnemy.size = CGSize(width: self.frame.width/9, height: self.frame.height/14)
        basicEnemy.zPosition = 4
        let minXSpawn = -(self.frame.width/2) + basicEnemy.size.width
        let maxXSpawn = (self.frame.width/2) - basicEnemy.size.width
        let spawnPoint = CGFloat.random(min: minXSpawn, max: maxXSpawn)
        basicEnemy.position.x = 0 + spawnPoint
        basicEnemy.position.y = self.frame.height/2 + basicEnemy.size.height/2
        
        let flyDownward = SKAction.moveTo(y: -self.size.height/2 - basicEnemy.size.height/2, duration: 10)
        let removeEnemy = SKAction.removeFromParent()
        
        basicEnemy.run(SKAction.sequence([flyDownward, removeEnemy]))

        basicEnemy.physicsBody = SKPhysicsBody(circleOfRadius: basicEnemy.frame.height/2)
        basicEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        basicEnemy.physicsBody?.collisionBitMask = PhysicsCategory.PlayerLaser | PhysicsCategory.Player
        basicEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerLaser | PhysicsCategory.Player
        basicEnemy.physicsBody?.isDynamic = false
        basicEnemy.physicsBody?.affectedByGravity = false
        
        basicEnemy.userData = NSMutableDictionary()
        basicEnemy.userData?.setValue(100, forKeyPath: "Health")
        
        self.addChild(basicEnemy)
    }
    
    func spawnEnemyType2(startX: CGFloat, startY: CGFloat, actionSequence: [SKAction], enemyHealth: Int){
        let enemyType2 = SKSpriteNode(imageNamed: "EnemyType2")
        enemyType2.name = "enemyType2"
        enemyType2.size = CGSize(width: self.frame.width/6, height: self.frame.width/10)
        enemyType2.zPosition = 4
        enemyType2.position.x = startX
        enemyType2.position.y = startY
        enemyType2.run(SKAction.sequence(actionSequence))
        
        enemyType2.physicsBody = SKPhysicsBody(rectangleOf: enemyType2.size)
        enemyType2.physicsBody?.categoryBitMask = PhysicsCategory.EnemyType2
        enemyType2.physicsBody?.collisionBitMask = PhysicsCategory.PlayerLaser | PhysicsCategory.Player
        enemyType2.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerLaser | PhysicsCategory.Player
        enemyType2.physicsBody?.isDynamic = false
        enemyType2.physicsBody?.affectedByGravity = false
        
        enemyType2.userData = NSMutableDictionary()
        enemyType2.userData?.setValue(enemyHealth, forKeyPath: "Health")
        
        self.addChild(enemyType2)
    }
    
    //make a small explosion after each laser-enemy contact
    func laserExplosion(laserX: CGFloat, laserY: CGFloat){
        explosion = SKSpriteNode(imageNamed: TextureAtlas.textureNames[0])
        explosion.zPosition = 10
        explosion.position = CGPoint(x: laserX, y: laserY)
        let explode = SKAction.animate(with: TextureArray, timePerFrame: 0.04)
        let remove = SKAction.removeFromParent()
        let explodeAndRemove = SKAction.sequence([explode,remove])
        explosion.run(explodeAndRemove)
        self.addChild(explosion)
    }
    
    //single user tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            player.position.x = location.x
            player.position.y = location.y
            if gameStart == false{
                if playButton.contains(location){
                    gameStart = true
                    self.removeAllChildren()
                    self.removeAllActions()
                    score = 0
                    createScene1()
                }
            }
            if gameOver == true{
                if continueButton.contains(location){
                    gameStart = false
                    gameOver = false
                    self.removeAllChildren()
                    self.removeAllActions()
                    menu()
                }
            }
        }
    }
    //continuous user tap and hold
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            player.position.x = location.x
            player.position.y = location.y
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if player.zRotation != 0{
            player.zRotation = 0
        }
    }
}
