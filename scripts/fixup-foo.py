import pysvn;

>>> t = pysvn.Transaction('repos/icu','1234',True)
>>> t
<Transaction object at 0x1adbbc8>
>>> t.revpropget('svn:log')
u'Modified package spec.\n'
>>> t = pysvn.Transaction('repos/icu','4444',True)
>>> t.revpropget('svn:log')
u'ticket:833 :\nRemoved dependency on fcdcheck for genrb.\n'
>>> s = t.revpropget('svn:log')
>>> t.revpropset('svn:log', s . '-- hey')
  File "<stdin>", line 1
    t.revpropset('svn:log', s . '-- hey')
                                       ^
SyntaxError: invalid syntax
>>> t.revpropset('svn:log', s + '-- hey')
>>> s = t.revpropget('svn:log')
>>> s
u'ticket:833 :\nRemoved dependency on fcdcheck for genrb.\n-- hey'
