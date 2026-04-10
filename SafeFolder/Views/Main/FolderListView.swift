import SwiftUI

struct FolderListView: View {
    @StateObject private var viewModel = FolderListViewModel()
    @State private var showingCreateForm = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(viewModel.folders) { folder in
                    Button {
                        navigationPath.append(folder)
                    } label: {
                        HStack {
                            Image(systemName: folder.isSecure ? "lock.fill" : "folder.fill")
                                .foregroundColor(folder.isSecure ? .red : .blue)
                            Text(folder.name)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
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
            .navigationDestination(for: Folder.self) { folder in
                FolderDetailView(folder: folder)
            }
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
