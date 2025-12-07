//
//  FootpathInspector.swift
//
//  Created by Zack Brown on 07/12/2025.
//

import AppKit
import Base

public class FootpathInspector: InspectorGridView {
    
    private enum Constant {
        
        static let heightMultiplier = 0.5
        static let borderWidth = 1.0
        static let cornerRadius = 4.0
    }
    
    private lazy var footpathTypePopUp = with(NSPopUpButton(title: "Footpath Type",
                                                            target: self,
                                                            action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addItems(withTitles: viewModel.footpathTypes.map { $0.id })
        $0.selectItem(withTitle: viewModel.footpathType.id)
    }
    
    private lazy var colorPaletteView = with(ColorPaletteView(colorPalette: viewModel.footpathType.colorPalette)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer?.borderColor = NSColor.controlColor.cgColor
        $0.layer?.borderWidth = Constant.borderWidth
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let viewModel: FootpathInspectorViewModel
    
    public required init(viewModel: FootpathInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(title: "Footpaths",
                   accentColor: .systemBrown)
        
        addRow(label: "Material",
               detail: footpathTypePopUp)
        addArrangedSubview(colorPaletteView)
        
        NSLayoutConstraint.activate([

            colorPaletteView.heightAnchor.constraint(equalTo: colorPaletteView.widthAnchor,
                                                     multiplier: Constant.heightMultiplier)
        ])
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension FootpathInspector {
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case footpathTypePopUp:
            
            let footpathType = viewModel.footpathType(at: sender.indexOfSelectedItem)
            
            viewModel.select(footpathType: footpathType)
            
            colorPaletteView.colorPalette = footpathType.colorPalette
            
        default: break
        }
    }
}
