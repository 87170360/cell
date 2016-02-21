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
                let x = Int(CGRectGetMinX(playableRect)) + nodeWidth / 2 + (j - 1) * Int(nodeWidth)
                let y = Int(CGRectGetMinY(playableRect)) + nodeHeight / 2 + (i - 1) * Int(nodeHeight)
                node.position = CGPoint(x:x, y:y)
                let mutable: NSMutableDictionary = NSMutableDictionary()
                mutable.setObject(j, forKey: "x")
                mutable.setObject(i, forKey: "y")
                mutable.setObject(0, forKey: "s")
                node.userData = mutable
                grid.append(node)
            }
        }
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("xx")
    }
    
    override func didMoveToView(view: SKView) {
        //debugDrawPlayableArea()
        backgroundColor = SKColor.blackColor()
        for item in grid {
            addChild(item)
        }
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.runBlock(iteration)])))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        let node = self.nodeAtPoint(touchLocation) as! SKSpriteNode
        let x = node.userData?.objectForKey("x") as! Int
        let y = node.userData?.objectForKey("y") as! Int
        let idx = getIndex(x, y: y)
        print("touch idx:\(idx), x:\(x), y:\(y)")
        
        setLive(grid[idx])
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        let node = self.nodeAtPoint(touchLocation) as! SKSpriteNode
        let x = node.userData?.objectForKey("x") as! Int
        let y = node.userData?.objectForKey("y") as! Int
        let idx = getIndex(x, y: y)
        print("touch idx:\(idx), x:\(x), y:\(y)")
        
        setLive(grid[idx])
    }
   
    func iteration() {
        for item in grid {
            computelive(item)
        }
    }
    
    func getRound(x: Int, y: Int) -> [SKSpriteNode] {
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
    
    func getUp(x: Int, y: Int) -> SKSpriteNode? {
        guard let newY:Int = y + 1 where newY > 0 && newY <= heightNum && x > 0 && x <= widthNum else {
            return nil
        }
        return grid[getIndex(x, y: newY)]
    }
    
    func getDown(x: Int, y: Int) -> SKSpriteNode? {
        guard let newY:Int = y - 1 where newY > 0 && newY <= heightNum && x > 0 && x <= widthNum else {
            return nil
        }
        return grid[getIndex(x, y: newY)]
    }
    
    func getLeft(x: Int, y: Int) -> SKSpriteNode? {
        guard let newX:Int = x - 1 where newX > 0 && newX <= widthNum && y > 0 && y <= heightNum  else {
            return nil
        }
        return grid[getIndex(newX, y: y)]
    }

    func getRight(x: Int, y: Int) -> SKSpriteNode? {
        guard let newX:Int = x + 1 where newX > 0 && newX <= widthNum && y > 0 && y <= heightNum  else {
            return nil
        }
        let index = getIndex(newX, y: y)
        return grid[index]
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        shape.zPosition = 1
        addChild(shape)
    }
    
    func computelive(node: SKSpriteNode) {
        let x = node.userData?.objectForKey("x") as! Int
        let y = node.userData?.objectForKey("y") as! Int
        let nodeRound = getRound(x, y: y)
        var live = 0
        
        for item in nodeRound {
            if item.userData?.objectForKey("s") as! Int == 1 {
                live++
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
    
    func setLive(node: SKSpriteNode) {
        node.texture = grass
        node.userData?.setObject(1, forKey: "s")
    }
    
    func setDie(node: SKSpriteNode) {
        node.texture = water
        node.userData?.setObject(0, forKey: "s")
    }
    
    func getIndex(x: Int, y: Int) -> Int {
        return x + (y - 1) * widthNum - 1
    }
}
