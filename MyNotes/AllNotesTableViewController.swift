//
//  AllNotesTableViewController.swift
//  MyNotes
//
//  Created by admin on 13.01.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

class AllNotesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet var labelHereYouCanAddYourNote: UILabel!
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Локализую подсказку для пользователя Here you can add your notes...
        labelHereYouCanAddYourNote.text = NSLocalizedString("Here you can add your notes...", comment: "The text explains what the user should do here")
        
        // Локализую название таблици.
        navigationItem.title = NSLocalizedString("All notes", comment: "Name of title")
        
        // Задаем цветовцю гамму tableView (Слоновая кость)
        tableView.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        
        // Создаем запрос в CoreData по имени таблици.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        // Создаем выборку по уникальному ключу uuid.
        let sortDescripor = NSSortDescriptor(key: "uuid", ascending: true)
        
        // Применяем выборку к запросу из CoreData.
        fetchRequest.sortDescriptors = [sortDescripor]
        
        
        // Создаем подключение к CoreData.
        if let context = (appDelegate)?.persistentContainer.viewContext{
            
            // Получение результатов из CoreData по запросу.
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchResultController.delegate = self 
            
            do{
                // Попытаться выполнить выборку.
                try fetchResultController.performFetch()
                
                // Присвоить результаты выборки из CoreData массиву.
                note = fetchResultController.fetchedObjects as! [Notes]
                
            }catch{
                print("Can't get datas from data")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Возврвщаем колличество строк из CoreData.
        return note.count
    }

    
    // функция отвечающая за конфигурацию действий при свайпе
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // создаем кастомное изображение для кнопки delete.
        let deleteImage = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteImage])
    }
    
    // Кастомная функция задает новый вид для кнопки удалить
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        // создаем замыкание на действие
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            note.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            
            // Если удалось подключиться к базе
            if let context = (appDelegate)?.persistentContainer.viewContext{
                
                // Запрос на удаление записи по индексу из базы
                let deleteRowToNote = self.fetchResultController.object(at: indexPath) as! Notes
                
                // Удаление записи из базы
                context.delete(deleteRowToNote)
                
                do{
                    // Попытка сохранить изменения при удалении из базы
                    try context.save()
                    print("Row was deleted")
                }
                catch{
                    print("Can not delete this is row")
                }
            }
        }
        
        // Задаем будующий вид нашей кнопки
        action.image = #imageLiteral(resourceName: "delete")
        
        return action
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .medium
        formatterDate.timeStyle = .short
        let remindYou = NSLocalizedString("Remind you", comment: "You added reminder with date")
        
        // Подключение к классу (AllNotesTableViewCell) по имени идентификатора, пля использования классовых полей.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAllNotes", for: indexPath) as! AllNotesTableViewCell

        cell.textNote.text = note[indexPath.row].textNote
        
        if note[indexPath.row].timeRemind != nil{
            cell.labelRemindNote.text = "\(remindYou) \((formatterDate.string(from: note[indexPath.row].timeRemind! as Date)))"
        }else{
            cell.labelRemindNote.text = NSLocalizedString("You did't add reminde", comment: "If user don't wanted add reminde")
        }
        
        // Создаем проверку на выполненные задания.
        if note[indexPath.row].noteCompletedOrNot == false{
            
            // Значек не выполненного задания.
            cell.imageNote.image = #imageLiteral(resourceName: "noteNotCompleted")
            
        }
        else{
            
            // Значек выполненного задания.
            cell.imageNote.image = #imageLiteral(resourceName: "noteCompleted")
        }
        
        return cell
    }
    
    // Событие: нажатая строка (выборка по индексу).
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Анимация при нажатии на строку (плавное затухание)
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let context = (appDelegate)?.persistentContainer.viewContext{

        // Выбираем строку по индексу
        let selectRow = fetchResultController.object(at: indexPath) as? Notes

        
            do{
                // Производим изменения выбронной строки
                if let changeNoteImage = selectRow{
                    
                    // Изменяем значек на противоположный noteCompletedOrNot и перезаписываем в базу
                    changeNoteImage.setValue(changeState(at: indexPath.row), forKey: "noteCompletedOrNot")
                }

                try context.save()
            }catch{
                print("Can't save new image 'changeNoteImage'")
            }
        }
    }
    

    // Функция запускается по обновлению таблици.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Функция определяет какое действие было выполненно.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // По switch передается type выбронного действия.
        switch type {
            
            // Обновить.
            case .update:
                if let _newIndexPath = newIndexPath{
                    tableView.reloadRows(at: [_newIndexPath], with: .fade)
                }
            
            // Вставить.
            case .insert:
                if let _newIndexPath = newIndexPath{
                    tableView.insertRows(at: [_newIndexPath], with: .fade)
                }
            
            // Удалить.
            case .delete:
                if let _newIndexPath = newIndexPath{
                    tableView.deleteRows(at: [_newIndexPath], with: .fade)
                }
            
            // переместить.
            case .move:
                if let _newIndexPath = newIndexPath{
                    tableView.moveRow(at: _newIndexPath, to: indexPath!)
                }
            
            default:
                // Обновить таблицу.
                tableView.reloadData()
            }
        
        // Записываем данные в массив после выполнения действия.
        note = controller.fetchedObjects as! [Notes]
    }
    
    
    // Запуск функции по завершению обновления.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBAction func back(segue: UIStoryboardSegue) {
    }
    
    

}


