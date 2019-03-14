//
//  Model.swift
//  MyNotes
//
//  Created by admin on 15.01.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

// Массив для работы с базой (передаются значения из CoreData).
var note: [Notes] = []

// Задаем переменную для подсчета всех пришедших уведомлений когда приложение на заднем плане.
var badgeCount = 0

// Создаем идентификатор, по которому будет определятся конкретная категория действий.
let userAction = "User Action"

var userDeletedNotification = false

// Создаем переменную идентификатор для хранения в ней тела записки как идентификатор
var localNotificationIdentifier:String?

// Создаем переменную appDelegate для переиспользования в проекте.
let appDelegate = UIApplication.shared.delegate as? AppDelegate

// Функция по изменению состояния (выполненно / не выполненного задание) присваевается противоположное значение от предыдущего.
func changeState(at item: Int) -> Bool{
    note[item].noteCompletedOrNot = !(note[item].noteCompletedOrNot)
    return note[item].noteCompletedOrNot
}

func addNotificationContent(noteClass: NoteClass) -> UNMutableNotificationContent{
    let content = UNMutableNotificationContent()
    
    content.title = "Remind you of..."
    content.body = "\(noteClass.noteText!)"
    content.sound = UNNotificationSound.default()
    
    badgeCount += 1
    localNotificationIdentifier = noteClass.noteText
    
    content.badge = badgeCount as NSNumber
    
    // Включаем соответствующую категорию в контент.
    content.categoryIdentifier = userAction
    
    guard let path = Bundle.main.path(forResource: "general_noAlpha", ofType: "png") else { fatalError("Еhe path specified is not correct")}
    let url = URL(fileURLWithPath: path)
    do{
        let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
        content.attachments = [attachment]
    }catch{
        print("The attachmetn could not by loaded")
    }
    
    return content
}

func getTimeInterval(noteClass: NoteClass) -> NSDate{
    
    // Присавеваем дату заданного пользователем уведомления.
    var date = noteClass.noteTimeRemind
    
    // Определяем интервал от начальной даты до пользовательской.
    let timeInterval = date?.timeIntervalSinceReferenceDate
    
    // Присваиваем дате интервал до назначенной даты.
    date = NSDate(timeIntervalSinceReferenceDate: timeInterval!) as Date
    
    return date! as NSDate
}

func getTriggerCalendarDate(_ date: NSDate) -> UNCalendarNotificationTrigger{
    
    // Создаем триггер даты на основе календаря.
    let triggerDate = Calendar.current.dateComponents([.year,.month, .day, .hour, .minute, .second], from: date as Date)
    
    // Создаем триггер который не будет повторятся
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    
    return trigger
}


// Функция выводит сообщение если текстовое не введено пользователем
func textFieldIsEmpty() -> UIAlertController{
    
    // Добавил локализацию ошибки.
    let ooops = NSLocalizedString("Ooops", comment: "Error if text field is empty")
    let ok = NSLocalizedString("OK", comment: "Button name")
    let noteTitleIsEmpty = NSLocalizedString("You dont added note title", comment: "Note title is empty")
    
    // Если поле оказалось пустым или nil, выводим сообщение о том что пользователь не ввел значение
    let alertController = UIAlertController(title: ooops, message: noteTitleIsEmpty, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: ok, style: .default, handler: nil))
    
    return alertController
}

