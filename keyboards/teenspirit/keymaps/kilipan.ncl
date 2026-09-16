let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in

# convenience aliases
# taps
let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = tap.reg.mod in
# holds
# let kch = hold.reg.kc in
# let ksh = hold.reg.ks in
let mdh = hold.reg.mod in
# sticky key
let sk = tap.sticky.mod in
# layer control
let lt = hold.reg.layer in
# boot, reset, etc
let fak = tap.custom.fak in
# media and mouse control
let media = tap.custom.media in
let mouse = tap.custom.mouse in
# keymap stuff
let tx = tap.none in
let tt = tap.trans in
let hx = hold.none in
let ht = hold.trans in

let cu = {
  # copy custom stuff from example
  COPY = md.lctl & kc.C,
  PSTE = md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
  SCH  = macro.make [
    macro.tap kc.S,
    macro.release mdh.rsft,
    macro.tap kc.C,
    macro.tap kc.H,
  ],
  SZ = macro.make [ macro.press mdh.ralt, macro.tap kc.S,    macro.release mdh.ralt, ],
  AE = macro.make [ macro.press mdh.ralt, macro.tap ks.DQUO, macro.release mdh.ralt, macro.tap kc.A, ],
  OE = macro.make [ macro.press mdh.ralt, macro.tap ks.DQUO, macro.release mdh.ralt, macro.tap kc.O, ],
  UE = macro.make [ macro.press mdh.ralt, macro.tap ks.DQUO, macro.release mdh.ralt, macro.tap kc.U, ],
} in

let virtual_keys' = [
  # alpha
  combo.make 25 [0, 1],   # W
  combo.make 25 [1, 2],   # M
  combo.make 25 [2, 3],   # B
  combo.make 25 [4, 5],   # V
  combo.make 25 [5, 6],   # comma
  combo.make 25 [6, 7],   # dot
  combo.make 25 [8, 9],   # F
  combo.make 25 [9, 10],  # P
  combo.make 25 [11, 12], # X
  combo.make 25 [12, 13], # Z
  # alpha non-adjacent
  combo.make 25 [1, 3],   # SCH
  combo.make 25 [8, 10],  # Q
  combo.make 25 [2, 10],  # K 2.0
  combo.make 25 [5, 11],  # J 2.0
  combo.make 25 [1, 15],  # ß
  combo.make 25 [5, 16],  # Ä
  combo.make 25 [7, 16],  # Ö
  combo.make 25 [12, 16], # Ü
  # sym
  combo.make 25 [1, 9],   # MINUS
  combo.make 25 [6, 12],  # SLSH
  combo.make 25 [12, 17], # SEMI
  combo.make 25 [13, 17], # COLON
  # parentheticals
  combo.make 25 [1, 8],  # {
  combo.make 25 [2, 9],  # [
  combo.make 25 [3, 10], # (
  combo.make 25 [1, 10], # <
  combo.make 25 [6, 11], # >
  combo.make 25 [4, 11], # )
  combo.make 25 [5, 12], # ]
  combo.make 25 [6, 13], # }
  # nav
  combo.make 25 [0, 3], # ESC
  combo.make 25 [11, 13], # ENT
  combo.make 25 [4, 6], # BSPC
  combo.make 25 [5, 7], # DEL
  combo.make 25 [4, 7], # C-BSPC
  # caps
  combo.make 25 [3, 4], # caps word
  combo.make 25 [1, 6], # caps lock
] in
let combos_base = [
  kc.W, kc.M, kc.B, kc.V, kc.COMMA, kc.DOT,
        kc.F, kc.P, kc.X, kc.Z,
  cu.SCH, kc.Q, kc.K, kc.J, cu.SZ, cu.AE, cu.OE, cu.UE,
  kc.MINS, kc.SLSH, kc.SCLN, ks.COLN,
  ks.LCBR, kc.LBRC, ks.LPRN, ks.LABK, ks.RABK, ks.RPRN, kc.RBRC, ks.RCBR,
  kc.ESC, kc.ENT, kc.BSPC, kc.DEL, md.lctl & kc.BSPC,
  fak.CWTG, kc.CAPS_LOCK,
] in

#  w m b    v , .
# r s t h  n a i o
#      k    j
#   c g d  l u y
#    f p    x z
#     q
# 
#          e
# 
#    w b    x z
#   l m d  g o u
#      k    j
# n r t h  c e i a
#  v p y    f , .
# 
#       s


let virtual_key_count = std.array.length virtual_keys' in
let key_count = 18 + virtual_key_count in

let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let layouts = {
  APTMIN = "RSTHNAIOCGDLUY",
} in

let make_hrm = fun key_idx =>
  let htb_hrm_base = fun eager => {
    timeout_ms = 150,
    # quick_tap_ms = 100,
    # quick_tap_interrupt_ms = 500,
    # global_quick_tap_ms = 80,
    eager_decision = eager,
    timeout_decision = 'hold,
  } in

  let virtual_interrupts = std.array.replicate virtual_key_count ki.hr in

  let htb_hrm_left = fun eager => htb_hrm_base eager & {
    key_interrupts = [
      ki.tr, ki.tr, ki.tr, ki.tr, ki.hr, ki.hr, ki.hr, ki.hr,
             ki.tp, ki.tp, ki.tp, ki.hr, ki.hr, ki.hr,
                    ki.hr, ki.hr, ki.hr, ki.hr,
    ] @ virtual_interrupts
  } in

  let htb_hrm_right = fun eager => htb_hrm_base eager & {
    key_interrupts = [
      ki.hr, ki.hr, ki.hr, ki.hr, ki.tr, ki.tr, ki.tr, ki.tr,
             ki.hr, ki.hr, ki.hr, ki.tp, ki.tp, ki.tp,
                    ki.hr, ki.hr, ki.hr, ki.hr,
    ] @ virtual_interrupts
  } in

  let hrm_mods = [
    mdh.lctl, mdh.lalt, mdh.lgui, mdh.lsft,
    mdh.rsft, mdh.rgui, mdh.lalt, mdh.rctl,
  ] in

  let hrm_key_indices = [0, 1, 2, 3, 4, 5, 6, 7] in

  if std.array.elem key_idx hrm_key_indices then
    let mod_idx = util.array.index_of key_idx hrm_key_indices in
    let side = if mod_idx < (std.array.length hrm_mods / 2) then 'left else 'right in
    let mod = std.array.at mod_idx hrm_mods in

    mod & hold.reg.behavior (
      (if side == 'left then htb_hrm_left else htb_hrm_right)
      (if mod == mdh.lgui || mod == mdh.rgui || mod == mdh.lalt || mod == mdh.ralt then 'none else 'hold)
    )
  else
    {}
in

let alphas = fun layout => layout
  |> std.string.characters
  |> util.array.enumerate
  |> std.array.map (
      fun { index, value } => kc."%{value}"
      & make_hrm index
    )
in

let thumb = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    kc.QUOT & lt 1 & hold.reg.behavior thumb_behavior,
    kc.SPC  & lt 2 & hold.reg.behavior thumb_behavior,
    kc.E    & lt 3 & hold.reg.behavior thumb_behavior,
    kc.TAB  & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in

### Keymap itself! ###
{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.APTMIN) |> std.array.at key_idx in
    # ALPHAS
    [
      base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,
               base 8,  base 9,  base 10, base 11, base 12, base 13,
                        thumb 0, thumb 1, thumb 2, thumb 3,
    ] @ combos_base,
    # NUM
    [
      kc.PPLS & ht, kc.PMNS & ht, kc.PAST & ht, kc.PSLS & ht, kc.N4,   kc.N5,   kc.N6,   kc.DOT,
                    kc.N9,        kc.N8,        kc.N7,        kc.N1,   kc.N2,   kc.N3,
                                  tt & ht,      tt & ht,      kc.E,    kc.N0,
    ] @ combos_base,
    # NAV
    [
      sk.lctl & ht, sk.lalt & ht, sk.lgui & ht, sk.lsft & ht, kc.LEFT, kc.DOWN, kc.UP,  kc.RGHT,
                    media.VOLD,   kc.PGDN,      media.VOLU,   kc.HOME, kc.PGUP, kc.END,
                                  tt & ht,      tt & ht,      sk.ralt, tt & ht,
    ] @ combos_base,
    # SYM
    [
      ks.EXLM, ks.AT,   ks.HASH, ks.DLR,  ks.AMPR, ks.ASTR, ks.PERC, ks.CIRC,
               kc.GRV,  ks.DQUO, ks.UNDS, kc.BSLS, ks.PIPE, kc.EQL,
                        ks.TILD, tt & ht, tt & ht, tt & ht,
    ] @ combos_base,
    # FUN
    [
      fak.BOOT, kc.F12,   kc.F11,  kc.F10,  kc.F4,   kc.F5,   kc.F6,   tt & ht,
                kc.F9,    kc.F8,   kc.F7,   kc.F1,   kc.F2,   kc.F3,
                          tt & ht, tt & ht, tt & ht, tt & ht,
    ] @ combos_base,
  ]
}
