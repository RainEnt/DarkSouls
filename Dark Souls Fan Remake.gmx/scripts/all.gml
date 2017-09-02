#define approach
///approach(current, target, amount)
/*
    This script can be used to approach a value
    but not pass the value.
*/

var current = argument[0]; // Current value
var target = argument[1]; // Target value
var amount = argument[2]; // Amount to approach each step

// approach the value but don't go over
if (current < target) {
    return min(current+amount, target); 
} else {
    return max(current-amount, target);
}

#define instance_place_multiple
///instance_place_multiple(x, y, instance)
/*
    Works like instance_place but returns a ds_list of
    all the instances at that location.
*/

var xx = argument0; // x position to check
var yy = argument1; // y position to check
var ins = argument2; // Object to check for
var list = ds_list_create(); // New list data structure

// Loop through the instances and add them to the list
while (instance_place(xx, yy, ins)) {
    var o = instance_place(xx, yy, ins); // o is the id of the instance
    ds_list_add(list, o); // Add the instance to the list
    instance_deactivate_object(o); // deactivate the instance we just added to the list
}

// Reactivate all the deactivated instances
for (var i=0; i<ds_list_size(list); i++) {
    instance_activate_object(list[| i]);
}

return list;

#define decimal_bbox_right
///decimal_bbox_right()
/*
    Bounding boxes in gamemaker are an integer values.
    This script allows you to get the decimal value of the
    bounding box.
*/
return bbox_right+(x-round(x));

#define decimal_bbox_bottom
///decimal_bbox_bottom()
/*
    Bounding boxes in gamemaker are an integer values.
    This script allows you to get the decimal value of the
    bounding box.
*/
return bbox_bottom+(y-round(y));

#define decimal_bbox_left
///decimal_bbox_left()
/*
    Bounding boxes in gamemaker are an integer values.
    This script allows you to get the decimal value of the
    bounding box.
*/
return bbox_left+(x-round(x));

#define decimal_bbox_top
///decimal_bbox_top()
/*
    Bounding boxes in gamemaker are an integer values.
    This script allows you to get the decimal value of the
    bounding box.
*/
return bbox_top+(y-round(y));

#define place_meeting_exception
///place_meeting_exception(x, y, obj, exception)
/*
    Works just like place_meeting but you can pass an exception
    instance that won't be included in the check.
*/

var xx = argument0; // x position to check
var yy = argument1; // y position to check
var obj = argument2; // Object to check for
var exception = argument3; // Exception instance to leave out

var instance = instance_place(xx, yy, obj); // Call instance_place

// Return true unless the exception instance matches the instance at that location
return (instance != exception && instance != noone);

#define initialize_movement_entity
///initialize_movement_entity(gravity, friction, air_resistance, bounce, collision_object)
/*
    This script is used to initialize a movement entity.
    You need to call this script in the CREATE EVENT of
    any object you would like using the movement scripts.
*/

// Input speeds
hsp[0] = 0;
vsp[0] = 0;

// Knockback speeds
hsp[1] = 0;
vsp[1] = 0;

grav = argument[0]; // Gravity amount (positive is down).
fric = argument[1]; // Friction amount (Only applies on ground for Platform Games).
air_res = argument[2]; // Friction for all movement( When gravity is not 0 it only applies horizontally)
bounce = argument[3]; // Bounce amount. 0 is no bounce, .5 is half velocity lost, 1 is no velocity lost.
collision_object = argument[4] // The object that will be used for collisions.

horizontal_move_input = false;
vertical_move_input = false;
air_jump = 0;

#define move_movement_entity
///move_movement_entity()
/*
    This script updates the position of the movement entity
    according to its horizontal speeds and vertical speeds.
    This script should be called at the end of the STEP EVENT for each
    object you want using the movement scripts
*/

var yslope = 0; // Used to calculate movement along a slope

// Air jump reset
if (place_meeting(x, y+1, collision_object)) {
    air_jump = 1;
}

// Get the total speeds
var hspd = hsp[0]+hsp[1];
var vspd = vsp[0]+vsp[1];


// Move down a slope
if (!place_meeting(x+hspd, y, collision_object) && abs(hspd) > 0 && place_meeting(x, y+1, collision_object)) {
    while (!place_meeting(x+hspd, y-yslope, collision_object) && yslope >= -abs(hspd)) {
        yslope--;
    }
    
    // Make sure we actually need to move down
    if (yslope != 0 && place_meeting(x+hspd, y-yslope+1, collision_object)) {
        y -= yslope;
    }
}

// Horizontal check
if (place_meeting(x+hspd, y, collision_object)) {
    // Move up a slope
    while (place_meeting(x+hspd, y-yslope, collision_object) && yslope <= abs(hspd)) {
        yslope++;
    }
    
    if (place_meeting(x+hspd, y-yslope, collision_object)) {
        // Move to contact and bounce
        while (!place_meeting(x+sign(hspd), y, collision_object)) {
            x+=sign(hspd);
        }
        
        // Update the horizontal speeds
        hspd = 0;
        hsp[0] = 0;
        hsp[1] = -(hsp[1])*bounce;
        
        // Stop bounce at low values
        if (abs(hsp[1]) < 1) hsp[1] = 0;
    } else {
        y-=yslope;
    }
}
if (!place_meeting(x+hspd, y, collision_object)) {
    x += hspd;
}

// Vertical collision check
if (place_meeting(x, y+vspd, collision_object)) {
    while (!place_meeting(x, y+sign(vspd), collision_object)) {
        y+=sign(vspd);
    }
    
    // Update the vertical speeds
    vspd = 0;
    vsp[0] = 0;
    vsp[1] = -vsp[1]*bounce;
    
    // Stop bounce at low values
    if (abs(vsp[1]) < 1) vsp[1] = 0;
}
y += vspd;


/// Apply gravity
if (!place_meeting(x, y+1, collision_object)) {
    vsp[0] += grav;
}

// Apply friction
if (place_meeting(x, y+1, collision_object)) {
    if (horizontal_move_input == false) {
        hsp[0] = approach(hsp[0], 0, fric);
    }
    
    hsp[1] = approach(hsp[1], 0, fric);
}

// Air resistance
if (horizontal_move_input == false) {
    hsp[0] = approach(hsp[0], 0, air_res);
}
if (vertical_move_input == false && grav == 0) {
    vsp[0] = approach(vsp[0], 0, air_res);
}

hsp[1] = approach(hsp[1], 0, air_res);
vsp[1] = approach(vsp[1], 0, air_res);

#define move_solid_entity
///move_solid_entity(push_object)
/*
    Use this script on moving collision objects instead of move_movement_entity.
    This script should be called in the end step event.
*/

var push_object = argument0; // Object to push
var ymove = true; // Can we move vertically?
var xmove = true; // Can we move horizontally?
var hspd = hsp[0]+hsp[1]; // Get the total hspd
var vspd = vsp[0]+vsp[1]; // Get the total vspd

// Check for left and right instances
var instances = instance_place_multiple(x+hspd+sign(hspd), y, push_object);
var last_hsp0 = hsp[0];
var last_hsp1 = hsp[1];
warp_movement_entity(x+hspd, y);
for (var i=0; i<ds_list_size(instances); i++) {
    var instance = instances[| i];
    if (instance) {
        var new_x = instance.x;
        if (hspd > 0) {
            new_x = (decimal_bbox_right()+1)-((instance.bbox_left-round(instance.x)));
        } else if (hspd < 0) {
           new_x = (decimal_bbox_left()-1)-(instance.bbox_right-round(instance.x));
        }
        with (instance) {
            if (place_meeting_exception(new_x+sign(hspd), y, collision_object, other.id)) {
                if (other.hsp[0] != 0) {
                    other.hsp[0] = -last_hsp0;
                }
                if (other.hsp[1] != 0) {
                    other.hsp[1] = -last_hsp1;
                }
                xmove = false;
            }
        }
    }
}


// Move left and right instances
if (xmove) {
    for (var i=0; i<ds_list_size(instances); i++) {
        var instance = instances[| i];
        if (instance) {
            var new_x = instance.x;
            if (hspd > 0) {
                if (bbox_right > instance.bbox_right) continue;
                new_x = (decimal_bbox_right()+1)-((instance.bbox_left-round(instance.x)));
            } else if (hspd < 0) {
                if (bbox_left < instance.bbox_left) continue;
                new_x = (decimal_bbox_left()-1)-(instance.bbox_right-round(instance.x));
            }
            with (instance) {
                x=new_x;
            }
        }
    }
} else {
    x = xprevious;
}

// Destroy the list containing the left and right instances
ds_list_destroy(instances);

// Bounce off walls horizontally
if (place_meeting(x+hspd+sign(hspd), y, collision_object)) {
    hsp[0] *= -1;
    hsp[1] *= -1;
}

// Check for on top instances
var top_instances = instance_place_multiple(x, y-(abs(vspd)+1), push_object);
var last_vsp0 = vsp[0];
var last_vsp1 = vsp[1];
warp_movement_entity(x, y+vspd);
for (var i=0; i<ds_list_size(top_instances); i++) {
    var instance = top_instances[| i];
    if (instance) {
        var new_y = (decimal_bbox_top())-((instance.bbox_bottom-round(instance.y)));
        with (instance) {
            if (place_meeting_exception(x, new_y, collision_object, other.id)) {
                if (other.vsp[0] != 0) {
                    other.vsp[0] = -last_vsp0;
                }
                if (other.vsp[1] != 0) {
                    other.vsp[1] = -last_vsp1;
                }
                ymove = false;
            }
        }
    }
}

// Check for bottom instances
var bottom_instances = instance_place_multiple(x, y+(abs(vspd)+1)+vspd, push_object);
for (var i=0; i<ds_list_size(bottom_instances); i++) {
    var instance = bottom_instances[| i];
    if (instance) {
        if (instance.bbox_bottom < bbox_bottom) continue;
        var new_y = (decimal_bbox_bottom()+1)-((instance.bbox_top-round(instance.y)));
        with (instance) {
            if (place_meeting_exception(x, new_y+1, collision_object, other.id)) {
                if (other.vsp[0] != 0) {
                    other.vsp[0] = -last_vsp0;
                }
                if (other.vsp[1] != 0) {
                    other.vsp[1] = -last_vsp1;
                }
                ymove = false;
            }
        }
    }
}

if (ymove) {
    // Move the top instances
    for (var i=0; i<ds_list_size(top_instances); i++) {
        var instance = top_instances[| i];
        if (instance) {
            var new_y = (decimal_bbox_top())-((instance.bbox_bottom-round(instance.y)));
            with (instance) {
                if (instance.bbox_top > bbox_top) continue;
                y = new_y;
                
                if (!place_meeting_exception(x+hspd+sign(hspd), y, collision_object, other.id)) {
                    if (place_meeting(x+hspd, y+1, collision_object)) {
                        x += hspd;
                    }
                }
            }
        }
    }
    
    // Move the bottom instances
    for (var i=0; i<ds_list_size(bottom_instances); i++) {
        var instance = bottom_instances[| i];
        if (instance) {
            if (instance.bbox_bottom < bbox_bottom) continue;
            var new_y = (decimal_bbox_bottom()+1)-((instance.bbox_top-round(instance.y)));
            with (instance) {
                if (y < new_y) y = new_y;
            }
        }
    }
} else {
    y = yprevious;
}

// Destroy the top and bottom instance lists
ds_list_destroy(bottom_instances);
ds_list_destroy(top_instances);

// Bounce off walls
if (place_meeting(x, y+vspd+sign(vspd), collision_object)) {
    vsp[0] *= -1;
    vsp[1] *= -1;
}

#define add_movement_horizontal_vertical
///add_movement_horizontal_vertical(hacceleration, vacceleration)
/*
    This script adds a horizontal and/or a vertical acceleration
    to a movement entity. This acceleration will be relative to 
    the previous horizontal speed and vertical speed. It is sort
    of like motion_add but it takes a horizontal acceleration and
    a vertical acceleration as arguments instead of a direction and
    speed.
*/

hsp[1] += argument0;
vsp[1] += argument1;

#define set_movement_horizontal_vertical
///set_movement_horizontal_vertical(hspeed, vspeed)
/*
    This script sets a horizontal and/or a vertical speed
    to a movement entity. This speed will NOT be relative to 
    the previous horizontal and vertical speeds. It is sort
    of like motion_set but it takes a horizontal and
    vertical speeds as arguments instead of a direction and
    speed.
*/

hsp[1] = argument0;
vsp[1] = argument1;



#define add_movement_direction_acceleration
///add_movement_direction_acceleration(direction, acceleration);
/*
    This script adds a direction and acceleration
    to a movement entity. This acceleration will be relative to 
    the previous speed of that entity. It works very much like
    motion_add.
*/

var dir = argument[0]; // Direction value
var acc = argument[1]; // Acceleration value

hsp[1] += lengthdir_x(acc, dir);
vsp[1] += lengthdir_y(acc, dir);

#define set_movement_direction_speed
///set_movement_direction_speed(direction, speed);
/*
    This script sets a direction and acceleration
    to a movement entity. This acceleration will NOT be relative to 
    the previous speed of that entity. It works very much like
    motion_set.
*/

var dir = argument[0]; // Direction value
var spd = argument[1]; // Speed value

hsp[1] = lengthdir_x(spd, dir);
vsp[1] = lengthdir_y(spd, dir);


#define add_movement_horizontal_vertical_maxspeed
///add_movement_horizontal_vertical_maxspeed(hacceleration, vacceleration, maxhspeed, maxvspeed)
/*
    This script adds a horizontal and/or a vertical acceleration
    to a movement entity. This acceleration will be relative to 
    the previous horizontal speed and vertical speed. It also allowes
    for a maximum horizontal speed and vertical speed. It is sort
    of like motion_add but it takes a horizontal acceleration and
    a vertical acceleration as arguments instead of a direction and
    speed.
*/
var hacc = argument0; // Horizontal acceleration
var vacc = argument1; // Vertical acceleration
var maxhspd = argument2; // Maximum horizontal speed
var maxvspd = argument3; // Maximum vertical speed
horizontal_move_input = hacc != 0;
vertical_move_input = hacc != 0;

hsp[0] = approach(hsp[0], maxhspd, abs(hacc));
vsp[0] = approach(vsp[0], maxvspd, abs(vacc));

#define warp_movement_entity
///warp_movement_entity(xwarp, vwarp)
/*
    This script can be used to warp a movement or solid entity
    to a location while keeping that instance outside of any
    collision objects.
*/

var xwarp = argument0; // x position to warp to
var ywarp = argument1; // y position to warp to

// Warp to the location but don't move inside collision objects
if (place_meeting(xwarp, y, collision_object)) {
    while(!place_meeting(sign(xwarp-x), y, collision_object)) {
        x+=sign(xwarp-x);
    }
    xwarp = x;
}
x = xwarp;

// Warp to the location but don't move inside collision objects
if (place_meeting(x, ywarp, collision_object)) {
    while(!place_meeting(x, sign(ywarp-y), collision_object)) {
        y+=sign(ywarp-y);
    }
    ywarp = y;
}
y = ywarp;

#define set_movement_collision_object
///set_movement_collision_object(object)
/*
    Call this script in order to change/set the
    object that will be used for collision checking
    in all your movement entities.
*/

// Set new collision object
collision_object = argument[0];

#define set_movement_friction
///set_movement_friction(amount)
/*
    Call this script in order to set/change
    the friction amount of a movement entity.
*/

// Set new friction
fric = argument[0];

#define set_movement_bounce
///set_movement_bounce(amount)
/*
    Call this script in order to set/change
    the bounce amount of a movement entity.
    
    0  -  No bounce
    .5 -  Half bounce
    1  -  Full bounce
*/

// Set new bounce
bounce = argument[0];

#define set_movement_gravity
///set_movement_grav(amount)
/*
    Call this script in order to set/change
    the gravity amount applied to a movement entity.
*/

// Set gravity
grav = argument[0];

#define enable_movement_platform_actions
///enable_movement_platform_actions(acceleration, run_speed, jump_height, right_input, left_input, jump_input, jump_release_input)
/*
    Call this script to enable basic platform physics on
    a movement entity. It will enable running, jumping, and
    wall jumping. If you want to mix and match the possible
    platform actions you can use the individual "enable_action"
    scripts separately in the step event of the movement entity.
    
    The reason you pass the inputs into this script is to
    decouple the actions from their inputs. You could even use
    this same script to enable platform actions on an AI.
    You would just pass in different inputs.
*/

var acceleration = argument[0]; // Run acceleration amount
var run_speed = argument[1]; // Maximum run speed
var jump_height = argument[2]; // Jump height (Should be a positive value)
var right_input = argument[3]; // The right input
var left_input = argument[4]; // The left input
var jump_input = argument[5]; // The jump input
var jump_release_input = argument[6]; // The jump release input (This is used to allow controlled jump height)

// Enable running
enable_movement_run(acceleration, run_speed, right_input, left_input);

// Enable jumping
enable_movement_jump(jump_height, jump_input, jump_release_input);

// Enable wall jump
enable_movement_wall_jump(jump_height, run_speed, jump_input, right_input, left_input);

#define enable_movement_jump
///enable_movement_jump(height, input, release_input)
/*
    Call this script to enable platform jumping
    on a movement entity.
*/

var height = argument[0]; // The jump height (Should be positive)
var input = argument[1]; // The input for jumping
var release_input = argument[2]; // The input for jump height control (release)

// Check for jump
if (place_meeting(x, y+1, collision_object) || place_meeting(xprevious, yprevious+1, collision_object)) {
    if (input) {
        vsp[0] = -height;
    }
} else {
    if (release_input && vsp[0] <= -height/3) {
        vsp[0] = -height/3;
    }
}

#define enable_movement_run
///enable_movement_run(acceleration, max_speed, right_input, left_input)
/*
    Call this script in order to enable horizontal
    running on a movement entity.
*/

var acc = argument[0]; // Acceleration value
var maxspd = argument[1]; // Maximum run speed
var right_input = argument[2]; // Right movement input
var left_input = argument[3]; // Left movement input
var hacc = (right_input - left_input)*acc;
maxspd *= sign(hacc);

horizontal_move_input = hacc != 0;

add_movement_horizontal_vertical_maxspeed(hacc, 0, maxspd, 0);

#define enable_movement_run_axis
///enable_movement_run_axis(acceleration, max_speed, horizontal_axis)
/*
    Call this script in order to enable horizontal
    running on a movement entity.
*/

var acc = argument[0]; // Acceleration value
var max_spd = argument[1]; // Maximum run speed
var haxis = argument[2]; // Horizontal input axis
var hacc = (haxis)*acc;
maxspd = max_spd*abs(haxis);

horizontal_move_input = hacc != 0;

add_movement_horizontal_vertical_maxspeed(hacc, 0, maxspd, 0);

#define enable_movement_air_jump
///enable_movement_air_jump(height, input)
/*
    Call this script in order to add platform double jumping
    (air jumping) to a movement entity.
*/

var height = argument[0]; // Jump height
var input = argument[1]; // Jump input

// Air jump
if (!place_meeting(x, y+1, collision_object) && air_jump == 1 && input) {
    vsp[0] = -height;
    air_jump--;
}

#define enable_movement_wall_jump
///enable_movement_wall_jump(height, distance, jump_input, right_input, left_input)
/*
    Call this script in order to enable platform wall
    jumping on a movement entity.
*/

var height = argument[0]; // Jump height
var distance = argument[1]; // Distance to check from wall and horizontal jump speed
var jump_input = argument[2]; // Jump input
var right_input = argument[3]; // Right movement input
var left_input = argument[4]; // Left movement input

// Wall jump
if (!place_meeting(x, y+1, collision_object)) {
    // Left wall
    if (place_meeting(x-distance, y, collision_object)) {
        if (jump_input && (right_input - left_input) != 0) {
            hsp[0] += distance;
            vsp[0] = -height;
        }
    }
    
    // Right wall
    if (place_meeting(x+distance, y, collision_object)) {
        if (jump_input && (right_input - left_input) != 0) {
            hsp[0] -= distance;
            vsp[0] = -height;
        }
    }
}

#define animation_end
///animation_end()
/*
    This script will return true if the image_index of your
    sprite hits the last frame.
*/

// Will return true if an animation is at its last frame
return animation_hit_frame(image_number - 1);

#define animation_hit_frame
///animation_hit_frame(frame)
/*
    This script will return true if the image_index of your
    sprite hits a specific frame.
*/

var frame = argument0; // The frame to check for
// Will return true if an animation is on a specific frame
return (image_index >= frame+1 - image_speed) && (image_index < frame+1);

#define enable_movement_platform_sprites
///enable_movement_platform_sprites(idle_sprite, walk_sprite, jump_sprite, walk_animation_speed)
/*
    This script can be used to set basic sprites and animations
    for a movement entity. The script is rather basic and is
    more of a example to show you how you might set the
    sprites for your character using your own script.
*/

var idle_sprite = argument0;
var walk_sprite = argument1;
var jump_sprite = argument2;
var walk_animation_speed = argument3;

// Set the image speed to 0 as a default
image_speed = 0;

/// Check to see if we are in the air
if (!place_meeting(x, y+1, collision_object)) {
    // We are in the air
    // Change to jump sprite
    sprite_index = jump_sprite;
    
    // The jump sprite has two images, one for going up,
    // and the other for falling. This code will show the
    // correct image index based on that information.
    image_index = (vsp[0] > 0);
} else {
    // We are on the ground
    // Are we moving?
    if (hsp[0] != 0) {
        // We are moving
        // Change to walk sprite and animate
        sprite_index = walk_sprite;
        image_speed = walk_animation_speed;
    } else {
        // We aren't moving
        // Change to idle sprite
        sprite_index = idle_sprite;
    }
}

// We need to update the direction the sprite is facing
if (hsp[0] != 0) {
    // Use the xscale and hspd to flip the sprite
    image_xscale = sign(hsp[0]);
}

