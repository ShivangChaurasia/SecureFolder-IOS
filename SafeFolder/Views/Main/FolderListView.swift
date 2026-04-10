import SwiftUI

struct FolderListView: View {
    @StateObject private var viewModel = FolderListViewModel()
    @State private var showingCreateForm = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.folders) { folder in
                    NavigationLink(destination: FolderDetailView(folder: folder)) {
                        HStack {
                            Image(systemName: folder.isSecure ? "lock.fill" : "folder.fill")
                                .foregroundColor(folder.isSecure ? .red : .blue)
                            Text(folder.name)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.toggleSecurity(for: folder)
                        } label: {
                            Label(folder.isSecure ? "Make Normal" : "Make Secure", systemImage: folder.isSecure ? "lock.open" : "lock")
                        }
                        .tint(.orange)
                    }
                }
                .onDelete(perform: viewModel.deleteFolder)
            }
            .navigationTitle("Safe Folder")
            .toolbar {
                Button(action: {
                    showingCreateForm = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingCreateForm) {
                CreateFolderView(viewModel: viewModel)
            }
        }
    }
}
