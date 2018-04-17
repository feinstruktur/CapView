//: # CapView Playground - assembling a view from small components.
//:
//: This view is used to display capacity information for trains derived from weight load sensors on the trains. Little figures and colour coding depict how crowded a train carriage is.

import UIKit

//: First create a ManikinView. This view is itself a composite of simple geometry: rectangles and circle segments for head, torso, shoulders, arms, and legs.

ManikinView(frame: CGRect(x: 0, y: 0, width: 280, height: 660))

//: We also compose a BadgeView – a simple number inside a circle with configurable text size, fill and stroke, which we will use to indicate the carriage number and load levels.

BadgeView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), text: "16")

//: The CarriageView groups a number of manikins together and places them in a rounded rectangle. It also adds the BadgeView overlay for the carriage number and a colour code for the load of the carriage (red - full, green - empty).

CarriageView(frame: CGRect(x: 0, y: 0, width: 88, height: 40), load: 1.0, carriageNumber: 1)

//: In the next step we combine a number of these CarriageViews into a TrainCapacityView by simply stringing them together. To better resemble a real train, the first and the last carriage come with chamfered egdes (TM). The load vector in the constructor sets the loads for the carriages (in [1,0] ranges with over capacity, i.e. 1.3 == 130% full).

TrainCapacityView(loads: [1.3, 0.2, 0.42, 0.9], maxBounds: CGSize(width: 660, height: 300))

//: We create a longer train with increasing load in the carriages as we go along to show a few other interesting aspects: Note how the size of the overlay badge is now larger relative to the size of the carriages compared to the one above. This keeps the numbers readable.
//: Also note how the numbers change from black to white as the background shifts to red for the busy carriages, again to keep them readable.

var loads = Array(0..<11).map({0.05 + Double($0) * 0.1})
TrainCapacityView(loads: loads, maxBounds: CGSize(width: 660, height: 300))

//: The scaling factor for the badge size follows a sigmoid function, which can be nicely visualised in a playground.

for i in 0..<10 {
    let h = Double(10 + i*10)
    0.7 - sigmoid(x: h, L: 0.4, k: 0.08, x0: 50)
}
