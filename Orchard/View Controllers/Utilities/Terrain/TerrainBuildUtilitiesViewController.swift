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
    
    @IBOutlet weak var terrainTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPalettePrimary: NSBox!
    @IBOutlet weak var colorPaletteSecondary: NSBox!
    @IBOutlet weak var colorPaletteTertiary: NSBox!
    @IBOutlet weak var colorPaletteQuaternary: NSBox!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let meadow, _):
            
            guard let terrainType = TerrainType(rawValue: sender.indexOfSelectedItem) else { break }
            
            viewModel.state = .build(meadow: meadow, terrainType: terrainType)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return TerrainBuildUtilitiesViewModel(initialState: .empty(meadow: nil))
    }()
    
    var cursorModelCallbackReference: UUID?
    
    lazy var graticuleModel = {
       
        return SceneView.GraticuleModel()
    }()
    
    var graticuleModelCallbackReference: UUID?
}

extension TerrainBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        graticuleModelCallbackReference = graticuleModel.subscribe(stateDidChange(from:to:))
    }
}

extension TerrainBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let meadow):
            
            guard let meadow = meadow else { break }
            
            meadow.input.cursorModel.tracksIdleEvents = false
            
            if let reference = cursorModelCallbackReference {
                
                meadow.input.cursorModel.unsubscribe(reference)
            }
            
            graticuleModel.state = .idle
            
        case .build(let meadow, let terrainType):
            
            meadow.input.cursorModel.tracksIdleEvents = true
            
            cursorModelCallbackReference = meadow.input.cursorModel.subscribe(stateDidChange(from:to:))
            
            terrainTypePopUp.removeAllItems()
            
            colorPalettePrimary.fillColor = NSColor.white
            colorPaletteSecondary.fillColor = NSColor.white
            colorPaletteTertiary.fillColor = NSColor.white
            colorPaletteQuaternary.fillColor = NSColor.white
            
            TerrainType.allCases.forEach { terrainType in
                
                terrainTypePopUp.addItem(withTitle: terrainType.name)
            }
            
            if let index = TerrainType.allCases.index(of: terrainType), let colorPalette = terrainType.colorPalette {
                
                terrainTypePopUp.selectItem(at: index)
                
                colorPalettePrimary.fillColor = colorPalette.primary.color
                colorPaletteSecondary.fillColor = colorPalette.secondary.color
                colorPaletteTertiary.fillColor = colorPalette.tertiary.color
                colorPaletteQuaternary.fillColor = colorPalette.quaternary.color
            }
        }
    }
}

extension TerrainBuildUtilitiesViewController: CursorModelObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .build(let meadow, let terrainType):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: meadow.scene.world,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.terrain.rawValue | SceneGraphNodeType.floor.rawValue]
         
            switch to {
                
            case .idle(let position):
                
                guard let hit = meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticuleModel.state {
                
                case .idle:
                    
                    graticuleModel.state = .tracking(position: coordinate, startPosition: coordinate)
                    
                case .tracking(let position, _):
                    
                    if position != coordinate {
                        
                        graticuleModel.state = .tracking(position: coordinate, startPosition: coordinate)
                    }
                }
                
            case .down(let position, _):
                
                guard let hit = meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                graticuleModel.state = .tracking(position: coordinate, startPosition: coordinate)
                
            case .tracking(let position, _, _):
                
                guard let hit = meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticuleModel.state {
                    
                case .tracking(let position, let startPosition):
                    
                    if position != coordinate {
                    
                        graticuleModel.state = .tracking(position: coordinate, startPosition: startPosition)
                    }
                    
                default: break
                }
                
            case .up(let position, let inputType, _):
                
                guard let hit = meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticuleModel.state {
                    
                case .tracking(_, let startPosition):
                    
                    graticuleModel.state = .idle
                    
                    let minimumX = min(startPosition.x, coordinate.x)
                    let maximumX = max(startPosition.x, coordinate.x)
                    let minimumZ = min(startPosition.z, coordinate.z)
                    let maximumZ = max(startPosition.z, coordinate.z)
                    
                    for x in minimumX...maximumX {
                        
                        for z in minimumZ...maximumZ {
                            
                            let coordinate = Coordinate(x: x, y: World.floor, z: z)
                            
                            
                        }
                    }
                    
                default: break
                }
            }
            
        default: break
        }
    }
}

extension TerrainBuildUtilitiesViewController: GraticuleModelObserver {
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState) {
        
        switch viewModel.state {
            
        case .build(let meadow, _):
            
            meadow.scene.world.blueprint.clear()
            
            switch graticuleModel.state {
                
            case .tracking(let position, let startPosition):
                
                guard let blueprintColor = ColorPalettes.shared?.color(named: "cerulean"), let invalidColor = ColorPalettes.shared?.color(named: "scarlet"), let validColor = ColorPalettes.shared?.color(named: "asparagus") else { break }
                
                var meshFaces: [MeshFace] = []
                
                let minimumX = min(startPosition.x, position.x)
                let maximumX = max(startPosition.x, position.x)
                let minimumZ = min(startPosition.z, position.z)
                let maximumZ = max(startPosition.z, position.z)
                
                for x in minimumX...maximumX {
                
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        var polytope: Polytope!
                        
                        var tileOccupied = false
                        
                        if let terrainLayer = meadow.scene.world.terrain.find(node: coordinate)?.topLayer {
                            
                            polytope = terrainLayer.polyhedron.upperPolytope
                            
                            tileOccupied = true
                        }
                        else {
                         
                            polytope = Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z))
                        }
                        
                        polytope = Polytope.translate(polytope: polytope, translation: SCNVector3(x: 0.0, y: 0.02, z: 0.0))
                        
                        var color = blueprintColor
                        
                        switch meadow.input.cursorModel.state {
                            
                        case .down(_, let inputType),
                             .tracking(_, let inputType, _),
                             .up(_, let inputType, _):
                            
                            if inputType == .left {
                                
                                color = (tileOccupied ? invalidColor : validColor)
                            }
                            else {
                                
                                color = (tileOccupied ? validColor : invalidColor)
                            }
                            
                        default: break
                        }
                        
                        GridEdge.Edges.forEach { edge in
                            
                            let corners = GridCorner.corners(edge: edge)
                            
                            meshFaces.append(MeshProvider.surface(corners: corners, polytope: polytope, color: color.vector))
                        }
                    }
                }
                
                meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
            }
            
        default: break
        }
    }
}
