//
//  NoteViewController.swift
//  NotePad
//
//  Created by 유승원 on 2022/02/06.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    var note = [Note]()
    
    var selectedCategory: Category?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        
        loadNote()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let newNote = Note(context: self.context)
        newNote.contents = noteTextView.text
        newNote.parentCategory = selectedCategory
        
        if note.isEmpty {
            note.append(newNote)
        } else {
            note[0] = newNote
        }
        
        saveNote()
    }
    
    func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = categoryPredicate
        
        do {
            note = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        if note.count != 0 {
            titleLabel.text = selectedCategory?.name
            noteTextView.text = note[0].contents!
        } else {
            titleLabel.text = selectedCategory?.name
            noteTextView.text = ""
        }
    }
    
}
