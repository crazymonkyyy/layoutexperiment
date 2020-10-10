
The design of my layout lib experiment:

Its based quite heavyly on css grids, look up something, The terminlogy is based on my understanding of fr and tracks etc.

Its an experiment to prove that its possible, and to enable extra wieght to future rants. Probaly dont use it as is, its has glaring bugs, it should probaly be adopted and intergated into a toolkit, or biult into one, it required spamming of casts to get the int promotion to play nice. If you had knew the format of the rectangle primitive and matched the typing, those could be removed.

Anyway, to start with the main type is "size", which is main up of 3 part and I was aiming for "complex value" syntax, so that you only need to define one part of it, an int representing charatars, fr units pulled straight from css, and pix for pixels. After playing with it some more this sould probaly have a "minmax" part and a;ll the extra math that requires.

An array of sizes defines a track, which defines spilting of a 1d range into pixels length. You stack two tracks on top of each other to make a grid.

A grid coloring is a collection of keys in a 2d array, that should produce recangles of simple whole numbers that don't overlap; this isnt enforced and probaly should be.

Combine a grid with a grid coloring and you have a layout. Which is a deleagate that takes a x and y and returns a collection of colored rectangles that exist in that x and y.

Now screen keys are a bit up in the air, I implimented the first idea with slight modification as I think css grids have a list of screens somewhere so I didnt have anythin to go off of. But anyway, a screen key is a vec2 of sizes and will treat fr units as a aspect ratio.... kinda; that code in pretictualer is awful if you have a better idea how to deside that 1050x720 is closer to 1080x720 then 4k. Its roughly based on distence and scaling.

So the user defines a AA of keys, and delegates that take rectangles(to then draw in thier rect), a AA of screen keys and layouts and you have reactive layouts. In thoery, you could also tell where the mouse is and send mouse events. 

I don't think this can be cleanly genertic; it kinda works but really int promotion rules I think get in the way of even a slightly different type primitive.

Also reactive text sizes should be a thing, but I'm unsure of the how to mesh these two idea together, but they should be. Imagine a list of tabs, if the layout generates the rectangles where the tabs fit, and you know the strings at compile time, you should be able to calculate the best text size at run time cleanly using genertic functions.

