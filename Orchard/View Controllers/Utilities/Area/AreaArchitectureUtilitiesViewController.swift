//
//  AreaArchitectureUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class AreaArchitectureUtilitiesViewController: NSViewController {
    
    @IBOutlet weak var selectedEdgeTypePopup: NSPopUpButton!
    @IBOutlet weak var selectedArchitectureTypePopup: NSPopUpButton!

    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .architecture(let editor, var utility):
            
            switch sender {
                
            case selectedEdgeTypePopup:
                
                guard let selectedEdgeType = AreaNodeEdgeType(rawValue: sender.indexOfSelectedItem) else { break }
                
                utility.edgeType = selectedEdgeType
                
            case selectedArchitectureTypePopup:
                
                guard let selectedArchitectureType = AreaArchitectureType(rawValue: sender.indexOfSelectedItem) else { break }
                
                utility.architectureType = selectedArchitectureType
                
            default: break
            }
            
            viewModel.state = .architecture(editor: editor, utility: utility)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return AreaArchitectureUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?

    lazy var graticule = {
        
        return SceneView.EdgeGraticule()
    }()
    
    var edgeGraticuleCallbackReference: SceneView.EdgeGraticule.CallbackReference?
}

extension AreaArchitectureUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        edgeGraticuleCallbackReference = graticule.subscribe(stateDidChange(from:to:))
    }
}

extension AreaArchitectureUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
            graticule.state = .idle
            
        case .architecture(let editor, let utility):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))
            
            selectedEdgeTypePopup.removeAllItems()
            selectedArchitectureTypePopup.removeAllItems()
            
            AreaNodeEdgeType.allCases.forEach { edgeType in
                
                selectedEdgeTypePopup.addItem(withTitle: edgeType.name)
            }
            
            AreaArchitectureType.allCases.forEach { architectureType in
                
                selectedArchitectureTypePopup.addItem(withTitle: architectureType.name)
            }
            
            if let index = AreaNodeEdgeType.allCases.index(of: utility.edgeType) {
                
                selectedEdgeTypePopup.selectItem(at: index)
            }
            
            if let index = AreaArchitectureType.allCases.index(of: utility.architectureType) {
                
                selectedArchitectureTypePopup.selectItem(at: index)
            }
        }
    }
}

extension AreaArchitectureUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .architecture(let editor, let utility):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world.areas,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.area.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                guard let areaNode = editor.meadow.scene.world.areas.find(node: coordinate) else { break }
                
                let closestEdge = areaNode.polyhedron.lowerPolytope.closest(edge: hit.worldCoordinates)
                
                switch graticule.state {
                    
                case .idle:
                    
                    graticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                    
                case .tracking(let position, let edge, _):
                    
                    if position != coordinate && edge != closestEdge {
                        
                        graticule.state = .tracking(position: coordinate, edge: closestEdge, yOffset: 0)
                    }
                }
                
            case .down(let position, let inputType):
                
                if inputType == .right {
                    
                    guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                    
                    let coordinate = Coordinate(vector: hit.worldCoordinates)
                    
                    guard let areaNode = editor.meadow.scene.world.areas.find(node: coordinate) else { break }
                    
                    editor.delegate.sceneGraph(didSelectChild: areaNode, atIndex: 0)
                }
                
            case .up(let position, _, _):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                switch graticule.state {
                    
                case .tracking(_, let edge, _):
                    
                    guard let areaNode = editor.meadow.scene.world.areas.find(node: coordinate), let edgeType = areaNode.find(edge: edge) else { break }
                    
                    let edge = AreaNode.Edge(edge: edge, edgeType: utility.edgeType, architectureType: utility.architectureType, externalColorPalette: edgeType.externalColorPalette, internalColorPalette: edgeType.internalColorPalette)
                    
                    areaNode.set(edge: edge)
                    
                default: break
                }
                
            default: break
            }
            
        default: break
        }
    }
}

extension AreaArchitectureUtilitiesViewController: EdgeGraticuleObserver {
    
    func stateDidChange(from: SceneView.EdgeGraticuleState?, to: SceneView.EdgeGraticuleState) {
        
        switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .architecture(let editor, _):
            
            editor.meadow.scene.world.blueprint.clear()
            
            switch graticule.state {
                
            case .tracking(let position, let edge, _):
                
                guard let colorPalette = ArtDirector.shared?.palette(named: "Blueprint"), let areaNode = editor.meadow.scene.world.areas.find(node: position) else { break }
                
                let corners = GridCorner.corners(edge: edge)
                
                let polytope = Polytope.translate(polytope: areaNode.polyhedron.lowerPolytope, translation: SCNVector3(x: 0.0, y: Blueprint.surface + AreaNode.surface, z: 0.0))
                
                let meshFace = MeshProvider.surface(corners: corners, polytope: polytope, color: colorPalette.primary.vector)
                
                editor.meadow.scene.world.blueprint.add(mesh: Mesh(faces: [meshFace]))
                
            default: break
            }
        }
    }
}
