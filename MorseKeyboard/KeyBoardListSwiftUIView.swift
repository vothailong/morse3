/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import RealmSwift

struct ListItem: Identifiable {
    let id = UUID()
    let name: String
}

struct KeyBoardListView: View {
    
    @State var lastpasteboardString: String?
    var clipItems: Results<Item>?
    var selectedCategory: Category?
    @State var controller : CategoryViewController
    //    let realm: Realm?
    init(controller: CategoryViewController) {
        self.controller = controller
        
        if let cats = controller.loadCategories(){
            selectedCategory = cats.first
            if let selectedCategory = selectedCategory, selectedCategory.items.count > 0 {
                clipItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: false)
            }
        } else {
            controller.createDefaultCategory()
        }
        
        
        
    }
    var body: some View {
        
        VStack {
            if clipItems?.count ?? 0 > 0 {
                List(clipItems!) { item in
                    Text(item.content)
                }.onAppear {
                    addClipboardItemToDB()
                }
            } else {
                List {
                    Text("no item yet")
                }
            }
        }
    }
    
    func addClipboardItemToDB() {
        let pasteboardString: String? = UIPasteboard.general.string
        guard let   theString = pasteboardString, let selectedCategory = selectedCategory else { return  }
        lastpasteboardString = clipItems?.first?.content
        
        if  theString == lastpasteboardString {
            print(lastpasteboardString != nil ? "duplicated value:\(theString)" : "no value to show")
        }
        else   {
            lastpasteboardString = theString
            print("String is \(theString)")
            // Put the string into your search bar and do the search
            let newItem = Item()
            newItem.content = theString
            newItem.dateCreated = Date()
            controller.addItemToCategory(item: newItem, cat: selectedCategory)
        }
        
        loadItems()
    }
    
    func loadItems() {
        //toDoItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: true)
        //        guard let toDoItems = toDoItems else {
        //            return
        //        }
        
        print(  "==============\nNEXT")
        for (index, element) in clipItems!.enumerated() {
            print(  "\(index+1)=====\(element.content)")
        }
        //        tableView.reloadData()
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyBoardListView()
//    }
//}
//
