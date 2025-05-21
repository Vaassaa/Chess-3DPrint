/*
King Piece Generator
*/

// Parameters
$fn = 12; // Number of polygon sides (preview quality)

magnet_height = 2.1;       // Magnet height (mm)
magnet_radius = 3.05;      // Magnet radius (mm)

body_height = 14.5;        // Body height
body_radius = 4.5;         // Body radius

head_radius = 4;           // Head sphere radius

base_flare_radius = 5;     // Base flare (rim) radius
base_flare_height = 3;     // Base flare height

transparency = 5;          // Transparency level
color_rgb = [143, 255, 61]; // RGB color (0–255)

// Optional bounding box for max size
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Max dimensions (W × D × H)
}

// Helper: Ring of spheres (used in crown decoration)
module ring_of_spheres(n = 12, radius = 3.5, sphere_radius = 0.8) {
    for (i = [0 : n - 1]) {
        angle = 360 / n * i;
        translate([radius * cos(angle), radius * sin(angle), 0])
            sphere(r = sphere_radius, $fn = 8);
    }
}

// Main model: King figure
module king() {
    union() {
        color(color_rgb / 255, transparency) {

            // Base flare (rim)
            cylinder(h = base_flare_height, r1 = base_flare_radius, r2 = base_flare_radius - 2, center = false);

            // Body (tapered cylinder)
            cylinder(h = body_height, r1 = body_radius, r2 = body_radius - 4, center = false);

            // Head (sphere)
            translate([0, 0, body_height - 4])
                sphere(r = head_radius);

            // Crown stem (cone)
            translate([0, 0, body_height - 4])
                cylinder(h = 8, r1 = 1, r2 = 4, center = true);

            // Crown decoration: scaled spheres & ring
            translate([0, 0, body_height + 0.5]) {

                // Two intersecting flattened spheres
                scale([1, 3.5, 0.5])
                    sphere(r = 1);

                scale([3.5, 1, 0.5])
                    sphere(r = 1);

                // Ring of small spheres
                scale([1, 1, 2])
                    ring_of_spheres(n = 8, radius = 3.5, sphere_radius = 0.8);
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

// Final model: king minus magnet hole
difference() {
    king();
    magnet_cavity();
}
