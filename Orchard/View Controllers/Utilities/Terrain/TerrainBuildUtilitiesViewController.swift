//
//  TerrainBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class TerrainBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, let tool):
            
            switch sender {
                
            case toolTypePopUp:
                
                guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .build(editor: editor, tool: (toolType: toolType, terrainType: tool.terrainType))
                
            case terrainTypePopUp:
                
                guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                viewModel.state = .build(editor: editor, tool: (toolType: tool.toolType, terrainType: terrainType))
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainBuildUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneKitView.Graticule.CallbackReference?
}

extension TerrainBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        DispatchQueue.main.async {
            
            switch to {
                
            case .empty(let editor):
                
                guard let editor = editor else { break }
                
                switch editor.meadow.scene.model.state {
                    
                case .scene(let world):
                    
                    world.blueprint.clear()
                    
                    editor.meadow.input.cursor.tracksIdleEvents = false
                    
                    if let graticuleIdentifier = self.graticuleIdentifier {
                        
                        editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
                    }
                    
                    self.graticuleIdentifier = nil
                    
                default: break
                }
                
            case .build(let editor, let tool):
                
                editor.meadow.input.cursor.tracksIdleEvents = true
                
                if self.graticuleIdentifier == nil {
                
                    self.graticuleIdentifier = editor.meadow.input.graticule.subscribe(self.stateDidChange(from:to:))
                }
                
                self.terrainTypePopUp.removeAllItems()
                self.toolTypePopUp.removeAllItems()
                
                self.toolTypePopUp.addItem(withTitle: "Edge")
                self.toolTypePopUp.addItem(withTitle: "Tile")
                
                self.toolTypePopUp.selectItem(at: tool.toolType.rawValue)
                
                self.colorPaletteView.color = nil
                
                TerrainType.allCases.forEach { terrainType in
                    
                    self.terrainTypePopUp.addItem(withTitle: terrainType.name)
                }
                
                if let index = TerrainType.allCases.firstIndex(of: tool.terrainType), let colorPalette = tool.terrainType.colorPalette {
                    
                    self.terrainTypePopUp.selectItem(at: index)
                    
                    self.colorPaletteView.colorPalette = colorPalette
                }
            }
        }
    }
}

extension TerrainBuildUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneKitView.GraticuleState?, to: SceneKitView.GraticuleState) {
            
        switch self.viewModel.state {
            
        case .build(let editor, let tool):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch to {
                    
                case .tracking(let start, let end, _, let inputType):
                    
                    world.blueprint.clear()
                    
                    guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                    
                    var meshFaces: [MeshFace] = []
                    
                    var color = colorPalette.primary
                    
                    switch inputType {
                        
                    case .left: color = colorPalette.secondary
                    case .right: color = colorPalette.tertiary
                        
                    default: break
                    }
                    
                    switch tool.toolType {
                        
                    case .edge:
                        
                        let lowerPolytope = end.polytope
                        
                        let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                        
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
                        
                        let minimumX = min(start.coordinate.x, end.coordinate.x)
                        let maximumX = max(start.coordinate.x, end.coordinate.x)
                        let minimumZ = min(start.coordinate.z, end.coordinate.z)
                        let maximumZ = max(start.coordinate.z, end.coordinate.z)
                        
                        for x in minimumX...maximumX {
                            
                            for z in minimumZ...maximumZ {
                                
                                let coordinate = Coordinate(x: x, y: World.floor, z: z)
                                
                                let terrainNode = world.terrain.find(node: coordinate)
                                
                                let lowerPolytope = (terrainNode?.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                                
                                let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                                
                                let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                                
                                GridEdge.Edges.forEach { edge in
                                    
                                    let corners = GridCorner.corners(edge: edge)
                                    
                                    let normal = GridEdge.normal(edge: edge)
                                    
                                    meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                                    
                                    meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: color.vector))
                                }
                            }
                        }
                    }
                    
                    world.blueprint.add(mesh: Mesh(faces: meshFaces))
                    
                case .up(let start, let end, _, let inputType):
                    
                    switch tool.toolType {
                        
                    case .edge:
                        
                        switch inputType {
                            
                        case .left:
                            
                            let _ = world.terrain.add(layer: end.coordinate, edge: end.edge, terrainType: tool.terrainType)
                            
                        case .right:
                            
                            if let terrainLayer = world.terrain.find(edge: end.coordinate, edge: end.edge)?.topLayer {
                                
                                world.terrain.remove(layer: terrainLayer)
                            }
                            
                        default: break
                        }
                        
                    case .tile:
                        
                        let minimumX = min(start.coordinate.x, end.coordinate.x)
                        let maximumX = max(start.coordinate.x, end.coordinate.x)
                        let minimumZ = min(start.coordinate.z, end.coordinate.z)
                        let maximumZ = max(start.coordinate.z, end.coordinate.z)
                        
                        for x in minimumX...maximumX {
                            
                            for z in minimumZ...maximumZ {
                                
                                let coordinate = Coordinate(x: x, y: World.floor, z: z)
                                
                                GridEdge.Edges.forEach { edge in
                                    
                                    switch inputType {
                                        
                                    case .left:
                                        
                                        let _ = world.terrain.add(layer: coordinate, edge: edge, terrainType: tool.terrainType)
                                        
                                    case .right:
                                        
                                        if let terrainLayer = world.terrain.find(edge: coordinate, edge: edge)?.topLayer {
                                            
                                            world.terrain.remove(layer: terrainLayer)
                                        }
                                        
                                    default: break
                                    }
                                }
                            }
                        }
                    }
                    
                default: break
                }
                
            default: break
            }
            
        default: break
        }
    }
}
