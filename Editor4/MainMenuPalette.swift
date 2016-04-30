//
//  MainMenuPalette.swift
//  Editor4
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct MainMenuPalette {
    // Keep menu item identifier length < 64.
    let file                            =	submenuContainerWithTitle(.File)
    let fileNew                         =	submenuContainerWithTitle(.FileNew)
    let fileNewWorkspace                =	menuItemWithAction(.FileNewWorkspace)
    let fileNewFolder                   =	menuItemWithAction(.FileNewFolder)
    let fileNewFile                     =	menuItemWithAction(.FileNewFile)
    let fileOpen                        =	submenuContainerWithTitle(.FileOpen)
    let fileOpenWorkspace               =	menuItemWithAction(.FileOpenWorkspace)
    let fileOpenClearWorkspaceHistory	=	menuItemWithAction(.FileOpenClearWorkspaceHistory)
    let fileCloseFile                   =	menuItemWithAction(.FileCloseFile)
    let fileCloseWorkspace              =	menuItemWithAction(.FileCloseWorkspace)
    let fileDelete                      =	menuItemWithAction(.FileDelete)
    let fileShowInFinder                =	menuItemWithAction(.FileShowInFinder)
    let fileShowInTerminal              =	menuItemWithAction(.FileShowInTerminal)

    let view                            =	submenuContainerWithTitle(.View)
    let viewEditor                      =	menuItemWithAction(.ViewEditor)
    let viewNavigators                  =	submenuContainerWithTitle(.ViewShowNavigator)
    let viewShowProjectNavigator        =	menuItemWithAction(.ViewShowProjectNavigator)
    let viewShowIssueNavigator          =	menuItemWithAction(.ViewShowIssueNavigator)
    let viewShowDebugNavigator          =	menuItemWithAction(.ViewShowDebugNavigator)
    let viewHideNavigator               =	menuItemWithAction(.ViewHideNavigator)
    let viewConsole                     =	menuItemWithAction(.ViewConsole)
    let viewFullScreen                  =	menuItemWithAction(.ViewFullScreen)

    let editor                          =	submenuContainerWithTitle(.Editor)
    let editorShowCompletions           =	menuItemWithAction(.EditorShowCompletions)

    let product                         =	submenuContainerWithTitle(.Product)
    let productRun                      =	menuItemWithAction(.ProductRun)
    let productBuild                    =	menuItemWithAction(.ProductBuild)
    let productClean                    =	menuItemWithAction(.ProductClean)
    let productStop                     =	menuItemWithAction(.ProductStop)

    let debug                           =	submenuContainerWithTitle(.Debug)
    let debugPause                      =	menuItemWithAction(.DebugPause)
    let debugResume                     =	menuItemWithAction(.DebugResume)
    let debugHalt                       =	menuItemWithAction(.DebugHalt)

    let debugStepInto                   =	menuItemWithAction(.DebugStepInto)
    let debugStepOut                    =	menuItemWithAction(.DebugStepOut)
    let debugStepOver                   =	menuItemWithAction(.DebugStepOver)

    let debugClearConsole               =	menuItemWithAction(.DebugClearConsole)

    init() {
        file.subcontrollers = ([
            fileNew,
            fileOpen,
            MainMenuItemController(type: .Separator),
            fileCloseFile,
            fileCloseWorkspace,
            MainMenuItemController(type: .Separator),
            fileDelete,
            fileShowInFinder,
            fileShowInTerminal,
            ])
        fileNew.subcontrollers = ([
            fileNewWorkspace,
            fileNewFile,
            fileNewFolder,
            ])
        fileOpen.subcontrollers = ([
            fileOpenWorkspace,
            fileOpenClearWorkspaceHistory,
            ])

        view.subcontrollers = ([
            viewEditor,
            viewNavigators,
            viewConsole,
            MainMenuItemController(type: .Separator),
            viewFullScreen,
            ])
        viewNavigators.subcontrollers = ([
            viewShowProjectNavigator,
            viewShowIssueNavigator,
            viewShowDebugNavigator,
            MainMenuItemController(type: .Separator),
            viewHideNavigator,
            ])

        editor.subcontrollers = ([
            editorShowCompletions,
            ])

        product.subcontrollers = ([
            productRun,
            productBuild,
            productClean,
            MainMenuItemController(type: .Separator),
            productStop,
            ])

        debug.subcontrollers = ([
            debugPause,
            debugResume,
            debugHalt,
            MainMenuItemController(type: .Separator),
            debugStepInto,
            debugStepOut,
            debugStepOver,
            MainMenuItemController(type: .Separator),
            debugClearConsole,
            ])
    }
    func topLevelMenuItemControllers() -> [MainMenuItemController] {
        return [file, view, editor, product, debug]
    }
}





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private func seprator() -> MainMenuItemController {
    return MainMenuItemController(type: .Separator)
}
private func submenuContainerWithTitle(id: MainMenuSubmenuID) -> MainMenuItemController {
    return MainMenuItemController(type: .Submenu(id))
}
private func menuItemWithAction(action: MainMenuAction) -> MainMenuItemController {
    return MainMenuItemController(type: .MenuItem(action: action))
}
































