//
//  AddRemindViewController.swift
//  MyNotes
//
//  Created by admin on 22.01.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddRemindViewController: UIViewController {

    @IBOutlet var labelNote: UILabel!
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var oldNoteText = ""
    var enableButton = false
    var goToStoryBoard = false
    
    var dataFormater = DateFormatter()
    var locale = NSLocale.current
    
    var note: Notes!
    
    @IBOutlet var labelRemindUserAbout: UILabel!
    @IBOutlet var labelWhenUserWillNeedToReminde: UILabel!
    @IBOutlet var labelWhenUserEndedEditHimNeedSave: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавляю локаль подсказка пользователю о чем он хочет напомнить.
        labelRemindUserAbout.text = NSLocalizedString("Remind me about...", comment: "Will help user understand about what him need to remind")
        // Добавляю локаль подсказки когда пользовате хочет получить напоминание о записи.
        labelWhenUserWillNeedToReminde.text = NSLocalizedString("When do you need to remind?", comment: "Will help user understand when he want to get notification")
        // Добавляю локалю которая объяснаяет пользователю что ему нужно сохранить измениния.
        labelWhenUserEndedEditHimNeedSave.text = NSLocalizedString("If you are finished click save...", comment: "Save all user changes to DB")
        
        // Присваиваем лэйблу значение из предыдущей страници.
        labelNote.text = oldNoteText
    
        saveButton.isEnabled = enableButton
        
        // Задаем минимальную дату меньше которой ввести нельзя.
        timePicker.date = NSDate() as Date
        timePicker.locale = NSLocale.current
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        checkDate()
    }
    
    // Проверка введения корректности даты.
    func checkDate(){
        
        if NSDate().earlierDate(timePicker.date) == timePicker.date{
            saveButton.isEnabled = enableButton
            
        }else{
            // Задаем цвет кнопки при введении корректной даты.
            saveButton.tintColor = UIColor.green
            
            // Отображаем кнопку при введенной коректной даты.
            enableButton = true
            saveButton.isEnabled = enableButton
        }
        enableButton = false
    }
    
    // Сохраняем параметры в базу данных.
    @IBAction func saveReminderAndNote(_ sender: Any) {
        let uuid = UUID().uuidString
        
        let noteClass = NoteClass(noteText: oldNoteText, noteUUID: uuid, noteCopletedOrNo: false, noteTimeRemind: timePicker.date)
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
            note = NSManagedObject(entity: entity!, insertInto: context) as! Notes
            
            
            if saveButton.isEnabled{
                note.textNote = noteClass.noteText
                note.noteCompletedOrNot = noteClass.noteCopletedOrNo
                note.timeRemind = noteClass.noteTimeRemind! as NSDate
                note.uuid = noteClass.noteUUID
                
                goToStoryBoard = true
            }
            
            do{
                try context.save()
                print("Data successfully saved")
            }catch{
                print("Can't save or text or complet or time")
            }
        }
        
        // Передаем в класса AppDelegate  объект noteClass
        appDelegate?.scheduleNotification(noteClass: noteClass)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
