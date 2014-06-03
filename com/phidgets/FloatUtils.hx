package com.phidgets;

/**
 * ...
 * @author Andreas Rønning
 */
class FloatUtils
{
	public static inline function toPrecision(f:Float, depth:Int):Float {
		var d = Std.parseFloat("1e" + depth);
		return Math.round(f * d) / d;
	}
}