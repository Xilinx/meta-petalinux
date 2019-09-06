 #*******************************************************************************
 #
 # Copyright (C) 2019 Xilinx, Inc.  All rights reserved.
 # 
 # Permission is hereby granted, free of charge, to any person obtaining a copy of
 # this software and associated documentation files (the "Software"), to deal in
 # the Software without restriction, including without limitation the rights to
 # use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 # of the Software, and to permit persons to whom the Software is furnished to do
 # so, subject to the following conditions:
 # 
 # The above copyright notice and this permission notice shall be included in all 
 # copies or substantial portions of the Software.
 # 
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 # AUTHORS OR COPYRIGHT HOLDERS  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
 # SOFTWARE.
 #
 # Author:	Bhargava Sreekantappa Gayathri <bsreekan@xilinx.com>
 #
 # ******************************************************************************


from upm import pyupm_jhd1313m1 as lcd
import sys

def main():

    # LCD address is 0x3E and RGB control adddress is 0x62
    myLcd = lcd.Jhd1313m1(0, 0x3E, 0x62)
    myLcd.setColor(255,0,0)

    myLcd.setCursor(0,0);
    myLcd.write("Powering off")
    myLcd.setCursor(1,0)
    myLcd.write("Please wait")

if __name__ == '__main__':
    main()

