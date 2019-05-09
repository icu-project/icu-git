s%^(cldrbug|jitterbug|ticket)[: ]*([0-9]+)[ :]*%CLDR-\2 %
s%(cldrbug|jitterbug|ticket)[: ]*([0-9]+)[ :]*%[CLDR-\2] %g
s%.*git-svn-id: [^@]*@([0-9]+).*%X-SVN-Rev: \1%g
