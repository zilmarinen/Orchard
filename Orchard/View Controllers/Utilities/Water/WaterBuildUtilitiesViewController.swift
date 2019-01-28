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
    
    @IBOutlet weak var waterTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, _):
            
            guard let waterType = WaterType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .build(editor: editor, waterType: waterType)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return WaterBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?
    
    lazy var graticule = {
        
        return SceneView.TileGraticule()
    }()
    
    var tileGraticuleCallbackReference: SceneView.TileGraticule.CallbackReference?
}

extension WaterBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        tileGraticuleCallbackReference = graticule.subscribe(stateDidChange(from:to:))
    }
}

extension WaterBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
            graticule.state = .idle
            
        case .build(let editor, let waterType):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            waterTypePopUp.removeAllItems()
            
            colorPaletteView.color = nil
            
            WaterType.allCases.forEach { waterType in
                
                waterTypePopUp.addItem(withTitle: waterType.name)
            }
            
            if let index = WaterType.allCases.index(of: waterType), let colorPalette = waterType.colorPalette {
                
                waterTypePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = colorPalette
            }
        }
    }
}

extension WaterBuildUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let editor, let waterType):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticule.state {
                    
                case .idle:
                    
                    graticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                    
                case .tracking(let position, _, _):
                    
                    if position != coordinate {
                        
                        graticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                    }
                }
                
            case .down(let position, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                graticule.state = .tracking(position: coordinate, startPosition: coordinate, yOffset: 0)
                
            case .tracking(let position, _, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticule.state {
                    
                case .tracking(let position, let startPosition, _):
                    
                    if position != coordinate {
                        
                        graticule.state = .tracking(position: coordinate, startPosition: startPosition, yOffset: 0)
                    }
                    
                default: break
                }
                
            case .up(let position, let inputType, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                if inputType == .left {
                    
                    let waterNode = editor.meadow.scene.world.water.add(node: coordinate)
                    
                    waterNode?.waterType = waterType
                    waterNode?.waterLevel = coordinate.y + 1
                }
                else {
                    
                    if let waterNode = editor.meadow.scene.world.water.find(node: coordinate) {
                        
                        let _ = editor.meadow.scene.world.water.drain(node: waterNode)
                    }
                }
                
                graticule.state = .idle
            }
            
        default: break
        }
    }
}

extension WaterBuildUtilitiesViewController: TileGraticuleObserver {
    
    func stateDidChange(from: SceneView.TileGraticuleState?, to: SceneView.TileGraticuleState) {
        
        /*switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .build(let editor, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch graticule.state {
                
            case .tracking(let position, _, _):
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint") else { break }
                
                var meshFaces: [MeshFace] = []
                
                if let terrainLayer = editor.meadow.scene.world.terrain.find(node: position)?.topLayer {
                    
                    let lowerPolytope = terrainLayer.polyhedron.upperPolytope
                    
                    var upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY, z: 0.0))
                    
                    if let waterNode = editor.meadow.scene.world.water.find(node: position) {
                        
                        upperPolytope = Polytope.translate(polytope: waterNode.polyhedron.upperPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface, z: 0.0))
                    }
                    
                    let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
                    
                    var color = colorPalette.primary
                    
                    if editor.meadow.scene.world.water.find(node: position) == nil {
                        
                        color = colorPalette.secondary
                    }
                    else {
                        
                        color = colorPalette.tertiary
                    }
                    
                    GridEdge.Edges.forEach { edge in
                        
                        let corners = GridCorner.corners(edge: edge)
                        
                        let normal = GridEdge.normal(edge: edge)
                        
                        meshFaces.append(MeshProvider.surface(corners: corners, polytope: polyhedron.upperPolytope, color: color.vector))
                        
                        meshFaces.append(contentsOf: TerrainMeshProvider.terrainLayer(crown: corners, acuteCorner: nil, polyhedron: polyhedron, normal: normal, color: color.vector))
                        meshFaces.append(contentsOf: TerrainMeshProvider.terrainLayer(throne: corners, acuteCorner: nil, polyhedron: polyhedron, normal: normal, color: color.vector))
                    }
                }
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
            }
        }*/
    }
}

