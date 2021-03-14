//
//  Board.swift
//  FaceAndWorldTrackingExample
//
//  Created by Ryan Wang on 3/14/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import RealityKit
import ARKit

class Board: Entity, HasModel {
    private let boardColor: SimpleMaterial.Color = .blue
    private let inactiveColor: SimpleMaterial.Color = .gray
    private lazy var boardEntity = findEntity(named: "board")!
    
    required init() {
        super.init()
        if let board = try? Entity.load(named: "board") {
            addChild(board)
        } else {
            fatalError("Error: Unable to load model.")
        }
        
    }
    enum Appearance {
        case anchored
        case notanchored
    }
    var appearance: Appearance = .notanchored {
        didSet {
            boardEntity.color = inactiveColor
        
        switch appearance {
        case .anchored:
        boardEntity.color = boardColor
        
        default: break
        }
        
        }
    }
    func update(with faceAnchor: ARFaceAnchor) {
        let blendShapes = faceAnchor.blendShapes
        guard let parent = parent else {
            // Abort updating the entity's transform if it has no parent.
            return
        }
        let cameraTransform = parent.transformMatrix(relativeTo: nil)
        let faceTransformFromCamera = simd_mul(simd_inverse(cameraTransform), faceAnchor.transform)
        self.position.z = -faceTransformFromCamera.columns.3.z
    }
    
}



