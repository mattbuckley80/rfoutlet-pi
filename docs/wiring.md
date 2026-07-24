# RF Outlet HAT — Wiring Reference

## RF Modules

### Transmitter (SYN115)
| SYN115 Pin | Raspberry Pi Pin |
|-----------|-----------------|
| VCC | 3.3V (Pin 1 or Pin 17) |
| GND | Any Ground pin |
| DATA | GPIO17 (Pin 11) |

> ⚠️ **Important:** The SYN115 operating voltage is 1.8V–3.6V. Do NOT connect to 5V — it will damage the chip.

### Receiver (SYN480R)
| SYN480R Pin | Raspberry Pi Pin |
|------------|-----------------|
| VCC | 3.3V (Pin 1 or Pin 17) |
| GND | Any Ground pin |
| DATA | GPIO27 (Pin 13) |

> ⚠️ **Important:** Power the SYN480R from 3.3V, not 5V. Its data output voltage tracks its supply voltage — a 5V output could damage the Pi's GPIO pins.

## Antenna
- Antenna wire length for 433MHz: **17.3cm (6.7 inches)**
- Keep antenna straight and vertical for best range
- Keep antenna away from metal objects and other wires

## Raspberry Pi GPIO Header Reference
```
        3.3V  [ 1] [ 2]  5V
         SDA  [ 3] [ 4]  5V
         SCL  [ 5] [ 6]  GND
      GPIO 4  [ 7] [ 8]  TX
         GND  [ 9] [10]  RX
     GPIO 17  [11] [12]  GPIO 18   <- Transmitter DATA
     GPIO 27  [13] [14]  GND       <- Receiver DATA
     GPIO 22  [15] [16]  GPIO 23
        3.3V  [17] [18]  GPIO 24   <- Use 3.3V for both modules
```

## Notes
- Both modules are on the same 3.3V rail
- RFSniffer uses GPIO27 (WiringPi pin 2) for receiving
- codesend.py uses GPIO17 (BCM) for transmitting
- Making the HAT interchangeable between Pi units requires keeping these pins consistent
