#!/usr/bin/env python3
"""Regenerate the footer QR code.

The QR on the poster has to be checkable: this script is the one live home for
what it encodes, so nobody has to scan a PNG to find out where it points.

Error correction M (15%) is the usual choice for print at this size; the poster
is A0 and the code is 46mm square, which is far above the ~2cm a phone needs at
arm's length, so there is no case for going higher and denser.
"""

import qrcode

URL = "https://near-nes.github.io/severus-inctn/"
OUT = "img/qr-severus.png"

qr = qrcode.QRCode(
    version=None,                                   # smallest that fits
    error_correction=qrcode.constants.ERROR_CORRECT_M,
    box_size=20,                                    # px per module; 20 is plenty for A0
    border=2,                                       # quiet zone, in modules
)
qr.add_data(URL)
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white")
img.save(OUT)
print(f"{OUT}  {img.size[0]}x{img.size[1]}  version {qr.version}  ->  {URL}")
