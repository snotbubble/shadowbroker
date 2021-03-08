Red [ needs 'view ]

;; reactor demo
;; react faces with reactor fields
;; use faces that don't match field types (float to color, string to color)
;; stress test with multiple copies as 'nodes'
;; made with expert help from Toomas Vooglaid and Gregg Irwin via red/help on gitter
;;
;; note: currently busted ui; faces are using container panel mouse events, workaround doesn't work with GTK atm...

clear-reactions
node: deep-reactor [
	name: "one"
	pos: 5x5
	color: 50.50.55
]

n: []	;; nodes
nl: []	;; node layouts
sidx: 1 ;; selected node

makenode: function [x] [
	u: compose/deep [
		panel 250x100 loose on-down [ 
			(reduce [to-set-path reduce ['sidx]]) (x)
		] on-up [
			(reduce [to-set-path reduce ['n length? n 'pos]]) face/offset
			getparams
		] react [
			(reduce [to-set-path reduce ['face 'offset]]) ( reduce [ to-path reduce [ 'n length? n 'pos ] ] )
			(reduce [to-set-path reduce ['face 'color]]) ( reduce [ to-path reduce [ 'n length? n 'color] ] )
			;print [ "base" (x) "reacted to data change: " ( reduce [ to-path reduce [ 'n length? n 'pos] ] )  ]
			;print [ "base" (x) "reacted to data change: " ( reduce [ to-path reduce [ 'n length? n 'color] ] )  ]
		] [
			below
			field 200x30 with [ text: (reduce [to-path reduce ['n length? n 'name]]) ] on-change [ probe (reduce [to-path reduce ['n length? n 'name]]) ] react [ (reduce [to-set-path reduce ['face 'text]]) (reduce [to-path reduce ['n length? n 'name]]) ]
			across
			slider 140x30 with [ data: (reduce [to-path reduce ['n length? n 'color 1]]) / 255.0 ] on-change [ 
				(reduce [to-set-path reduce ['n length? n 'color]]) to-tuple reduce [ to-integer  face/data * 255.0 (reduce [to-path reduce ['n length? n 'color 2]]) (reduce [to-path reduce ['n length? n 'color 3]]) ]
				;print [ "slider" (x) "on-change " (reduce [to-path reduce ['n length? n 'color]]) ]
			] react [
				(reduce [to-set-path reduce ['face 'data]]) (reduce [to-path reduce ['n length? n 'color 1]]) / 255.0
				;print [ "slider" (x) "reacted to data change : " probe (reduce [to-path reduce ['n length? n 'color]]) ]
			]
			field 50x30 with [ text: to-string (reduce [to-path reduce ['n length? n 'color 1]]) ] on-change [
				(reduce [to-set-path reduce ['n length? n 'color]]) to-tuple reduce [ to-integer (reduce [to-path reduce ['face 'text]]) (reduce [to-path reduce ['n length? n 'color 2]]) (reduce [to-path reduce ['n length? n 'color 3]]) ]
				;print [ "field" (x) "on-change : " probe (reduce [to-path reduce ['n length? n 'color 1]]) ]
			] react [
				(reduce [to-set-path reduce ['face 'text]]) to-string (reduce [to-path reduce ['n length? n 'color 1]])
				;print [ "field" (x) "reacted to data change : " probe (reduce [to-path reduce ['n length? n 'color 1]]) ]
			]
		]
	]
	u
]

getparams: func [] [
	print [ "selected node idx is: " sidx ]
	u: compose/deep [
		panel with [ size: paramview/size ] [
			below
			text "Node name"
			field with [ size: to-pair reduce [ (paramview/size/x - 30) 30 ] text: (reduce [to-path reduce ['n sidx 'name]]) ] react [ face/text: (reduce [to-path reduce ['n sidx 'name]]) ]
			pad 0x10 text "Node color"
			base with [ size: to-pair reduce [( paramview/size/x - 30) 30 ] color: (reduce [to-path reduce ['n sidx 'color]]) ] react [ face/color: (reduce [to-path reduce ['n sidx 'color]]) ]
			pad 0x10 text "Node position"
			panel with [ size: paramview/size ] [
				field 50x30 with [ text: to-string (reduce [to-path reduce ['n sidx 'pos 1]]) ]
				text 10x30 "x"
				field 50x30 with [ text: to-string (reduce [to-path reduce ['n sidx 'pos 2]]) ]
			]
		]
	]
	paramview/pane: layout/only copy/deep u
]

layoutnodes: function [cx ox oy] [
	m: to-integer (cx / 270.0)
	repeat i (length? n) [
		xx: 10 + ox + (((i - 1) % m) * 260)
		yy: 10 + oy + ((to-integer ((i - 1) / m)) * 110)
		n/(i)/pos: to-pair reduce [ (xx) (yy) ]
	]
]

v: layout [
	below
	nodeview: panel 600x600 [
		below
		c: panel 600x530 [ 
			p: panel 2000x2000 40.40.45 loose [ ] react [
				face/offset/y: (max (min 0 face/offset/y) (-2000 + face/parent/size/y))
				face/offset/x: (max (min 0 face/offset/x) (-2000 + face/parent/size/x))
				;p/offset/y: to integer! negate face/offset/y
			] 
		]
		nodebtns: panel 50.50.55 600x50 [
			button "make node" [
				nn: copy/deep node
				append n nn
				thisidx: length? n
				u: makenode thisidx
				append nl copy/deep u
				p/pane: layout/only nl
				layoutnodes c/size/x (negate p/offset/x) (negate p/offset/y)
			]
			button "layout nodes" [
				layoutnodes c/size/x (negate p/offset/x) (negate p/offset/y)
			]
		]
	]
	return
	paramview: panel 300x600 []
]

view/flags/options v [resize] [
	actors: object [
		on-resizing: function [face event][
			nodeview/size: face/size - 320x20
			c/size: nodeview/size - 0x70
			nodebtns/size/x: c/size/x
			nodebtns/offset/y: nodeview/size/y - 50
			paramview/offset/x: face/size/x - 310
			paramview/size/y: face/size/y - 20
		]
	]
]
