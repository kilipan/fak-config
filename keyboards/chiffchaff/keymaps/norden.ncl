let { make_base, .. } = import "lib/norden.ncl" in

let paddings = {
  top = { left = 1, middle = 0, right = 1 },
  mid = { left = 0, middle = 0, right = 0 },
  bot = { left = 0, middle = 0, right = 0 },
  thm = { left = 1, middle = 0, right = 1 },
} in
let base = make_base paddings in

let { alph, numb, navi, symb, func, over } = base.keymap in

### default FAK keymap definition
{
  virtual_keys = base.virtual_keys,
  layers = [
    # Alpha layer
    alph.fingers @ alph.thumbs @ base.combos_base,
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
