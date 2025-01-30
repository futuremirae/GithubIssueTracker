//
//  LoginView.swift
//  IssueTracker
//
//  Created by 이숲 on 10/8/24.
//

import SwiftUI

struct LoginView: View {

    // MARK: - Properties

    @State private var id = String()
    @State private var password = String()

    let onLogin: () -> Void

    // MARK: - UI Configure
    
    var body: some View {
        ZStack {
            Color(cgColor: UIColor.systemGray6.cgColor).ignoresSafeArea()

            VStack {
                Text("Issue Tracker")
                    .bold()
                    .italic()
                    .font(.system(size: 30))

                VStack {
                    List {
                        HStack {
                            Text("아이디")
                            TextField("아이디를 입력하세요.", text: $id)
                                .padding(.leading, 45)
                        }

                        HStack {
                            Text("비밀번호")
                            SecureField("비밀번호를 입력하세요.", text: $password)
                                .padding(.leading, 30)
                        }
                    }
                    .frame(height: 150)

                    List {
                        HStack {
                            Button(action: {onLogin()}, label: {
                                Text("로그인")
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity)
                            })
                        }.listRowBackground(Color.accentColor)
                    }.frame(height: 100)

                    Button(action: { }, label: {Text("회원가입")})
                }

                Text("SNS 로그인").padding(.top, 60)

                HStack {
                    Button(action: { }, label: {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .padding(11)
                        .frame(width: 44, height: 44)})
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .clipShape(.circle)

                    Button(action: tappedGithubLogin, label: {
                        Image("github")
                            .resizable()
                            .padding(10)
                        .frame(width: 44, height: 44)})
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .clipShape(.circle)
                }.padding(.top, 10)

            }
        }
    }

    func tappedGithubLogin() {
        LoginUseCase(repository: LoginRepositoryImpl(loginService: LoginServiceImpl())).openGithubLoginPage()
    }
}

#Preview {
    LoginView(onLogin: {})
}
