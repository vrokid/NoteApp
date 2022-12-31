//
//  NewNoteViewController.swift
//  NoteApp
//
//  Created by vro kid on 30.12.2022.
//

import UIKit

protocol AddNoteProtocol {
    func addNewNote(title: String, body: String)
    func updateOrDeleteTheNote(body: String?, indexPath: IndexPath)
}

class NewNoteViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var textView: UITextView!
    
    var delegate: AddNoteProtocol?
    
    var oldText: String?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.becomeFirstResponder()
        if let text = oldText {
            self.textView.text = text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("saving the note")
        if oldText == nil {
            if textView.text.count != 0 {
                self.delegate?.addNewNote(title: "random", body: textView.text)
            }
        } else {
            if textView.text.count != 0 {
                self.delegate?.updateOrDeleteTheNote(body: textView.text, indexPath: indexPath!)
            } else {
                self.delegate?.updateOrDeleteTheNote(body: nil, indexPath: indexPath!)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
