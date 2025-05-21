/*
Pawn Piece Generator
*/

// Parameters
$fn = 12; // Polygon detail (preview quality)

magnet_height = 2.1;       // Magnet height (mm)
magnet_radius = 3.05;      // Magnet radius (mm)

body_height = 13;          // Total body height
body_radius = 4.5;         // Base radius

neck_radius = 3;           // Neck/shoulder sphere radius
head_radius = 3;           // Head sphere radius

transparency = 5;          // Visual transparency
color_rgb = [143, 255, 61]; // RGB color

// Optional size bounds visualization
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Width × Depth × Height
}

// Main model: Pawn figure
module pawn() {
    union() {
        color(color_rgb / 255, transparency) {

            // Body (slightly tapered)
            cylinder(h = body_height, r1 = body_radius - 0.5, r2 = body_radius - 4, center = false);

            // Base shoulder taper
            cylinder(h = 3.6, r1 = body_radius, r2 = body_radius - 1.5, center = false);

            // Midsection bulge (neck/torso)
            scale([1, 1, 2])
                sphere(r = 4.2);

            // Head
            translate([0, 0, body_height - 2.9])
                sphere(r = head_radius);

            // Helmet (tapered cone and mirrored copy)
            translate([0, 0, body_height - 3]) {
                scale([0.8, 0.8, 0.8])
                    cylinder(h = 3, r1 = 4.5, r2 = 2, center = false);

                rotate([0, 180, 0])
                    scale([0.8, 0.8, 0.8])
                        cylinder(h = 3, r1 = 4.5, r2 = 2, center = false);
            }
        }
    }
}

// Magnet cavity
module magnet_cavity() {
    offset = 0.5;
    translate([0, 0, -offset]) {
        color("yellow", transparency)
            cylinder(h = magnet_height + offset, r = magnet_radius, center = false, $fn = 100);
    }
}

// Negative base for cleanup (e.g., flush base when printing)
module bottom_cutout() {
    translate([-50, -50, -10])
        cube([100, 100, 10]);
}

// Final model with cutouts
difference() {
    pawn();
    magnet_cavity();
    bottom_cutout();
}
