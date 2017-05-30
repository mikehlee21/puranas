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
        //        NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //        NSString* dbPath = [docPath stringByAppendingPathComponent:@"test.sqlite"];
        //        NSFileManager *fm = [NSFileManager defaultManager];
        //
        //        // Check if the database is existed.
        //        if(![fm fileExistsAtPath:dbPath])
        //        {
        //            // If database is not existed, copy from the database template in the bundle
        //            NSString* dbTemplatePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"sqlite"];
        //            NSError* error = nil;
        //            [fm copyItemAtPath:dbTemplatePath toPath:dbPath error:&error];
        //            if(error){
        //                NSLog(@"can't copy db.");
        //            }
        //        }
        
        var docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        docPath.append("/" + Const.dbName + ".sqlite")
        
        let fm = FileManager.default
        
        if fm.fileExists(atPath: docPath) == false
        {
            let templatePath = Bundle.main.path(forResource: Const.dbName, ofType: "sqlite")
            
            let content = NSData(contentsOfFile: templatePath!)
            
            let result = fm.createFile(atPath: docPath, contents: content as Data?, attributes: nil)
            
            if result == false
            {
                print("Failed to Copy sqlite content")
            }
            
        }
        
        return docPath
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
        let query = "SELECT bookName, bookImage, seriesName, volumeNo, lang, bookId FROM \(Const.booksTable)"
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
                temp.bookId = String.init(cString: sqlite3_column_text(statement, 5)!)
                
                res.append(temp)
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return res
    }
    
    func loadBookContData(_ bookId: String) -> [BookCont]
    {
        //open db
        openDB()
        
        //reads all data
        let query = "SELECT volumeNo, cantoNo, chapterNo, contentId, uvacha, content, translation FROM \(Const.bookContTable) WHERE bookId = '" + bookId + "'"
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
                temp.contentId = Int(sqlite3_column_int(statement, 3))
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
    
    func insertBookmark(data: CellData, startPos: Int, bmlength: Int, totalLength: Int, type: String) -> String {
        
        let storedDataArray = loadBookmark()
        var storedData = CellData()
        var isExist = false
        var highlightType = type
        
        for i in 0..<storedDataArray.count {
            let t = storedDataArray[i]
            if ((t.bookId == data.bookId) && (t.volumeNo == data.volumeNo) && (t.cantoNo == data.cantoNo) && (t.chapterNo == data.chapterNo) && (t.isCont == data.isCont) && (t.contentId == data.contentId)) {
                storedData = t
                isExist = true
                break
            }
        }
        
        var highlightData = ""
        var updateStatementString = ""
        
        if (isExist == false) {    // No bookmark yet
            for _ in 0..<totalLength {
                highlightData += "0"
            }
        }
        else {
            highlightData = storedData.highlightData
        }
        if (highlightType == "p") {
            for i in 0..<bmlength {
                if (highlightData[i+startPos] == "0") {
                    let start = highlightData.index(highlightData.startIndex, offsetBy: i + startPos);
                    let end = highlightData.index(highlightData.startIndex, offsetBy: i + startPos + 1);
                    highlightData.replaceSubrange(start..<end, with: "1")
                }
            }
        
            if highlightData.range(of: "0") == nil{
                highlightType = "f"
            }
            
            if (highlightData == storedData.highlightData) {
                for i in 0..<bmlength {
                    let start = highlightData.index(highlightData.startIndex, offsetBy: i + startPos);
                    let end = highlightData.index(highlightData.startIndex, offsetBy: i + startPos + 1);
                    highlightData.replaceSubrange(start..<end, with: "0")
                }
                highlightType = "p"
                
            }
        }
    
        if (highlightType == "f") {
            highlightData = ""
            for _ in 0..<totalLength {
                highlightData += "1"
            }
        }
        
        openDB()
        
        if (isExist == true) {
            updateStatementString = "UPDATE \(Const.userHighlightsTable) SET highlightType='" + highlightType + "', highlightData='" + highlightData + "' WHERE bookId='\(data.bookId)' AND volumeNo=\(data.volumeNo) AND cantoNo=\(data.cantoNo) AND chapterNo=\(data.chapterNo) AND isCont=\(data.isCont) AND contentID=\(data.contentId)"
        }
        else {
            updateStatementString = "INSERT INTO \(Const.userHighlightsTable) (userId,bookId,volumeNo,cantoNo,chapterNo,lastUpdeDesc,isCont,contentId,highlightType,highlightData) VALUES (0, '\(data.bookId)', \(data.volumeNo), \(data.cantoNo), \(data.chapterNo), ' ', \(data.isCont), \(data.contentId), '\(highlightType)', '\(highlightData)');"
        }
        
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_step(updateStatement)
        }
        
        sqlite3_finalize(updateStatement)
        
        sqlite3_close(database)
        
        checkEmptybookmark()
        
        return highlightData
        
    }
    
    func deleteBookmark(data: CellData) {
        
        openDB()
        
        let updateStatementString = "DELETE FROM \(Const.userHighlightsTable) WHERE bookId = '" + "\(data.bookId)" + "' AND volumeNo = \(data.volumeNo) AND cantoNo = \(data.cantoNo) AND chapterNo = \(data.chapterNo) AND isCont = \(data.isCont) AND contentId = \(data.contentId);"
        
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_step(updateStatement)
        }
        
        sqlite3_finalize(updateStatement)
        
        sqlite3_close(database)
    }
    
    func checkEmptybookmark() {
        let bmArray = loadBookmark()
        
        for i in 0..<bmArray.count {
            let temp = bmArray[i]
            if temp.highlightData.range(of: "1") == nil{
                deleteBookmark(data: temp)
            }
        }
    }
    
    func loadBookmark() -> [CellData] {
        //open db
        openDB()
        
        //reads all data
        let query = "SELECT bookId, volumeNo, cantoNo, chapterNo, isCont, contentId, highlightType, highlightData FROM \(Const.userHighlightsTable)"
        var statement : OpaquePointer? = nil
        
        var res : [CellData] = []
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let temp = CellData()
                
                temp.bookId = String.init(cString: sqlite3_column_text(statement, 0)!)
                temp.volumeNo = Int(sqlite3_column_int(statement, 1))
                temp.cantoNo = Int(sqlite3_column_int(statement, 2))
                temp.chapterNo = Int(sqlite3_column_int(statement, 3))
                temp.isCont = Int(sqlite3_column_int(statement, 4))
                temp.contentId = Int(sqlite3_column_int(statement, 5))
                temp.highlightType = String.init(cString: sqlite3_column_text(statement, 6)!)
                temp.highlightData = String.init(cString: sqlite3_column_text(statement, 7)!)
                
                res.append(temp)
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return res
    }
    
    func saveLastReadingPos(bookId: String, chapterNo: Int, contentId: Int, isCont: Int) {
        
        openDB()
        
        let prefName = "lastReadingPos.\(bookId)"
        let prefValue = "\(chapterNo)-\(contentId)-\(isCont)"
        
        let isExist = checkIfLastReadingPosExist(prefName)
        
        var updateStatementString = ""
        
        if isExist == true {
            updateStatementString = "UPDATE \(Const.userPrefTable) SET prefValue='" + prefValue + "' WHERE prefName='" + prefName + "';"
        }
        else {
            updateStatementString = "INSERT INTO \(Const.userPrefTable) (email,prefName,prefValue,lastUpdateOn,lastUpdateDesc) VALUES ('" + "ckdhrgid@outlook.com" + "', '" + prefName + "', '" + prefValue + "', NULL, NULL);"
        }
        
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_step(updateStatement)
        }
        
        sqlite3_finalize(updateStatement)
        
        sqlite3_close(database)
    }
    
    func checkIfLastReadingPosExist(_ prefName: String) -> Bool {
        let query = "SELECT prefValue FROM \(Const.userPrefTable) WHERE prefName='" + prefName + "'"
        var statement : OpaquePointer? = nil
        var cnt = 0
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                cnt += 1
            }
            
            sqlite3_finalize(statement)
        }
        
        if cnt == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func loadLastReadingPos(_ bookId: String) -> CellData {
        let ret = CellData()
        
        openDB()
        
        //reads all data
        let query = "SELECT prefName, prefValue FROM \(Const.userPrefTable)"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let t = String.init(cString: sqlite3_column_text(statement, 0)!)
                let p = String.init(cString: sqlite3_column_text(statement, 1)!)
                
                ret.bookId = t.replacingOccurrences(of: "lastReadingPos.", with: "")
                
                if (ret.bookId == bookId) {
                    let delimiter = "-"
                    let temp = p.components(separatedBy: delimiter)
                    ret.chapterNo = Int(temp[0])!
                    ret.contentId = Int(temp[1])!
                    ret.isCont = Int(temp[2])!
                }
                
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return ret
    }
    
    func getLastReadingPos() -> CellData {
        let ret = CellData()
        
        openDB()
        
        //reads all data
        let query = "SELECT prefName, prefValue FROM \(Const.userPrefTable)"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let t = String.init(cString: sqlite3_column_text(statement, 0)!)
                let p = String.init(cString: sqlite3_column_text(statement, 1)!)
                
                ret.bookId = t.replacingOccurrences(of: "lastReadingPos.", with: "")
                
                let delimiter = "-"
                let temp = p.components(separatedBy: delimiter)
                ret.chapterNo = Int(temp[0])!
                ret.contentId = Int(temp[1])!
                ret.isCont = Int(temp[2])!
                
            }
            
            sqlite3_finalize(statement)
        }
        
        //close db
        sqlite3_close(database)
        
        return ret
    }
    
    
    /*
     func updateBookContData(t: BookCont) {
     openDB()
     
     let updateStatementString = "UPDATE \(Const.bookContTable) SET isContBookmarked = \(t.isContBookmarked), isTransBookmarked = \(t.isTransBookmarked) WHERE volumeNo = \(t.volumeNo) AND cantoNo = \(t.cantoNo) AND chapterNo = \(t.chapterNo) AND contentID = \(t.contentID);"
     
     var updateStatement: OpaquePointer? = nil
     
     if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
     if sqlite3_step(updateStatement) == SQLITE_DONE {
     print("Successfully updated row.")
     } else {
     print("Could not update row.")
     }
     } else {
     print("UPDATE statement could not be prepared")
     }
     
     sqlite3_finalize(updateStatement)
     
     sqlite3_close(database)
     }
     */
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

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
