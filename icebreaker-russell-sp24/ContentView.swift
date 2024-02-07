import SwiftUI
import Firebase
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
            
            Button(action:{
                setRandomQuestion()
            }){
                Text("Security Question")
            }
            Text(txtQuestion)
            TextField("Answer", text: $txtAnswer)
            
            Button(action:{
                if (txtAnswer != ""){ writeStudentToFirebase() }
                resetTextFields()
            }){
                Text("Submit")
            }
            .padding(30)
            .font(.system(size:30))
            .color.red
        }
        
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .autocorrectionDisabled(true)
        .padding()
        .onAppear(){ getQuestionsFromFirebase() }
        }
    func setRandomQuestion(){
        print("Security Question was activated")
        var newQuestion = questions.randomElement()?.text
        if(newQuestion != nil){
            self.txtQuestion = newQuestion!
        }
    }
    
    func getQuestionsFromFirebase(){
        db.collection("questions")
            .getDocuments(){ (querySnapshot, err) in
                if let err = err { //error is not null
                    print("Error getting Documents: \(err)")
                }else{//get question from Firebase
                    for document in querySnapshot!.documents{
                        print("\(document.documentID)")
                        if let question = Question(id:document.documentID, data: document.data()){
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
        questions = ""
        txtAnswer = ""
    }
    
    func writeStudentToFirebase(){
        print("First Name: \(txtFirstName)")
        print("Last Name: \(txtLastName)")
        print("Preferred Name: \(txtPrefName)")
        print("Answer: \(txtAnswer)")
        print("Question: \(questions)")
        print("Class: iOS-Spring2024")
        
        let data = [
            "firstName" : txtFirstName,
            "lastName" : txtLastName,
            "prefName" : txtPrefName,
            "question" : questions,
            "class" : "iOS-Spring2024"
        ] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("students")
            .addDocument(data: data){ err in
                if let err = err {
                    print("Error adding Document: \(err)")
                }else {
                    print("Document Added with ID: \(ref!.documentID)")
                }
            }
    }
}

#Preview {
    ContentView()
}
