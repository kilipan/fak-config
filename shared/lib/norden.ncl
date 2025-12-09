let keycode = import "fak/keycode.ncl" in
let fak_util = import "fak/util_functions.ncl" in
let kilipan = import "lib/kilipan_util.ncl" in
let de = import "lib/german.ncl" in

# make base keymap depending on the keyboard's individual paddings
# (keys not on zilpzalp that can be assigned extra functions individually)
let rec make_base' = fun paddings => {
  virtual_keys =
    # embed default 24-key alpha layout in larger layouts
    # input format: paddings = { top = { left = 1, middle = 0, right = 1 }, mid = {...}, bot = {...} }
    let combo_term = 25 in
    let combo_indices = [
      # alpha
      [0, 1], # Q
      [1, 2], # V
      [18, 19], # X
      [9, 25],  # SZ
      [17, 26], # AE
      [6, 26], # OE
      [7, 26],  # UE
      # alpha macros
      [0, 2], # SCH
      # sym
      [22, 23], # SLSH
      [21, 22], # MINS
      [22, 27], # SCLN
      [23, 27], # COLON
      # parentheticals
      [0, 9],  # {
      [1, 10], # [
      [2, 11], # (
      [3, 12], # <
      [4, 13], # >
      [5, 14], # )
      [6, 15], # ]
      [7, 16], # }
      # nav
      [4, 5], # TAB
      [19, 20], # ESC
      [18, 20], # ENT
      [21, 23], # ENT
      [5, 6], # BSPC
      [6, 7], # DEL
      [5, 7], # C-BSPC
      # shifting
      [9, 11], # left oss
      [14, 16], # right oss
      [11, 14], # caps word
      [0, 7], # caps lock
      # other osm
      [9, 18], # left os-alt
      [10, 19], # left os-gui
      [11, 20], # left os-ctl
      [14, 23], # right os-ctl
      [15, 24], # right os-gui
      [16, 25], # right os-alt
    ] in
    kilipan.make_virtual_keys paddings combo_term combo_indices,

  # number of keys including combos (and technically other virtual keys, but not implemented)
  virtual_key_count = std.array.length virtual_keys,
  key_count = 28 + kilipan.extra_keys paddings + virtual_key_count,

  # convenience aliases
  # taps
  kc = keycode.tap.reg.kc,
  ks = keycode.tap.reg.ks,
  md = keycode.tap.reg.mod,
  # holds
  mdh = keycode.hold.reg.mod,
  # hold-tap behavior
  htb = keycode.hold.reg.behavior,
  # sticky key
  sk' = keycode.tap.sticky.mod,
  # layer control
  lt = keycode.hold.reg.layer,
  lto = keycode.tap.layer.TO,
  lst = keycode.tap.sticky.layer,
  # boot, reset, etc
  fak = keycode.tap.custom.fak,
  # media and mouse control
  media = keycode.tap.custom.media,
  # mouse = keycode.tap.custom.mouse,
  # keymap stuff
  tx = keycode.tap.none,
  tt = keycode.tap.trans,
  hx = keycode.hold.none,
  ht = keycode.hold.trans,
  ttlx = keycode.tap.tlex,
  htlx = keycode.hold.tlex,

  # key interrupt behaviors
  ki = kilipan.ki,

  sticky_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  },
  sk = {
    lctl = sk'.lctl & mdh.lctl & htb sticky_behavior,
    rctl = sk'.rctl & mdh.rctl & htb sticky_behavior,
    lalt = sk'.lalt & mdh.lalt & htb sticky_behavior,
    ralt = sk'.ralt & mdh.ralt & htb sticky_behavior,
    lgui = sk'.lgui & mdh.lgui & htb sticky_behavior,
    rgui = sk'.rgui & mdh.rgui & htb sticky_behavior,
    lsft = sk'.lsft & mdh.lsft & htb sticky_behavior,
    rsft = sk'.rsft & mdh.rsft & htb sticky_behavior,
  },

  # function to automatically generate hrm keycodes for the appropriate positions
  make_hrm = fun key_idx =>
    let htb_hrm_base = fun eager => {
      timeout_ms = 150,
      # quick_tap_ms = 100,
      # quick_tap_interrupt_ms = 500,
      # global_quick_tap_ms = 80,
      eager_decision = eager,
      timeout_decision = 'hold,
    } in

    # make all virtual keys behave non-intrusively
    let virtual_interrupts = std.array.replicate virtual_key_count ki.hr in

    # generate the interrupt map for left handed hrm
    let htb_hrm_left = fun eager => htb_hrm_base eager & {
      key_interrupts = kilipan.padded_hrm_left paddings @ virtual_interrupts
    } in

    # generate the interrupt map for right handed hrm
    let htb_hrm_right = fun eager => htb_hrm_base eager & {
      key_interrupts = kilipan.padded_hrm_right paddings @ virtual_interrupts
    } in

    # list of hrm, lsft activates layer 5 for key overrides
    let hrm_mods = [
      mdh.lctl, mdh.lalt, mdh.lgui, mdh.lsft & lt 5, mdh.ralt,
      mdh.ralt, mdh.rsft, mdh.rgui, mdh.lalt, mdh.rctl,
    ] in

    # ignore paddings because this works off the base layout (e.g. layouts.APTMAK)
    let hrm_key_indices = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17] in

    # pick out key indices with hrm function
    #   -> assign side (left/right)
    #   -> assign respective mod with 
    if std.array.elem key_idx hrm_key_indices then
      let mod_idx = fak_util.array.index_of key_idx hrm_key_indices in
      let side = if mod_idx < (std.array.length hrm_mods / 2) then 'left else 'right in
      let mod = std.array.at mod_idx hrm_mods in

      # make shift, ctrl, and ralt eager holds (is this good???)
      mod & keycode.hold.reg.behavior (
        (if side == 'left then htb_hrm_left else htb_hrm_right)
        (if mod == mdh.lgui || mod == mdh.rgui || mod == mdh.lalt then 'none else 'hold)
      )
    else
      {},

  alphas = fun layout => layout
    |> std.string.characters
    |> fak_util.array.enumerate
    |> std.array.map (
        fun { index, value } => kc."%{value}"
        # (un)comment for home-row mods
        & make_hrm index
      ),

  macro = keycode.macro,
  cu = {
    COPY = md.lctl & kc.C,
    PSTE = md.lctl & kc.V,
    CUT  = md.lctl & kc.X,
    PRNT = md.lctl & kc.P,
    SAVE = md.lctl & kc.S,
    SCH  = macro.make [
      macro.tap kc.S,
      macro.release mdh.rsft,
      macro.tap kc.C,
      macro.tap kc.H,
    ],
    AU   = macro.make [
      macro.tap kc.A,
      macro.release mdh.lsft,
      macro.tap kc.U,
    ],
    SOSS = macro.make [
      macro.tap kc.SPC,
      macro.tap sk'.lsft,
    ],
  },

  thumb = fun thumb_idx =>
    let thumb_behavior = {
      timeout_ms = 150,
      timeout_decision = 'hold,
      key_interrupts = std.array.replicate key_count ki.hr,
    } in
    [
      kc.TAB  & lt 1 & keycode.hold.reg.behavior thumb_behavior,
      kc.S    & lt 2 & keycode.hold.reg.behavior thumb_behavior,
      kc.SPC  & lt 3 & keycode.hold.reg.behavior thumb_behavior,
      de.QUOT & lt 4 & keycode.hold.reg.behavior thumb_behavior,
      # additional things for off-base layers
      # htlx thumb_behavior & lto 0,
    ]
    |> std.array.at thumb_idx,

  combos_base = [
    kc.Q, kc.V, kc.X,
    de.SZ, de.AE, de.OE, de.UE,
    cu.SCH,
    de.SLSH, de.MINS, de.SCLN, de.COLN,
    de.LCBR, de.LBRC, de.LPRN, de.LABK,
    de.RABK, de.RPRN, de.RBRC, de.RCBR,
    kc.TAB, kc.ESC, kc.ENT, kc.ENT, kc.BSPC, kc.DEL, md.lctl & kc.BSPC,
    sk.lsft & lst 5, sk.rsft & lst 5, fak.CWTG, kc.CAPS_LOCK,
    sk.lalt, sk.lgui, sk.lctl, sk.rctl, sk.rgui, sk.lalt,
  ],
  combos_trans = [
    tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  ],
  combos_numb = [
    tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  ],
  combos_overlay = [
    tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht,
    de.SZ,   tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht,
    tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
  ],

  # alpha layout to generate base keymap from
  layouts = {
    # APTMAK = "WFPBJLUYRSTHKXNAIOCGDM,.",
    # APTMAK_DE = "WFPBJLUZRSTHKXNAIOCGDM,.",
    # NAUGHT = "FLKJPGOUNSHTMYCAIEBXDW',",
    # NAUGHT_DE =    "FLKYPGOUNSHTMZCAIEBJDW',",
    NORDEN = "LDYKPWOURNTHFZCEIAJMBG,.",
  },

  #   l d z k  p w o u
  # r n t h f  y c e i a
  #   j m b      g , .
  #       # s  _ !

  ### Keymap itself! ###
  keymap = {
    alph = {
        fingers = let alpha = fun key_idx => (alphas layouts.NORDEN) |> std.array.at key_idx in [
                  alpha 0,  alpha 1,  alpha 2,  alpha 3,  alpha 4,  alpha 5,  alpha 6,  alpha 7,
        alpha 8,  alpha 9,  alpha 10, alpha 11, alpha 12, alpha 13, alpha 14, alpha 15, alpha 16, alpha 17,
                  alpha 18, alpha 19, alpha 20,                     alpha 21, alpha 22, alpha 23,
      ] |> (fun x => kilipan.pad_fingers x (hx & tx) paddings),
      thumbs = [                      thumb 0,  thumb 1,  thumb 2,  thumb 3,
      ] |> (fun x => kilipan.pad_thumbs x (hx & tx) paddings),
    },
    numb = {
      fingers = [
                kc.N9,   kc.N8,   kc.N7,    de.PLUS,     de.PLUS,  kc.N4,   kc.N5,   kc.N6,
      kc.DOT,   kc.N6,   kc.N5,   kc.N4,    kc.N0,       de.MINS,  kc.N1,   kc.N2,   kc.N3,   kc.DOT,
                kc.N3,   kc.N2,   kc.N1,                           kc.N7,   kc.N8,   kc.N9,
      ] |> (fun x => kilipan.pad_fingers x (hx & tx) paddings),
      thumbs = [                  tt & ht, tt & ht,      tt & ht,  kc.N0,
      ] |> (fun x => kilipan.pad_thumbs x (hx & tx) paddings),
    },
    navi = {
      fingers = [
                  tx & hx,      cu.SAVE,      cu.PRNT,      tx & hx,      tx & hx,    tx & hx,   kc.PGDN,    kc.PGUP,
      sk.lctl,    sk.lalt,      sk.lgui,      sk.lsft,      sk.ralt,      tx & hx,    kc.LEFT,   kc.DOWN,    kc.UP,      kc.RGHT,
                  cu.COPY,      cu.CUT,       cu.PSTE,                                kc.HOME,   media.MUTE, kc.END,
      ] |> (fun x => kilipan.pad_fingers x (hx & tx) paddings),
      thumbs = [                              tx & hx,      tt & ht,      media.VOLD, media.VOLU,
      ] |> (fun x => kilipan.pad_thumbs x (hx & tx) paddings),
    },
    symb = {
      fingers = [
                 de.LCBR, de.LBRC, de.LPRN, de.LABK, de.RABK, de.RPRN, de.RBRC, de.RCBR,
        ks.EXLM, de.AT,   de.HASH, ks.DLR,  tx & hx, tx & hx, de.AMPR, de.ASTR, ks.PERC, de.CIRC,
                 de.GRV,  de.DQUO, de.ACUT,                   de.BSLS, de.PIPE, de.EQL,
      ] |> (fun x => kilipan.pad_fingers x (hx & tx) paddings),
      thumbs = [                   de.TILD, tt & ht, tt & ht, tt & ht,
      ] |> (fun x => kilipan.pad_thumbs x (hx & tx) paddings),
    },
    func = {
      fingers = [
                 fak.BOOT, tt & ht, tt & ht, tt & ht, kc.F11,  kc.F7,   kc.F8,   kc.F8,
        tt & ht, tt & ht,  tt & ht, tt & ht, tt & ht, kc.F10,  kc.F4,   kc.F5,   kc.F6,   kc.F12,
                 tt & ht,  tt & ht, tt & ht,                   kc.F1,   kc.F2,   kc.F3,
      ] |> (fun x => kilipan.pad_fingers x (hx & tx) paddings),
      thumbs = [                    tt & ht, tt & ht, tt & ht, tt & ht,
      ] |> (fun x => kilipan.pad_thumbs x (hx & tx) paddings),
    },
    over = {
      fingers = [
                 tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
        tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht, tt & ht,
                 tt & ht, tt & ht, tt & ht,                   tt & ht, tt & ht, tt & ht,
      ] |> (fun x => kilipan.pad_fingers x (hx & tx) paddings),
      thumbs = [                   tt & ht, tt & ht, tt & ht, de.DQUO,
      ] |> (fun x => kilipan.pad_thumbs x (hx & tx) paddings),
    },
  }
} in

{
  make_base = make_base',
}
