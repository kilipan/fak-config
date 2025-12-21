let { DirectPinKey, PeripheralSideKey, .. } = import "fak/keyboard.ncl" in
let { CH552T, .. } = import "fak/mcus.ncl" in

let D = DirectPinKey in
let S = PeripheralSideKey in

let side_periph = {
  mcu = CH552T,
  split.channel = CH552T.features.uart_30_31,
  keys = [
    D 17, D 16, D 15, D 33,
    D 13, D 12, D 11, D 32,
    D 34, D 35,
  ]
} in

# central
{
  mcu = CH552T,
  split.channel = CH552T.features.uart_30_31,
  split.peripheral = side_periph,
  usb_dev = {
    vendor_id = 43962, # 0xABBA
    product_id = 20,
    product_ver = 1,
  },
  keys = [
    D 12, D 13, D 35, D 34,  S 0, S 1, S 2, S 3,
    D 11, D 32, D 33, D 15,  S 4, S 5, S 6, S 7,
                D 16, D 17,  S 8, S 9,
  ],
}
