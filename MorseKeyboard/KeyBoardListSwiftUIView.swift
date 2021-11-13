
import SwiftUI



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
//                        .onChange(of: previousIndex) { (e: Equatable) in
//                            //  proxy.scrollTo(previousIndex!+2, anchor: .top)
//                            //                        proxy.scrollTo(3, anchor: .top) // will display 1st cell
//                        }
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
            UITableView.appearance().backgroundColor = .clear
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
