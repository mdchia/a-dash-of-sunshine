// Sun keychain
// by Ming-Dao Chia
// inspired by Hannah Jang

// Settings
layer_height = 0.2001; // layer height in mm
circle_res=128; // Resolution of circles (usually 20 for preview, 64/128 for production)
keyring=4; // Size of keyring hole in mm

flares = 25; // Number of pointy bits around circle
flare_width = 0.5; // How wide the flare is (relative)
flare_length = 1; // How much the flare extends (relative)
flare_size = 7; // Original size of flare, in mm
flare_distance = 10; // Distance from flare center to overall center, in mm 
flare_height = 7; // in layers

subring_width = 0.8; // Width of the supporting ring, in mm
subring_adjust = 0.8; // Use if subring isn't aligned to flares (scale)
subring_height = 9; // in layers

core_adjust = 0.7; // Use if core ring isn't aligned to flares
core_height = 2; // in layers

module sun_arm(){
    color("orange")
    translate([flare_distance,0,0])
    scale([flare_length,flare_width,1])
    cylinder(d=flare_size, h=flare_height*layer_height, $fn=3);
}

module sun_core(){
    color("yellow")
    cylinder(d=flare_distance*(2+core_adjust), h=core_height*layer_height, $fn=circle_res);
}

module sun_subring(){
    dia = (flare_distance*2-((flare_size/(2+subring_adjust))*flare_length));
    color("red")
    difference(){
        cylinder(d=dia, h=(subring_height*layer_height), $fn=circle_res);
        cylinder(d=dia-(subring_width*2), h=subring_height*layer_height+1, $fn=circle_res);
    }
}

module sun_keyring(){
    color("gray")
    translate([0,0,flare_height*layer_height/2]) // raise to the level of the rest of model
    difference(){
        cylinder(d=keyring+2,h=flare_height*layer_height, $fn=circle_res, center=true);
        cylinder(d=keyring,h=flare_height*layer_height+0.01, $fn=circle_res, center=true);
    }
}

module sun_arms(num){
    function angle(i,num)=i*(360/num); // evenly spread arms in a circle
    for(i=[1:num]){
        // add an arm each rotation
        rotate([0,0,angle(i,num)])
        sun_arm();
    }
}

module sun_keychain(){
    sun_arms(flares);
    sun_core();
    sun_subring();
    // keyring
    translate([(flare_size/2*flare_length)+flare_distance+keyring/2,0,0])
    sun_keyring();
    // keyring stability hack (small keychains only)
    //color("gray")
    //translate([((flare_size*flare_length)+flare_distance)-
    //(keyring+flare_size/4),-flare_size*flare_width/2,0])
    //cube([flare_size/2,flare_size*flare_width,flare_height*layer_height]);
}

//sun_arm();
sun_keychain();