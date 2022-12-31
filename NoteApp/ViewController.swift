//
//  ViewController.swift
//  NoteApp
//
//  Created by vro kid on 29.12.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, AddNoteProtocol {
    
    var tableView: UITableView = UITableView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes: [NoteModel] = []
    
    func fetchNotes() {
        do {
            self.notes = try context.fetch(NoteModel.fetchRequest())
            self.tableView.reloadData()
        }
        catch {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchNotes()
        addDefaultNoteIfNeeded()
        self.navigationController?.navigationBar.topItem?.title = "Ваши заметки"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Добавить", style: .done, target: self, action: #selector(addNote(sender:)))
    }
    
    func addDefaultNoteIfNeeded() {
        if self.notes.count == 0 {
            addNewNote(title: "", body: "Привет, это ваша первая заметка")
        }
    }
    
    func updateOrDeleteTheNote(body: String?, indexPath: IndexPath) {
        let note = notes[indexPath.row]
        if let body = body {
            note.body = body
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.fetchNotes()
        } else {
            self.context.delete(note)
            
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            tableView.beginUpdates()
            do {
                self.notes = try context.fetch(NoteModel.fetchRequest())
            }
            catch { }
            
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    func addNewNote(title: String, body: String) {
        let newNote = NoteModel(context: context)
        newNote.title = title
        newNote.body = body
        do {
            try self.context.save()
        }
        catch {
            
        }
        self.fetchNotes()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.tableView.register(UINib.init(nibName: "NoteListTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc private func addNote(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "newNoteSegue", sender: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteListTableViewCell", for: indexPath) as! NoteListTableViewCell
        cell.textBody.text = self.notes[indexPath.row].body
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToDelete = self.notes[indexPath.row]
            
            self.context.delete(noteToDelete)
            
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            tableView.beginUpdates()
            do {
                self.notes = try context.fetch(NoteModel.fetchRequest())
            }
            catch { }
            
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "newNoteSegue", sender: indexPath)
//        self.navigationController?.performSegue(withIdentifier: "newNoteSegue", sender: nil)
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newNoteSegue" {
            print("hello")
            let secondView = segue.destination as! NewNoteViewController
            secondView.delegate = self
            if let indexPath = sender as? IndexPath {
                secondView.oldText = self.notes[indexPath.row].body
                secondView.indexPath = indexPath
            }
        }
    }
}

