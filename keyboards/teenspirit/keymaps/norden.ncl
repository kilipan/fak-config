let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let de = import "lib/german.ncl" in
let util = import "fak/util_functions.ncl" in

# convenience aliases
# taps
let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = tap.reg.mod in
# holds
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
  SZ = kc.MINS,
  AE = kc.QUOT,
  OE = kc.SCLN,
  UE = kc.LBRC,
  PRNS = macro.make [
    macro.tap de.LPRN,
    macro.tap de.RPRN,
    macro.tap kc.LEFT,
  ],
  BRCS = macro.make [
    macro.tap de.LBRC,
    macro.tap de.RBRC,
    macro.tap kc.LEFT,
  ],
  CBRS = macro.make [
    macro.tap de.LCBR,
    macro.tap de.RCBR,
    macro.tap kc.LEFT,
  ],
} in

# 0  1  2  3   4  5  6  7
#    8  9 10  11 12 13
#      14 15  16 17

let virtual_keys' = [
  # alpha
  combo.make 25 [1, 2],   # W
  combo.make 25 [1, 3],   # K
  combo.make 25 [2, 3],   # P
  combo.make 25 [4, 5],   # BSPC
  combo.make 25 [4, 6],   # V
  combo.make 25 [5, 6],   # DELETE
  combo.make 25 [8, 9],   # M
  combo.make 25 [8, 10],  # Z
  combo.make 25 [9, 10],  # F
  combo.make 25 [11, 12], # MINUS
  combo.make 25 [11, 13], # ENTER
  combo.make 25 [12, 13], # X
  combo.make 25 [2, 10],  # Q
  combo.make 25 [5, 11],  # J
  # alpha non-adjacent
  combo.make 25 [1, 15],  # ß
  combo.make 25 [7, 16],  # Ä
  combo.make 25 [12, 16],  # Ö
  combo.make 25 [13, 16], # Ü
  # sym
  combo.make 25 [4, 7],   # ctrl-bspc
  combo.make 25 [1, 9],   # BACKSLSH
  combo.make 25 [6, 12],  # SLSH
  combo.make 25 [12, 17], # SEMI
  combo.make 25 [13, 17], # COLON
  # parentheticals
  combo.make 25 [1, 8],  # {}left
  combo.make 25 [2, 9],  # []left
  combo.make 25 [3, 10], # ()left
  combo.make 25 [1, 10], # <
  combo.make 25 [6, 11], # >
  combo.make 25 [4, 11], # y, formerly )
  combo.make 25 [5, 12], # comma, formerly ]
  combo.make 25 [6, 13], # dot, formerly }
  # nav
  combo.make 25 [0, 3], # ESC
  combo.make 25 [5, 7], # DEL
  combo.make 25 [4, 13], # C-BSPC
  combo.make 25 [3, 8], # TAB
  # caps
  combo.make 25 [3, 4], # caps word
  combo.make 25 [1, 6], # caps lock
] in
let combos_base = [
  kc.W, kc.K, kc.P, kc.BSPC, kc.V, kc.DEL,
  kc.M, kc.Y, kc.F, de.MINS, kc.ENTER, kc.X,
  kc.Q, kc.J,
  cu.SZ, cu.AE, cu.OE, cu.UE,
  md.lctl & kc.BSPC, de.BSLS, de.SLSH, de.SCLN, de.COLN,
  cu.CBRS, cu.BRCS, cu.PRNS, de.LABK, de.RABK, kc.Z, kc.COMMA, kc.DOT,
  kc.ESC, kc.DEL, md.lctl & kc.BSPC, kc.TAB,
  fak.CWTG, kc.CAPS_LOCK,
] in
let combos_num = [
  kc.N0, tt & ht, kc.N8, kc.N8, tt & ht, kc.N0,
  kc.N9, tt & ht, kc.N7, kc.N7, tt & ht, kc.N9,
  kc.PPLS,
  tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht,
] in



let virtual_key_count = std.array.length virtual_keys' in
let key_count = 18 + virtual_key_count in

let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
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
      (if std.array.elem mod [mdh.lgui, mdh.rgui, mdh.lalt, mdh.ralt] then 'none else 'hold)
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
    kc.TAB  & lt 1 & hold.reg.behavior thumb_behavior,
    kc.S    & lt 2 & hold.reg.behavior thumb_behavior,
    kc.SPC  & lt 3 & hold.reg.behavior thumb_behavior,
    de.QUOT & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in

let layouts = {
  APTMIN = "RSTHNAIOCGDLUY",
  APTMIN_DE = "RSTHNAIOCGDLUZ",
  NORDMIN = "RNTHCEIALDBGOU",
} in

### Keymap itself! ###
{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.NORDMIN) |> std.array.at key_idx in
    # ALPHAS
    [
      base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,
               base 8,  base 9,  base 10, base 11, base 12, base 13,
                        thumb 0, thumb 1, thumb 2, thumb 3,
    ] @ combos_base,
    # NUM
    [
      kc.DOT,       kc.N6,        kc.N5,        kc.N4,        kc.N4,   kc.N5,   kc.N6,   kc.DOT,
                    kc.N3,        kc.N2,        kc.N1,        kc.N1,   kc.N2,   kc.N3,
                                  tt & ht,      tt & ht,      kc.E,    kc.N0,
    ] @ combos_num,
    # NAV
    [
      sk.lctl & ht, sk.lalt & ht, sk.lgui & ht, sk.lsft & ht, kc.LEFT,    kc.DOWN,    kc.UP,     kc.RIGHT,
                    cu.COPY,      cu.CUT,       cu.PSTE,      kc.HOME,    media.MUTE, kc.END,
                                  tt & ht,      tt & ht,      media.VOLD, media.VOLU,
    ] @ combos_base,
    # SYM
    [
      ks.EXLM, de.AT,   de.HASH, ks.DLR,  de.AMPR, de.ASTR, ks.PERC, de.CIRC,
               de.GRV,  de.DQUO, de.UNDS, de.BSLS, de.PIPE, de.EQL,
                        de.TILD, de.DEGR, tt & ht, tt & ht,
    ] @ combos_base,
    # FUN
    [
      fak.BOOT, kc.F12,   kc.F11,  kc.F10,  kc.F4,   kc.F5,   kc.F6,   tt & ht,
                kc.F9,    kc.F8,   kc.F7,   kc.F1,   kc.F2,   kc.F3,
                          tt & ht, tt & ht, tt & ht, tt & ht,
    ] @ combos_base,
  ]
}
