//
//  DBManager.swift
//  SQLiteList
//
//  Created by Macbook on 29/05/2022.
//

import Foundation
import UIKit
import SQLite3

class DBManager {
    
    // Singelton Logic
    static var shared = DBManager()
  
     private let fileURL : URL? = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("test1.sqlite")
    
    
    // Disallow Any Class Create New Instance From DBManager
    private init() {
        
    }


    //connect to database using the path
     func openDatabase() -> OpaquePointer? {
        let part1DbPath = fileURL?.path
        var db: OpaquePointer?
        guard let partDbPath = part1DbPath else {
            print("partDbPath is nil.")
            return nil
        }
        if sqlite3_open(partDbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(partDbPath)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }
    
    
    // Created our table
    func createTable() {
        let createTableString = """
        create table Movies(
        name char(255) primary key not null,
        image char(255)
        )
        """
        // 1
        var createTableStatement: OpaquePointer?
        // 2
        if sqlite3_prepare_v2(DBManager.shared.openDatabase(), createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nmovies table created.")
            } else {
                print("\nmovies table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
   
    //Insert data
    func insertData(name: NSString, image: NSString) {
        let insertStatementString = "INSERT INTO movies (Name, Image) VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(DBManager.shared.openDatabase(), insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
           
            // 2
            sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
            // 3
            sqlite3_bind_text(insertStatement, 2, image.utf8String, -1, nil)
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
  

    func query() {
        
        let queryStatementString = "SELECT * FROM Movies;"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(DBManager.shared.openDatabase(), queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            // 2
            //  We can use if, and retrieve the first element.
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3

                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 0) else {
                    print("Query result is nil")
                    return
                }
                
                // 4
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return
                }
                
                let name  = String(cString: queryResultCol1)
                let image = String(cString: queryResultCol2)
                let object = Movie.init(movieName: name, movieImage: image)
                print(object)
                ArrayManager.moviesData.append(object)
                print("\nQuery Result:")
                print("\(name) | \(image)")
            }
            
            //        else {
            //            print("\nQuery returned no results.")
            //        }
        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(DBManager.shared.openDatabase()))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
    }

   
    //delete Data
    func delete(movie:NSString) {
        
        let deleteStatementString = "DELETE FROM Movies WHERE Name = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(DBManager.shared.openDatabase(), deleteStatementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            
            sqlite3_bind_text(deleteStatement, 1, movie.utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
                
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    
    
}
