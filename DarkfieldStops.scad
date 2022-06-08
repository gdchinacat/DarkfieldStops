
// filter parameters
diameter = 35.4; // the size of  the filter (mm)
thickness = 3;   // the thickness of the filter (mm)
aperture = 32;   // the size of the aperture (mm)
spoke_count = 3; // the number of spokes to support the stop

// set creation
start=6;         // mm for smallest stop
end=22;          // mm fo largest stop (ish...based on steps)
steps=.8;         // how much to increment stop size by
spacing = 5;    // mm between stops when laid out

// advanced features
$fn=360;
smoothing = 1.2;  // the radius of intersections of spokes
fudge = .01; // used to extend the difference volumes beyond the boundary to improve preview
text_depth = .8;


grid(start, steps, end);

module grid(start, steps, end) {
    c = floor((end - start)/steps);
    width = ceil(sqrt(c));
    for(i=[0:c-1]) {
        x = i % width;
        y = floor(i / width);
        translate([x * (diameter + spacing), y * (diameter + spacing), 0]) {
            stop(diameter, aperture, thickness, start + i * steps);
        }
    }
}

//spokes creates the "spokes" from the center of the stop to the diameter 
//(typically inside diameter of stop)).
module spokes(diameter, n, spoke_width) {
  r = diameter/2;
  for(deg = [0:360/n:360]) { //math is easier to just do 0 and 360
    rotate(deg) {
      translate([0, r/2]){
        square([spoke_width, r], center=true);
      }
    }
  }
}

module ring(od, id) {
  difference(){
    circle(r=od/2);
    circle(r=id/2);
  }
}

//stop creates an individual centered stop
module stop(od, id, h, stop_size) {
  difference() {
    linear_extrude(h) {
      offset(r=-smoothing) {
        ring(od+2*smoothing, id-2*smoothing); //adjust for negative smoothing
        circle(stop_size/2 + smoothing);
        spokes(id, spoke_count, (diameter-aperture)/2+2*smoothing);
      }
    }
    translate([0,0,h-text_depth+fudge])
      linear_extrude(text_depth) 
        text(str(stop_size), size=3, 
          font=":style=Bold", spacing=1,
          halign="center", valign="center");
  }
}

