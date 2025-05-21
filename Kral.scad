/*
King Piece Generator
*/

// Parameters
$fn = 12; // Number of faces (moderate poly)

magnet_height = 2.1;       // Magnet height
magnet_radius = 3.05;      // Magnet radius

body_height = 14.5;        // Main body height
body_radius = 4.5;         // Body base radius

head_radius = 4;           // Head sphere radius
base_flare_radius = 5;     // Base flare radius (rim at bottom)
base_flare_height = 3;     // Base flare height

transparency = 5;          // Transparency level
color_rgb = [143, 255, 61]; // RGB color (0–255)

/*
Optional: bounding box for visualizing max dimensions
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Max size (W × D × H)
}
*/

// Decorative ring of spheres (e.g., crown base)
module ring_of_spheres(n = 12, radius = 2.5, sphere_radius = 1) {
    for (i = [0 : n - 1]) {
        angle = 360 / n * i;
        translate([radius * cos(angle), radius * sin(angle), 0])
            sphere(r = sphere_radius, $fn = 8);
    }
}

// Main model: King piece
module king() {
    union() {
        color(color_rgb / 255, transparency) {

            // Flared base (for stability/decor)
            cylinder(h = base_flare_height, r1 = base_flare_radius, r2 = base_flare_radius - 2, center = false);

            // Tapered body
            cylinder(h = body_height, r1 = body_radius, r2 = body_radius - 4, center = false);

            // Head (sphere)
            translate([0, 0, body_height - 4])
                sphere(r = head_radius);

            // Decorative crown ring (around head)
            translate([0, 0, body_height - 7.2])
                ring_of_spheres(n = 12, radius = 2.5, sphere_radius = 1);

            // Crown cone
            translate([0, 0, body_height - 4])
                cylinder(h = 8, r1 = 1, r2 = 4, center = true);

            // Crown spikes (cross-like decoration)
            translate([0, 0, body_height + 0.5]) {

                // First arm
                rotate([0, 0, 45]) {
                    scale([0.8, 2, 1.2])
                        sphere(r = 1);
                    cube([7, 1.5, 1], center = true);
                }

                // Second arm (perpendicular)
                rotate([0, 0, 315]) {
                    scale([0.8, 2, 1.2])
                        sphere(r = 1);
                    cube([7, 1.5, 1], center = true);
                }
            }
        }
    }
}

// Magnet cavity (subtract from base)
module magnet_cavity() {
    offset = 0.5;
    translate([0, 0, -offset]) {
        color("yellow", transparency)
            cylinder(h = magnet_height + offset, r = magnet_radius, center = false, $fn = 100);
    }
}

// Final output: king with magnet cavity
difference() {
    king();
    magnet_cavity();
}
