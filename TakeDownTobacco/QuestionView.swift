import SwiftUI

struct QuestionView: View {
    let question: String
    let answers: [String]
    @State private var selectedAnswer: String?
    var vc: StatsVC
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            ForEach(answers, id: \.self) { answer in
                Button(action: {
                    self.selectedAnswer = answer
                }) {
                    Text(answer)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(selectedAnswer == answer ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    self.submitAnswer()
                }) {
                    Text("Select the right answer choice")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
        .padding()
    }
    
    func submitAnswer() {
//        if let answer = selectedAnswer {
//            // Call the submitAnswer function in StatsVC
//            var correctAns = vc.getAnswer()
//            
//            for i in 0..<answers.count {
//                    answers[i] = answers[i].replacingOccurrences(of: "gray", with: "red") // Update color
//                }
//            
//            vc.submitAnswer(answer)
//        }
    }
}
