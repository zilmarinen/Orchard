//
//  FoliageTypeInspector.swift
//  Core
//
//  Created by Zack Brown on 09/10/2025.
//

import AppKit
import Base

internal class FoliageTypeInspector: InspectorGridView {
    
    private enum Constant {
        
        static let heightMultiplier = 0.5
        static let borderWidth = 1.0
        static let cornerRadius = 4.0
    }
    
    private lazy var septominoPopUp = with(NSPopUpButton(title: "Foliage Type",
                                                         target: self,
                                                         action: #selector(popUpButton(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addItems(withTitles: viewModel.septominos.map { $0.id })
        $0.selectItem(withTitle: viewModel.septomino.id)
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var footprintView = with(FootprintView(footprint: viewModel.septomino.footprint(origin: .zero))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
        $0.layer?.borderColor = NSColor.controlColor.cgColor
        $0.layer?.borderWidth = Constant.borderWidth
        $0.layer?.cornerRadius = Constant.cornerRadius
    }
    
    private let viewModel: FoliageInspectorViewModel
    
    internal required init(viewModel: FoliageInspectorViewModel) {
        
        self.viewModel = viewModel
        
        super.init(title: "Material")
        
        addRow(label: "Shape",
               detail: septominoPopUp)
        addArrangedSubview(footprintView)
        
        NSLayoutConstraint.activate([

            footprintView.heightAnchor.constraint(equalTo: footprintView.widthAnchor,
                                                 multiplier: Constant.heightMultiplier)
        ])
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension FoliageTypeInspector {
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case septominoPopUp:
            
            let septomino = viewModel.septomino(at: sender.indexOfSelectedItem)
            
            viewModel.select(septomino: septomino)
            
            footprintView.footprint = septomino.footprint(origin: .zero)
            
        default: break
        }
    }
}
