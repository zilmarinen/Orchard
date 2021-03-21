//
//  Map.swift
//
//  Created by Zack Brown on 10/03/2021.
//

import SpriteKit
import Meadow

class Map: SKScene, Codable, StartOption, Responder2D, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case meadow
    }
    
    enum Constants {
        
        static let width = 128
        static let height = (width / 4) * 3
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let meadow: Editor
    
    var world: World {
        
        didSet {
            
            guard oldValue.season != world.season else { return }
            
            becomeDirty()
        }
    }
    
    var map: Map? { self }
    
    override init() {
        
        meadow = Editor()
        
        world = World(season: .spring)
        
        super.init(size: CGSize(width: Constants.width, height: Constants.height))
        
        name = "Meadow"
        
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .aspectFill

        addChild(meadow)
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        meadow = try container.decode(Editor.self, forKey: .meadow)
        
        world = World(season: .spring)
        
        super.init(size: CGSize(width: Constants.width, height: Constants.height))
        
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
