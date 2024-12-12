//
//  GameScene.swift
//  bottleGame
//
//  Created by samet kaya on 11.12.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKSpriteNode()
   
    var brick2 = SKSpriteNode()
    var brick3 = SKSpriteNode()
   
    var bottle1 = SKSpriteNode()
    var bottle2 = SKSpriteNode()
    
    var gameStarted = false
    
    var orginalPositon : CGPoint?
    
    var orginalPositonBottle1 : CGPoint?
    var orginalPositonBottle2 : CGPoint?
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    enum ColliderType : UInt32 {
        case ball = 1
        case bottle = 2
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        
        //Fırlatılan top
    
        ball = childNode(withName: "ball") as! SKSpriteNode
        
        let ballTexture = SKTexture(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballTexture.size().height / 8)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.mass = 0.1
        orginalPositon = ball.position
        
        ball.physicsBody?.contactTestBitMask = ColliderType.ball.rawValue
        ball.physicsBody?.categoryBitMask = ColliderType.ball.rawValue
        ball.physicsBody?.collisionBitMask = ColliderType.bottle.rawValue
        
        
        //Kutular
        let boxTexture = SKTexture(imageNamed: "brick")
        let size = CGSize(width: boxTexture.size().width / 8, height: boxTexture.size().height / 8)
     
        brick2 = childNode(withName: "brick2") as! SKSpriteNode
        brick2.physicsBody = SKPhysicsBody(rectangleOf: size)
        brick2.physicsBody?.affectedByGravity = false
        brick2.physicsBody?.isDynamic = true
        brick2.physicsBody?.mass = 50
        
        brick3 = childNode(withName: "brick3") as! SKSpriteNode
        brick3.physicsBody = SKPhysicsBody(rectangleOf: size)
        brick3.physicsBody?.affectedByGravity = false
        brick3.physicsBody?.isDynamic = true
        brick3.physicsBody?.mass = 50
        
        
        
        //Şişeler
        let bottleTexture = SKTexture(imageNamed: "bottle")
        let sizee = CGSize(width: bottleTexture.size().width / 8, height: bottleTexture.size().height / 8)
        bottle1 = childNode(withName: "bottle1") as! SKSpriteNode
        bottle1.physicsBody = SKPhysicsBody(rectangleOf: sizee)
        bottle1.physicsBody?.isDynamic = true
        bottle1.physicsBody?.mass = 0.2
        bottle1.physicsBody?.collisionBitMask = ColliderType.ball.rawValue
        orginalPositonBottle1 = bottle1.position
        

        bottle2 = childNode(withName: "bottle2") as! SKSpriteNode
        bottle2.physicsBody = SKPhysicsBody(rectangleOf: sizee)
        bottle2.physicsBody?.isDynamic = true
        bottle2.physicsBody?.mass = 0.2
        bottle2.physicsBody?.collisionBitMask = ColliderType.ball.rawValue
        orginalPositonBottle2 = bottle2.position
        
        //Label
        
        scoreLabel.fontName = "Helvatica"
        scoreLabel.fontSize = 40
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        self.addChild(scoreLabel)
        self.zPosition = 2
        

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.collisionBitMask == ColliderType.ball.rawValue || contact.bodyB.collisionBitMask == ColliderType.ball.rawValue {
            print("click")
            score += 1
            scoreLabel.text = String(score)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            if let touch = touches.first{
                let location = touch.location(in: self)
                let nodes = nodes(at: location)
                
                if nodes.isEmpty == false {
                    for node in nodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                ball.position = location
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            if let touch = touches.first{
                let location = touch.location(in: self)
                let nodes = nodes(at: location)
                
                if nodes.isEmpty == false {
                    for node in nodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                ball.position = location
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            if let touch = touches.first{
                let location = touch.location(in: self)
                let nodes = nodes(at: location)
                
                if nodes.isEmpty == false {
                    for node in nodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == ball {
                                let dx = -(location.x - orginalPositon!.x)
                                let dy = -(location.y - orginalPositon!.y)
                                
                                let impulse = CGVector(dx: dx, dy: dy)
                                ball.physicsBody?.applyImpulse(impulse)
                                ball.physicsBody?.affectedByGravity = true
                                
                                
                                gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func update(_ currentTime: TimeInterval) {
       
        if let birdPhysicsBody = ball.physicsBody {
                   
            if birdPhysicsBody.velocity.dx >= 0.01 && gameStarted == true {
                       
                       ball.physicsBody?.affectedByGravity = false
                       ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                       ball.physicsBody?.angularVelocity = 0
                       ball.zPosition = 1
                       ball.position = orginalPositon!
                       gameStarted = false
                       
            }
        }
    }
}
