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
        
        var idx: Int = 0
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
                mutable.setObject(idx, forKey: "idx")
                ++idx
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
        
        //runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(2.0), SKAction.runBlock(iteration)])))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        let node = self.nodeAtPoint(touchLocation) as! SKSpriteNode
        let idx = node.userData?.objectForKey("idx") as! Int
        let x = node.userData?.objectForKey("x") as! Int
        let y = node.userData?.objectForKey("y") as! Int
        print("touch idx:\(idx), x:\(x), y:\(y)")
        
        grid[idx].texture = grass
        
        let nodeRound = getRound(x, y: y)
        for item in nodeRound {
            item.texture = grass
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
    
    func iteration() {
        for item in grid {
            let state = item.userData?.objectForKey("s") as! Int
            if state == 0 {
                item.texture = grass
                item.userData?.setObject(1, forKey: "s")
            } else {
                item.texture = water
                item.userData?.setObject(0, forKey: "s")
            }
            //let x = item.userData?.objectForKey("x") as! Int
            //let y = item.userData?.objectForKey("y") as! Int
            //let up = getUp(x, y: y)
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
        guard let newY:Int = y + 1 where newY > 0 && newY < heightNum else {
            return nil
        }
        return grid[Int(x % widthNum + (newY - 1) * widthNum - 1)]
    }
    
    func getDown(x: Int, y: Int) -> SKSpriteNode? {
        guard let newY:Int = y - 1 where newY > 0 && newY < heightNum else {
            return nil
        }
        return grid[Int(x % widthNum + (newY - 1) * widthNum - 1)]
    }
    
    func getLeft(x: Int, y: Int) -> SKSpriteNode? {
        guard let newX:Int = x - 1 where newX > 0 && newX < widthNum else {
            return nil
        }
        return grid[Int(newX % widthNum + (y - 1) * widthNum - 1)]
    }

    func getRight(x: Int, y: Int) -> SKSpriteNode? {
        guard let newX:Int = x + 1 where newX > 0 && newX < widthNum else {
            return nil
        }
        return grid[Int(newX % widthNum + (y - 1) * widthNum - 1)]
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
}
