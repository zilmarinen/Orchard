//
//  Actor2D.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import Meadow
import SpriteKit

class Actor2D: SKSpriteNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    let coordinate: Coordinate
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        
        super.init(texture: nil, color: .black, size: CGSize(width: 1, height: 1))
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = CGPoint(x: Double(coordinate.x), y: Double(coordinate.z))
        
        anchorPoint = .zero
        zPosition = 1
        blendMode = .replace
        color = .systemPurple
        
        isDirty = false
        
        return true
    }
}
