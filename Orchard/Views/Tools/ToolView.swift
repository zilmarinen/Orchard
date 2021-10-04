//
//  ToolView.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

struct ToolView: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var tool: Tool
    
    var body: some View {
        
        ScrollView {
            
            VStack {
        
                switch tool {
                
                case .bridges: BridgeTool(model: model, tool: tool)
                case .bushes: BushTool(model: model, tool: tool)
                case .buildings: BuildingTool(model: model, tool: tool)
                case .footpaths: FootpathTool(model: model, tool: tool)
                case .map: MapTool(model: model, tool: tool)
                case .portals: PortalTool(model: model, tool: tool)
                case .rocks: RockTool(model: model, tool: tool)
                case .seams: SeamTool(model: model, tool: tool)
                case .stairs: StairTool(model: model, tool: tool)
                case .surface: SurfaceTool(model: model, tool: tool)
                case .trees: TreeTool(model: model, tool: tool)
                case .walls: WallTool(model: model, tool: tool)
                case .water: WaterTool(model: model, tool: tool)
                }
            
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 280, idealWidth: 280.0)
    }
}
