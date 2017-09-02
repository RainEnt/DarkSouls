#define draw_text_outlined
///draw_text_outlined(x, y, string, colour, outline_colour)
var xx = argument0;
var yy = argument1;
var str = argument2;
draw_set_colour(argument4);
draw_text(xx-1, yy, str);
draw_text(xx+1, yy, str);
draw_text(xx, yy-1, str);
draw_text(xx, yy+1, str);
draw_set_colour(argument3);
draw_text(xx, yy, str);
draw_set_colour(c_white);

#define draw_text_shadow
///draw_text_shadow(x, y, string, colour, shadow_colour, shadow_alpha)
var xx = argument0;
var yy = argument1;
var str = argument2;

//Draw shadow
draw_set_colour(argument4);
draw_set_alpha(argument5);
draw_text(xx, yy+1, str);

//Draw Text
draw_set_colour(argument3);
draw_set_alpha(1);
draw_text(xx, yy, str);
draw_set_colour(c_white);

#define draw_text_shadow_ext
///draw_text_shadow_ext(x, y, string, colour, shadow_colour, shadow_direction, shadow_distance, shadow_alpha)
var xx = argument0;
var yy = argument1;
var str = argument2;
var dir = argument5;
var len = argument6;

//Draw text shadow
draw_set_colour(argument4);
draw_set_alpha(argument7);
var shadow_x = xx+lengthdir_x(len, dir);
var shadow_y = yy+lengthdir_y(len, dir);
draw_text(shadow_x, shadow_y, str);

//Draw text
draw_set_colour(argument3);
draw_set_alpha(1);
draw_text(xx, yy, str);
draw_set_colour(c_white);

#define draw_sprite_outlined
///draw_sprite_outlined(sprite, subimg, x, y, xscale, yscale, ang, colour, outline_colour)
var spr = argument0;
var img = argument1;
var xx = argument2;
var yy = argument3;
var xs = argument4;
var ys = argument5;
var ang = argument6;
var col = argument7;
var ocol = argument8;
d3d_set_fog(true, ocol, 0, 1);
draw_sprite_ext(spr, img, xx-xs, yy, xs, ys, ang, c_white, 1);
draw_sprite_ext(spr, img, xx+xs, yy, xs, ys, ang, c_white, 1);
draw_sprite_ext(spr, img, xx, yy-ys, xs, ys, ang, c_white, 1);
draw_sprite_ext(spr, img, xx, yy+ys, xs, ys, ang, c_white, 1);
d3d_set_fog(0, 0, 0, 0);
draw_sprite_ext(spr, img, xx, yy, xs, ys, ang, col, 1);


#define draw_sprite_shadow
///draw_sprite_shadow(direction, distance, scale, colour, alpha);
///Draws the shadow of a sprite
///Using the calling object's x, y, image_angle, sprite_index & image_index
/*
 * Example use:
 * draw_sprite_shadow(270, 3, 1, c_black, 0.5);
 * draw_self();
 */
var dir = argument0;
var len = argument1;
var sca = argument2;
var col = argument3;
var alp = argument4;
var xx = x+lengthdir_x(len, dir);
var yy = y+lengthdir_y(len, dir);
d3d_set_fog(true, col, 0, 1);
draw_sprite_ext(sprite_index, image_index, xx, yy, sca, sca, image_angle, c_white, alp);
d3d_set_fog(0, 0, 0, 0);


#define string_split
///string_split(string, split)
///Returns a ds_list of strings after splitting the initial string
/* 
 * Example use:
 * var str = "These are some words";
 * word_list = string_split(str, " ");
 * //Returns a list containing ("These", "are", "some", "words")
 */
var str = argument0;
var split = argument1;
var list = ds_list_create();
var number = string_count(split, str);
if (number == 0)
{
    ds_list_add(list, str);
}
else
{
    for (var i = 0; i < number; i++)
    {
        var pos = string_pos(split, str);
        ds_list_add(list, string_copy(str, 1, pos-1));
        str = string_delete(str, 1, pos);
    }
    ds_list_add(list, str);
}
return list;


#define approach
///approach(current, target, amount)
/*
 * Example use:
 * x = approach(x, target_x, 2);
 */
var c = argument0;
var t = argument1;
var a = argument2;
if (c < t)
{
    c = min(c+a, t); 
}
else
{
    c = max(c-a, t);
}
return c;

#define angle_approach
///angle_approach(current, target, turn_speed)
/*
 * Example use (rotate to face towards the cursor):
 * var target_angle = point_direction(x, y, mouse_x, mouse_y);
 * image_angle = angle_approach(image_angle, target_angle, 4);
 */
var tempdir;
var angle = argument0;
var target_angle = argument1;
var turn_speed = argument2;
var diff = abs(target_angle-angle);
if (diff > 180)
{
    if (target_angle > 180)
    {
        tempdir = target_angle - 360;
        if (abs(tempdir-angle ) > turn_speed)
        {
            angle -= turn_speed;
        }
        else
        {
            angle = target_angle;
        }
    }
    else
    {
        tempdir = target_angle + 360;
        if (abs(tempdir-angle) > turn_speed)
        {
            angle += turn_speed;
        }
        else
        {
            angle = target_angle;
        }
    }
}
else
{
    if (diff > turn_speed)
    {
        if (target_angle > angle)
        {
            angle += turn_speed;
        }
        else
        {
            angle -= turn_speed;
        }
    }
    else
    {
        angle = target_angle;
    }
}
return angle;

#define smooth_approach
///smooth_approach(current, target, speed[0-1])
/*
 * Example use (smooth camera movement):
 * view_xview = smooth_approach(view_xview, x-view_wview/2, 0.1);
 * view_yview = smooth_approach(view_yview, y-view_hview/2, 0.1);
 */
var diff = argument1-argument0;
if abs(diff) < 0.0005
{
   return argument1;
}
else 
{
   return argument0+sign(diff)*abs(diff)*argument2;
}

#define percent_chance
///percent_chance(%)
return (random(100) <= argument0);

#define round_chance
///round_chance(number)
/*
 * This is a bit of a weird one, but can be useful!
 *
 * Example use:
 * round_chance(1.75)
 *    < this has a 75% chance of returning 2, otherwise returning 1
 *
 * So we're using the decimal as a chance of rounding the number up
 */
var num = argument0;
var chance = (num-floor(num))*100;
if (percent_chance(chance))
{
    var count = ceil(num);
}
else
{
    var count = floor(num);
}

return count;

#define set_chance
///set_chance(%, value_if_true, value_if_false)
/*
 * a chance of returning the 1st value, otherwise returns the 2nd value
 * Example use:
 * value = set_chance(10, a, b);
 * // ^ has a 10% chance to set value to a, otherwise value is set to b
 */
if (percent_chance(argument0))
{
    return argument1;
}
else
{
    return argument2;
}

#define multi_chance
///multi_chance(value1, chance1, value2, chance2, ..., [default_value])
/*
 * a different chance of returning each value
 * Example use:
 * value = set_chance(a, 10, b, 20, c, 40, d);
 * // ^ has a certain chance of returning a, b or c, and if not it returns d
 * (the final argument, default value, is optional)
 */
var count = argument_count; //get the number of arguments

//Loop through the arguments, adding values and chances to an array
var i = 0;
while (count > 1)
{
    value[i] = argument[i*2];
    chance[i] = argument[i*2+1];
    i++; //add to the number of values
    count -= 2; //remove 2 from the total argument count (2 arguments per value)
}
var total = i;

//Find out if there's a default value
var default_value = 0;
if (count == 1) //if there's 1 argument left, that is the default value
{
    default_value = argument[i*2];
}

//Default the final value to the default value (which is 0 if there's no default value)
var final_value = default_value;
//Get a random value
//var rand = random(100);
var current = 0;
//Loop through the values, checking if the random value satisfies that value
for (var i = 0; i < total; i++)
{
    current += chance[i];
    if (rand < current)
    {
        final_value = value[i];
        break;
    }
}

//Return the final value
return final_value;


#define ds_list_reverse
///ds_list_reverse(list)
/*
 * Returns the list given in the argument, but in reverse order
 */
var list = argument0;
var result = ds_list_create();
//Loop through the list in reverse order, adding each value to our resulting list
for (var i = ds_list_size(list)-1; i >= 0; i--)
{
    ds_list_add(result, list[|i]);
}
//Return the newly populated list
return result;


#define ds_list_random
///ds_list_random(list)
///Return a random value from a list
var list = argument0;
var size = ds_list_size(list)-1;
var i = irandom(size);
return list[|i];

#define ds_list_delete_all
///ds_list_delete_all(list, value)
///Remove all instances of a value from a list
var list = argument0;
var value = argument1;
var i = -1;
do
{
    i = ds_list_find_index(list, value);
    if (i != -1)
    {
        ds_list_delete(list, i);
    }
}
until (i == -1);


#define instance_list_random
///instance_list_random(object)
/*
 * Returns a list containing all the instances of an object, in a random order.
 *
 * Example use:
 *
   var list = instance_list_random(objPlayer);
   for (var i = 0; i < ds_list_size(list); i++)
   {
      with (list[|i]) //destroy all players, in a random order
      {
          instance_destroy();
      }
   }
 *
 */
var list = ds_list_create();
var obj = argument0;
with (obj)
{
    ds_list_add(list, id);
}
ds_list_shuffle(list);
return list;


#define instance_nearest_list
///instance_nearest_list(x, y, obj)
/*
 * Returns a list of instances in nearest order
 */
var xx = argument0;
var yy = argument1;
var obj = argument2;
var list = ds_list_create(); //initialise the list of objects
var inst;
do
{
    //Find the instance nearest to the x & y position
    inst = instance_nearest(xx, yy, obj);
    //If an instance is found, add it to the list
    //and deactivate the instance. It'll be
    //reactivated later.
    if (inst != noone)
    {
        ds_list_add(list, inst);
        instance_deactivate_object(inst);
    }
}
until (inst == noone); //break the loop when there's no more instances

//Reactivate the deactivated objects
for (var i = 0; i < ds_list_size(list); i++)
{
    instance_activate_object(list[|i]);
}

//Return the list of instances
return list;

#define mouse_over
///mouse_over()
///Returns true if cursor is within object's bounding box
return (mouse_x >= bbox_left &&
        mouse_x <= bbox_right &&
        mouse_y >= bbox_top &&
        mouse_y <= bbox_bottom);

#define stick_to
///stick_to(object, xoffset, yoffset)
var obj = argument0;
var xx = argument1;
var yy = argument2;
x = obj.x+xx;
y = obj.y+yy;

#define stick_to_angle
///stick_to_angle(object, xoffset, yoffset, angleoffset)
var obj = argument0;
var xx = argument1;
var yy = argument2;
var dis = point_distance(obj.x, obj.y, obj.x+xx, obj.y+yy);
var dir = point_direction(obj.x, obj.y, obj.x+xx, obj.y+yy);
x = obj.x+lengthdir_x(dis, dir+obj.image_angle);
y = obj.y+lengthdir_y(dis, dir+obj.image_angle);
image_angle = obj.image_angle+argument3;



#define within
///within(variable, value, within)
/*
 * Returns true if the given variable is close enough
 * to the given value (within a certain number)
 */
var a = argument0;
var b = argument1;
var c = argument2/2;
return (a > b-c && a < b+c);

