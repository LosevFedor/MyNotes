//
//  NoteClass.swift
//  MyNotes
//
//  Created by admin on 12.02.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


class NoteClass {
    
    var noteText:String?
    var noteUUID: String?
    var noteCopletedOrNo:Bool
    var noteTimeRemind:Date?
    
    
    // Пользователь решил не добавлять уведомление.
    init(noteText: String?, noteUUID: String, noteCopletedOrNo:Bool) {
        self.noteText = noteText
        self.noteUUID = noteUUID
        self.noteCopletedOrNo = noteCopletedOrNo
    }
    
    // Пользователь решил добавить уведомление
    init(noteText: String?, noteUUID: String, noteCopletedOrNo:Bool, noteTimeRemind:Date?) {
        self.noteText = noteText
        self.noteUUID = noteUUID
        self.noteCopletedOrNo = noteCopletedOrNo
        self.noteTimeRemind = noteTimeRemind
    }
    
    
    
    
}
