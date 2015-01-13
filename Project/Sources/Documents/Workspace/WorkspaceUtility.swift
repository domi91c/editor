//
//  WorkspaceUtility.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import PrecompilationOfExternalToolSupport

struct WorkspaceUtility {
	///	Returns URL to newly created config data file if everything is OK.
	///	Otherwise, `nil`.
	static func createNewWorkspaceAtURL(desiredWorkspaceRootURL:NSURL) -> NSURL? {
		assert(desiredWorkspaceRootURL.existingAsAnyFile == false)
		
		let	desiredWorkspaceName	=	desiredWorkspaceRootURL.lastPathComponent!
		let	configDataFileName		=	desiredWorkspaceName.stringByAppendingPathExtension(".eew")!
		let	configDataFileURL		=	desiredWorkspaceRootURL.URLByAppendingPathComponent(configDataFileName, isDirectory: false)
		let	parentDirURL			=	desiredWorkspaceRootURL.URLByDeletingLastPathComponent!
		
		//	`cargo` will create a directory for the URL.
		CargoExecutionController.create(parentDirURL, name: desiredWorkspaceName)
		
		if desiredWorkspaceRootURL.existingAsDirectoryFile {
			let	ok2	=	NSData().writeToURL(configDataFileURL, atomically: true)
			if ok2 {
				return	configDataFileURL
			}
		}
		return	nil
	}
	
//	///	Returns `true` if everything is OK.
//	///	Otherwise, `false`.
//	static func createNewWorkspaceAtURL(desiredWorkspaceRootURL:NSURL) -> Bool {
//		assert(desiredWorkspaceRootURL.existingAsAnyFile == false)
//		
//		let	desiredWorkspaceName	=	desiredWorkspaceRootURL.lastPathComponent!
//		let	configDataFileURL		=	desiredWorkspaceRootURL.URLByAppendingPathComponent(desiredWorkspaceName, isDirectory: false)
//		
//		let	ok1	=	NSFileManager.defaultManager().createDirectoryAtURL(desiredWorkspaceRootURL, withIntermediateDirectories: true, attributes: nil, error: nil)
//		let	ok2	=	NSData().writeToURL(configDataFileURL, atomically: true)
//		
//		if ok1 && ok2 {
//			CargoExecutionController.create(desiredWorkspaceRootURL)
//			return	true
//		} else {
//			return	false
//		}
//	}
	
	
	private init() {
	}
}