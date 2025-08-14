package main

import "core:fmt"
import "core:math"
import "core:math/linalg"
import sdl "vendor:sdl3"

collide_player :: proc(n: Player_Number, pos: [2]f32, rad: f32) -> bool
{
  result := false
  switch n {
  case .one: 
    result = collide(pos, rad, player_1.pos, player_1.COLLIDE_RAD)
  case .two: 
    result = collide(pos, rad, player_2.pos, player_2.COLLIDE_RAD)
  }
	return result
}

collide :: proc(p0: [2]f32, r0: f32, p1: [2]f32, r1: f32) -> bool
{
	return linalg.length(p0 - p1) - (r0 + r1) < 0 
}

collide_inf_line_circle :: proc(c_pos: [2]f32, c_rad: f32, la: [2]f32, lb: [2]f32) -> bool
{
	g := la - c_pos
	a := linalg.dot(lb, lb)
	b := 2 * linalg.dot(lb, g)
	c := linalg.dot(g, g) - c_rad * c_rad
	d := b * b - 4 * a * c

	return d >= 0
}

collide_line_seg :: proc(a0: [2]f32, a1: [2]f32, b0: [2]f32, b1: [2]f32) -> bool
{
	// (line2->p2.y - line2->p1.y)*(line1->p2.x-line1->p1.x) -
	// (line2->p2.x - line2->p1.x)*(line1->p2.y-line1->p1.y);
	d := ((b1.y - b0.x) * (a1.x - a0.x) - (b1.x - b0.x) * (a1.y - a0.y))
	if d == 0 {
		return false
	}

	// (line2->p2.x - line2->p1.x)*(line1->p1.y-line2->p1.y) - 
	// (line2->p2.y - line2->p1.y)*(line1->p1.x-line2->p1.x);
	a := ((b1.x - b0.x) * (a0.y - b0.y) - (b1.y - b0.y) * (a0.x - b0.x)) / d

	// (line1->p2.x - line1->p1.x)*(line1->p1.y - line2->p1.y) -
	// (line1->p2.y - line1->p1.y)*(line1->p1.x - line2->p1.x);
	b := ((a1.x - a0.x) * (a0.y - b0.y) - (a1.y - a0.y) * (a0.x - b0.x)) / d

	if a >= 0 && a <= 1 && b >= 0 && b <= 1 {
	    return true
	}
	return false
}




// LINE/CIRCLE
collide_line_seg_circle :: proc(x1: f32, y1: f32, x2: f32, y2: f32, cx: f32, cy: f32, r: f32) -> bool
{
  // is either end INSIDE the circle?
  // if so, return true immediately
  inside1 := collide_point_circle(x1,y1, cx,cy,r)
  inside2 := collide_point_circle(x2,y2, cx,cy,r)
  if inside1 || inside2 {
  	return true
  }

  // get length of the line
  distX: f32 = x1 - x2
  distY: f32 = y1 - y2
  len := math.sqrt( (distX*distX) + (distY*distY) )

  // get dot product of the line and circle TODO: use linalge
  dot := ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / math.pow(len,2)

  // find the closest point on the line
  closestX := x1 + (dot * (x2-x1))
  closestY := y1 + (dot * (y2-y1))

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  onSegment := line_point(x1,y1,x2,y2, closestX,closestY)
  if (!onSegment) {
  	return false
  }

  // get distance to closest point
  distX = closestX - cx;
  distY = closestY - cy;
  distance := math.sqrt( (distX*distX) + (distY*distY) )

  if (distance <= r) {
    return true
  }
  return false
}


// POINT/CIRCLE
collide_point_circle :: proc(px: f32, py: f32, cx: f32, cy: f32, r: f32) -> bool
{
  // get distance between the point and circle's center
  // using the Pythagorean Theorem
  distX := px - cx
  distY := py - cy
  distance := math.sqrt( (distX*distX) + (distY*distY) )

  // if the distance is less than the circle's
  // radius the point is inside!
  if (distance <= r) {
    return true;
  }
  return false;
}


// LINE/POINT
line_point :: proc(x1: f32, y1: f32, x2: f32, y2: f32, px: f32, py: f32) -> bool {

  // get distance from the point to the two ends of the line
  d1 := linalg.distance([2]f32{px, py}, [2]f32{x1, y1})
  d2 := linalg.distance([2]f32{px, py}, [2]f32{x2, y2})

  // get the length of the line
  lineLen := linalg.distance([2]f32{x1, y1}, [2]f32{x2,y2})

  // since floats are so minutely accurate, add
  // a little buffer zone that will give collision
  buffer := f32(0.1)    // higher # = less accurate

  // if the two distances are equal to the line's
  // length, the point is on the line!
  // note we use the buffer here to give a range,
  // rather than one #
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true
  }
  return false
}

test_collides :: proc()
{
	fmt.println("\n:: test collide_inf_line_circle ::")
	fmt.println("1 -> ", collide_inf_line_circle({3, 3}, 1, {0, 0}, {3, 3}))
	fmt.println("2 -> ", collide_inf_line_circle({3, 3}, 1, {0, 0}, {2, 5}))
	fmt.println("3 -> ", collide_inf_line_circle({3, 3}, 1, {0, 0}, {1, 1}))
	fmt.println("4 -> ", collide_inf_line_circle({3, 3}, 1, {0, 0}, {4, 2}))
	fmt.println("5 -> ", collide_inf_line_circle({3, 3}, 1, {0, 0}, {2, 1.5}))

	fmt.println("\n:: test collide_lines ::")
	fmt.println("1 -> ", collide_line_seg({0, 0}, {3, 3}, {1, 0}, {1, 3})) 
	fmt.println("2 -> ", collide_line_seg({0, 0}, {3, 3}, {4, 0}, {4, 3}))

	fmt.println("\n:: test collide_line_circle ::")
	fmt.println("1 -> ", collide_line_seg_circle(0,0,3,3, 3,3,1)) // <- true    
	fmt.println("2 -> ", collide_line_seg_circle(0,0,3,3, 5,5,1)) // <- false  
	fmt.println("3 -> ", collide_line_seg_circle(0,0,3,3, 5,5,3)) // <- true     
	fmt.println("4 -> ", collide_line_seg_circle(0,0,4,2, 3,3,1)) // <- false       

	fmt.println()
}

