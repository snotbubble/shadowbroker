Red [ needs 'view ]
;; how to make a two-way link a view field with an object field
;; made with help from Greg Irwin and Toomas Vooglaid
;; unresolved issues: 
;; [ ] new node inherits name of previous node
;; [ ] reset button not working when there's more than one node
;; [ ] select node yields correct array index
;; [ ] assess need to store node ui in the node object.
node: reactor [
	name: "one"
	ui: [ panel 120x50 50.50.55 loose [ field 60x30 name react [ face/text: node/name ] ] ]
]
n: []	;; nodes
nl: []	;; instances of node ui to display
view [
	below
	p: panel 40.40.45 [ ]
	button "make node" [ 
		nn: copy node
		append n nn
		u: compose/deep [ panel 120x50 50.50.55 loose [ field 60x30 on-change [ probe (reduce [to-path reduce ['n length? n ]]) ] react [ face/text: (reduce [to-path reduce ['n length? n 'name]]) ] ] ]
		probe u
		append nl u
		p/pane: layout/only nl
	]
	button "rest node 1" [ n/1/name: "two" probe n/1 ]
]
