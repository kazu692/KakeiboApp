//
//  CoreDataManager.swift
//  KakeiboApp
//
//  Created by 山口和也 on 2025/06/03. // 今日日付を更新
//

import CoreData
import Foundation

class CoreDataManager {
    // シングルトンパターン: アプリ全体でCoreDataManagerのインスタンスは一つだけにする
    static let shared = CoreDataManager()

    // NSPersistentContainer: Core Dataスタック全体を管理する主要なオブジェクト
    // モデルファイル名 (KakeiboAppModel.xcdatamodeld) と一致させる
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "KakeiboAppModel") // ★ここをData Modelファイル名に合わせる★
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                // エラーハンドリング: ここで詳細なエラーをログに出力するとデバッグに役立つ
                fatalError("Core Dataストアのロードに失敗しました: \(error.localizedDescription)\n\(error)")
            }
            print("DEBUG: Core Dataストアが正常にロードされました。")
        }
    }

    // MARK: - Core Data Saving support

    // 現在のManagedObjectContextを返すプロパティ
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // データ変更を永続化するメソッド
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges { // 変更がある場合のみ保存
            do {
                try context.save()
                print("DEBUG: Core Dataコンテキストが保存されました。")
            } catch {
                // エラーが発生した場合
                let nsError = error as NSError
                fatalError("Core Dataコンテキストの保存に失敗しました: \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - Generic Fetching (汎用的なデータ取得)

    // 指定されたエンティティ名でデータを取得する汎用メソッド
    func fetch<T: NSManagedObject>(_ entityName: String, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            let objects = try context.fetch(fetchRequest)
            print("DEBUG: Core Dataから \(objects.count) 件の \(entityName) を取得しました。")
            return objects
        } catch {
            print("ERROR: Core Dataからのデータ取得に失敗しました: \(error.localizedDescription)")
            return []
        }
    }
}
