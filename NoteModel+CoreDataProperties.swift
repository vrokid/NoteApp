//
//  NoteModel+CoreDataProperties.swift
//  NoteApp
//
//  Created by vro kid on 30.12.2022.
//
//

import Foundation
import CoreData


extension NoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteModel> {
        return NSFetchRequest<NoteModel>(entityName: "NoteModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?

}

extension NoteModel : Identifiable {

}
