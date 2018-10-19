//
//  ViewController.swift
//  SqliteDemo
//
//  Created by Kaibo Lu on 2018/10/19.
//  Copyright © 2018年 Kaibo Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func clickButton() {
        let db = DataBase()
        db.open()
        db.createTable()
        
        db.insert(students: [Student(name: "Sam", score: 80, sex: "Male"),
                             Student(name: "Tom", score: 70, sex: "Variable"),
                             Student(name: "Susan", score: 75.5, sex: "Female")])
        
        db.selectAll()
        
        db.update(score: 65, forName: "Susan")
        
        db.selectAll()
        
        db.update2(score: 66, forName: "Susan")
        
        db.selectAll()
        
        db.delete()
        
        db.close()
    }
}

