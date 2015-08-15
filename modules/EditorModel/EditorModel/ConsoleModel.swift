//
//  ConsoleModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public class ConsoleModel: ModelSubnode<WorkspaceModel> {

	public var workspace: WorkspaceModel {
		get {
			assert(owner != nil)
			return	owner!
		}
	}

	///
	
	public var outputLines: ArrayStorage<String> {
		get {
			return	_outputLines
		}
	}
	public func appendLine(line: String) {
		fatalErrorBecauseUnimplementedYet()
	}
	public func appendLines(lines: String) {
		fatalErrorBecauseUnimplementedYet()
	}

	///

	private let	_outputLines	=	MutableArrayStorage<String>([])
}
