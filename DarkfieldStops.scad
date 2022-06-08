$fn=90;

diameter = 35.4; // mm for outer diameter of stop
thickness = 2.2;
ring_width = 2;
spoke_width = 1;
spoke_count = 3;

// set creation
start=6;         // mm for smallest stop
end=22;          // mm fo largest stop (ish...based on steps)
steps=.8;         // how much to increment stop size by
spacing = 5;    // mm between stops when laid out

grid(start, steps, end);

module grid(start, steps, end) {
    c = floor((end - start)/steps);
    width = ceil(sqrt(c));
    for(i=[0:c-1]) {
        x = i % width;
        y = floor(i / width);
        translate([x * (diameter + spacing), y * (diameter + spacing), 0]) {
            stop(diameter, thickness, start + i * steps);
        }
    }
}

module spokes(d, h, n) {
    for(deg = [0:360/n:360]) { //math is easier to just do 0 and 360
        rotate(deg) {
            translate([0, d/4, 0]){ // shift it half the radius to start at center
                cube([spoke_width, d/2, h], center=true);
            }
        }
    }
}


//ring creates a centered ring that is d mm in diameter, t mm thick, and h mm in height.
module ring(d, t, h) {
    difference(){
        cylinder(h=h, r=d/2, center=true);
        cylinder(h=h+.2, r=d/2-t, center=true);
    }
}

module stop(d, h, s) {
        ring(d, ring_width, h);
        cylinder(h=h, r=s/2, center=true);
        spokes(d-ring_width*2, h, spoke_count);
}

