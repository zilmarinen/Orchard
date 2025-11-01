//
//  TerrainToolInspector.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

internal class TerrainToolInspector: InspectorGridView {
    
    private enum Constant {
        
        static let heightMultiplier = 0.5
        static let borderWidth = 1.0
        static let cornerRadius = 4.0
    }
    
    private lazy var sculptCheckbox = with(NSButton(checkboxWithTitle: "Sculpt",
                                                    target: self,
                                                    action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.state = viewModel.sculpt ? .on : .off
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
    }
    
    private lazy var paintCheckbox = with(NSButton(checkboxWithTitle: "Paint",
                                                    target: self,
                                                    action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.state = viewModel.paint ? .on : .off
        $0.font = .systemFont(ofSize: NSFont.smallSystemFontSize)
    }
    
    private lazy var biomePopUp = with(NSPopUpButton(title: "Biome",
                                                     target: self,
                                                     action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addItems(withTitles: viewModel.biomes.map { $0.id })
        $0.selectItem(withTitle: viewModel.biome.id)
    }
    
    private lazy var colorPaletteView = with(ColorPaletteView(colorPalette: viewModel.biome.colorPalette)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer?.borderColor = NSColor.controlColor.cgColor
        $0.layer?.borderWidth = Constant.borderWidth
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let viewModel: TerrainInspectorViewModel
    
    internal required init(viewModel: TerrainInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(title: "Terrain",
                   accentColor: .systemBrown)
        
        addRow(detail: sculptCheckbox)
        addRow(detail: paintCheckbox)
        addRow(label: "Biome",
               detail: biomePopUp)
        addArrangedSubview(colorPaletteView)
        
        NSLayoutConstraint.activate([

            colorPaletteView.heightAnchor.constraint(equalTo: colorPaletteView.widthAnchor,
                                                     multiplier: Constant.heightMultiplier)
        ])
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension TerrainToolInspector {
    
    @objc
    internal func button(_ sender: NSButton) {
    
        switch sender {
            
        case sculptCheckbox:
            
            viewModel.toggle(sculpt: sender.state == .on)
            
        case paintCheckbox:
            
            viewModel.toggle(paint: sender.state == .on)
            
        default: break
        }
    }
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case biomePopUp:
            
            let biome = viewModel.biome(at: sender.indexOfSelectedItem)
            
            viewModel.select(biome: biome)
            
            colorPaletteView.colorPalette = biome.colorPalette
            
        default: break
        }
    }
}
