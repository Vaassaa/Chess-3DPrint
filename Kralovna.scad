/*
Queen Piece Generator
*/

// Parameters
$fn = 8; // Number of faces for rounded objects (low poly for draft preview)

magnet_height = 2.1;     // Magnet height
magnet_radius = 3;       // Magnet radius

body_height = 14.5;      // Body height
body_radius = 4;         // Body base radius

neck_radius = 3;         // Neck radius 
head_radius = 4;         // Head radius

crown_radius_up = 2;      // Crown radius upper
crown_radius_dw = 4.2;    // Crown radius down
crown_height = 2.5;      // Crown height

crown_top_heigh = 2.5;   // Crown top height
crown_top_radius = 2;    // Crown top radius

transparency = 5;        // Transparency level (0-1 in render preview)
color_rgb = [143, 255, 61]; // RGB color as 0–255 values

// Bounding box for reference (commented out by default)
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Approximate max dimensions: width x depth x height
}

// Main model: Queen piece
module queen() {
    union() {
        // Main body (lower section and mid section)
        color(color_rgb / 255, transparency) {
            cylinder(h = body_height, r1 = body_radius - 0.5, r2 = body_radius - 3.5, center = false);
            cylinder(h = body_height - 9.5, r1 = body_radius + 1.5, r2 = body_radius - 1.7, center = false);

            // Neck sphere
            translate([0, 0, body_height - 4])
                sphere(r = neck_radius);

            // Head crown part 1 (base cylinder with taper)
            translate([0, 0, body_height - 3.5])
                cylinder(h = crown_height, r1 = crown_radius_up, r2 = crown_radius_dw, center = true);

            // Head crown part 2 (cone to top)
            translate([0, 0, body_height - 1])
                cylinder(h = crown_top_heigh, r1 = crown_top_radius, r2 = crown_top_radius - crown_top_radius, center = true);
        }
    }
}

// Optional: magnet space cutter (used in difference)
module magnet_cavity() {
    magnet_offset = 0.5;
    translate([0, 0, -magnet_offset]) {
        color("yellow", transparency)
            cylinder(h = magnet_height + magnet_offset, r = magnet_radius, center = false, $fn = 100);
    }
}

// Uncomment one of the following lines to render the desired output
queen(); // Default: render the queen piece
// bounds(); // Optional: show bounding box
// difference() { queen(); magnet_cavity(); } // Optional: subtract magnet space
