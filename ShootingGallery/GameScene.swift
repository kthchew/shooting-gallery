//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Kenneth Chew on 3/27/21.
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var score = 0 {
        didSet {
            scoreCounter?.text = "Score: \(score)"
        }
    }
    var scoreCounter: SKLabelNode?
    var timer: Timer?

    override func didMove(to view: SKView) {
        backgroundColor = .white
        for rowNum in 1...3 {
            let row = SKSpriteNode(imageNamed: "row\(rowNum)")
            row.position = CGPoint(x: 512, y: 192 * rowNum)
            row.size = CGSize(width: 1024, height: 10)
            row.zPosition = -1

            addChild(row)
        }

        physicsWorld.gravity = .zero

        scoreCounter = SKLabelNode(text: "Score: 0")
        scoreCounter?.fontName = "Chalkduster"
        scoreCounter?.fontColor = .black
        scoreCounter?.position = CGPoint(x: 100, y: 50)
        addChild(scoreCounter!)

        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: createTarget)
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children {
            let isTarget = node.name == "goodTarget" || node.name == "badTarget"
            let isOutOfBounds = node.position.x < -200 || node.position.x > 1300
            if isTarget && isOutOfBounds {
                node.removeFromParent()

                if node.name == "goodTarget" {
                    score -= 1
                }
            }
        }
    }

    func createTarget(_ timer: Timer?) {
        let isGood = Double.random(in: 0...1) < 0.74 // chance of good target
        let rowNumber = Int.random(in: 1...3)
        let size = Int.random(in: 50...160)
        let speed = 40000 / size
        let image = isGood ? "target-good" : "target-bad"

        let target = SKSpriteNode(imageNamed: image)
        target.name = isGood ? "goodTarget" : "badTarget"
        target.size = CGSize(width: size, height: size)
        target.physicsBody = SKPhysicsBody(texture: target.texture!, size: target.size)
        target.physicsBody?.collisionBitMask = 0
        if rowNumber == 2 {
            target.position = CGPoint(x: 1300, y: 192 * rowNumber)
            target.physicsBody?.velocity = CGVector(dx: -speed, dy: 0)
        } else {
            target.position = CGPoint(x: -200, y: 192 * rowNumber)
            target.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        }
        target.physicsBody?.linearDamping = 0

        addChild(target)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)

        for node in nodes(at: position) {
            if node.name == "goodTarget" {
                score += 1
                node.removeFromParent()
            } else if node.name == "badTarget" {
                score -= 1
                node.removeFromParent()
            }
        }
    }
}
