//
//  ChatsTableViewController.swift
//  Messenger
//
//  Created by wajih on 9/2/22.
//

import UIKit

class ChatsTableViewController: UITableViewController {
    
    //MARK: - Vars
    var allRecents : [RecentChat] = []
    var filtredRecents : [RecentChat] = []

    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        downloadRecentChats()
        setupSearchController()
    }
    //MARK: - IBActions

    @IBAction func composeBarButtonPressed(_ sender: Any) {
        let userView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersView") as! UsersTableViewController
        navigationController?.pushViewController(userView, animated: true)
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filtredRecents.count :  allRecents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentTableViewCell

        // Configure the cell...
        let recent = searchController.isActive ? filtredRecents[indexPath.row]:allRecents[indexPath.row]
        cell.configure(recent: recent)
        return cell
    }
    
    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recent = searchController.isActive ? filtredRecents[indexPath.row]:allRecents[indexPath.row]
        FirebaseRecentListener.shared.clearUnreadCounter(recent: recent)
        goToChat(recent:recent)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recent = searchController.isActive ? filtredRecents[indexPath.row]:allRecents[indexPath.row]
            FirebaseRecentListener.shared.deleteRecent(recent)
            searchController.isActive ? self.filtredRecents.remove(at: indexPath.row) : self.allRecents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    //MARK: - Download chats
    private func downloadRecentChats(){
        FirebaseRecentListener.shared.downloadRecentChatsFromFireStore { allchats in
            self.allRecents = allchats
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Navigations
    func goToChat(recent:RecentChat){
        //we need to make sure we have tow recents one for us and one for the other user
        restartChat(chatRoomId: recent.chatRoomId, membersIds: recent.memberIds)
        let privateChatView = ChatViewController(chatId: recent.chatRoomId, recipientId: recent.receiverId, recipientName: recent.receiverName)
        navigationController?.pushViewController(privateChatView, animated: true)
    }
    
    //MARK: - setupSearchController
    private func setupSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func filtredContentForSearchText(searchText: String){
        filtredRecents = allRecents.filter({ recent -> Bool in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
extension ChatsTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filtredContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}
