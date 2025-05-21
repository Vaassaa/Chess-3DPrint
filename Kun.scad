/*
Horse Piece Generator
*/

// Parameters
$fn = 6; // Number of faces for low-poly preview

magnet_height = 2.1;      // Magnet height
magnet_radius = 3;        // Magnet radius

body_height = 5.5;        // Body height
body_radius = 4.5;        // Body radius

neck_radius = 2;          // Neck radius
head_radius = 1.6;        // Head radius

transparency = 5;         // Transparency level
color_rgb = [143, 255, 61]; // Color as RGB (0–255)

// Bounding box (optional helper for scale visualization)
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Max width × depth × height
}

// Main model: Horse piece
module horse() {
    union() {
        color(color_rgb / 255, transparency) {

            // Body (tapered cylinder)
            cylinder(h = 12, r1 = body_radius, r2 = body_radius - 3, center = false, $fn = 6);

            // Snout (long nose projection)
            translate([-5, 0, body_height + 1])
                rotate([0, 60, 0])
                    translate([0, 0, 4])
                        scale([1, 1, 1.9])
                            sphere(r = 3);

            // Center of head (bulge)
            translate([0.55, 0, body_height + 3.5])
                scale([2.5, 1.2, 3])
                    sphere(r = neck_radius);

            // Left ear
            translate([1, 2, body_height + 5.8])
                rotate([-10, 30, 0])
                    scale([1.2, 0.7, 1.5])
                        sphere(r = neck_radius);

            // Right ear
            translate([1, -2, body_height + 5.8])
                rotate([10, 30, 0])
                    scale([1, 0.7, 1.5])
                        sphere(r = neck_radius);
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

// Final output (horse with magnet hole)
difference() {
    horse();
    magnet_cavity();
}
