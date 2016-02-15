//
//  GameScene.swift
//  cell
//
//  Created by 刘书心 on 16/2/15.
//  Copyright (c) 2016年 bookheart. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let lifeCell = SKSpriteNode(imageNamed: "grass")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        lifeCell.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(lifeCell)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}
