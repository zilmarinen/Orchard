//
//  TerrainPaintUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 25/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class TerrainPaintUtilitiesViewController: NSViewController {

    @IBOutlet weak var toolTypePopUp: NSPopUpButton!
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
     
        switch stateObserver.state {
            
        case .paint(let editor, let tool):
            
            switch sender {
                
            case toolTypePopUp:
                
                guard let toolType = ToolType(rawValue: sender.indexOfSelectedItem) else { break }
                
                stateObserver.state = .paint(editor: editor, tool: (toolType: toolType, terrainType: tool.terrainType))
                
            case terrainTypePopUp:
                
                guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
                
                stateObserver.state = .paint(editor: editor, tool: (toolType: tool.toolType, terrainType: terrainType))
                
            default: break
            }
            
        default: break
        }
    }
    
    lazy var stateObserver = {
        
        return TerrainPaintUtilitiesStateObserver(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneKitView.Graticule.CallbackReference?
}

extension TerrainPaintUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        stateObserver.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainPaintUtilitiesViewController {
    
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
                
            case .paint(let editor, let tool):
                
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

extension TerrainPaintUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneKitView.GraticuleState?, to: SceneKitView.GraticuleState) {
            
        switch self.stateObserver.state {
            
        case .paint(let editor, let tool):
            
            switch editor.meadow.scene.model.state {
                
            case .scene(let world):
                
                switch to {
                    
                case .tracking(let start, let end, _, _):
                    
                    world.blueprint.clear()
                    
                    guard let colorPalette = tool.terrainType.colorPalette else { break }
                    
                    var meshFaces: [MeshFace] = []
                    
                    switch tool.toolType {
                        
                    case .edge:
                        
                        guard let terrainLayer = world.terrain.find(edge: end.coordinate, edge: end.edge)?.topLayer else { break }
                        
                        let corners = GridCorner.corners(edge: end.edge)
                        
                        let edgeNormal = GridEdge.normal(edge: end.edge)
                        let inverseNormal = SCNVector3.negate(vector: edgeNormal)
                        
                        let upperPolytope = Polytope.translate(polytope: terrainLayer.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                        
                        let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: terrainLayer.polyhedron.lowerPolytope)
                        
                        meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: colorPalette.primary.vector))
                        
                        meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: edgeNormal, color: colorPalette.secondary.vector))
                        
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
                            
                            meshFaces.append(contentsOf: MeshFace.diagonal(polytope: polytope, normal: diagonalNormal, color: colorPalette.secondary.vector))
                        }
                        
                    case .tile:
                        
                        let minimumX = min(start.coordinate.x, end.coordinate.x)
                        let maximumX = max(start.coordinate.x, end.coordinate.x)
                        let minimumZ = min(start.coordinate.z, end.coordinate.z)
                        let maximumZ = max(start.coordinate.z, end.coordinate.z)
                        
                        for x in minimumX...maximumX {
                            
                            for z in minimumZ...maximumZ {
                                
                                let coordinate = Coordinate(x: x, y: World.floor, z: z)
                                
                                if let terrainNode = world.terrain.find(node: coordinate) {
                                    
                                    let upperPolytope = Polytope.translate(polytope: terrainNode.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                                    
                                    let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: terrainNode.polyhedron.lowerPolytope)
                                    
                                    GridEdge.Edges.forEach { edge in
                                        
                                        let corners = GridCorner.corners(edge: edge)
                                        
                                        let normal = GridEdge.normal(edge: edge)
                                        
                                        meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: colorPalette.primary.vector))
                                        
                                        meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: colorPalette.secondary.vector))
                                    }
                                }
                            }
                        }
                    }
                    
                    world.blueprint.add(mesh: Mesh(faces: meshFaces))
                    
                case .up(let start, let end, _, _):
                    
                    switch tool.toolType {
                        
                    case .edge:
                        
                        guard let terrainLayer = world.terrain.find(edge: end.coordinate, edge: end.edge)?.topLayer else { break }
                        
                        terrainLayer.terrainType = tool.terrainType
                        
                    case .tile:
                        
                        let minimumX = min(start.coordinate.x, end.coordinate.x)
                        let maximumX = max(start.coordinate.x, end.coordinate.x)
                        let minimumZ = min(start.coordinate.z, end.coordinate.z)
                        let maximumZ = max(start.coordinate.z, end.coordinate.z)
                        
                        for x in minimumX...maximumX {
                            
                            for z in minimumZ...maximumZ {
                                
                                let coordinate = Coordinate(x: x, y: World.floor, z: z)
                                
                                GridEdge.Edges.forEach { edge in
                                    
                                    if let terrainLayer = world.terrain.find(edge: coordinate, edge: edge)?.topLayer {
                                        
                                        terrainLayer.terrainType = tool.terrainType
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
