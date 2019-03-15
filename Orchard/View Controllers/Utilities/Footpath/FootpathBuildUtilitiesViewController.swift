//
//  FootpathBuildUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class FootpathBuildUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var footpathTypePopUp: NSPopUpButton!
    
    @IBOutlet weak var colorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var slopeButton: NSButton!
    @IBOutlet weak var steepButton: NSButton!
    
    @IBOutlet weak var selectedEdgePopUp: NSPopUpButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var tool):
            
            switch sender {
                
            case slopeButton:
                
                switch sender.state {
                    
                case .on:
                    
                    tool.slope = FootpathNode.Slope(edge: .north, steep: false)
                    
                case .off:
                    
                    tool.slope = nil
                    
                default: break
                }
                
            case steepButton:
                
                guard let slope = tool.slope else { break }
                
                tool.slope = FootpathNode.Slope(edge: slope.edge, steep: (sender.state == .on))
                
            default: break
            }
            
            viewModel.state = .build(editor: editor, tool: tool)
            
        default: break
        }
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .build(let editor, var tool):
            
            switch sender {
                
            case footpathTypePopUp:
                
                guard let footpathType = FootpathType(rawValue: sender.indexOfSelectedItem) else { break }
                
                tool.footpathType = footpathType
                
            case selectedEdgePopUp:
                
                guard let edge = GridEdge(rawValue: sender.indexOfSelectedItem), let slope = tool.slope else { break }
                
                tool.slope = FootpathNode.Slope(edge: edge, steep: slope.steep)
            
            default: break
            }
            
            viewModel.state = .build(editor: editor, tool: tool)
            
        default: break
        }
    }

    lazy var viewModel = {
        
        return FootpathBuildUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var graticuleIdentifier: SceneView.Graticule.CallbackReference?
}

extension FootpathBuildUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
}

extension FootpathBuildUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let graticuleIdentifier = graticuleIdentifier {
                
                editor.meadow.input.graticule.unsubscribe(graticuleIdentifier)
            }
            
            graticuleIdentifier = nil
            
        case .build(let editor, let tool):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            if graticuleIdentifier == nil {
                
                graticuleIdentifier = editor.meadow.input.graticule.subscribe(stateDidChange(from:to:))
            }
            
            footpathTypePopUp.removeAllItems()
            selectedEdgePopUp.removeAllItems()
            
            steepButton.isEnabled = (tool.slope != nil)
            selectedEdgePopUp.isEnabled = (tool.slope != nil)
            
            FootpathType.allCases.forEach { footpathType in
                
                footpathTypePopUp.addItem(withTitle: footpathType.name)
            }
            
            if let index = FootpathType.allCases.index(of: tool.footpathType), let colorPalette = tool.footpathType.colorPalette {
                
                footpathTypePopUp.selectItem(at: index)
                
                colorPaletteView.colorPalette = colorPalette
            }
            
            slopeButton.state = (tool.slope == nil ? .off : .on)
            steepButton.state = (tool.slope?.steep ?? false ? .on : .off)
            
            GridEdge.Edges.forEach { edge in
                
                selectedEdgePopUp.addItem(withTitle: edge.description)
            }
            
            if let edge = tool.slope?.edge, let index = GridEdge.Edges.index(of: edge) {
                
                selectedEdgePopUp.selectItem(at: index)
            }
        }
    }
}

extension FootpathBuildUtilitiesViewController: GraticuleObserver {
    
    func stateDidChange(from: SceneView.GraticuleState?, to: SceneView.GraticuleState) {
        
        switch viewModel.state {
            
        case .build(let editor, let tool):
            
            switch to {
                
            case .down(let start, let inputType):
                
                let footpathNode = editor.meadow.scene.world.footpaths.add(node: start.coordinate, footpathType: .asphalt)
                
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
                var maximumX = max(start.coordinate.x, end.coordinate.x)
                let minimumZ = min(start.coordinate.z, end.coordinate.z)
                var maximumZ = max(start.coordinate.z, end.coordinate.z)
                
                let deltaX = abs(minimumX - maximumX)
                let deltaZ = abs(minimumZ - maximumZ)
                
                maximumX = (deltaZ >= deltaX ? minimumX : maximumX)
                maximumZ = (deltaX > deltaZ ? minimumZ : maximumZ)
                
                for x in minimumX...maximumX {
                    
                    for z in minimumZ...maximumZ {
                        
                        let coordinate = Coordinate(x: x, y: World.floor, z: z)
                        
                        let terrainNode = editor.meadow.scene.world.terrain.find(node: coordinate)
                        
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
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: meshFaces))
                
            default: break
                
            }
            
        default: break
        }
    }
}
