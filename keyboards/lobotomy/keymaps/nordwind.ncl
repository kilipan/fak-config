let { make_base, .. } = import "lib/nordwind.ncl" in
let keycode = import "fak/keycode.ncl" in
let de = import "lib/german.ncl" in

let paddings = {
  top = { left = 1, middle = 0, right = 1 },
  mid = { left = 0, middle = 0, right = 0 },
  bot = { left = 1, middle = 2, right = 1 },
  thm = { left = 0, middle = 0, right = 0 },
} in
let base = make_base paddings in

let { alph, numb, navi, symb, func, over } = base.keymap in

let kc = keycode.tap.reg.kc in
let fingers = 
  [kc.Q]
  @ std.array.slice 1 9 alph.fingers
  @ [kc.COMMA]
  @ std.array.slice 10 20 alph.fingers
  @ [kc.X]
  @ std.array.slice 21 24 alph.fingers
  @ [kc.V, de.QUOT]
  @ std.array.slice 26 29 alph.fingers
  @ [kc.DOT]
in

### default FAK keymap definition
{
  virtual_keys = base.virtual_keys,
  layers = [
    # Alpha layer
    fingers @ alph.thumbs @ base.combos_base,
    # Num layer
    numb.fingers @ numb.thumbs @ base.combos_numb,
    # Nav layer
    navi.fingers @ navi.thumbs @ base.combos_trans,
    # Sym layer
    symb.fingers @ symb.thumbs @ base.combos_trans,
    # Fun layer
    func.fingers @ func.thumbs @ base.combos_trans,
    # Overlay layer
    over.fingers @ over.thumbs @ base.combos_overlay,
  ],
}
