//
//  MapTool.swift
//
//  Created by Zack Brown on 30/09/2021.
//

import SwiftUI

struct MapTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: MapToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = MapToolModel(tool: tool, name: model.harvest.map.name ?? "", identifier: model.harvest.map.identifier)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
            
                ToolPropertyView(title: "Name", color: toolModel.tool.color) {
                
                    TextField("Name", text: $toolModel.name)
                        .onChange(of: toolModel.name) { _ in
                            
                            model.harvest.map.name = toolModel.name
                        }
                }
            
                ToolPropertyView(title: "Identifier", color: toolModel.tool.color) {
                
                    TextField("Identifier", text: $toolModel.identifier)
                        .onChange(of: toolModel.identifier) { _ in
                            
                            model.harvest.map.identifier = toolModel.identifier
                        }
                }
            }
        }
    }
}
