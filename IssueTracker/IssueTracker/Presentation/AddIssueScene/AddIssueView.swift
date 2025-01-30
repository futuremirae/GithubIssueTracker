//
// AddIssueView.swift
// IssueTracker
//
// Created by 김미래 on 10/9/24.
//

import SwiftUI
import PhotosUI
import Combine

struct AddIssueView: View {

    @State private var cancellables = Set<AnyCancellable>()
    @State private var selectedOption = 0

    @State private var issueTitle = ""
    @State private var issueContents = ""

    @State private var isPresentingPhotoPicker = false
    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage?

    @State private var assingee = ""
    @State private var label = ""
    @State private var milestone: Int? = nil

    var dismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                VStack {
                    Picker("view", selection: $selectedOption) {
                        Text("마크다운")
                        Text("미리보기")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal, .top], 16)

                    List {
                        TitleAndBodySection(
                            issueTitle: $issueTitle,
                            issueContents: $issueContents,
                            isPresentingPhotoPicker: $isPresentingPhotoPicker,
                            pickerItem: $pickerItem
                        )
                        AdditionalInfoSection(
                            assingee: $assingee,
                            label: $label,
                            milestone: $milestone
                        )
                    }
                }
            }
        }
        .navigationBarTitle("새로운 이슈", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                dismiss?()
            }) { Text("닫기") },
            trailing: Button(action: {
                createIssue()
                dismiss?()
            }) { Text("저장") }
        )
    }
}

extension AddIssueView {

    func createIssue() {
        let newIssue = RequestIssueEntity(
            title: issueTitle,
            labels: [label],
            state: "open",
            assignees: [assingee],
            milestone: milestone,
            body: issueContents
        )

        CreateIssueUseCase(repository: IssueRepositoryImpl(issueService: IssueServiceImpl(token: Token().personalAccessToken))).execute(issue: newIssue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("success")
                case .failure(let error):
                    print("Error creating Issue: \(error.localizedDescription)")
                }}, receiveValue: {})
            .store(in: &cancellables)
    }

}

struct TitleAndBodySection: View {

    @Binding var issueTitle: String
    @Binding var issueContents: String
    @Binding var isPresentingPhotoPicker: Bool
    @Binding var pickerItem: PhotosPickerItem?

    var body: some View {
        Section {
            HStack {
                Text("제목").padding(.trailing, 30)
                TextField("이슈의 제목을 입력하세요", text: $issueTitle)
                    .autocorrectionDisabled()
            }
            VStack {
                TextWrapper(text: $issueContents, insertPhotoCallback: {
                    self.isPresentingPhotoPicker = true
                })
                .frame(minHeight: 250, maxHeight: .infinity)
                .autocorrectionDisabled()
                .sheet(isPresented: $isPresentingPhotoPicker) {
                    PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
                        VStack {
                            Image(systemName: "photo")
                            Text("사진 선택")
                                .padding()
                        }
                    }
                }
            }
        }
    }

}

struct AdditionalInfoSection: View {

    @State private var showAssigneeView = false
    @State private var showLabelView = false
    @State private var showMilestoneView = false

    @Binding var assingee: String
    @Binding var label: String
    @Binding var milestone: Int?

    @State var milestoneName = ""

    var body: some View {
        Section(header: Text("추가 정보")) {
            HStack {
                Text("담당자")
                Spacer()
                Text(assingee)
                    .foregroundStyle(.gray)
                Spacer().frame(width: 5)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }.onTapGesture {
                showAssigneeView = true
            }.sheet(isPresented: $showAssigneeView) {
                UIKitViewController(viewController: AssigneeSelectionViewBuilder().build())
            }.onReceive(NotificationCenter.default.publisher(for: .addAssignee)) { notification in
                if let user = notification.object as? UserEntity {
                    self.assingee = user.login
                }
            }

            HStack {
                Text("레이블")
                Spacer()
                Text(label)
                    .foregroundStyle(.gray)
                Spacer().frame(width: 5)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }.onTapGesture {
                showLabelView = true
            }.sheet(isPresented: $showLabelView) {
                UIKitViewController(viewController: LabelSelectionViewBuilder().build())
            }.onReceive(NotificationCenter.default.publisher(for: .addLabel)) { notification in
                if let label = notification.object as? LabelEntity {
                    self.label = label.name
                }
            }

            HStack {
                Text("마일스톤")
                Spacer()
                Text(milestoneName)
                    .foregroundStyle(.gray)
                Spacer().frame(width: 5)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }.onTapGesture {
                showMilestoneView = true
            }.sheet(isPresented: $showMilestoneView) {
                UIKitViewController(viewController: MilestoneSelectionViewBuilder().build())
            }.onReceive(NotificationCenter.default.publisher(for: .addMilestone)) { notification in
                if let milestone = notification.object as? MilestoneEntity {
                    self.milestone = milestone.number
                    self.milestoneName = milestone.title
                }
            }
        }
    }

}

#Preview {
    AddIssueView()
}
