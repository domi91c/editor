//
//  DebugState.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/14.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation.NSURL
import EonilToolbox

/// Reprents state of all debugging sessions.
///
/// This state is managed by `DebugService`. And the service notifies
/// its state to `Driver` by copy when it changes its state.
///
/// - Note:
///     A workspace can contain multiple debugging sessions.
///
struct DebugState {
    var targets = [DebugTargetID: DebugTargetState]()
}

////////////////////////////////////////////////////////////////

struct DebugTargetID: Hashable {
    private let oid = ObjectAddressID()
    var hashValue: Int {
        get { return oid.hashValue }
    }
}
func == (a: DebugTargetID, b: DebugTargetID) -> Bool {
    return a.oid == b.oid
}
struct DebugTargetState {
    private(set) var executableURL: NSURL
    var session: DebugProcessState?
}
struct DebugProcessState {
    var processID: pid_t?
//    var phase: DebugSessionPhase = .NotStarted
    var threads = Transmissive<[DebugThreadState]>.none
    var variables = Transmissive<DebugVariableState>.none
}

enum DebugProcessPhase {
    case notStarted
    case running
    case paused(DebugSessionPauseReason)
    case exited(DebugSessionExitReason)
}
enum DebugSessionPauseReason {
    case breakpoint
    case crash
    case userCommand
}
enum DebugSessionExitReason {
    case end(code: Int)
    case crash
    case userCommand
}

////////////////////////////////////////////////////////////////

struct DebugProcessID: Hashable {
    var hashValue: Int {
        get { MARK_unimplemented(); fatalError() }
    }
}
func ==(a: DebugProcessID, b: DebugProcessID) -> Bool {
    MARK_unimplemented()
    return false
}

//struct DebugThreadID: Hashable {
//    var hashValue: Int {
//        get { MARK_unimplemented(); fatalError() }
//    }
//}
//func ==(a: DebugThreadID, b: DebugThreadID) -> Bool {
//    MARK_unimplemented()
//    return false
//}

struct DebugThreadState {
    var callStackFrames = [DebugCallStackFrameState]()
}

//struct DebugCallStackID: Hashable {
//    var hashValue: Int {
//        get { MARK_unimplemented(); fatalError() }
//    }
//}
//func ==(a: DebugCallStackID, b: DebugCallStackID) -> Bool {
//
//}
struct DebugCallStackFrameState {
    var functionName: String
}

////////////////////////////////////////////////////////////////

struct DebugVariableState {
    var name: String
    var type: String
    var value: String
    var subvariables = Progressive<(), [DebugVariableState]>.none
}

//enum DebugVariableLazySubvariables {
//    case Unresolved
//    case Resolved([DebugVariableState])
//}
//enum DebugVariableType {
//
//}
//enum DebugVariableValue {
//    case
//}


















