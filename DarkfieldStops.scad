
// filter parameters
diameter = 35.4; // the size of  the filter (mm)
thickness = 3;   // the thickness of the filter (mm)
aperture = 32;   // the size of the aperture (mm)
spoke_count = 3; // the number of spokes to support the stop

// set creation
start=15; end=15; // to do a single stop
//start=6;     // mm for smallest stop
//end=22;      // mm fo largest stop (ish...based on steps)
steps=.8;    // how much to increment stop size by
spacing = 5; // mm between filters  when laid out in grid

// Main. Comment out to use the tests below.
//grid(start, steps, end, ys=5*diameter/4);

// advanced features
//$fn=360;
smoothing = 0.5; // the radius of intersections of spokes
fudge = .01; // used to extend the difference volumes beyond the boundary to improve preview
text_size = 5;
text_depth = .8;

// Using animation verify that with changing _smoothing the body doesn't change.
// Uncomment one by one and run animation.

// basic body shape tests
//body(diameter + (diameter - aperture) * $t, aperture + (diameter - aperture) * $t); // changing diameter and aperture

//stop(diameter, aperture, thickness, end - $t*(end-start), smoothing=min((aperture-end)/4, ((diameter-aperture)/2 * (1-$t))));

//test smoothing works (start and end for extremes)
//stop(diameter, aperture, thickness, start, smoothing=min((aperture-end)/4, ((diameter-aperture)/2 * $t)));
//stop(diameter, aperture, thickness, end, smoothing=min((aperture-end)/4, ((diameter-aperture)/2 * $t)));

//Test grid spacing.
grid(start, steps, end, ys=5*diameter/4, spacing=diameter/2*$t);


module grid(start, steps, end, xs=diameter, ys=diameter, spacing=spacing,
maxwidth=200, square=true) {
  c = floor(1 + (end - start)/steps);
  width = square ? ceil(sqrt(c)) : floor((maxwidth*1.0)/(xs+spacing));
  translate([(xs+spacing)/2, (ys+spacing)/2])
  for(i=[0:1:c-1]) {
    x = i % width;
    y = floor(i / width);
    translate([x * (xs + spacing), y * (ys + spacing), 0])
      stop(diameter, aperture, thickness, start + i * steps);
  }
}

//spokes creates the "spokes" from the center of the stop to the diameter 
//(typically inside diameter of stop)).
module spokes(diameter, n, spoke_width) {
  r = diameter/2;
  for(deg = [0:360/n:360]) { //math is easier to just do both 0 and 360
    rotate(deg) {
      translate([0, r/2]){
        square([spoke_width, r], center=true);
      }
    }
  }
}

module body(od, id) {
  y = od*3/4;
  rod = od/2;
  difference(){
    union() {
      circle(r=rod);        // the "filter" body
      translate([-rod, -y]) // the handle
        square([od, y]);
    }
    circle(r=id/2);         // the aperture
  }
}

//stop creates an individual centered stop
module stop(od, id, h, size, smoothing=smoothing) {
  difference() {
    linear_extrude(h) {
      offset(r=-smoothing) { 
            offset(delta=smoothing)
            	body(od, id);
            circle(size/2 + smoothing); // the actual stop
            spokes(id, spoke_count, (od-id)/2+2*smoothing);
      }
    }
    translate([0,-od/2,h-text_depth+fudge])
      linear_extrude(text_depth) 
        text(str(size), size=text_size, 
          font=":style=Bold", halign="center", valign="top");
  }
}

