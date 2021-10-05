//
//  ToolView.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

struct ToolView: View {
    
    let tool: Tool
    
    @ObservedObject private(set) var appModel: AppViewModel
    
    init(tool: Tool, appModel: AppViewModel) {
        
        self.tool = tool
        self.appModel = appModel
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack {
        
                switch tool {
                
                case .bridges: BridgeTool(tool: tool, appModel: appModel)
                case .buildings: BuildingTool(tool: tool, appModel: appModel)
                case .bushes: BushTool(tool: tool, appModel: appModel)
                case .footpaths: FootpathTool(tool: tool, appModel: appModel)
                case .map: MapTool(tool: tool, appModel: appModel)
                case .portals: PortalTool(tool: tool, appModel: appModel)
                case .rocks: RockTool(tool: tool, appModel: appModel)
                case .seams: SeamTool(tool: tool, appModel: appModel)
                case .stairs: StairTool(tool: tool, appModel: appModel)
                case .surface: SurfaceTool(tool: tool, appModel: appModel)
                case .trees: TreeTool(tool: tool, appModel: appModel)
                case .walls: WallTool(tool: tool, appModel: appModel)
                case .water: WaterTool(tool: tool, appModel: appModel)
                }
            
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 280, idealWidth: 280.0)
    }
}
