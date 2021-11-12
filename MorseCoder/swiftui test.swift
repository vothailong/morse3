
import SwiftUI
//import RealmSwift



struct KeyBoardListView: View {
    weak var delegate: MorseKeyboardViewDelegate?
    let items = [ """
This goes
over multiple
sdfdsfsdfsdfsdfenddfdafsf
lines
sdjhfkjh
"""
                  ,"abc","skdfkfdj","def"]
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    var body: some View {
        
        
        VStack
        {
            GeneralList(verticalSpacing: 1) {
                ForEach(items, id: \.self)  { item in
                    
                    HStack {
                        Text(item).onTapGesture {
                            delegate?.insertString(item)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
                    .border(Color.gray, width: 1)
                    .font(.footnote)
                    .lineLimit(4)
                    .removeSeparator()
                    
                }  .listRowInsets( EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4) )//default: 8 ?
            }
            .environment(\.defaultMinListRowHeight, 0)// default : 8?
            .listStyle(GroupedListStyle())//remove padding of the entire list
            //.listRowBackground(Color.green)
            //.listSeparatorStyle(style: .none)
        }
        .edgesIgnoringSafeArea(.horizontal)
        .onAppear {
            UITableView.appearance().backgroundColor = .blue
            UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Double.leastNonzeroMagnitude))
            UITableView.appearance().showsVerticalScrollIndicator = false
            
            //UITableViewCell.appearance().selectionStyle = .none
        }
        
      
        
    }
}




@available(iOS 14.0, *)
struct RowSeparatorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.listRowSeparator(.hidden)//iOS 15+
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
        
        return KeyBoardListView()
    }
}
