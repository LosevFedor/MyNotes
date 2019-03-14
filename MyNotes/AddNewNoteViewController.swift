//
//  AddNewNoteViewController.swift
//  MyNotes
//
//  Created by admin on 14.01.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class AddNewNoteViewController: UIViewController {

    var note: Notes!

    // Переменная будет принимать в себя текстовое поле который введет пользователь.
    var text: String?
    
    @IBOutlet var addTextForNote: UITextField!
    @IBOutlet var promptUserToAddReminders: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавляю локаль для Placeholder текстового поля
        addTextForNote.placeholder = NSLocalizedString("Write your note...", comment: "Placeholder text field")
        
        // Добавляю локаль подсказки о добавлении напоминания
        promptUserToAddReminders.text = NSLocalizedString("If you need remind you need press that button...", comment: "Thes is hint wil help  user will understand what him need to do if hi want add reminder")
        
        // Локализую название страници AddNewNoteViewController
        navigationItem.title = NSLocalizedString("Add new note", comment: "Name of page where user add new note")
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Сохраняем контент в базу.
    @IBAction func saveData(_ sender: Any) {
        
        // Добавляю локаль к ошибке пользователь не добавил напоминание.
      let reminderOff = NSLocalizedString("Reminder Off", comment: "Remind will not aded")
        // Добавляю локаль ошибки в теле пользователь не добавил напоминание.
      let youDidNotAddReminder = NSLocalizedString("You didn't add reminder", comment: "User don't added reminder")
        
        // Добавляю локаль к ошибке игнорирует добавление напоминание.
      let noThanks = NSLocalizedString("No thanks", comment: "If user dont want to add reminder him need pres to the button")
        
        // Добавляю локаль к ошибке пользователь добавить напоминание.
      let addReminder = NSLocalizedString("Add reminder", comment: "If user want to add reminder him need pres to the button")
        // Переменная принимает в сетя занчение текстового поля.
        text = addTextForNote.text
        
        // Проверка введенного значениея на пустоту
        if text != nil && text != "" {
            
            // Создаем сообщение о том что потльзователь создал запись без добавления напоминания
            let alertContriller = UIAlertController(title: reminderOff, message: youDidNotAddReminder, preferredStyle: .alert)
            
            // Добавляем кнопку НЕ добавлять напоминание.
            alertContriller.addAction(UIAlertAction(title: noThanks, style: .default, handler: { (action) in
                
                // Создаем уникальный идентификатор сообщения.
                let uuid = UUID().uuidString
                
                let noteClass = NoteClass(noteText: self.addTextForNote.text, noteUUID: uuid, noteCopletedOrNo: false)
                
                // Сохраняем занчения в базу.
                self.saveParemetersToDate(noteClass: noteClass)
                
                // Возвращаемся на главную страницу после сохранения данных.
                self.navigationController?.popViewController(animated: true)

            }))
            
            // Создаем кнопку с добавлением напоминания
            alertContriller.addAction(UIAlertAction(title: addReminder, style: .cancel, handler: { (action) in
            
                // Создаем "связь" для перехода к AddRemindViewController по Storyboard ID.
                let сontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addReminderStoryboard") as? AddRemindViewController

                // Передаем полю из AddRemindViewController поле addTextForNote.
                сontroller?.oldNoteText = self.addTextForNote.text!
                
                // Переходим из AddNewNoteViewController в AddRemindViewController.
                self.navigationController?.pushViewController(сontroller!, animated: true)

            }))

            // Вывод окна сообщения
            present(alertContriller, animated: true, completion: nil)
        }
        else{
            
            // Задаем параметры выводимого контента.
            let alertController = textFieldIsEmpty()
            
            // Вывод сообщения.
            self.present(alertController, animated: true, completion: nil)

        }
    }
    
    // Функция отвечает за сохранение данных в CoreData
    func saveParemetersToDate(noteClass: NoteClass){

        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
            note = NSManagedObject(entity: entity!, insertInto: context) as! Notes

            note.textNote = noteClass.noteText
            note.noteCompletedOrNot = noteClass.noteCopletedOrNo
            note.uuid = noteClass.noteUUID
            
            do{
                try context.save()
                print("save datas")
            }catch{
                print("Failed save datas")
                
            }
        }
    }
    
    @IBAction func addRemindTime(_ sender: Any) {
        
        // Переменная принимает в сетя занчение текстового поля.
        text = addTextForNote.text
        
        // Проверка введенного значениея на пустоту.
        if text == nil || text == "" {
            
            // Задаем параметры выводимого контента.
            let alertController = textFieldIsEmpty()
            
            // Выводим сообщение
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // При попытке нажать на addRemindTime пробуем передать параметры в AddRemindViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Проверяем идентификатор по которому передаем параметры.
        if segue.identifier == "addReminderAndNote"{
            
            // Задаем контроллер для управления данными в AddRemindViewController.
            let controller = segue.destination as! AddRemindViewController
            
            // Присваеваем полю из AddRemindViewController новое знвчение.
            controller.oldNoteText = addTextForNote.text!
        }
    }
    
    // При нажатии на кнопку возвращает в на предыдущий VC.
    @IBAction func stepBack(_ segue: UIStoryboardSegue){
        
    }

}
