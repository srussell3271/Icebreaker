import SwiftUI

struct ContentView: View {
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtPrefName: String = ""
    @State var txtAnswer: String = ""
    @State var txtQuestion: String = ""

    
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
                setSecurityQuestion()
            }){
                Text("Security Question")
            }
            Text(txtQuestion)
            TextField("Answer", text: $txtAnswer)
            
            Button(action:{
                writeStudentToFirebase()
            }){
                Text("Submit")
            }
        }
        
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .autocorrectionDisabled(true)
        .padding()
        }
    func setSecurityQuestion(){
        print("Security Question was activated")
    }
    
    func writeStudentToFirebase(){
        print("First Name: \(txtFirstName)")
        print("Last Name: \(txtLastName)")
        print("Preferred Name: \(txtPrefName)")
        print("Answer: \(txtAnswer)")
    }

}

#Preview {
    ContentView()
}
