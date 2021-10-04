//
//  TreeTool.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import Meadow
import SwiftUI

struct TreeTool: View {
    
    @ObservedObject private(set) var model: AppViewModel
    
    @State private(set) var toolModel: TreeToolModel
    
    init(model: AppViewModel, tool: Tool) {
        
        self.model = model
        self.toolModel = TreeToolModel(tool: tool, rendering: !model.harvest.map.foliage.isHidden)
    }
    
    var body: some View {
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: toolModel.tool.id.capitalized, imageName: toolModel.tool.imageName, badge: model.badge(for: toolModel.tool))) {
                
                ToolPropertyView(title: "Rendering", color: toolModel.tool.color) {
                    
                    Toggle("Rendering", isOn: $toolModel.rendering)
                        .onChange(of: toolModel.rendering) { _ in
                            
                            model.harvest.map.foliage.isHidden = !toolModel.rendering
                        }
                }
            }
        }
        
        ToolPropertySection {
            
            ToolPropertyGroup(model: .init(title: "Foliage")) {
                
                ToolPropertyView(title: "Species", color: toolModel.tool.color) {
                    
                    Picker("Species", selection: $toolModel.species) {
                        
                        ForEach(TreeSpecies.allCases, id: \.self) { species in
                        
                            Text(species.id.capitalized).tag(species)
                        }
                    }
                }
                
                ToolPropertyView(title: "Direction", color: toolModel.tool.color) {
                    
                    Picker("Direction", selection: $toolModel.direction) {
                        
                        ForEach(Cardinal.allCases, id: \.self) { cardinal in
                        
                            Text(cardinal.id.capitalized).tag(cardinal)
                        }
                    }
                }
            }
        }
    }
}
