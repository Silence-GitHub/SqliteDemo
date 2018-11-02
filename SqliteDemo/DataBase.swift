//
//  DataBase.swift
//  SqliteDemo
//
//  Created by Kaibo Lu on 2018/10/19.
//  Copyright © 2018年 Kaibo Lu. All rights reserved.
//

import UIKit
import SQLite3

class DataBase {

    private var db: OpaquePointer?
    
    func open() {
        guard let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        let path = "\(dirPath)/Person.db"
        if sqlite3_open(path, &db) == SQLITE_OK { // sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil)
            print("Open success")
        } else {
            print("Open fail")
        }
    }
    
    func createTable() {
        let sql = "CREATE TABLE IF NOT EXISTS Student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, score real DEFAULT 0, sex text DEFAULT 'Unknown');"
        var error: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, sql, nil, nil, &error) == SQLITE_OK {
            print("Create table success")
        } else {
            print("Create table fail, error: \(String(cString: error!))")
        }
    }
    
    func insert(students: [Student]) {
        var sql = ""
        for student in students {
            sql.append("INSERT INTO Student (name, score, sex) VALUES ('\(student.name)', \(student.score), '\(student.sex)');") // Use "INSERT OR REPLACE INTO ..." to replace data if same primary key
        }
        var error: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, sql, nil, nil, &error) == SQLITE_OK { // sqlite3_exec = (sqlite3_prepare_v2, sqlite3_step, sqlite3_finalize)
            print("Insert data success")
        } else {
            print("Insert data fail, error: \(String(cString: error!))")
        }
    }
    
    func update(score: Double, forName name: String) {
        let sql = "UPDATE Student SET score = \(score) WHERE name = '\(name)';"
        var error: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, sql, nil, nil, &error) == SQLITE_OK {
            print("Update data success")
        } else {
            print("Update data fail, error: \(String(cString: error!))")
        }
    }
    
    func update2(score: Double, forName name: String) {
        let sql = "UPDATE Student SET score = ?1 WHERE name = ?2;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_double(stmt, 1, score)
            sqlite3_bind_text(stmt, 2, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Update data success")
            } else {
                print("Update data fail")
            }
            sqlite3_finalize(stmt)
        } else {
            print("Update data fail")
        }
    }
    
    func selectAll() {
        let sql = "SELECT id, name, score, sex FROM Student;" // If add condition: WHERE score > 70 AND sex = 'Male'
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            print("Select data success")
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id = sqlite3_column_int(stmt, 0)
                let name = String(cString: sqlite3_column_text(stmt, 1))
                let score = sqlite3_column_double(stmt, 2)
                let sex = String(cString: sqlite3_column_text(stmt, 3))
                print("id: \(id); name: \(name); score: \(score); sex: \(sex);)")
            }
            sqlite3_finalize(stmt)
        } else {
            print("Select data fail")
        }
    }
    
    func delete() {
        let sql = "DELETE FROM Student;" // If add condition: WHERE score < 60 AND/OR ...
        var error: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, sql, nil, nil, &error) == SQLITE_OK {
            print("Delete success")
        } else {
            print("Delete fail, error: \(String(cString: error!))")
        }
    }
    
    func close() {
        if let currentDB = db {
            if sqlite3_close(currentDB) == SQLITE_OK {
                db = nil
                print("Close success")
            } else {
                print("Close fail")
            }
        }
    }
}

struct Student {
    let name: String
    let score: Double
    let sex: String
}
