//
//  CommonView.swift
//  Editor3
//
//  Created by Hoon H. on 2016/01/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Provides a common feature set for a view.
/// -	Always uses layer.
class CommonView: NSView {
    private var supercallChecked = false
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		super.wantsLayer = true
		assert(layer is TransparentLayer)
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		super.wantsLayer = true
		assert(layer is TransparentLayer)
	}

	func sizeThatFits(size: CGSize) -> CGSize {
		return size
	}
	func sizeToFit() {
		frame.size	=	sizeThatFits(frame.size)
	}
	/// `setNeedsDisplayInRect(bounds)`.
	func setNeedsDisplay() {
		setNeedsDisplayInRect(bounds)
        supercallChecked = true
	}
    func layoutSubviews() {
        supercallChecked = true
    }

	// MARK: -
	override func makeBackingLayer() -> CALayer {
		return TransparentLayer()
	}
	@available(*, unavailable)
	override var wantsLayer: Bool {
		get {
			return super.wantsLayer
		}
		set {
			assert(newValue == true, "This class always use a layer, so you cannot set this property to `false`.")
			super.wantsLayer = newValue
		}
	}
	override var layer: CALayer? {
		get {
			return super.layer
		}
		set {
			assert(newValue != nil, "This class always use a layer, so you cannot set this property to `nil`.")
			assert(newValue is TransparentLayer)
			super.layer = newValue
		}
	}

	@available(*,unavailable,message="Do not access this property youtself to avoid unwanted effect.")
	override var needsDisplay: Bool {
		didSet {
		}
	}
	override func setNeedsDisplayInRect(invalidRect: NSRect) {
		super.setNeedsDisplayInRect(invalidRect)
		guard let layer = layer else { return }
		layer.setNeedsDisplayInRect(invalidRect)
	}
//	override func resizeSubviewsWithOldSize(oldSize: NSSize) {
//		super.resizeSubviewsWithOldSize(oldSize)
//		_layout()
//	}
	override func resizeWithOldSuperviewSize(oldSize: NSSize) {
		super.resizeWithOldSuperviewSize(oldSize)
        supercallChecked = false
        layoutSubviews()
		assert(supercallChecked == true)
	}

	override func didAddSubview(subview: NSView) {
		super.didAddSubview(subview)
	}
	override func willRemoveSubview(subview: NSView) {
		super.willRemoveSubview(subview)
	}
}

























































