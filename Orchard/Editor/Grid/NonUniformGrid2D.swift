//
//  NonUniformGrid2D.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Meadow
import SpriteKit

class NonUniformGrid2D<C: NonUniformChunk2D>: SKNode, Codable, Responder2D, Soilable {
    
    private enum CodingKeys: String, CodingKey {
        
        case chunks = "c"
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var chunks: [C] = []
    
    override init() {
        
        super.init()
        
        becomeDirty()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([C].self, forKey: .chunks)
        
        super.init()
        
        for chunk in chunks {
            
            addChild(chunk)
        }
        
        becomeDirty()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chunks, forKey: .chunks)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
    
    typealias ChunkConfiguration = ((C) -> Void)
        
    func add(chunk footprint: Footprint, configure: ChunkConfiguration? = nil) -> C? {
        
        guard find(chunk: footprint) == nil else { return nil }
        
        let chunk = C(footprint: footprint)
        
        chunks.append(chunk)
        
        addChild(chunk)
        
        configure?(chunk)
        
        becomeDirty()
        
        return chunk
    }
}

extension NonUniformGrid2D {
    
    func find(chunk coordinate: Coordinate) -> C? {
        
        return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
    
    func find(chunk footprint: Footprint) -> C? {
        
        return chunks.first { $0.footprint.intersects(footprint: footprint) }
    }
    
    func remove(chunk coordinate: Coordinate) {
        
        guard let chunk = find(chunk: coordinate),
              let index = chunks.firstIndex(of: chunk) else { return }
        
        chunks.remove(at: index)
        
        chunk.removeFromParent()
        
        becomeDirty()
    }
}
