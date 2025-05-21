/*
Bishop Piece Generator (Střelec)
*/

// Parameters
$fn = 8; // Polygon detail (render smoothness)

magnet_height = 2.1;        // Magnet height (mm)
magnet_radius = 3;          // Magnet radius (mm)

body_height = 15;           // Total body height
body_radius = 4.5;          // Base radius

neck_radius = 3;            // Neck transition sphere radius
head_radius = 4;            // Head/helmet sphere radius

transparency = 5;           // Material transparency (for preview)
color_rgb = [143, 255, 61]; // RGB color (scaled to 0–1)

// Optional size boundary preview
module bounds() {
    color("red", 0.3)
        cube([6, 1, 17]); // Width × Depth × Height bounds
}

// Bishop piece
module bishop() {
    union() {
        color(color_rgb / 255, transparency) {

            // Body (slight taper)
            cylinder(h = body_height, r1 = body_radius - 0.1, r2 = body_radius - 4, center = false);

            // Tapered shoulder base
            cylinder(h = 5, r1 = body_radius + 0.5, r2 = body_radius - 1.5, center = false);

            // Neck sphere
            translate([0, 0, body_height - 6])
                sphere(r = neck_radius);

            // Helmet top (cone)
            translate([0, 0, body_height - 4.8])
                cylinder(h = 2, r1 = 3.5, r2 = 1, center = true);

            // Helmet bottom (inverted cone)
            translate([0, 0, body_height - 6.8])
                rotate([0, 180, 0])
                    cylinder(h = 2, r1 = 3.5, r2 = 1, center = true);
        }
    }
}

// Magnet cavity at base
module magnet_cavity() {
    offset = 0.5;
    translate([0, 0, -offset]) {
        color("yellow", transparency)
            cylinder(h = magnet_height + offset, r = magnet_radius, center = false, $fn = 100);
    }
}

// Final piece with magnet cutout
difference() {
    bishop();
    magnet_cavity();
}
