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
    
    var grid:[SKSpriteNode] = []
    
    override init(size: CGSize) {
        let nodeSize = Int(water.size().width)
        let widthNum = Int(Int(size.width) / nodeSize)
        let heightNum = Int(Int(size.height) / nodeSize)
        
        for i in 1...widthNum {
            for j in 1...heightNum {
                let node = SKSpriteNode(imageNamed: "water")
                node.position = CGPoint(x: -nodeSize / 2 + i * nodeSize, y: -nodeSize / 2 + j * nodeSize)
                let mutable: NSMutableDictionary = NSMutableDictionary()
                mutable.setObject(i, forKey: "y")
                mutable.setObject(j, forKey: "x")

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
        
        for item in grid {
            addChild(item)
        }
        
        runAction(SKAction.sequence([ SKAction.waitForDuration(2.0), SKAction.runBlock(iteration)]))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
    
    func iteration() {
        for item in grid {
            item.texture = grass
            //print("x:\(item.userData?.objectForKey("x") as! Int), y:\(item.userData?.objectForKey("y") as! Int)")
        }
    }
}
