//
//  UserInteractionRenderer.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import AppKit

/// Manages view-part.
///
/// Driver will call `render` method after finishing mutation of
/// state, and the state won't be changed until rendering finishes.
/// Even they dispatch some actions, the actions will be queued, 
/// and will not be applied immediately.
/// So, all view components are guaranteed to access same state in
/// a rendering session.
///
final class UserInteractionRenderer: DriverAccessible {

    private let mainMenu: MainMenuController
    private let workspaceManager: WorkspaceManager

    init() {
        NSAppearance.setCurrentAppearance(NSAppearance(named: NSAppearanceNameVibrantDark))
        mainMenu = MainMenuController()
        workspaceManager = WorkspaceManager()
    }

    func scan() {
        workspaceManager.scan()
    }
    func render(state: UserInteractionState) {
        mainMenu.render(state)
        workspaceManager.render(state)
        assertProperUIConfigurations()
    }
    func alert(error: ErrorType) {
//        let error = error ?? NSError(domain: "", code: -1, userInfo: [:]) // TODO: Configure error parameters properly.
        NSApplication.sharedApplication().presentError(error as NSError)
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import ObjectiveC

private var discoveredViewIDsInAssertion = Set<ObjectIdentifier>()
private extension UserInteractionRenderer {
    func assertProperUIConfigurations() {
        discoveredViewIDsInAssertion = []
        for document in NSDocumentController.sharedDocumentController().documents {
            for windowController in document.windowControllers {
                windowController.assertProperUIConfigurationsRecursively()
            }
        }
        for workspaceWindowController in workspaceManager.ADHOC_allWindows {
            workspaceWindowController.assertProperUIConfigurationsRecursively()
        }
        debugLog("Total view count: \(discoveredViewIDsInAssertion.count)")
    }
}

private extension NSWindowController {
    private func assertProperUIConfigurationsRecursively() {
        assertProperUIConfigurations()
        contentViewController?.assertProperUIConfigurationsRecursively()
        window?.assertProperUIConfigurationsRecursively()
    }
}
private extension NSViewController {
    private func assertProperUIConfigurationsRecursively() {
        assertProperUIConfigurations()
        for child in childViewControllers {
            child.assertProperUIConfigurationsRecursively()
        }
        view.assertProperUIConfigurationsRecursively()
    }
}
private extension NSWindow {
    private func assertProperUIConfigurationsRecursively() {
        assertProperUIConfigurations()
        contentViewController?.assertProperUIConfigurationsRecursively()
        contentView?.assertProperUIConfigurationsRecursively()
    }
}
private extension NSView {
    private func assertProperUIConfigurationsRecursively() {
        assertProperUIConfigurations()
        for subview in subviews {
            subview.assertProperUIConfigurationsRecursively()
        }
    }
}

private extension NSWindowController {
    private func assertProperUIConfigurations() {
    }
}
private extension NSViewController {
    private func assertProperUIConfigurations() {
    }
}
private extension NSWindow {
    private func assertProperUIConfigurations() {
    }
}
private extension NSView {
    private func assertProperUIConfigurations() {
//        assert(shouldSkipCheck() || autoresizesSubviews == false, "Auto-resizing is not allowed.")
//        assert(shouldSkipCheck() || autoresizingMask == [], "Auto-resizing must be turned-off.")
        assert(shouldSkipCheck() || translatesAutoresizingMaskIntoConstraints == false, "Auto-layout must be turned off.")
        assert(shouldSkipCheck() || containsAnyNonSystemContraint() == false, "Auto-layout constraint is not allowed.")
        discoveredViewIDsInAssertion.insert(ObjectIdentifier(self))
    }
    private func containsAnyNonSystemContraint() -> Bool {
        for c in constraints {
            if NSStringFromClass(c.dynamicType) == "NSContentSizeLayoutConstraint" {
                continue
            }
            return true
        }
        return false
    }
    private func shouldSkipCheck() -> Bool {
        return  isWindowContentView()
        ||      isKVOSubclassOfAppKitViewMadeByAppleCode()
        ||      isAppKitViewMadeByAppleCode()
        ||      hasAnySkippableAncestorClass()
    }
    private func isWindowContentView() -> Bool {
        return window?.contentView === self
    }
    private func hasAnySkippableAncestorClass() -> Bool {
        let skippableAncestorClasses = [
            NSOutlineView.self,
        ]
        var c: AnyClass? = self.dynamicType
        while let c1 = c {
            if skippableAncestorClasses.contains({ c1 == $0 }) { return true }
            c = class_getSuperclass(c1)
        }
        return false
    }
    private func isKVOSubclassOfAppKitViewMadeByAppleCode() -> Bool {
        let PREFIX = "NSKVONotifying_"
        let n = NSStringFromClass(self.dynamicType)
        guard n.hasPrefix(PREFIX) else { return false }
        let n1 = n.substringFromIndex(PREFIX.endIndex)
        guard let c1 = NSClassFromString(n1) else { return false }
        guard NSBundle(forClass: c1).bundleIdentifier == "com.apple.AppKit" else { return false }
        return true
    }
    private func isAppKitViewMadeByAppleCode() -> Bool {
        guard NSBundle(forClass: self.dynamicType).bundleIdentifier == "com.apple.AppKit" else { return false }
        return true
    }
}


private enum SuperClassKind {
    case exactlyNSView
    case exactlyNSOutlineView
    case exactlyNSSplitView
    case directSubclassOfNSView
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// MARK: -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//private typealias Cast = () -> ()
////private var observerTable = [(id: ObjectIdentifier, cast: Cast, deregisteredWhileBroadcasting: Bool)]()
//private var allObservers = [ObjectIdentifier: Cast]()
//private var allObserverDebuggingDescriptions = [ObjectIdentifier: String]()
//private var isBroadcasting = false
//private var registeredObserversWhileBroadcasting = [(id: ObjectIdentifier, cast: Cast, debugInfo: String)]()
//private var deregisteredObserversWhileBroadcasting = [ObjectIdentifier]()
//extension Shell {
//    /// Broadcasts rendering signal to all registered components.
//    ///
//    /// Why do we need this where we can call `render` method cascadely?
//    /// *Cascade* means nesting. Cascaded action routing can be broken at
//    /// anytime by missing routing link. This can happen easily because
//    /// program changes over time. And for each time it happens, we need
//    /// to search for them, and it's a huge cost. Flat is better than
//    /// nesting.
//    ///
//    /// So, `Shell` broadcasts actions to interested parties. I mean,
//    /// components. Each components must register themselves to shell to
//    /// get guaranteed action notification without concerning intermediate
//    /// routing links, so they can trigger rendering themselves.
//    ///
//    /// Actually this is mainly because of nested structure of AppKit
//    /// views. For UI architecture that keeps every views in flat space
//    /// wouldn't need this kind of trick.
//    ///
//    /// Thankfully, we employ immutable state tree sequence architecture,
//    /// the state is guaranteed not to be changed in broadcasting an action.
//    /// You can dispatch another action in broadcasting, and they will be
//    /// processed just like dispatched another actions --- asynchronously.
//    ///
//    /// ## Design Intensions
//    ///
//    /// This broadcasting facility is strictly only for UI part --- shell.
//    /// So, it's limited to be used in main thread only.
//    ///
//    private static func broadcast() {
//        assertMainThread()
//        isBroadcasting = true
//        for (id, cast) in allObservers {
//            guard deregisteredObserversWhileBroadcasting.contains(id) == false else { continue }
//            cast()
//        }
//        isBroadcasting = false
//        // Observers deregistered in broadcasting will not be called
//        // because they are already dead, so they cannot process anything.
//        while let last = deregisteredObserversWhileBroadcasting.popLast() {
//            allObservers[last] = nil
//            allObserverDebuggingDescriptions[last] = nil
//        }
//        // Observers registered in broadcasting will not be called
//        // because it may
//        while let last = registeredObserversWhileBroadcasting.popLast() {
//            allObservers[last.id] = last.cast
//            allObserverDebuggingDescriptions[last.id] = last.debugInfo
//        }
//    }
//    static func register<T: AnyObject where T: Renderable>(observer: T) {
//        assertMainThread()
//        register(observer, observer.dynamicType.render)
//    }
//    static func register<T: AnyObject>(observer: T, _ handler: T -> () -> ()) {
//        assertMainThread()
//        let id = ObjectIdentifier(observer)
//        let cast = { [weak observer] in
//            guard let observer = observer else {
//                let debugDescription = allObserverDebuggingDescriptions[id] ?? "????"
//                reportErrorToDevelopers("An observer has been dead without deregistering it from shell broadcasting. (\(debugDescription))")
//                return
//            }
//            handler(observer)()
//        }
//        let debugInfo = "\(observer)"
//
//        if isBroadcasting {
//            registeredObserversWhileBroadcasting.append((id, cast, debugInfo))
//        }
//        else {
//            allObserverDebuggingDescriptions[id] = "\(observer)"
//            allObservers[id] = cast
//        }
//    }
//    static func deregister<T: AnyObject>(observer: T) {
//        assertMainThread()
//        let id = ObjectIdentifier(observer)
//        if isBroadcasting {
//            deregisteredObserversWhileBroadcasting.append(id)
//        }
//        else {
//            allObservers[id] = nil
//            allObserverDebuggingDescriptions[id] = nil
//        }
//    }
//
//}











