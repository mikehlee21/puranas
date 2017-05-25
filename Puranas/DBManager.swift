//
//  DBManager.swift
//  PocketWatch
//
//  Created by Ghost on 16/3/2017.
//
//

import Foundation

private var _manager : DBManager? = nil
class DBManager
{
    static func getInstance() -> DBManager
    {
        if _manager == nil
        {
            _manager = DBManager()
        }
        return _manager!
    }
    
    var database : OpaquePointer? = nil
    
    init()
    {
        
    }
    
    func openDB()
    {
        let result = sqlite3_open(dataFilePath(), &database)
        
        if result != SQLITE_OK
        {
            sqlite3_close(database)
            print("Failed to Open Database")
            return
        }
    }
    
    func dataFilePath() -> String
    {
        /*
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        var url : String? = ""
        
        do{
            try url = urls.first?.appendingPathComponent(Const.dbPath).path
        }
        catch{
            print("Error is \(error)")
        }
        
        return url!
 */
        
        let path = Bundle.main.path(forResource: "Veda-Vyasa", ofType: "sqlite")!
        return path
        //return Const.dbPath
    }
    
    func loadSeriesData() -> [Series]
    {
        //open db
        openDB()
        
        //reads all data
        let query = "SELECT seriesName, seriesImage, seriesType, volumes, lang FROM \(Const.seriesTable)"
        var statement : OpaquePointer? = nil
        
        var res : [Series] = []
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let temp = Series()
                temp.name = String.init(cString: sqlite3_column_text(statement, 0)!)
                temp.image = String.init(cString: sqlite3_column_text(statement, 1)!)
                temp.type = String.init(cString: sqlite3_column_text(statement, 2)!)
                temp.volumes = Int(sqlite3_column_int(statement, 3))
                temp.lang = String.init(cString: sqlite3_column_text(statement, 4)!)
                
                res.append(temp)
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return res
    }
    
    func loadBooksData() -> [Book]
    {
        //open db
        openDB()
        
        //reads all data
        let query = "SELECT bookName, bookImage, seriesName, volumeNo, lang FROM \(Const.booksTable)"
        var statement : OpaquePointer? = nil
        
        var res : [Book] = []
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let temp = Book()
                temp.name = String.init(cString: sqlite3_column_text(statement, 0)!)
                //temp.image = String.init(cString: sqlite3_column_text(statement, 1)!)
                temp.seriesName = String.init(cString: sqlite3_column_text(statement, 2)!)
                temp.volumeNo = Int(sqlite3_column_int(statement, 3))
                temp.lang = String.init(cString: sqlite3_column_text(statement, 4)!)
                
                res.append(temp)
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return res
    }
    
    func loadBookContData() -> [BookCont]
    {
        //open db
        openDB()
        
        //reads all data
        let query = "SELECT volumeNo, cantoNo, chapterNo, contentID, uvacha, content, translation lang FROM \(Const.bookContTable)"
        var statement : OpaquePointer? = nil
        
        var res : [BookCont] = []
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let temp = BookCont()
                
                temp.volumeNo = Int(sqlite3_column_int(statement, 0))
                temp.cantoNo = Int(sqlite3_column_int(statement, 1))
                temp.chapterNo = Int(sqlite3_column_int(statement, 2))
                temp.contentID = Int(sqlite3_column_int(statement, 3))
                temp.uvacha = String.init(cString: sqlite3_column_text(statement, 4)!)
                temp.content = String.init(cString: sqlite3_column_text(statement, 5)!)
                
                let column_type = sqlite3_column_type(statement, 6)
                
                if column_type == Const.COLUMN_NULL
                {
                    temp.translation = nil
                }
                else
                {
                    temp.translation = String.init(cString: sqlite3_column_text(statement, 6))
                }
                
                res.append(temp)
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return res
    }

    
    /*
    func addReceipt(receipt : Receipt)
    {
        openDB()
        
        
        let query = "INSERT INTO FIELDS (AMOUNT, CATEGORY, PATH, TIMESTAMP, YEAR, MONTH, DAY) " + "VALUES (?, ?, ?, ?, ?, ?, ?);"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_double(statement, 1, receipt.amount)
            sqlite3_bind_int(statement, 2, Int32(receipt.category))
            sqlite3_bind_text(statement, 3, receipt.path, -1, nil)
            sqlite3_bind_text(statement, 4, receipt.timestamp, -1, nil)
            sqlite3_bind_int(statement, 5, Int32(receipt.year))
            sqlite3_bind_int(statement, 6, Int32(receipt.month))
            sqlite3_bind_int(statement, 7, Int32(receipt.day))
            
        }
        if sqlite3_step(statement) != SQLITE_DONE
        {
            print("Error inserting receipt")
            sqlite3_close(database)
            return
        }
        sqlite3_finalize(statement)
 

        sqlite3_close(database)
    }
 */
}
