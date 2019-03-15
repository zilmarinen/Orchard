//
//  TerrainTerraformUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class TerrainTerraformUtilitiesViewController: NSViewController {

    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var depthTextField: NSTextField!
    
    @IBOutlet weak var widthStepper: NSStepper!
    @IBOutlet weak var depthStepper: NSStepper!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .terraform(let editor, let tool):
            
            guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .terraform(editor: editor, tool: (toolType: toolType, reticule: tool.reticule))
            
        default: break
        }
    }
    
    @IBAction func stepper(_ sender: NSStepper) {
        
        switch viewModel.state {
            
        case .terraform(let editor, var tool):
            
            switch sender {
                
            case widthStepper:
                
                tool.reticule.width = widthStepper.integerValue
                
            case depthStepper:
                
                tool.reticule.depth = depthStepper.integerValue
                
            default: break
            }
            
            viewModel.state = .terraform(editor: editor, tool: tool)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainTerraformUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneView.Graticule.CallbackReference?
}

extension TerrainTerraformUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainTerraformUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty(let editor):
                
                guard let editor = editor else { break }
                
                editor.meadow.input.cursor.tracksIdleEvents = false
                
                if let graticuleIdentifier = self.graticuleIdentifier {
                    
                    editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
                }
                
                self.graticuleIdentifier = nil
                
            case .terraform(let editor, let tool):
                
                editor.meadow.input.cursor.tracksIdleEvents = true
                
                if self.graticuleIdentifier == nil {
                    
                    self.graticuleIdentifier = editor.meadow.input.graticule.subscribe(self.stateDidChange(from:to:))
                }
                
                self.toolTypePopUp.removeAllItems()
                
                self.toolTypePopUp.addItem(withTitle: "Corner")
                self.toolTypePopUp.addItem(withTitle: "Edge")
                self.toolTypePopUp.addItem(withTitle: "Tile")
                
                self.toolTypePopUp.selectItem(at: tool.toolType.rawValue)
                
                self.widthStepper.maxValue = 10
                self.widthStepper.minValue = 1
                self.widthStepper.integerValue = tool.reticule.width
                self.widthStepper.isEnabled = tool.toolType == ToolType.tile
                
                self.depthStepper.maxValue = 10
                self.depthStepper.minValue = 1
                self.depthStepper.integerValue = tool.reticule.depth
                self.depthStepper.isEnabled = tool.toolType == ToolType.tile
                
                self.widthTextField.integerValue = self.widthStepper.integerValue
                self.widthTextField.isEnabled = tool.toolType == ToolType.tile
                
                self.depthTextField.integerValue = self.depthStepper.integerValue
                self.depthTextField.isEnabled = tool.toolType == ToolType.tile
            }
        }
    }
}

extension TerrainTerraformUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState) {
        
        DispatchQueue.main.async {
            
            switch self.viewModel.state {
                
            case .terraform(let editor, let tool):
                
                switch to {
                    
                case .tracking(let start, _, let yOffset, let inputType):
                    
                    editor.meadow.scene.world.blueprint.clear()
                    
                    guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                    
                    var meshFaces: [MeshFace] = []
                    
                    switch tool.toolType {
                        
                    case .corner:
                        
                        let coordinate = Coordinate(x: start.coordinate.x, y: World.floor, z: start.coordinate.z)
                        
                        let edges = GridEdge.edges(corner: start.corner)
                        
                        [edges.e0, edges.e1].forEach { edge in
                            
                            if let terrainLayer = editor.meadow.scene.world.terrain.find(edge: coordinate, edge: edge)?.topLayer {
                                
                                let corners = GridCorner.corners(edge: edge)
                                
                                let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                                
                                meshFaces.append(MeshFace.apex(corners: corners, polytope: polytope, color: colorPalette.secondary.vector))
                                
                                if inputType == .left {
                                    
                                    let height = start.coordinate.y + yOffset
                                    
                                    terrainLayer.set(center: height)
                                    terrainLayer.set(corner: corners.c0, height: height)
                                    terrainLayer.set(corner: corners.c1, height: height)
                                }
                            }
                        }
                        
                    case .edge:
                        
                        let coordinate = Coordinate(x: start.coordinate.x, y: World.floor, z: start.coordinate.z)
                        
                        if let terrainLayer = editor.meadow.scene.world.terrain.find(edge: coordinate, edge: start.edge)?.topLayer {
                         
                            let corners = GridCorner.corners(edge: terrainLayer.edge)
                            
                            let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                            
                            meshFaces.append(MeshFace.apex(corners: corners, polytope: polytope, color: colorPalette.secondary.vector))
                            
                            if inputType == .left {
                                
                                let height = start.coordinate.y + yOffset
                                
                                terrainLayer.set(center: height)
                                terrainLayer.set(corner: corners.c0, height: height)
                                terrainLayer.set(corner: corners.c1, height: height)
                            }
                        }
                        
                    case .tile:
                        
                        let minimumX = start.coordinate.x
                        let maximumX = start.coordinate.x + tool.reticule.width
                        let minimumZ = start.coordinate.z
                        let maximumZ = start.coordinate.z + tool.reticule.depth
                        
                        for x in minimumX..<maximumX {
                            
                            for z in minimumZ..<maximumZ {
                                
                                let coordinate = Coordinate(x: x, y: World.floor, z: z)
                                
                                GridEdge.Edges.forEach { edge in
                                    
                                    if let terrainLayer = editor.meadow.scene.world.terrain.find(edge: coordinate, edge: edge)?.topLayer {
                                        
                                        let corners = GridCorner.corners(edge: edge)
                                        
                                        let polytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                                        
                                        meshFaces.append(MeshFace.apex(corners: corners, polytope: polytope, color: colorPalette.secondary.vector))
                                        
                                        if inputType == .left {
                                            
                                            let height = start.coordinate.y + yOffset
                                            
                                            terrainLayer.set(center: height)
                                            terrainLayer.set(corner: corners.c0, height: height)
                                            terrainLayer.set(corner: corners.c1, height: height)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                    
                default: break
                }
                
            default: break
            }
        }
    }
}
