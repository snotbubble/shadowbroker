Red [ needs 'view ]

;; reactor demo
;; react faces with reactor fields
;; use faces that don't match field types (float to color, string to color)
;; stress test with multiple copies as 'nodes'
;; made with expert help from Toomas Vooglaid and Gregg Irwin via red/help on gitter
;; next steps: put node generation into a function
;; adapt layout to resizable UI

clear-reactions
node: deep-reactor [
	name: "one"
	pos: 5x5
	color: 50.50.55
]
n: []	;; nodes
nl: []	;; node layouts

layoutnodes: function [cx] [
	m: to-integer (cx / 270.0)
	repeat i (length? n) [
		xx: 10 + (((i - 1) % m) * 260)
		yy: 10 + ((to-integer ((i - 1) / m)) * 110)
		probe xx
		probe yy
		n/(i)/pos: to-pair reduce [ (xx) (yy) ]
		probe n/(i)/pos
	]
]

view [
	below
	c: panel 600x600 [ p: panel 1000x1000 40.40.45 loose [ ] ]
	button "make node" [
		
		nn: copy/deep node
		append n nn

		x: length? n
		u: compose/deep [
			panel 250x100 loose react [
				face/offset: ( reduce [ to-path reduce [ 'n length? n 'pos ] ] )
				face/color: ( reduce [ to-path reduce [ 'n length? n 'color] ] )
				print [ "base" (x) "reacted to data change: " ( reduce [ to-path reduce [ 'n length? n 'pos] ] )  ]
				print [ "base" (x) "reacted to data change: " ( reduce [ to-path reduce [ 'n length? n 'color] ] )  ]
			] [
				below
				field 200x30 with [ text: (reduce [to-path reduce ['n length? n 'name]]) ] on-change [ probe (reduce [to-path reduce ['n length? n 'name]]) ] react [ face/text: (reduce [to-path reduce ['n length? n 'name]]) ]
				across
				slider 140x30 with [ data: (reduce [to-path reduce ['n length? n 'color 1]]) / 255.0 ] on-change [ 
					rr: to-integer face/data * 255.0
					gg: (reduce [to-path reduce ['n length? n 'color 2]])
					bb: (reduce [to-path reduce ['n length? n 'color 3]])
					(reduce [to-set-path reduce ['n length? n 'color]]) to-tuple reduce [ rr gg bb ]
					print [ "slider" (x) "on-change " (reduce [to-path reduce ['n length? n 'color]]) ]
				] react [
					face/data: (reduce [to-path reduce ['n length? n 'color 1]]) / 255.0
					print [ "slider" (x) "reacted to data change : " probe (reduce [to-path reduce ['n length? n 'color]]) ]
				]
				field 50x30 with [ text: to-string (reduce [to-path reduce ['n length? n 'color 1]]) ] on-change [
					rr: to-integer face/text
					gg: (reduce [to-path reduce ['n length? n 'color 2]])
					bb: (reduce [to-path reduce ['n length? n 'color 3]])
					(reduce [to-set-path reduce ['n length? n 'color]]) to-tuple reduce [ rr gg bb ]
					print [ "field" (x) "on-change : " probe (reduce [to-path reduce ['n length? n 'color 1]]) ]
				] react [
					face/text: to-string (reduce [to-path reduce ['n length? n 'color 1]])
					print [ "field" (x) "reacted to data change : " probe (reduce [to-path reduce ['n length? n 'color 1]]) ]
				]
			]
		]
		probe u
		append nl copy/deep u
		p/pane: layout/only nl
		layoutnodes c/size/x
	]
	button "layout nodes" [
		layoutnodes c/size/x
	]
	
]
