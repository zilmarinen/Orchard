//
//  WorldEditorViewController.swift
//  Feature
//
//  Created by Zack Brown on 13/05/2026.
//

import AppKit
import Base

internal protocol WorldEditorViewDelegate: AnyObject {
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   click button: MouseButton,
                                   location: CGPoint)
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   hover location: CGPoint)
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   magnify magnification: Double)
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   pan button: MouseButton,
                                   location: CGPoint,
                                   translation: CGPoint)
}

internal class WorldEditorViewController: NSViewController {
    
    // MARK: Gesture Recognisers
    
    private lazy var leftClickGestureRecognizer = with(NSClickGestureRecognizer(target: self,
                                                                                action: #selector(clickGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.left.rawValue
    }
    
    private lazy var rightClickGestureRecognizer = with(NSClickGestureRecognizer(target: self,
                                                                                 action: #selector(clickGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.right.rawValue
    }
    
    private lazy var panGestureRecognizer = with(NSPanGestureRecognizer(target: self,
                                                                        action: #selector(panGestureRecognizer(_:)))) {
        
        $0.buttonMask = MouseButton.both.rawValue
    }
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldEditorViewDelegate?
    
    internal init(viewModel: WorldViewModel,
                  delegate: WorldEditorViewDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(viewModel.editorView)
        
        viewModel.editorView.pinEdges(to: view)
        
        viewModel.editorView.gestureRecognizers = [leftClickGestureRecognizer,
                                                   rightClickGestureRecognizer,
                                                   panGestureRecognizer]
    }
    
    public override func viewDidLayout() {
        
        super.viewDidLayout()
        
        viewModel.editorView.trackingAreas.forEach {
            
            viewModel.editorView.removeTrackingArea($0)
        }
        
        viewModel.editorView.addTrackingArea(.init(rect: viewModel.editorView.frame,
                                                   options: [.activeInKeyWindow,
                                                             .mouseMoved],
                                                   owner: self))
    }
    
    // MARK: Mouse Moved

    public override func mouseMoved(with event: NSEvent) {

        super.mouseMoved(with: event)
        
        delegate?.worldEditorViewController(self,
                                            hover: viewModel.location(event.locationInWindow))
    }
    
    // MARK: Scroll

    public override func scrollWheel(with event: NSEvent) {

        super.scrollWheel(with: event)
        
        delegate?.worldEditorViewController(self,
                                            magnify: event.scrollingDeltaY)
    }
}

extension WorldEditorViewController {
    
    // MARK: Click Gesture
    
    @objc
    private func clickGestureRecognizer(_ sender: NSClickGestureRecognizer) {
        
        let button: MouseButton = sender == leftClickGestureRecognizer ? .left : .right
        
        delegate?.worldEditorViewController(self,
                                            click: button,
                                            location: sender.location(in: view))
    }
    
    // MARK: Pan Gesture
    
    @objc
    private func panGestureRecognizer(_ sender: NSPanGestureRecognizer) {
        
        guard let button = MouseButton(rawValue: sender.buttonMask) else { return }
        
        let translation = sender.translation(in: view)
        let location = sender.location(in: view)
        let origin = location - translation
        
        delegate?.worldEditorViewController(self,
                                            pan: button,
                                            location: origin,
                                            translation: translation)
    }
}
