//
//  AreaPaintUtilitiesViewController.swift
//  Orchard
//
//  Created by Zack Brown on 23/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa
import Meadow
import SceneKit

class AreaPaintUtilitiesViewController: NSViewController {

    @IBOutlet weak var selectedFloorColorPalettePopUp: NSPopUpButton!
    @IBOutlet weak var floorColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var externalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var externalColorPaletteView: ColorPaletteView!
    
    @IBOutlet weak var internalColorPalettePopup: NSPopUpButton!
    @IBOutlet weak var internalColorPaletteView: ColorPaletteView!
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        switch viewModel.state {
            
        case .paint(let editor, var utility):
            
            switch sender {
                
            case selectedFloorColorPalettePopUp:
                
                guard let colorPalette = ArtDirector.shared?.palettes.child(at: sender.indexOfSelectedItem) else { break }
                
                utility.floorColorPalette = colorPalette
                
            case externalColorPalettePopup:
                
                guard let colorPalette = ArtDirector.shared?.palettes.child(at: sender.indexOfSelectedItem) else { break }
                
                utility.externalColorPalette = colorPalette
                
            case internalColorPalettePopup:
                
                guard let colorPalette = ArtDirector.shared?.palettes.child(at: sender.indexOfSelectedItem) else { break }
                
                utility.internalColorPalette = colorPalette
                
            default: break
            }
            
            viewModel.state = .paint(editor: editor, utility: utility)
            
        default: break
        }
    }
    
    lazy var viewModel = {
        
        return AreaPaintUtilitiesViewModel(initialState: .empty(editor: nil))
    }()
    
    var cursorCallbackReference: SceneView.Cursor.CallbackReference?

    lazy var graticule = {
        
        return SceneView.EdgeGraticule()
    }()
    
    var edgeGraticuleCallbackReference: SceneView.EdgeGraticule.CallbackReference?
}

extension AreaPaintUtilitiesViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel.subscribe(stateDidChange(from:to:))
        
        edgeGraticuleCallbackReference = graticule.subscribe(stateDidChange(from:to:))
    }
}

extension AreaPaintUtilitiesViewController {
    
    func stateDidChange(from: ViewState?, to: ViewState) {
        
        switch to {
            
        case .empty(let editor):
            
            guard let editor = editor else { break }
            
            editor.meadow.input.cursor.tracksIdleEvents = false
            
            if let reference = cursorCallbackReference {
                
                editor.meadow.input.cursor.unsubscribe(reference)
            }
            
            graticule.state = .idle
            
        case .paint(let editor, let utility):
            
            editor.meadow.input.cursor.tracksIdleEvents = true
            
            cursorCallbackReference = editor.meadow.input.cursor.subscribe(stateDidChange(from:to:))

            selectedFloorColorPalettePopUp.removeAllItems()
            externalColorPalettePopup.removeAllItems()
            internalColorPalettePopup.removeAllItems()
            
            floorColorPaletteView.color = nil
            externalColorPaletteView.color = nil
            internalColorPaletteView.color = nil
            
            if let paletteCount = ArtDirector.shared?.palettes.totalChildren {
                
                for index in 0..<paletteCount {
                    
                    if let palette = ArtDirector.shared?.palettes.child(at: index) {
                        
                        selectedFloorColorPalettePopUp.addItem(withTitle: palette.name)
                        externalColorPalettePopup.addItem(withTitle: palette.name)
                        internalColorPalettePopup.addItem(withTitle: palette.name)
                    }
                }
            }
            
            if let index = ArtDirector.shared?.palettes.index(of: utility.floorColorPalette) {
                
                selectedFloorColorPalettePopUp.selectItem(at: index)
                
                floorColorPaletteView.colorPalette = utility.floorColorPalette
            }
            
            if let index = ArtDirector.shared?.palettes.index(of: utility.externalColorPalette) {
                
                externalColorPalettePopup.selectItem(at: index)
                
                externalColorPaletteView.colorPalette = utility.externalColorPalette
            }
            
            if let index = ArtDirector.shared?.palettes.index(of: utility.internalColorPalette) {
                
                internalColorPalettePopup.selectItem(at: index)
                
                internalColorPaletteView.colorPalette = utility.internalColorPalette
            }
        }
    }
}

extension AreaPaintUtilitiesViewController: CursorObserver {
    
    func stateDidChange(from: SceneView.CursorState?, to: SceneView.CursorState) {
        
        switch viewModel.state {
            
        case .paint(let editor, let utility):
            
            let options: [SCNHitTestOption : Any] = [SCNHitTestOption.rootNode: editor.meadow.scene.world.areas,
                                                     SCNHitTestOption.categoryBitMask: SceneGraphNodeType.area.rawValue]
            
            switch to {
                
            case .idle(let position):
                
                guard let hit = editor.meadow.sceneView.hitTest(position, options: options).first else { break }
                
                let coordinate = Coordinate(vector: hit.worldCoordinates)
                
                guard let areaNode = editor.meadow.scene.world.areas.find(node: coordinate) else { break }
                
                let closestEdge = areaNode.polyhedron.upperPolytope.closest(edge: hit.worldCoordinates)
                
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
                    
                    let edge = AreaNode.Edge(edge: edge, edgeType: edgeType.edgeType, architectureType: edgeType.architectureType, externalColorPalette: utility.externalColorPalette, internalColorPalette: utility.internalColorPalette)
                    
                    areaNode.set(edge: edge)
                    areaNode.floorColorPalette = utility.floorColorPalette
                    
                default: break
                }
                
            default: break
            }
            
        default: break
        }
    }
}

extension AreaPaintUtilitiesViewController: EdgeGraticuleObserver {
    
    func stateDidChange(from: SceneView.EdgeGraticuleState?, to: SceneView.EdgeGraticuleState) {
        
        switch viewModel.state {
            
        case .empty(let editor):
            
            editor?.meadow.scene.world.blueprint.clear()
            
        case .paint(let editor, _):
            
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
