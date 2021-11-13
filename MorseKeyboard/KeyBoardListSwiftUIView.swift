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


class ClipboardSOT: ObservableObject {
    var lastpasteboardString: String?
    @Published var clipItems: Results<Item>?
    @Published var selectedCategory: Category?
    var categoryService : CategoryViewController
    init(controller: CategoryViewController) {
        self.categoryService = controller
        
        if let cats = controller.loadCategories(){
            selectedCategory = cats.first
            if let selectedCategory = selectedCategory, selectedCategory.items.count > 0 {
                clipItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: false)
            }
        } else {
            controller.createDefaultCategory()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addClipboardItemToDB),
                                               name: NSNotification.Name.UIPasteboardChanged , object: nil)
        addClipboardItemToDB()
        
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
    }
    
    
    //    @objc  func clipboardChanged(){
    //        let pasteboardString: String? = UIPasteboard.general.string
    //        if let theString = pasteboardString {
    //            print("String is \(theString)")
    //            // Put the string into your search bar and do the search
    //        }
    //    }
    func removeItemFromDB(item: Item) {
        categoryService.removeItemFromCategory(item: item, cat: selectedCategory!)
        
    }
    @objc func addClipboardItemToDB() {
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
            categoryService.addItemToCategory(item: newItem, cat: selectedCategory)
            //    clipItems = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: false)//no need, because of LIVE updating in Realm
            loadItems()
        }
        
        
    }
    
    func loadItems() {
        
        print(  "==============\nNEXT")
        for (index, element) in clipItems!.enumerated() {
            print(  "\(index+1)=====\(element.content)")
        }
        //        tableView.reloadData()
    }
}

struct KeyBoardListView: View {
    @ObservedObject var sot: ClipboardSOT
    weak var delegate: MorseKeyboardViewDelegate?
    @State private var previousIndex : Int? = nil
    var body: some View {
        
        ScrollViewReader { proxy in
            VStack {
                if sot.clipItems?.count ?? 0 > 0 {
                    GeneralList(verticalSpacing: 1) {
                        ForEach(sot.clipItems!)  { item in
                            HStack {
                                Text(item.content).onTapGesture {
                                    delegate?.insertString(item.content)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 4)
                            .border(Color.gray, width: 1)
                            .font(.footnote)
                            .lineLimit(4)
                            .removeSeparator()
                        }
                        .onDelete { offsets in
                            //  sot.clipItems?.remove(atOffsets: offsets)
                            //    self.previousIndex = offsets.first
                            // print("previous=\(String(describing: previousIndex))")
                            if let index = offsets.first , let item =  sot.clipItems?[index] {
                                sot.removeItemFromDB(item: item)
                            }
                        }
                    }
                    .onChange(of: previousIndex) { (e: Equatable) in
                        //  proxy.scrollTo(previousIndex!+2, anchor: .top)
                        //                        proxy.scrollTo(3, anchor: .top) // will display 1st cell
                    }
                    .listRowInsets( EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4) )//default: 8 ?
                    
                    .environment(\.defaultMinListRowHeight, 0)// default : 8?
                    .listStyle(GroupedListStyle())//remove padding of the entire list
                } else {
                    List {
                        Text("no item yet")
                    }
                }
            }
        }
        //.edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            UITableView.appearance().backgroundColor = .blue
            UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            UITableView.appearance().showsVerticalScrollIndicator = false
            
            //UITableViewCell.appearance().selectionStyle = .none
        }
        
        
        
        
        
    }
    
    
}

struct RowSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOSApplicationExtension 15.0, *) {
            content
                .listRowSeparator(.hidden)
        } else {
            content
        }
    }
}
extension View {
    func removeSeparator() -> some View {
        modifier(RowSeparatorModifier())
    }
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let sot = ClipboardSOT(controller: CategoryViewController ())
        return KeyBoardListView(sot: sot,delegate: nil)
    }
}
