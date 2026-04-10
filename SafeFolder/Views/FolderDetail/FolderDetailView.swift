import SwiftUI

struct FolderDetailView: View {
    let folder: Folder
    @StateObject private var viewModel: FolderDetailViewModel
    
    @State private var showingActionSheet = false
    @State private var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case camera, photoLibrary, documents
        var id: Int { hashValue }
    }
    
    init(folder: Folder) {
        self.folder = folder
        _viewModel = StateObject(wrappedValue: FolderDetailViewModel(folder: folder))
    }
    
    var body: some View {
        VStack {
            if folder.isSecure && !viewModel.isAuthenticated {
                AuthenticationView(folder: folder) {
                    viewModel.isAuthenticated = true
                    viewModel.loadFiles()
                }
            } else {
                FileGridView(viewModel: viewModel)
            }
        }
        .navigationTitle(folder.name)
        .onAppear {
            viewModel.authenticateIfNeeded()
        }
        .toolbar {
            if viewModel.isAuthenticated {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingActionSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .confirmationDialog("Add File", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("Camera") { activeSheet = .camera }
            Button("Photo Library") { activeSheet = .photoLibrary }
            Button("Files") { activeSheet = .documents }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
            case .camera:
                ImagePicker(sourceType: .camera) { image in
                    viewModel.addImageFile(image)
                }
            case .photoLibrary:
                ImagePicker(sourceType: .photoLibrary) { image in
                    viewModel.addImageFile(image)
                }
            case .documents:
                DocumentPicker { url in
                    viewModel.addDocumentFile(from: url)
                }
            }
        }
    }
}
