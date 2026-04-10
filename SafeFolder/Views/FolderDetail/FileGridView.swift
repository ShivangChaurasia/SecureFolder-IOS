import SwiftUI

struct FileGridView: View {
    @ObservedObject var viewModel: FolderDetailViewModel
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 16)]
    
    var body: some View {
        if viewModel.files.isEmpty {
            VStack {
                Spacer()
                Text("No files yet")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            }
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.files) { file in
                        FileThumbnailView(
                            file: file,
                            fileURL: viewModel.getFileURL(for: file)
                        )
                    }
                }
                .padding()
            }
        }
    }
}
