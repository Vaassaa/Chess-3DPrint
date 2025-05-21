/*
Rook Piece Generator (Věž)
*/

// Parameters
$fn = 8; // Polygon detail level

magnet_height = 2.1;        // Height of magnet
magnet_radius = 3.05;       // Radius of magnet

body_height = 14;           // Height of rook body
body_radius = 5;            // Base radius of rook body
top_taper = 1.2;            // Amount to taper toward top

crenellation_depth = 6;     // Depth of crenellation cut
crenellation_width = 1.5;   // Width of crenellation cuts
crenellation_shift = -0.4;  // Fine adjustment in Z position

transparency = 5;           // Transparency (visual only)
color_rgb = [143, 255, 61]; // RGB color

// Optional bounding cube for design envelope
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Width × Depth × Height
}

// Rook model
module rook() {
    union() {
        color(color_rgb / 255, transparency) {
            // Body with top taper and crenellation cutouts
            difference() {
                // Main body
                cylinder(h = body_height, r1 = body_radius, r2 = body_radius - top_taper, center = false);
                
                // Crenellations
                translate([0, 0, body_height + crenellation_shift]) {
                    // Inner core cut (cylinder)
                    cylinder(h = crenellation_depth + 2, r = 2, center = true);

                    // Opposing side cube cuts
                    rotate(45, [0, 0, 1])
                        cube([10, crenellation_width, crenellation_depth], center = true);

                    rotate(315, [0, 0, 1])
                        cube([10, crenellation_width, crenellation_depth], center = true);
                }
            }
        }
    }
}

// Magnet cavity under the base
module magnet_cavity() {
    offset = 0.5; // Offset for printer tolerance
    translate([0, 0, -offset]) {
        color("yellow", transparency)
            cylinder(h = magnet_height + offset, r = magnet_radius, center = false, $fn = 100);
    }
}

// Final piece with magnet hole
difference() {
    rook();
    magnet_cavity();
}
