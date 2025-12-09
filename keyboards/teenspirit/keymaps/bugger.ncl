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
let sl = tap.sticky.layer in
# layer control
let lt = hold.reg.layer in
let to = tap.layer.TO in
let ttlx = tap.tlex in
let htlx = hold.tlex in
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
  COPY = md.lctl & kc.C,
  PSTE = md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
  SCH  = macro.make [
    macro.tap kc.S,
    macro.release mdh.rsft,
    macro.tap kc.C,
    macro.tap kc.H,
  ],
  de_SZ = kc.MINS,
  de_AE = kc.QUOT,
  de_OE = kc.SCLN,
  de_UE = kc.LBRC,
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
  RL = macro.make [ macro.tap kc.R, macro.tap kc.L, ],
  DT = macro.make [ macro.tap kc.D, macro.tap kc.T, ],
  HM = macro.make [ macro.tap kc.H, macro.tap kc.M, ],
  SC = macro.make [ macro.tap kc.S, macro.tap kc.C, ],
  EO = macro.make [ macro.tap kc.E, macro.tap kc.O, ],
  UI = macro.make [ macro.tap kc.U, macro.tap kc.I, ],
  WR = macro.make [ macro.tap kc.W, macro.tap kc.R, ],
  BT = macro.make [ macro.tap kc.B, macro.tap kc.T, ],
  MF = macro.make [ macro.tap kc.M, macro.tap kc.F, ],
  GS = macro.make [ macro.tap kc.G, macro.tap kc.S, ],
  OE = macro.make [ macro.tap kc.O, macro.tap kc.E, ],
  IU = macro.make [ macro.tap kc.I, macro.tap kc.U, ],
} in

# 0  1  2  3   4  5  6  7
#    8  9 10  11 12 13
#      14 15  16 17

let virtual_keys' = [
  # alpha
  combo.make 25 [4, 5],   # BSPC
  combo.make 25 [5, 6],   # DELETE
  combo.make 25 [11, 12], # MINUS
  combo.make 25 [11, 13], # ENTER
  # alpha non-adjacent
  combo.make 25 [4, 17],  # ß
  combo.make 25 [7, 17],  # Ä
  combo.make 25 [5, 17], # Ö
  combo.make 25 [6, 17], # Ü
  # sym
  combo.make 25 [4, 6],   # ctrl-bspc
  combo.make 25 [1, 9],   # BACKSLSH
  combo.make 25 [6, 12],  # SLSH
  combo.make 25 [12, 17], # SEMI
  combo.make 25 [13, 17], # COLON
  # vertical combos
  combo.make 25 [1, 8],  # RL / WR
  combo.make 25 [2, 9],  # DT / BT
  combo.make 25 [3, 10], # HM / MF
  combo.make 25 [4, 11], # SC / GS
  combo.make 25 [5, 12], # EO / OE
  combo.make 25 [6, 13], # UI / IU
  # nav
  combo.make 25 [9, 10], # ESC
  combo.make 25 [2, 3], # TAB
  # caps
  combo.make 25 [3, 4], # caps word
  combo.make 25 [1, 6], # caps lock
] in
let combos_L1 = [
  kc.BSPC, kc.DEL,
  de.MINS, kc.ENTER,
  cu.de_SZ, cu.de_AE, cu.de_OE, cu.de_UE,
  md.lctl & kc.BSPC, de.BSLS, de.SLSH, de.SCLN, de.COLN,
  cu.RL, cu.DT, cu.HM, cu.SC, cu.EO, cu.UI,
  kc.ESC, kc.TAB,
  fak.CWTG, kc.CAPS_LOCK,
] in
let combos_L2 = [
  kc.BSPC, kc.DEL,
  de.MINS, kc.ENTER,
  cu.de_SZ, cu.de_AE, cu.de_OE, cu.de_UE,
  md.lctl & kc.BSPC, de.BSLS, de.SLSH, de.SCLN, de.COLN,
  cu.WR, cu.BT, cu.MF, cu.GS, cu.OE, cu.IU,
  kc.ESC, kc.TAB,
  fak.CWTG, kc.CAPS_LOCK,
] in
let combos_num = [
  tt & ht, tt & ht,
  tt & ht, ttlx,
  tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  cu.COPY, cu.CUT, cu.PSTE, kc.N7, kc.N8, kc.N9, 
  ttlx, tt & ht,
  kc.SPC, tt & ht,
] in
let combos_sym = [
  tt & ht, tt & ht,
  de.PLUS, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, de.LABK, de.RABK, tt & ht, tt & ht,
  de.LCBR, de.LBRC, de.LPRN, de.RPRN, de.RBRC, de.RCBR, 
  tt & ht, tt & ht,
  tt & ht, tt & ht,
] in
let combos_trans = [
  tt & ht, tt & ht,
  tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, 
  tt & ht, tt & ht,
  tt & ht, tt & ht,
] in
let combos_overlay = [
  tt & ht, tt & ht,
  tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht,
  tt & ht, tt & ht, de.SZ, tt & ht, tt & ht,
  tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, 
  tt & ht, tt & ht,
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
    mdh.lctl, mdh.lalt, mdh.lgui, mdh.lsft & lt 5,
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
      # comment in for hrm
      & make_hrm index
    )
in

# thumb keys
let t_L1 = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    to 2    & lt 2 & hold.reg.behavior thumb_behavior,
    sl 1    & lt 1 & hold.reg.behavior thumb_behavior,
    kc.SPC  & lt 3 & hold.reg.behavior thumb_behavior,
    de.QUOT & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in
let t_L2 = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    to 2,
    sl 1,
    kc.SPC  & lt 3 & hold.reg.behavior thumb_behavior,
    de.QUOT & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in

let layouts = {
  BUGGER_L1 = "NLDMSOUARTHCEI",
  BUGGER_L2 = "PXVKZJ,YWBFGQ.",
} in

### Keymap itself! ###
{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.BUGGER_L1) |> std.array.at key_idx in
    # ALPHA 1
    [
      base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,
               base 8,  base 9,  base 10, base 11, base 12, base 13,
                        t_L1 0,  t_L1 1,  t_L1 2,  t_L1 3,
    ] @ combos_L1,
    let base = fun key_idx => (alphas layouts.BUGGER_L2) |> std.array.at key_idx in
    # ALPHA 2
    [
      base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,
               base 8,  base 9,  base 10, base 11, base 12, base 13,
                        t_L2 0,  t_L2 1,  t_L2 2,  t_L2 3,
    ] @ combos_L2,
    # NUM
    [
      tt & ht, kc.HOME, kc.UP,   kc.END,  kc.N4,   kc.N5,   kc.N6,   kc.DOT,
               kc.LEFT, kc.DOWN, kc.RGHT, kc.N1,   kc.N2,   kc.N3,
                        to 0,    ttlx,    ttlx,    kc.N0,
    ] @ combos_num,
    # NAV
    # [
    #   sk.lctl & ht, sk.lalt & ht, sk.lgui & ht, sk.lsft & ht, kc.LEFT,    kc.DOWN,    kc.UP,     kc.RIGHT,
    #                 cu.COPY,      cu.CUT,       cu.PSTE,      kc.HOME,    media.MUTE, kc.END,
    #                               tt & ht,      tt & ht,      media.VOLD, media.VOLU,
    # ] @ combos_trans,
    # SYM
    [
      ks.EXLM, de.GRV,  de.DQUO, de.UNDS, de.BSLS, de.PIPE, de.EQL,  de.CIRC,
               de.AT,   de.HASH, ks.DLR,  de.AMPR, de.ASTR, ks.PERC,
                        de.TILD, de.DEGR, tt & ht, tt & ht,
    ] @ combos_sym,
    # FUN
    [
      fak.BOOT, kc.F12,   kc.F11,  kc.F10,  kc.F4,   kc.F5,   kc.F6,   tt & ht,
                kc.F9,    kc.F8,   kc.F7,   kc.F1,   kc.F2,   kc.F3,
                          tt & ht, tt & ht, tt & ht, tt & ht,
    ] @ combos_trans,
    [
      tt & ht, tt & ht, tt & ht, tt & ht,    tt & ht, tt & ht, tt & ht, tt & ht,
               tt & ht, tt & ht, tt & ht,    tt & ht, tt & ht, tt & ht,
                        tt & ht, tt & ht,    tt & ht, tt & ht,
    ] @ combos_overlay,
  ]
}
