//
//  GameScene.swift
//  PacMan
//
//  Created by Ольга Чарная on 22.09.2022.
//

import SpriteKit
import GameplayKit


class Enemy{
    var ghost: SKSpriteNode!
    var scene: SKScene!
    var Directions: [String] = []
    var DirectionsTrue: [String] = []
    var StartMove: String!
    init(ghost: SKSpriteNode!, scene: SKScene!) {
        self.ghost = ghost
        self.scene = scene
    }
    func create_ghost(){
        ghost.name = "ghost"
        scene.addChild(ghost)
    }
    
    func check(i: Int) -> String{
        switch i {
        case 0:
            return "left"
        case 1:
            return "right"
        case 2:
            return "up"
        default:
            return "down"
        }
    }
    
    func NodeNext(x: CGFloat, y: CGFloat)->SKNode{
        return scene.nodes(at: CGPoint(x: ghost.position.x + x, y: ghost.position.y + y)).last!
    }
    
    func returnNode(name: String) -> SKNode{
        switch name{
        case "left":
            return NodeNext(x: -scene.size.width/21, y: 0)
        case "right":
            return NodeNext(x: scene.size.width/21, y: 0)
        case "up":
            return NodeNext(x: 0, y: scene.size.width/21)
        case "down":
            return NodeNext(x: 0, y: -scene.size.width/21)
        default:
            return SKNode()
        }
    }
    
    func checkDirection(){
        Directions.removeAll()
        DirectionsTrue.removeAll()
        let left = NodeNext(x: -scene.size.width/21, y: 0).name
        let right = NodeNext(x: scene.size.width/21, y: 0).name
        let up = NodeNext(x: 0, y: scene.size.width/21).name
        let down = NodeNext(x: 0, y: -scene.size.width/21).name
        Directions.append(left!)
        Directions.append(right!)
        Directions.append(up!)
        Directions.append(down!)
        
        for i in 0...Directions.count - 1{
            if Directions[i] == "0"{
                DirectionsTrue.append(check(i: i))
            }
        }
    }
    
    func create_actionGhost(to: SKNode){
        let move = SKAction.move(to: to.position, duration: 0.2)
        let void = SKAction.run {[self] in
            moveGhost()
        }
        let sequence = SKAction.sequence([move, void])
        ghost.run(sequence)
    }
    
    func moveGhost(){
        let Next = returnNode(name: StartMove)
        checkDirection()
        let pacman = scene.childNode(withName: "pacman")
        if pacman != nil{
            if distance(point1: ghost.position, point2: pacman!.position) <= ghost.size.width{
                var newpacman = pacman!.copy() as! SKNode
                newpacman.name = "pacman1"
                scene.addChild(newpacman)
                pacman?.removeFromParent()
                return
            }
            if Next.name == "0" && DirectionsTrue.count < 3{
                create_actionGhost(to: Next)
            }
            else{
                checkDirection()
                StartMove = DirectionsTrue.randomElement()
                create_actionGhost(to: returnNode(name: StartMove))
            }}
    }
    func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(point2.x - point1.x), Float(point2.y - point1.y)))
    }
}


class GameScene: SKScene {
    var Pacman:SKSpriteNode!
    var Points:[CGPoint] = []
    var touched: Bool = false;
    var ghost1: Enemy!
    var ghost2: Enemy!
    var score: Int = 0
    var arrayPoint:[[Int]] = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                              [1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1],
                              [1,0,1,1,1,1,0,1,1,0,1,0,1,1,0,1,1,1,1,0,1],
                              [1,0,1,1,1,1,0,1,1,0,1,0,1,1,0,1,1,1,1,0,1],
                              [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                              [1,0,1,1,1,0,1,0,1,1,1,1,1,0,1,0,1,1,1,0,1],
                              [1,0,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,1],
                              [1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,1,1],
                              [1,2,2,2,1,0,1,0,0,0,0,0,0,0,1,0,1,2,2,2,1],
                              [1,1,1,1,1,0,1,0,1,1,0,1,1,0,1,0,1,1,1,1,1],
                              [1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1],
                              [1,1,1,1,1,0,1,0,1,0,0,0,1,0,1,0,1,1,1,1,1],
                              [1,2,2,2,1,0,1,0,1,1,1,1,1,0,1,0,1,2,2,2,1],
                              [1,1,1,1,1,0,1,0,0,0,0,0,0,0,1,0,1,1,1,1,1],
                              [1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,1],
                              [1,0,1,1,1,0,1,1,1,0,1,0,1,1,1,0,1,1,1,0,1],
                              [1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1],
                              [1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1],
                              [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                              [1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1],
                              [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                              [1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1],
                              [1,0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1],
                              [1,0,1,0,0,0,0,1,0,1,0,1,0,1,0,0,0,0,1,0,1],
                              [1,0,1,1,1,1,1,1,0,1,0,1,0,1,1,1,1,1,1,0,1],
                              [1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,1],
                              [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    override func didMove(to view: SKView) {
        create_map()
        create_Pacman()
        create_ghost1()
        create_ghost2()
    }
    
    func create_ghost1(){
        let ghost = SKSpriteNode(color: .red, size: CGSize(width: self.size.width/21, height: self.size.width/21))
        ghost1 = Enemy(ghost: ghost, scene: self)
        ghost1.create_ghost()
        ghost1.checkDirection()
        ghost1.StartMove = ghost1.DirectionsTrue.randomElement()
        ghost1.moveGhost()
    }
    func create_ghost2(){
        let ghost = SKSpriteNode(color: .red, size: CGSize(width: self.size.width/21, height: self.size.width/21))
        ghost2 = Enemy(ghost: ghost, scene: self)
        ghost2.create_ghost()
        ghost2.checkDirection()
        ghost2.StartMove = ghost2.DirectionsTrue.randomElement()
        ghost2.moveGhost()
    }
    
    func create_map(){
        var x:CGFloat = -self.size.width/2 + self.size.width/CGFloat(arrayPoint[0].count)/2
        var y:CGFloat = self.size.height/2 - self.size.width/CGFloat(arrayPoint[0].count)/2
        for i in 0...arrayPoint.count - 1{
            x = -self.size.width/2 + self.size.width/CGFloat(arrayPoint[0].count)/2
            if i==0{
                y = self.size.height/2 - self.size.width/CGFloat(arrayPoint[0].count)/2
            }else{
                y-=self.size.width/CGFloat(arrayPoint[0].count)
            }
            for j in 0...arrayPoint[0].count - 1{
                let ground = SKSpriteNode()
                ground.size = CGSize(width: self.size.width/CGFloat(arrayPoint[0].count), height: self.size.width/CGFloat(arrayPoint[0].count))
                if arrayPoint[i][j]==0{
                    let food = SKSpriteNode(color: UIColor.white, size: CGSize(width: 5, height: 5))
                    food.name = "0"
                    ground.name = "0"
                    ground.color = .black
                    ground.addChild(food)
                }else if arrayPoint[i][j]==1{
                    ground.name = "1"
                    ground.texture = SKTexture(imageNamed: "brick-wall")
                }
                
                ground.position = CGPoint(x: x, y: y)
                x+=self.size.width/CGFloat(arrayPoint[0].count)
                addChild(ground)
                Points.append(ground.position)
            }
        }
    }
    
    func create_Pacman(){
        Pacman = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: self.size.width/CGFloat(arrayPoint[0].count), height: self.size.width/CGFloat(arrayPoint[0].count)))
        Pacman.name = "pacman"
        Pacman.position = Points[481]
        addChild(Pacman)
    }
    
    func actionGhost(to: SKNode, x:CGFloat, y:CGFloat){
        let move = SKAction.move(to: to.position, duration: 0.2)
        let void = SKAction.run {[self] in
            movePacman(x: x, y: y)
        }
        let sequence = SKAction.sequence([move, void])
        Pacman.run(sequence)
    }
    
    func movePacman(x:CGFloat, y:CGFloat){
        if touched{
            let next = nodes(at: CGPoint(x: Pacman.position.x + x, y: Pacman.position.y + y)).last
            if next?.name == "0"{
                score += 1
                next?.childNode(withName: "0")?.removeFromParent()
                actionGhost(to: next!, x: x, y: y)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        if atPoint(location).name == "left"{
            touched = true
            childNode(withName: "left")?.alpha = 1
            movePacman(x: -self.size.width/CGFloat(arrayPoint[0].count), y: 0)
        }
        if atPoint(location).name == "right"{
            touched = true
            childNode(withName: "right")?.alpha = 1
            movePacman(x: self.size.width/CGFloat(arrayPoint[0].count), y: 0)
        }
        if atPoint(location).name == "up"{
            touched = true
            childNode(withName: "up")?.alpha = 1
            movePacman(x: 0, y:self.size.width/CGFloat(arrayPoint[0].count))
        }
        if atPoint(location).name == "down"{
            touched = true
            childNode(withName: "down")?.alpha = 1
            movePacman(x: 0, y:-self.size.width/CGFloat(arrayPoint[0].count))
        }
        if atPoint(location).name == "restart"{
            for child in children{
                if child.name != "left" && child.name != "right" && child.name != "up" && child.name != "down" && child.name != "restart"{
                    child.removeFromParent()
                }
            }
            score = 0
            create_map()
            create_Pacman()
            create_ghost1()
            create_ghost2()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for child in children{
            if child.name == "left" || child.name == "right" || child.name == "up" || child.name == "down"{
                child.alpha = 0.5
            }
        }
        
        touched = false
    }
}

