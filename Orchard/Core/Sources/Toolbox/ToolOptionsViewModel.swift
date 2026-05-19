//
//  ToolOptionsViewModel.swift
//  Core
//
//  Created by Zack Brown on 08/02/2026.
//

import Base
import Bivouac
import Cobble
import Deltille
import Harvest
import Newel
import Palisade

public protocol ToolOptionsDelegate: AnyObject {
    
    func toolOptionsViewModel(_ viewModel: ToolOptionsViewModel,
                              didSelect cursorStyle: CursorStyle)
}

@MainActor
public class ToolOptionsViewModel {
    
    private(set) public var biome: Biome = .boreal
    private(set) public var cast: Cast = .terraced
    private(set) public var design: Design = .wedge
    private(set) public var rampart: Rampart = .hedge
    private(set) public var rise: Rise = .ascending
    private(set) public var sculpt: Bool = true
    private(set) public var segment: FenceSegment = .fence
    private(set) public var septomino: Triangle.Septomino = .antlia
    private(set) public var slope: Slope = .narrow
    private(set) public var waterType: WaterType = .ocean
    
    private(set) public var tool: Tool
    private(set) public var cursorStyle: CursorStyle = .vertex
    
    private weak var delegate: ToolOptionsDelegate?
    
    public init(tool: Tool,
                delegate: ToolOptionsDelegate) {
        
        self.tool = tool
        self.delegate = delegate
    }
}

extension ToolOptionsViewModel {
    
    // MARK: Tool
    
    public func select(tool value: Tool) {
        
        self.tool = value
        
        guard !cursorStyles.contains(cursorStyle),
              let defaultCursorStyle = cursorStyles.first else { return }
        
        select(cursorStyle: defaultCursorStyle)
    }
    
    // MARK: Cursor
    
    public var cursorStyles: [CursorStyle] {
        
        switch tool {
            
        case .buildings: [.footprint(asset: .building(septomino))]
            
        case .foliage: [.triangle,
                        .hexagonal]
            
        case .footpaths: [.vertex]
            
        case .portals: [.triangle]
            
        case .slopes: [.footprint(asset: .slope(slope,
                                                rise,
                                                cast))]
            
        case .terrain: [.vertex,
                        .triangle,
                        .hexagonal]
            
        case .water: [.triangle,
                      .hexagonal]
            
        default: []
        }
    }
    
    public func select(cursorStyle value: CursorStyle) {
        
        self.cursorStyle = value
        
        delegate?.toolOptionsViewModel(self,
                                       didSelect: value)
    }
    
    // MARK: Buildings
    
    internal func select(septomino value: Triangle.Septomino) {
        
        self.septomino = value
    }
    
    // MARK: Fences
    
    internal func select(rampart value: Rampart) {
        
        self.rampart = value
    }
    
    internal func select(segment value: FenceSegment) {
        
        self.segment = value
    }
    
    // MARK: Footpaths
    
    internal func select(design value: Design) {
        
        self.design = value
    }
    
    // MARK: Slopes
    
    internal func select(slope value: Slope) {
        
        self.slope = value
    }
    
    internal func select(rise value: Rise) {
        
        self.rise = value
    }
    
    internal func select(cast value: Cast) {
        
        self.cast = value
    }
    
    // MARK: Terrain
    
    internal func select(biome value: Biome) {
        
        self.biome = value
    }
    
    internal func select(sculpt value: Bool) {
        
        self.sculpt = value
    }
    
    // MARK: Water
    
    internal func select(waterType value: WaterType) {
        
        self.waterType = value
    }
}
