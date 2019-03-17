//
//  AreaBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class AreaBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var selectedExternalAreaTypePopUp: NSPopUpButton!
    @IBOutlet weak var selectedInternalAreaTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var selectedFloorColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var selectedEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedArchitectureTypePopup: NSPopUpButton!
    
    @IBOutlet weak var externalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var utility):
            
            switch sender {
                
            default: break
            }
            
            viewModel.state = .build(editor: editor, utility: utility)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return AreaBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneView.Graticule.CallbackReference?
}

extension AreaBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension AreaBuildUtilitiesViewController {
    
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
                
                //
            }
        }
    }
}

extension AreaBuildUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState) {
        
        switch self.viewModel.state {
            
        case .build(let editor, let tool):
            
            switch to {
                
            case .tracking(let start, let end, _, let inputType):
                
                editor.meadow.scene.world.blueprint.clear()
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                var meshFaces: [MeshFace] = []
                
                var color = colorPalette.primary
                
                switch inputType {
                    
                case .left: color = colorPalette.secondary
                case .right: color = colorPalette.tertiary
                    
                default: break
                }
                    
                let minimumX = min(start.coordinate.x, end.coordinate.x)
                let maximumX = max(start.coordinate.x, end.coordinate.x)
                let minimumZ = min(start.coordinate.z, end.coordinate.z)
                let maximumZ = max(start.coordinate.z, end.coordinate.z)
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        if let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate) {
                        
                            let lowerPolytope = (terrainNode.polyhedron.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
                            
                            let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY * MDWFloat(AreaNodeEdge.areaHeight), z: 0.0))
                            
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
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            case .up(let start, let end, _, let inputType):
                
                let minimumX = min(start.coordinate.x, end.coordinate.x)
                let maximumX = max(start.coordinate.x, end.coordinate.x)
                let minimumZ = min(start.coordinate.z, end.coordinate.z)
                let maximumZ = max(start.coordinate.z, end.coordinate.z)
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: start.coordinate.y, z: z)
                        
                        GridEdge.Edges.forEach { edge in
                            
                            switch inputType {
                                
                            case .left:
                                
                                if let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate) {
                                    
                                    let _ = editor.meadow.scene.world.areas.add(node: coordinate)
                                }
                                
                            case .right:
                                
                                if let areaNode = editor.meadow.scene.world.areas.find(node: coordinate) {
                                    
                                    editor.meadow.scene.world.areas.remove(node: areaNode)
                                }
                                
                            default: break
                            }
                        }
                    }
                }
                
            default: break
            }
            
        default: break
        }
    }
}
