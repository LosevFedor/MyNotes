//
//  AppDelegate.swift
//  MyNotes
//
//  Created by admin on 13.01.2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


// Расширяем класс AppDelegate для того что бы уведобления приходили не только на задний но и не передний план
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // Метод выводит уведомление на передний план.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Задаем вид уведомления.
        completionHandler([.alert, .sound])
    }
    
    
    // Функция реализует действия с уведомлениями (добовляем кнопки и действия по нажатии на них).
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == localNotificationIdentifier{
            
            switch response.actionIdentifier{
            case "Open":
                print("Application is opened")
           
            default:
                print("defaulT")
                
            }
        }
        completionHandler()
    }
    
}

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, NSFetchedResultsControllerDelegate {

    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // подписка под протокол UNUserNotificationCenterDelegate обязует назначть длегат
        notificationCenter.delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow{
                print("User has declined notificatios")
            }
        }
        
        return true
    }


    // Метод задает время уведомлений.
    func scheduleNotification(noteClass:NoteClass) {
        
        // Метод создает и возвращает контент уведомления
        let content = addNotificationContent(noteClass: noteClass)
        
        // Метод возвращает интервал времени
        let date = getTimeInterval(noteClass: noteClass)
        
        let trigger = getTriggerCalendarDate(date)
        
        // Идентификатор каждого уведомления (имя уведомления).
        let identifier = noteClass.noteText
        
        // Создаем запрос на уведомление.
        let request = UNNotificationRequest(identifier: identifier!, content: content, trigger: trigger)
        
        // Передаем запрос в центр уведомлений.
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        // Создаем категории действий: открыть приложение.
        let openAction = UNNotificationAction(identifier: "Open", title: "Open app", options: [.foreground])
        
        // Инициализируем категорию.
        let category = UNNotificationCategory(identifier: userAction, actions: [openAction], intentIdentifiers: [], options: [])
        
        // Регистрируем созданную категорию в центре уведомлений.
        notificationCenter.setNotificationCategories([category])
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // При открытии приложения сбрасываем счетсик значков на иконке в 0.
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Сбрасываем общий счетчик значков в 0.
        badgeCount = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "MyNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

