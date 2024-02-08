import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtPrefName: String = ""
    @State var txtAnswer: String = ""
    @State var txtQuestion: String = ""
    @State var questions = [Question]()
    
    var body: some View {
        
        VStack {
            Text("Icebreaker")
                .font(.system(size: 40))
                .bold().italic()
                .underline(color: Color.blue)
            Text("Built with SwiftUI")
            
            TextField("First Name", text: $txtFirstName)
            TextField("Last Name", text: $txtLastName)
            TextField("Preferred Name", text: $txtPrefName)
            
            Button(action: { setRandomQuestion()
            }){
                Text("Security Question")
                    .font(.system(size: 28))
            }
            Text(txtQuestion)
            TextField("Answer", text: $txtAnswer)
            
            Button(action: {
                if(txtAnswer != "") {
                    writeStudentToFirebase()
                }
                resetTextFields()
                
            })
            {
                Text("Submit")
                    .font(.system(size: 28))
            }
            .padding(30)
        }
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .autocorrectionDisabled(true)
        .padding()
        .onAppear(){
            getQuestionsFromFirebase()
        }
    }
    
    func setRandomQuestion(){
        print("Security Question pressed")
        var newQuestion = questions.randomElement()?.text
        if(newQuestion != nil){
            self.txtQuestion = newQuestion!
        }
    }
    
    func getQuestionsFromFirebase(){
        db.collection("questions")
            .getDocuments() {  (querySnapshot,err) in
                if let err = err { // if error is not nil
                    print("Error getting documents: \(err)")
                } else { // Get my question documents from Firebase
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        if let question = Question(id: document.documentID, data: document.data()){
                            print("Question ID = \(question.id), text = \(question.text)")
                            
                            self.questions.append(question)
                        }
                    }
                }
                
            }
    }
    
    func resetTextFields(){
        txtFirstName = ""
        txtLastName = ""
        txtPrefName = ""
        txtQuestion = ""
        txtAnswer = ""
    }
    
    func writeStudentToFirebase(){
        print("Submit button pressed")
        print("First Name: \(txtFirstName)")
        print("Last Name: \(txtLastName)")
        print("Pref Name: \(txtPrefName)")
        print("Question: \(txtQuestion)")
        print("Answer: \(txtAnswer)")
        print("Class: iOS-Spring24")
        
        let data = ["firstName" : txtFirstName,
                    "lastName" : txtLastName,
                    "prefName" : txtPrefName,
                    "question"  : txtQuestion,
                    "answer"    : txtAnswer,
                    "class"     : "iOS-Spring24"] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("students")
            .addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
    }
}

#Preview {
    ContentView()
}
