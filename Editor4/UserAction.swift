//
//  Action.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL

/// Declares atomic action for UI state.
///
/// Action definitions can be nested to provide:
/// - Semantic locality
/// - Common contextual parameter
///
/// Each action must be atomically transactional.
/// Which means final result after applying the action
/// must produce consistent state.
///
enum UserAction {
    /// The first action to activate driver.
    case Reset
    case Test(TestAction)
    case Shell(ShellAction)
    case Workspace(WorkspaceID, WorkspaceAction)
    case Notify(Notification)
}
enum TestAction {
    case Test1
    case Test2CreateWorkspaceAt(NSURL)
}
enum ShellAction {
    case Quit
    case Alert(ErrorType)
    case RunCreatingWorkspaceDialogue
    case RunOpeningWorkspaceDialogue
//    case NewWorkspace(NSURL)
//    case OpenWorkspace(NSURL)
}
/// Actions about a workspace.
///
enum WorkspaceAction {
    case File(FileAction)
    case Editor(EditorAction)
    //        case FileNode(path: WorkspaceItemPath, FileNodeAction)
    //        case FileNodeList(paths: [WorkspaceItemPath], FileNodeAction)
    case Build(BuildAction)
    case Debug(DebugAction)
}

enum FileAction {
    /// Creates a new folder at index in the specified container
    /// and put it under editing state.
    case CreateFolderAndStartEditingName(container: FileID2, index: Int, name: String)
    /// Creates a new file at index in the specified container
    /// and put it under editing state.
    case CreateFileAndStartEditingName(container: FileID2, index: Int, name: String)
    case StartEditingCurrentFileName
    case DeleteAllCurrentOrSelectedFiles
    case DeleteFiles(Set<FileID2>)
    case Reconfigure(FileID2, FileState2)
    case Drop(from: [NSURL], onto: FileNodePath)
    case Move(from: [FileNodePath], onto: FileNodePath)
//    case EditTree(id: FileNodeID, action: FileTreeEditAction)
    case SetHighlightedFile(FileID2?)
    case SetSelectedFiles(current: FileID2, items: TemporalLazyCollection<FileID2>)
    case Rename(FileID2, newName: String)
}

enum FileActionError: ErrorType {
    case BadFileNodePath(FileNodePath)
    case BadFileNodeIndex
}
//enum FileTreeEditAction {
//}
//enum FileNodeAction {
//        case Select
//        case Deselect
//        case Delete
//}
enum EditorAction {
    case Open(NSURL)
    case Save
    case Close
    case TextEditor(TextEditorAction)
}
enum TextEditorAction {
}
enum AutocompletionAction {
    case ShowCandidates
    case HideCandidates
    case ReconfigureCandidates(expression: String)
}
enum BuildAction {
    case Clean
    case Build
}
enum DebugAction {
    case Launch
    case Halt
    case Pause
    case Resume
    case StepInto
    case StepOver
    case StepOut
    case SelectStackFrame(index: Int)
    case DeselectStackFrame
//        case SelectSlotVariable(index: Int)
//        case DeselectSlotVariable
    case PrintSlotVariable(index: Int)
}








