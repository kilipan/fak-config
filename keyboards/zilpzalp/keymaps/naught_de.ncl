let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let de = import "lib/german.ncl" in
let util = import "fak/util_functions.ncl" in

let virtual_keys' = [
  # alpha
  combo.make 25 [0, 1],   # V
  combo.make 25 [1, 2],   # Q
  combo.make 25 [18, 19], # Z
  combo.make 25 [0, 2],   # SCH
  combo.make 25 [9, 25],  # SZ
  combo.make 25 [15, 26], # AE
  combo.make 25 [6, 26], # OE
  combo.make 25 [7, 26],  # UE
  # sym
  combo.make 25 [22, 23], # SLSH
  combo.make 25 [21, 22], # MINS
  combo.make 25 [23, 27], # SEMI
  combo.make 25 [17, 27], # PERIOD
  combo.make 25 [22, 27], # COLON
  # parentheticals
  combo.make 25 [0, 9],  # {
  combo.make 25 [1, 10], # [
  combo.make 25 [2, 11], # (
  combo.make 25 [3, 12], # <
  combo.make 25 [4, 13], # >
  combo.make 25 [5, 14], # )
  combo.make 25 [6, 15], # ]
  combo.make 25 [7, 16], # }
  # nav
  combo.make 25 [19, 20], # ESC
  combo.make 25 [21, 23], # ENT
  combo.make 25 [5, 6], # BSPC
  combo.make 25 [6, 7], # DEL
  combo.make 25 [5, 7], # C-BSPC
  # caps
  combo.make 25 [11, 14], # caps word
  combo.make 25 [0, 7], # caps lock
] in

let virtual_key_count = std.array.length virtual_keys' in
let key_count = 28 + virtual_key_count in

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
let sk' = tap.sticky.mod in
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


let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let sticky_behavior = {
  timeout_ms = 150,
  timeout_decision = 'hold,
  key_interrupts = std.array.replicate key_count ki.hr,
} in
let sk = {
  lctl = sk'.lctl & mdh.lctl & hold.reg.behavior sticky_behavior,
  rctl = sk'.rctl & mdh.rctl & hold.reg.behavior sticky_behavior,
  lalt = sk'.lalt & mdh.lalt & hold.reg.behavior sticky_behavior,
  ralt = sk'.ralt & mdh.ralt & hold.reg.behavior sticky_behavior,
  lgui = sk'.lgui & mdh.lgui & hold.reg.behavior sticky_behavior,
  rgui = sk'.rgui & mdh.rgui & hold.reg.behavior sticky_behavior,
  lsft = sk'.lsft & mdh.lsft & hold.reg.behavior sticky_behavior,
  rsft = sk'.rsft & mdh.rsft & hold.reg.behavior sticky_behavior,
} in

let layouts = {
  APTMAK = "WFPBJLUYRSTHKXNAIOCGDM,.",
  APTMAK_DE = "WFPBJLUZRSTHKXNAIOCGDM,.",
  NAUGHT = "FLKJPGOUNSHTMYCAIEBXDW',",
  NAUGHT_DE = "FLKJPGOUNSHTMZCAIEBXDW',",
  NAUGHT_MIRROR_DE = "UOGPJKLFEIACYMTHSN,'WDXB",
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
             ki.tp, ki.tp, ki.tp, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
             ki.tp, ki.tp, ki.tp,                  ki.hr, ki.hr, ki.hr,
                           ki.hr, ki.hr,    ki.hr, ki.hr,
    ] @ virtual_interrupts
  } in

  let htb_hrm_right = fun eager => htb_hrm_base eager & {
    key_interrupts = [
             ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tp, ki.tp, ki.tp,       
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,
             ki.hr, ki.hr, ki.hr,                  ki.tp, ki.tp, ki.tp,
                           ki.hr, ki.hr,    ki.hr, ki.hr,
    ] @ virtual_interrupts
  } in

  let hrm_mods = [
    mdh.lctl, mdh.lalt, mdh.lgui, mdh.lsft, mdh.ralt,
    mdh.ralt, mdh.rsft, mdh.rgui, mdh.lalt, mdh.rctl,
  ] in

  let hrm_key_indices = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17] in

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
  SOSS = macro.make [
    macro.tap kc.SPC,
    macro.tap sk'.lsft,
  ],
} in

let thumb = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    kc.TAB  & lt 1 & hold.reg.behavior thumb_behavior,
    kc.R    & lt 2 & hold.reg.behavior thumb_behavior,
    kc.SPC  & lt 3 & hold.reg.behavior thumb_behavior,
    cu.SOSS & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in

let combos_base = [
  kc.V, kc.Q, kc.Y, cu.SCH, de.SZ, de.AE, de.OE, de.UE,
  de.SLSH, de.MINS, de.SCLN, kc.DOT, de.COLN,
  de.LCBR, de.LBRC, de.LPRN, de.LABK, de.RABK, de.RPRN, de.RBRC, de.RCBR,
  kc.ESC, kc.ENT, kc.BSPC, kc.DEL, md.lctl & kc.BSPC,
  fak.CWTG, kc.CAPS_LOCK,
] in

### Keymap itself! ###
{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.NAUGHT_DE) |> std.array.at key_idx in
    # ALPHAS
    [
               base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,
      base 8,  base 9,  base 10, base 11, base 12, base 13, base 14, base 15, base 16, base 17,
               base 18, base 19, base 20,                   base 21, de.QUOT, base 23,
                                 thumb 0, thumb 1, thumb 2, thumb 3,
    ] @ combos_base,
    # NUM
    [
                    tx & hx,      tx & hx,      tx & hx,      tx & hx,      tx & hx, kc.N7,   kc.N8,   kc.N9,
      kc.PPLS & ht, kc.PMNS & ht, kc.PAST & ht, kc.PSLS & ht, tx & ht,      tx & hx, kc.N4,   kc.N5,   kc.N6,   kc.DOT,
                    kc.N9,        kc.N8,        kc.N7,                               kc.N1,   kc.N2,   kc.N3,
                                                tt & ht,      tt & ht,      kc.E,    kc.N0,
    ] @ combos_base,
    # NAV
    [
                  tx & hx,      tx & hx,      tx & hx,      media.VOLU,   tx & hx,    tx & hx,    tx & hx,  tx & hx,
      sk.lctl,    sk.lalt,      sk.lgui,      sk.lsft,      media.VOLD,   media.MUTE, kc.LEFT,    kc.DOWN,  kc.UP,      kc.RGHT,
                  cu.COPY,      cu.CUT,       cu.PSTE,                                kc.HOME,    tx & hx,  kc.END,
                                              tt & ht,      tt & ht,      kc.PGDN,    kc.PGUP,
    ] @ combos_base,
    # SYM
    [
               tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx, tx & hx,
      ks.EXLM, de.AT,   de.HASH, ks.DLR,  tx & hx, tx & hx, de.AMPR, de.ASTR, ks.PERC, de.CIRC,
               de.GRV,  de.DQUO, de.UNDS,                   de.BSLS, de.PIPE, de.EQL,
                                 de.TILD, tt & ht, tt & ht, tt & ht,
    ] @ combos_base,
    # FUN
    [
               fak.BOOT, tt & ht, tt & ht, tt & ht, tt & ht, kc.F7,   kc.F8,   kc.F8,
      tt & ht, kc.F12,   kc.F11,  kc.F10,  tt & ht, tt & ht, kc.F4,   kc.F5,   kc.F6,   tt & ht,
               kc.F9,    kc.F8,   kc.F7,                     kc.F1,   kc.F2,   kc.F3,
                                  tt & ht, tt & ht, tt & ht, tt & ht,
    ] @ combos_base,
  ]
}
