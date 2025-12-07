//
//  WaterInspector.swift
//
//  Created by Zack Brown on 07/12/2025.
//

import AppKit
import Base

public class WaterInspector: InspectorGridView {
    
    private enum Constant {
        
        static let heightMultiplier = 0.5
        static let borderWidth = 1.0
        static let cornerRadius = 4.0
    }
    
    private lazy var waterTypePopUp = with(NSPopUpButton(title: "Water Type",
                                                         target: self,
                                                         action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addItems(withTitles: viewModel.waterTypes.map { $0.id })
        $0.selectItem(withTitle: viewModel.waterType.id)
    }
    
    private lazy var colorPaletteView = with(ColorPaletteView(colorPalette: viewModel.waterType.colorPalette)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer?.borderColor = NSColor.controlColor.cgColor
        $0.layer?.borderWidth = Constant.borderWidth
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let viewModel: WaterInspectorViewModel
    
    public required init(viewModel: WaterInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(title: "Water",
                   accentColor: .systemBrown)
        
        addRow(label: "Material",
               detail: waterTypePopUp)
        addArrangedSubview(colorPaletteView)
        
        NSLayoutConstraint.activate([

            colorPaletteView.heightAnchor.constraint(equalTo: colorPaletteView.widthAnchor,
                                                     multiplier: Constant.heightMultiplier)
        ])
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension WaterInspector {
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case waterTypePopUp:
            
            let waterType = viewModel.waterType(at: sender.indexOfSelectedItem)
            
            viewModel.select(waterType: waterType)
            
            colorPaletteView.colorPalette = waterType.colorPalette
            
        default: break
        }
    }
}
