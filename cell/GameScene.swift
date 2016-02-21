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
                mutable.setObject("w", forKey: "t")
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
        backgroundColor = SKColor.blackColor()
        
        debugDrawPlayableArea()
        
        for item in grid {
            addChild(item)
        }
        
        //runAction(SKAction.sequence([SKAction.waitForDuration(2.0), SKAction.runBlock(iteration)]))
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
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
    
    func iteration() {
        for item in grid {
            item.texture = grass
            //let x = item.userData?.objectForKey("x") as! Int
            //let y = item.userData?.objectForKey("y") as! Int
            //let up = getUp(x, y: y)
        }
    }
    
    func getUp(node: SKSpriteNode) -> SKSpriteNode? {
        let idx = node.userData?.objectForKey("idx") as! Int
        if idx < widthNum {
            return nil
        } else {
            return grid[idx - widthNum]
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        addChild(shape)
    }

}
