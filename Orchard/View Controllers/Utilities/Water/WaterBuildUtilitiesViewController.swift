//
//  WaterBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 18/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class WaterBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    @IBOutlet weak var waterTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, let tool):
            
            switch sender {
                
            case toolTypePopUp:
                
                guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .build(editor: editor, tool: (toolType: toolType, waterType: tool.waterType))
            
            case waterTypePopUp:
            
                guard let waterType = WaterType(rawValue: sender.indexOfSelectedItem) else { break }
            
                viewModel.state = .build(editor: editor, tool: (toolType: tool.toolType, waterType: waterType))
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return WaterBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneView.Graticule.CallbackReference?
}

extension WaterBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension WaterBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty(let editor):
                
                guard let editor = editor else { break }
                
                editor.meadow.scene.world.blueprint.clear()
                
                editor.meadow.input.cursor.tracksIdleEvents = false
                
                if let graticuleIdentifier = self.graticuleIdentifier {
                    
                    editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
                }
                
                self.graticuleIdentifier = nil
                
            case .build(let editor, let tool):
                
                editor.meadow.input.cursor.tracksIdleEvents = true
                
                if self.graticuleIdentifier == nil {
                    
                    self.graticuleIdentifier = editor.meadow.input.graticule.subscribe(self.stateDidChange(from:to:))
                }
                
                self.waterTypePopUp.removeAllItems()
                self.toolTypePopUp.removeAllItems()
                
                self.toolTypePopUp.addItem(withTitle: "Edge")
                self.toolTypePopUp.addItem(withTitle: "Tile")
                
                self.toolTypePopUp.selectItem(at: tool.toolType.rawValue)
                
                self.colorPaletteView.color = nil
                
                WaterType.allCases.forEach { waterType in
                    
                    self.waterTypePopUp.addItem(withTitle: waterType.name)
                }
                
                if let index = WaterType.allCases.index(of: tool.waterType), let colorPalette = tool.waterType.colorPalette {
                    
                    self.waterTypePopUp.selectItem(at: index)
                    
                    self.colorPaletteView.colorPalette = colorPalette
                }
            }
        }
    }
}

extension WaterBuildUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState) {
            
        switch self.viewModel.state {
            
        case .build(let editor, let tool):
            
            switch to {
                
            case .down(let start, let inputType):
                
                guard let terrainNode = editor.meadow.scene.world.terrain.find(node: start.coordinate) else { return }
                
                switch inputType {
                    
                case .left:
                    
                    switch tool.toolType {
                        
                    case .edge:
                        
                        guard let terrainNodeEdgeLayer = terrainNode.find(edge: start.edge)?.topLayer else { break }
                        
                        let waterNodeEdge = editor.meadow.scene.world.water.add(edge: start.coordinate, edge: start.edge, waterType: tool.waterType)
                        
                        waterNodeEdge?.waterLevel = terrainNodeEdgeLayer.base + 1
                        
                    case .tile:
                        
                        let waterLevel = terrainNode.peak + 1
                        
                        GridEdge.Edges.forEach { edge in
                            
                            if terrainNode.find(edge: start.edge)?.topLayer != nil {
                                
                                let waterNodeEdge = editor.meadow.scene.world.water.add(edge: start.coordinate, edge: start.edge, waterType: tool.waterType)
                                
                                waterNodeEdge?.waterLevel = waterLevel
                            }
                        }
                    }
                    
                case .right:
                    
                    guard let waterNode = editor.meadow.scene.world.water.find(node: start.coordinate) else { break }
                    
                    switch tool.toolType {
                        
                    case .edge:
                        
                        guard let waterNodeEdge = waterNode.find(edge: start.edge) else { break }
                        
                        editor.meadow.scene.world.water.remove(edge: waterNodeEdge)
                        
                    case .tile:
                        
                        editor.meadow.scene.world.water.remove(node: waterNode)
                    }
                    
                default: break
                }
                
            case .tracking(_, let end, _, _):
                
                editor.meadow.scene.world.blueprint.clear()
                
                guard let terrainNode = editor.meadow.scene.world.terrain.find(node: end.coordinate), let colorPalette = tool.waterType.colorPalette else { break }
                
                var meshFaces: [MeshFace] = []
                
                let color = colorPalette.primary
                
                switch tool.toolType {
                    
                case .edge:
                    
                    guard let terrainNodeEdgeLayer = terrainNode.find(edge: end.edge)?.topLayer else { break }
                    
                    let waterLevel = terrainNodeEdgeLayer.peak + 1
                    
                    let lowerPolytope = terrainNodeEdgeLayer.polyhedron.upperPolytope
                    
                    let upperPolytope = Polytope(x: MDWFloat(terrainNodeEdgeLayer.coordinate.x), y0: waterLevel, y1: waterLevel, y2: waterLevel, y3: waterLevel, z: MDWFloat(terrainNodeEdgeLayer.coordinate.z))
                    
                    let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                    
                    let corners = GridCorner.corners(edge: end.edge)
                    
                    let edgeNormal = GridEdge.normal(edge: end.edge)
                    let inverseNormal = SCNVector3.negate(vector: edgeNormal)
                    
                    meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                    
                    meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: edgeNormal, color: color.vector))
                    
                    let edges = GridEdge.edges(edge: end.edge)
                    
                    [edges.e0, edges.e1].forEach { connectedEdge in
                        
                        let diagonalNormal = inverseNormal + GridEdge.normal(edge: connectedEdge)
                        
                        let connectedCorners = GridCorner.corners(edge: connectedEdge)
                        
                        let corner = (connectedCorners.c0 == corners.c0 ? connectedCorners.c0 : (connectedCorners.c0 == corners.c1 ? connectedCorners.c0 : connectedCorners.c1))
                        
                        let cornerUpper = polyhedron.upperPolytope.vertices[corner.rawValue]
                        let centreUpper = polyhedron.upperPolytope.center
                        
                        let cornerLower = polyhedron.lowerPolytope.vertices[corner.rawValue]
                        let centerLower = polyhedron.lowerPolytope.center
                        
                        let polytope = Polytope(v0: cornerUpper, v1: centreUpper, v2: centerLower, v3: cornerLower)
                        
                        meshFaces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: color.vector))
                    }
                    
                case .tile:
                    
                    let waterLevel = terrainNode.peak + 1
                    
                    GridEdge.Edges.forEach { edge in
                        
                        if let terrainNodeEdgeLayer = terrainNode.find(edge: edge)?.topLayer {
                            
                            let lowerPolytope = terrainNodeEdgeLayer.polyhedron.upperPolytope
                            
                            let upperPolytope = Polytope(x: MDWFloat(terrainNodeEdgeLayer.coordinate.x), y0: waterLevel, y1: waterLevel, y2: waterLevel, y3: waterLevel, z: MDWFloat(terrainNodeEdgeLayer.coordinate.z))
                            
                            let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                            
                            let corners = GridCorner.corners(edge: edge)
                            
                            let edgeNormal = GridEdge.normal(edge: edge)
                            let inverseNormal = SCNVector3.negate(vector: edgeNormal)
                            
                            meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                            
                            meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: edgeNormal, color: color.vector))
                            
                            let edges = GridEdge.edges(edge: edge)
                            
                            [edges.e0, edges.e1].forEach { connectedEdge in
                                
                                let diagonalNormal = inverseNormal + GridEdge.normal(edge: connectedEdge)
                                
                                let connectedCorners = GridCorner.corners(edge: connectedEdge)
                                
                                let corner = (connectedCorners.c0 == corners.c0 ? connectedCorners.c0 : (connectedCorners.c0 == corners.c1 ? connectedCorners.c0 : connectedCorners.c1))
                                
                                let cornerUpper = polyhedron.upperPolytope.vertices[corner.rawValue]
                                let centreUpper = polyhedron.upperPolytope.center
                                
                                let cornerLower = polyhedron.lowerPolytope.vertices[corner.rawValue]
                                let centerLower = polyhedron.lowerPolytope.center
                                
                                let polytope = Polytope(v0: cornerUpper, v1: centreUpper, v2: centerLower, v3: cornerLower)
                                
                                meshFaces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: color.vector))
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
