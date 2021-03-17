# Draw vs Red vs data
```
Red [ needs 'view ]

p: 10x10
s: 50x50
c: green
```

```
view [ base draw [ fill-pen c box p s ] button "change color" [ c: red ] ]
```
This doesn't work as Draw doesn't know what the variables (data) are, even though its right there above it...

```
view [ base draw compose [ fill-pen (c) box (p) (s) ] button "change color" [ c: red ] ]
```
We're pleasing Draw with some cruft, but now the button doesn't work. The color of fill-pen is a copy of c's value, not an instance of c.

```
view [ b: base draw compose [ fill-pen (c) box (p) (s) ] button "change color" [ b/draw b/draw/box/color: c ] ]
```
Now we try and fail to change the box color directly. The box isn't addressable; its essentially a render.

```
drawthis: compose [ fill-pen (c) box (p) (s) ]
view [ b: base draw [] button "change color" [ c: red b/draw: drawthis ] do [ b/draw: drawthis ] ]
```
This is getting annoying now: we've made the draw outside of Draw, then use it to redraw, but the draw data isn't picking up the change to c.
The data is a static snapshot of what it was when 1st defined.


```
redraw: func [ ] [ o: compose [ fill-pen (c) box (p) (s) ] b/draw: o ]
view [ b: base draw [] button "change color" [ c: red redraw ] do [ redraw ] ]
```
Works, but we're rebuilding the whole draw instead of changing something that's already there. box/color *cannot* be linked to c that's for sure!


... in other words Draw seems to be a renderer rather than a block containing objects.
