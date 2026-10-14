#!/bin/csh

foreach sea ( "JJA" "DJF" )
setenv sean $sea

foreach var ("tas" "pr")
setenv varn $var

ncl < Eval.DEI.scalarVar.ncl 

end


foreach var ("ta" "zg" "hus")
setenv varn $var

ncl < Eval.DEI.vectorVar.TZQ.ncl

end

ncl < Eval.DEI.vectorVar.UV.ncl

end