# ConcordanceLibrary
Ruby library to parse and process Concordance dat files.<br />

c = Concordance.new('C:\Productions\H11344_Full\VOL002_export - Copy.dat')<br />
puts c.Headers<br />
puts c.Headers.length<br />
puts c.DocumentCount<br />
puts c.Encoding?<br />
data = '... some load file data in string format ...'<br />
puts c.CompareFile?('C:\Productions\H11344_Full\VOL002_export - Copy.dat')<br />
puts c.ColumnValues('Prod_ParentID', false)<br />
