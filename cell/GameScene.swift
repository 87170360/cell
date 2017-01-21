//
//  GameScene.swift
//  cell
//
//  Created by 刘书心 on 16/2/15.
//  Copyright (c) 2016年 bookheart. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let water = SKTexture(imageNamed: "water")
    let grass = SKTexture(imageNamed: "grass")
    var widthNum: Int = 0
    var heightNum: Int = 0
    
    var grid:[SKSpriteNode] = []
    let playableRect: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let playableMargin = (size.width - playableWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0, width: playableWidth, height: size.height)
        
        let nodeWidth = Int(water.size().width)
        let nodeHeight = Int(water.size().height)
        widthNum = Int(playableRect.width) / nodeWidth
        heightNum = Int(playableRect.height) / nodeHeight
        
        for i in 1...heightNum {
            for j in 1...widthNum {
                let node = SKSpriteNode(imageNamed: "water")
                let x = Int(playableRect.minX) + nodeWidth / 2 + (j - 1) * Int(nodeWidth)
                let y = Int(playableRect.minY) + nodeHeight / 2 + (i - 1) * Int(nodeHeight)
                node.position = CGPoint(x:x, y:y)
                let mutable: NSMutableDictionary = NSMutableDictionary()
                mutable.setObject(j, forKey: "x" as NSCopying)
                mutable.setObject(i, forKey: "y" as NSCopying)
                mutable.setObject(0, forKey: "s" as NSCopying)
                node.userData = mutable
                grid.append(node)
            }
        }
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("xx")
    }
    
    override func didMove(to view: SKView) {
        //debugDrawPlayableArea()
        backgroundColor = SKColor.black
        for item in grid {
            addChild(item)
        }
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run(iteration)])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let node = self.atPoint(touchLocation) as! SKSpriteNode
        let x = node.userData?.object(forKey: "x") as! Int
        let y = node.userData?.object(forKey: "y") as! Int
        let idx = getIndex(x, y: y)
        print("touch idx:\(idx), x:\(x), y:\(y)")
        
        setLive(grid[idx])
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let node = self.atPoint(touchLocation) as! SKSpriteNode
        let x = node.userData?.object(forKey: "x") as! Int
        let y = node.userData?.object(forKey: "y") as! Int
        let idx = getIndex(x, y: y)
        print("touch idx:\(idx), x:\(x), y:\(y)")
        
        setLive(grid[idx])
    }
   
    func iteration() {
        for item in grid {
            computelive(item)
        }
    }
    
    func getRound(_ x: Int, y: Int) -> [SKSpriteNode] {
        var result:[SKSpriteNode] = []
        if let up = getUp(x, y: y) {
            result.append(up)
        }
        if let down = getDown(x, y: y) {
            result.append(down)
        }
        if let left = getLeft(x, y: y) {
            result.append(left)
        }
        if let right = getRight(x, y: y) {
            result.append(right)
        }
        if let upLeft = getLeft(x, y: y + 1) {
            result.append(upLeft)
        }
        if let upRight = getRight(x, y: y + 1) {
            result.append(upRight)
        }
        if let downLeft = getLeft(x, y: y - 1) {
            result.append(downLeft)
        }
        if let downRight = getRight(x, y: y - 1) {
            result.append(downRight)
        }
        return result
    }
    
    func getUp(_ x: Int, y: Int) -> SKSpriteNode? {
        guard let newY:Int = y + 1 , newY > 0 && newY <= heightNum && x > 0 && x <= widthNum else {
            return nil
        }
        return grid[getIndex(x, y: newY)]
    }
    
    func getDown(_ x: Int, y: Int) -> SKSpriteNode? {
        guard let newY:Int = y - 1 , newY > 0 && newY <= heightNum && x > 0 && x <= widthNum else {
            return nil
        }
        return grid[getIndex(x, y: newY)]
    }
    
    func getLeft(_ x: Int, y: Int) -> SKSpriteNode? {
        guard let newX:Int = x - 1 , newX > 0 && newX <= widthNum && y > 0 && y <= heightNum  else {
            return nil
        }
        return grid[getIndex(newX, y: y)]
    }

    func getRight(_ x: Int, y: Int) -> SKSpriteNode? {
        guard let newX:Int = x + 1 , newX > 0 && newX <= widthNum && y > 0 && y <= heightNum  else {
            return nil
        }
        let index = getIndex(newX, y: y)
        return grid[index]
    }
    
    func debugDrawPlayableArea() {
        
        
        let shape = SKShapeNode()
        //let path = CGMutablePath()
        //CGPathAddRect(path, nil, playableRect)
        
        let path : CGMutablePath = CGMutablePath()
        path.addRect(playableRect)

        
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        shape.zPosition = 1
        addChild(shape)
    }
    
    func computelive(_ node: SKSpriteNode) {
        let x = node.userData?.object(forKey: "x") as! Int
        let y = node.userData?.object(forKey: "y") as! Int
        let nodeRound = getRound(x, y: y)
        var live = 0
        
        for item in nodeRound {
            if item.userData?.object(forKey: "s") as! Int == 1 {
                live += 1
            }
        }
        if live == 3 {
            setLive(node)
            return
        }
        
        if live == 2 {
            return
        }
        
        setDie(node)
    }
    
    func setLive(_ node: SKSpriteNode) {
        node.texture = grass
        node.userData?.setObject(1, forKey: "s" as NSCopying)
    }
    
    func setDie(_ node: SKSpriteNode) {
        node.texture = water
        node.userData?.setObject(0, forKey: "s" as NSCopying)
    }
    
    func getIndex(_ x: Int, y: Int) -> Int {
        return x + (y - 1) * widthNum - 1
    }
}
