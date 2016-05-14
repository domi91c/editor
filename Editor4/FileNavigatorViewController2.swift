//
//  FileNavigatorViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/20.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EonilToolbox

private enum ColumnID: String {
    case Name
}

final class FileNavigatorViewController: RenderableViewController, DriverAccessible, WorkspaceAccessible {

    private let scrollView = NSScrollView()
    private let outlineView = NSOutlineView()
    private let nameColumn = NSTableColumn(identifier: ColumnID.Name.rawValue)
    private var installer = ViewInstaller()

    private var sourceFilesVersion: Version?
    private var proxyMapping = [FileID2: FileUIProxy2]()
    private var rootProxy: FileUIProxy2?

    var workspaceID: WorkspaceID? {
        didSet {
            render()
        }
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        renderLayout()
    }
    override func render() {
        renderLayout()
        renderStates()
    }
    private func renderLayout() {
        installer.installIfNeeded {
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.redColor().CGColor

            view.addSubview(scrollView)
            scrollView.documentView = outlineView
            outlineView.addTableColumn(nameColumn)
            outlineView.outlineTableColumn = nameColumn
            outlineView.headerView = nil
            outlineView.rowSizeStyle = .Small
            outlineView.setDataSource(self)
            outlineView.setDelegate(self)
        }
        scrollView.frame = view.bounds

    }
    private func renderStates() {
        guard sourceFilesVersion != workspaceState?.files.version else { return }
        if let workspaceState = workspaceState {
            let oldMappingCopy = proxyMapping
            proxyMapping = [:]
            for (fileID, fileState) in workspaceState.files {
                proxyMapping[fileID] = oldMappingCopy[fileID]?.renewSourceFileState(fileState) ?? FileUIProxy2(sourceFileID: fileID, sourceFileState: fileState)
            }
            rootProxy = proxyMapping[workspaceState.files.rootID]
        }
        else {
            proxyMapping = [:]
        }
        sourceFilesVersion = workspaceState?.files.version
        outlineView.reloadData()
    }

    private func scanSelection() {
        guard let workspaceID = workspaceID else { return reportErrorToDevelopers("Missing `FileNavigatorViewController.workspaceID`.") }
        guard let workspaceState = workspaceState else { return }
        var selectedItemPaths = [FileNodePath]()
        for rowIndex in outlineView.selectedRowIndexes {
            guard let proxy = outlineView.itemAtRow(rowIndex) as? FileUIProxy2 else { continue }
            let path = workspaceState.files.resolvePathFor(proxy.sourceFileID)
            selectedItemPaths.append(path)
        }
        dispatch(.Workspace(id: workspaceID, action: .File(.SelectNodes(selectedItemPaths))))
    }
}
extension FileNavigatorViewController: NSOutlineViewDataSource {
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return true
    }
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            // Root nodes.
            guard rootProxy != nil else { return 0 }
            return 1
        }
        else {
            guard let proxy = item as? FileUIProxy2 else { return 0 }
            return proxy.sourceFileState.subfileIDs.count
        }
    }
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            // Root nodes.
            assert(rootProxy != nil)
            guard let rootProxy = rootProxy else { fatalError() }
            return rootProxy
        }
        else {
            guard let proxy = item as? FileUIProxy2 else { return 0 }
            let subfileID = proxy.sourceFileState.subfileIDs[index]
            guard let childProxy = proxyMapping[subfileID] else { fatalError() }
            return childProxy
        }
    }
    func outlineView(outlineView: NSOutlineView, heightOfRowByItem item: AnyObject) -> CGFloat {
        return 16
    }
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        guard let proxy = item as? FileUIProxy2 else { return nil }

        let imageView = NSImageView()
        let textField = NSTextField()
        let cell = NSTableCellView()
        cell.addSubview(imageView)
        cell.addSubview(textField)
        cell.imageView = imageView
        cell.textField = textField
//        imageView.image = NSWorkspace.sharedWorkspace().iconForFile(<#T##fullPath: String##String#>)
        textField.bordered = false
        textField.drawsBackground = false
//        textField.stringValue = proxy.sourceState?.name ?? ""
        textField.stringValue = proxy.sourceFileState.name

        return cell
    }
}
extension FileNavigatorViewController: NSOutlineViewDelegate {
    func outlineViewSelectionDidChange(notification: NSNotification) {
        scanSelection()
    }
}















private final class FileUIProxy2 {
    let sourceFileID: FileID2
    var sourceFileState: FileState2
    init(sourceFileID: FileID2, sourceFileState: FileState2) {
        self.sourceFileID = sourceFileID
        self.sourceFileState = sourceFileState
    }
    func renewSourceFileState(sourceFileState: FileState2) -> FileUIProxy2 {
        self.sourceFileState = sourceFileState
        return self
    }
}

//extension FileNode: IdentifiableType {
//    func identify() -> String {
//        return state.name
//    }
//}
//private final class RootFileNodeUIProxy: FileNodeUIProxy {
//    var changedProxies = [FileNodeUIProxy]()
//    private override func notifyChangeOfNode(node: FileNodeUIProxy) {
//        changedProxies.append(node)
//    }
//}
//private class FileNodeUIProxy: SynchronizableElementType, IdentifiableType, DefaultInitializableType {
//    typealias SourceType = FileNode
//    weak var parentProxy: FileNodeUIProxy?
//    var sourcePath: FileNodePath?
//    var sourceVersion: Version?
//    var sourceState: FileNodeState?
//    var sourceSubnodesVersion: Version?
//    var proxySubnodeManager = ArraySynchronizationManager<FileNodeUIProxy>()
//
//    private func identify() -> String {
//        return sourceState?.name ?? ""
//    }
//    func syncFrom(source: FileNode) {
//        guard sourceVersion != source.version else { return } //< No-op for same version.
//        sourceState = source.state
//        proxySubnodeManager.syncFrom(source.subnodes)
//        for subproxy in proxySubnodeManager.array {
//            subproxy.parentProxy = self
//            if let subproxyName = subproxy.sourceState?.name {
//                subproxy.sourcePath = sourcePath?.appendingLastPathComponent(subproxyName)
//            }
//            else {
//                subproxy.sourcePath = nil
//            }
//        }
//        sourceVersion = source.version
//    }
//    func notifyChangeOfNode(node: FileNodeUIProxy) {
//        if parentProxy != nil {
//            parentProxy?.notifyChangeOfNode(node)
//        }
//    }
//}























