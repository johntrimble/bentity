#!/usr/bin/env python
'''
Copyright (C) 2012 John Trimble

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'''
__authors = ['John Trimble <trimblej@gmail.com>']
__license__ = 'MIT License'

import Tkinter
from UserDict import UserDict

class ConversionDict(UserDict):
  """Returns the appropriate HTML escaping of the given character, or the 
  character itself if it does not require escaping.
  
  >>> conversion_dict = ConversionDict()
  >>> conversion_dict('&')
  '&amp;'
  >>> conversion_dict("'")
  '&apos;'
  >>> conversion_dict('"')
  '&quot;'
  >>> conversion_dict(chr(3))
  ' '
  >>> conversion_dict('<')
  '&lt;'
  >>> conversion_dict('>')
  '&gt;'
  >>> "".join(map(conversion_dict, "Mass of Ben's mom > mass of Jupiter & Saturn"))
  'Mass of Ben&apos;s mom &gt; mass of Jupiter &amp; Saturn'
  """
  def __init__(self):
    self.exception_dict = { '&' : '&amp;',
                   "'" : '&apos;',
                   '"' : '&quot;',
                   '<' : '&lt;',
                   '>' : '&gt;',
                   chr(3) : ' '
                  }
  
  def __call__(self, c): return self[c]
    
  def __getitem__(self, index):
    if index in self.exception_dict:
      return self.exception_dict[index]
    elif ord(index) < 128:
      return index
    else:
      return "&#" + str(ord(index)) + ";"
      
  def __repr__(self):
    return repr(self.exception_dict)

conversion_dict = ConversionDict()

class UnicodeAsciiEscapeGUI(Tkinter.Frame):
  
  def __init__(self, master=None):
    Tkinter.Frame.__init__(self, master)
    self.grid(padx=10,pady=10)
    self.unicode_text_area = Tkinter.Text(self)
    self.unicode_text_area.grid(row=1, column=0)
    self.ascii_text_area = Tkinter.Text(self)
    self.ascii_text_area.grid(row=1, column=1, padx=10, pady=10)
    self.convert_text_button = Tkinter.Button(self, text="convert", 
                                              command=self.escape_command)
    self.convert_text_button.grid(row=2, column=0, columnspan=2)
    self.pack()
  
  def escape_command(self):
    val = "".join(map(conversion_dict, self.unicode_text_area.get(1.0, Tkinter.END)))
    self.ascii_text_area.delete(1.0, Tkinter.END)
    self.ascii_text_area.insert(1.0, val)

    
if __name__ == "__main__":
  # Run our doc tests
  import doctest
  doctest.testmod()
  # Start the app
  root = Tkinter.Tk()
  guiFrame = UnicodeAsciiEscapeGUI(root)
  guiFrame.mainloop()
