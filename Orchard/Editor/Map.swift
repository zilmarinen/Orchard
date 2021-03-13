//
//  Map.swift
//  Orchard
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class Map: SKScene, Codable, StartOption, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case meadow
    }
    
    enum Constants {
        
        static let size = 100
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let meadow: Editor
    
    override init() {
        
        meadow = Editor()
        
        super.init(size: CGSize(width: Constants.size, height: Constants.size))
        
        name = "Meadow"
        
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        
        addChild(meadow)
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        meadow = try container.decode(Editor.self, forKey: .meadow)
        
        super.init(size: CGSize(width: Constants.size, height: Constants.size))
        
        name = try container.decode(String.self, forKey: .name)
        
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        
        addChild(meadow)
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(meadow, forKey: .meadow)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        clean()
    }
}

extension Map {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        meadow.clean()
        
        isDirty = false
        
        return true
    }
}

extension Map {
    
    func hitTest(point: CGPoint) -> Coordinate {
        
        let point = convertPoint(fromView: point)
        
        let hit = CGPoint(x: floor(point.x), y: floor(point.y))
        
        return Coordinate(x: Int(hit.x), y: 0, z: Int(hit.y))
    }
}
