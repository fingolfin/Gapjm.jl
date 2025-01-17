# Hand-translated part of chevie/tbl/cmp4_22.g
# (C) 1998 - 2017  Gunter Malle & Jean Michel
#
# Data about the complex reflection groups with Shephard-Todd numbers 4--22 
#
# The data for classes, characters and Schur elements comes from
# G.Malle, ``Degres relatifs des algebres de Hecke cyclotomiques associees aux
#  groupes de reflexions complexes de dimension 2'',  in
# ``Finite  reductive groups'', Progress in  math. n0 141, Birkhauser 1997
# to which should be added the following info:
# -- the subalgebra H' is generated as described by the function "Embed"
# -- there is a misprint in the numerator of the relative degrees of
#    2-dimensional characters of G7: it should read
#        -x1^3 x_2^3 y_1 y_2^3 y_3^4 z_1^2 z_2^2 z_3^4
#    instead of
#        -x1^2 x_2^2 y_1 y_2^3 y_4   z_1^2 z_2^2 z_3^4
# -- There are  misprints in  the relative  degrees of  the 4-dimensional
#    characters of G11:
# -- The  numerator  should   read  -(x1x2)^9y1^10(y2y3)^5z1^6(z2z3z4)^4t^2
# -- In the last  product in the denominator i should run in {2,3}.
# -- there is a misprint in the relative degrees of the 3-dimensional
#    characters of G19:
#    The numerator should read x1^10x2^15y1^7z1^3z4^12

const G4_22IndexChars_dict=Dict{Int,Any}()

for i in 4:22 G4_22IndexChars_dict[i]=Dict() end

CHEVIE[:CheckIndexChars]=false

function G4_22FetchIndexChars(ST, para)
  if !CHEVIE[:CheckIndexChars]
    return chevieget(:G4_22, :CharInfo)(ST)[:indexchars]
  end
  get!(G4_22IndexChars_dict[ST],para)do
    chevieget(:G4_22, :HeckeCharTable)(ST, para, [])[:indexchars]
  end
end

# tests if res=Chartable(Hecke(G_ST,res[:parameter])) is correct
# where rows=irrs for generic group (G7, G11 or G19)
# and i is the selector from rows to test.
function G4_22Test(res,rows,i)
  ST=res[:ST]
  T(ST)=string("G",ST in 4:7 ? 7 : ST in 8:15 ? 11 : 19)
  if haskey(G4_22IndexChars_dict[ST],res[:parameter])
#   InfoChevie("IndexChars(Hecke(G_$ST,",
#              HeckeAlgebras.simplify_para(res[:parameter]),"))\n")
    ic=G4_22IndexChars_dict[ST][res[:parameter]]
    res[:irreducibles]=rows[ic]
    if ic!=i
      println("*** WARNING: choice of character restrictions from ", T(ST), 
        " for this specialization does not agree with group CharTable")
      if !CHEVIE[:CheckIndexChars]
        print("Try again with CHEVIE[:CheckIndexChars]=true\n")
      end
    end
    return ic
  end
  ic=i
  res[:irreducibles]=rows[ic]
  if length(Set(res[:irreducibles]))==length(res[:classes]) l=i
  else
    l=map(x->findfirst(==(x),rows), rows)
    if length(Set(l))!=length(res[:classes])
      error("specialization not semi-simple")
    end
    xprintln("*** WARNING: bad choice of char. restrictions from ",T(ST), 
             " for H(G$ST,",HeckeAlgebras.simplify_para(res[:parameter]),")")
    if !CHEVIE[:CheckIndexChars]
      print("Try again with CHEVIE[:CheckIndexChars]=true\n")
    end
 #  l=map(x->filter(i->l[i]==x,eachindex(l)), sort(unique(l)))
    l=map(x->findall(==(x),l), unique(sort(l)))
    o=filter(x->count(j->j in x,i)>1,l)
  # println(" over-represented by ", intersect(union(o...), i)," : ", o)
  # println(" absent : ",filter(x->iszero(count(j->j in x,i)),l))
    l=first.(l)
    o=filter(p->first(p)!=last(p),collect(zip(i,l)))
    println("changing choice ",join(first.(o),",")," → ",join(last.(o),","))
  # println(" Choosing ",l)
    res[:irreducibles]=rows[l]
  end
  G4_22IndexChars_dict[ST][res[:parameter]]=l
end

#----------------- next 2 here to reduce compiling time
const GeneratingRoots4_22=
[[[0,-2E(3)-E(3,2)],[2E(3,2),E(3,2)]],  # 4
 [[0,(3-root(-3))//2],[-1,1]],  # 4
 [[-1+root(3),-1],[0,-2E(3)-E(3,2)]], # 6
 [[0,1],[((-E(12,11)-E(12,8))-2E(12,4))//2,(E(12,8)-E(12,11))//2], # 7
  [((-E(12,11)-E(12,8))-2E(12,4))//2,(-E(12,8)-E(12,11))//2]],
 [[0,E(4)],[(E(4)+1)//2,(E(4)+1)//2]], # 8
 [[(2-root(2))//2,-1],[0,1-E(4)]],  # 9
 [[0,-2E(3)-E(3,2)],[-1+root(3),1]],  # 10
 [[(3+root(6))//3,E(3)root(6)//6],[0,root(-2)//2], # 11
  [(3-root(3))*(1-E(4))//6,(1-E(4))root(3)//6]],  
 [[root(-2),-1-root(-2)],[-root(-2),-1+root(-2)],[0, 2]],  # 12
 [[0,1],[2-root(2),root(2)]//2,[1-root(2),-E(4)]//(E(4)-1)], # 13
 [[0,2],[-2E(3,2)-1-root(-2),-1]], # 14
 [[E(24,22)-E(24,19)+2E(24,17)+E(24,16)-E(24,14)+E(24,8)+E(24), # 15
   -E(24,16)+E(24,11)-E(24,8)],[0,-2E(3)-E(3,2)],[-1+root(3),1]], 
 [[0,1],[(2*E(5,4)+3*E(5))//root(5)-1,(E(5)-E(5,3))//root(5)]], # 16
 [[(E(20,17)-E(20,13))//root(5), # 17
   (E(20,16)-E(20,12)-E(20,9)-E(20,8)+E(20,4)+E(20))//root(5)],[0,1]], 
 [[1,E(15,14)+E(15,13)+E(15,11)+E(15)],[0,E(5,4)-E(5)]], # 18
 [[1,E(20)-E(20,8)-E(20,9)-E(20,12)],[1,E(15)+E(15,11)+E(15,13)+E(15,14)],
  [0,-E(20)+E(20,9)]], # 19
 [[0,E(5)+E(5,4)],(3-root(-3))*[(-5+3root(5))//2,1]//6], # 20
 [[(5-root(5))//2,root(3)-E(5,2)-E(5,3)],[0,1-E(3)]],  # 21
 [[1,E(20,17)-E(20,16)-E(20,13)-E(20,4)], # 22
  [E(20,16)+E(20,13)+E(20,12)+E(20,8)+E(20,4)+E(20),
   -E(20,16)+E(20,9)-E(20,8)-E(20,4)],
  [E(20,17)-E(20,16)-E(20,12)+E(20,9)-E(20,8)-E(20,4),
   E(20,16)+E(20,12)+E(20,4)+E(20)]]]
chevieset(:G4_22, :GeneratingRoots,ST->GeneratingRoots4_22[ST-3])

GeneratingCoRoots4_22=
[[[0,1],[root(-3)//3,root(-3)//3]], # 4
 [[0,1],[(-3+root(-3))//6,(3-root(-3))//3]], # 5
 [[root(3)//3,(-3-root(3))//3],[0,1]], # 6
 [[0,2],[1,((-1-root(3))*(-(E(4))+1))//2],[1,((-1-root(3))*(E(4)+1))//2]], # 7
 [[0,-(E(4))-1],[-(E(4)),-(E(4))]], # 8
 [[1,(-2-root(2))//2],[0,1]], # 9
 [[0,1],[(-(root(-3))*(E(4)+1))//6,((3+root(3))*(-(E(4))+1))//6]], # 10
 [[1,(-2+root(6))*E(3,2)],[0,root(6)*E(3,2)],[1,1+root(3)]], # 11
 [[1//root(-2),-1+root(-2)]//2,[-1//root(-2),-1-root(-2)]//2,[0,1]], # 12
 [[0,2],[1,1+root(2)],[root(-2),2+root(2)]//(E(4)-1)], # 13
 [[0,1],([1,-(root(-2))+1+2E(3,2)]//2)//E(3)], # 14
 [[(-3E(24,19)-E(24,17)-2E(24,16)-3E(24,14)-3E(24,11)-E(24,8)+E(24))//6, # 15
   (E(24,17)-E(24,16)-2E(24,8)-E(24))//3],[0,1],[root(3)//3,(3+root(3))//3]],
 [[0,-E(5,4)-E(5,3)-E(5,2)-2E(5)],[(1-root(5))//2,-E(5)]], # 16
 [[E(20,12)-E(20,9)+E(20,8)+E(20),1],[0,-E(5,4)-E(5,3)-E(5,2)-2E(5)]], # 17
 [[(5E(15,14)+E(15,13)+5E(15,11)+5E(15,8)+4E(15,7)+3E(15,4)+5E(15,2) # 18
    +2E(15))//5,(-2E(15,13)-3E(15,7)-E(15,4)+E(15))//5],[0,-E(5,4)-E(5,2)]],
 [[(-2E(20,17)-5E(20,16)+2E(20,13)-5E(20,12)+E(20,9)-5E(20,8)-5E(20,4) # 19
   -E(20))//5,(-E(20,17)+E(20,13)-2E(20,9)+2E(20))//5],
  [(5E(15,14)+E(15,13)+5E(15,11)+5E(15,8)+4E(15,7)+3E(15,4)+5E(15,2)
   +2E(15))//5,(-2E(15,13)-3E(15,7)-E(15,4)+E(15))//5],
  [0,-E(20,13)-E(20)]],
 [[0,(1+root(5))*(3-root(-3))//4],[root(5)//5,(3+root(5))//2]], # 20
 [[(1-root(3))*(root(5)-5//root(3))//10,root(3)//3],[0,1]], # 21
 [[(-2E(5,4)+E(5,3)-E(5,2)+2E(5))//5//E(4)+1, # 22
   (-E(5,4)-2E(5,3)+2E(5,2)+E(5))//5//E(4)],
  [(-4E(20,17)-E(20,16)-E(20,13)+3E(20,12)-3E(20,9)+2E(20,8)+E(20,4)-2E(20))//5,
  (-2E(20,17)-3E(20,16)+2*E(20,13)-E(20,12)+E(20,9)+E(20,8)-2E(20,4)-E(20))//5],
  [(-E(20,17)-E(20,16)-4E(20,13)-2E(20,12)-2E(20,9)-3E(20,8)+E(20,4)-3E(20))//5,
   (2E(20,17)+2E(20,16)-2E(20,13)-E(20,12)-E(20,9)+E(20,8)+3E(20,4)+E(20))//5]]]
chevieset(:G4_22,:GeneratingCoRoots,ST->GeneratingCoRoots4_22[ST-3])

sparseFakeDegrees4_22=
[[[0],[4],[8],[5,7],[3,5],[1,3],[2,4,6]], # 4
 [[0],[4],[8],[4],[8],[12],[8],[12],[16],[9,15],[7,13],[5,11],[7,13],[5,11], # 5
  [3,9],[5,11],[3,9],[1,7],[4,10,10],[2,8,14],[6,6,12]],
 [[0],[4],[8],[6],[10],[14],[5,13],[3,11],[3,7],[7,11],[1,9], # 6
  [5,9],[2,6,10],[4,8,12]],
 [[0],[4],[8],[4],[8],[12],[8],[12],[16],[6],[10],[14],[10],[14],[18],[14],[18],
  [22],[9,21],[7,19],[11,11],[7,19],[11,11],[9,9],[11,11],[9,9],[7,7],[15,15],
  [13,13],[5,17],[13,13],[5,17],[3,15],[5,17],[3,15],[1,13],[10,10,10], # 7
  [4,16,16],[2,14,14],[8,8,20],[6,6,18],[12,12,12]],
 [[0],[6],[12],[18],[1,5],[4,8],[7,11],[7,11],[10,14],[13,17],[8,12,16], # 8
  [6,10,14],[4,8,12],[2,6,10],[5,9,9,13],[3,7,11,15]],
 [[0],[6],[12],[18],[12],[18],[24],[30],[5,13],[4,20],[7,23],[7,23],[10,26],# 9
  [13,29],[1,17],[14,22],[17,25],[11,19],[11,19],[8,16],[8,16,24],[6,14,22],
  [4,12,20],[2,10,18],[12,20,28],[10,18,26],[8,16,24],[6,14,22],[9,9,17,25],
  [7,15,15,23],[3,11,19,27],[5,13,21,21]],
 [[0],[6],[12],[18],[8],[14],[20],[26],[16],[22],[28],[34],[9,21],[12,24], # 10
  [15,27],[15,27],[18,30],[21,33],[5,17],[8,20],[11,23],[11,23],[14,26],
  [17,29],[1,13],[4,16],[7,19],[7,19],[10,22],[13,25],[8,20,32],[14,14,26],
  [8,20,20],[2,14,26],[16,16,28],[10,22,22],[4,16,28],[10,10,22],[12,24,24],
  [6,18,30],[12,12,24],[6,18,18],[9,9,21,21],[11,11,23,23],[7,19,19,31],
  [3,15,15,27],[5,17,17,29],[13,13,25,25]],
 [[0],[6],[12],[18],[8],[14],[20],[26],[16],[22],[28],[34],[12],[18],[24], # 11
  [30],[20],[26],[32],[38],[28],[34],[40],[46],[9,33],[12,36],[27,27],[27,27],
  [18,42],[33,33],[5,29],[20,20],[11,35],[11,35],[14,38],[29,29],[1,25],[4,28],
  [7,31],[7,31],[22,22],[25,25],[21,21],[24,24],[15,39],[15,39],[30,30],[21,45],
  [17,17],[8,32],[23,23],[23,23],[26,26],[17,41],[13,13],[16,16],[19,19],
  [19,19],[10,34],[13,37],[8,32,32],[14,14,38],[20,20,20],[2,26,26],[20,20,44],
  [26,26,26],[8,32,32],[14,14,38],[16,16,40],[22,22,22],[4,28,28],[10,10,34],
  [28,28,28],[10,34,34],[16,16,40],[22,22,22],[24,24,24],[6,30,30],[12,12,36],
  [18,18,18],[12,36,36],[18,18,42],[24,24,24],[6,30,30],[21,21,21,21],
  [23,23,23,23],[19,19,19,43],[3,27,27,27],[5,29,29,29],[25,25,25,25],
  [9,9,33,33],[11,11,35,35],[7,31,31,31],[15,15,15,39],[17,17,17,41],
  [13,13,37,37]],
 [[0],[12],[1,11],[4,8],[5,7],[2,4,6],[6,8,10],[3,5,7,9]], # 12
 [[0],[6],[12],[18],[7,11],[4,8],[1,17],[5,13],[10,14],[7,11],[4,8,12],[2,6,10],
  [8,12,16],[6,10,14],[3,7,11,15],[5,9,9,13]], # 13
 [[0],[8],[16],[12],[20],[28],[15,21],[12,24],[9,27],[11,17],[8,20],[5,23],
  [7,13],[4,16],[1,19],[2,14,20],[8,14,26],[4,10,22],[10,16,22],[6,12,18],
  [6,18,24],[3,9,15,21],[5,11,17,23],[7,13,19,25]], # 14
 [[0],[6],[8],[14],[16],[22],[12],[18],[20],[26],[28],[34],[9,33],[12,24],
  [15,27],[15,27],[18,30],[21,21],[5,29],[8,20],[11,23],[11,23],[14,26],
  [17,17],[1,25],[4,16],[7,19],[7,19],[10,22],[13,13],[8,20,20],[2,14,26],
  [8,20,32],[14,14,26],[4,16,28],[10,10,22],[16,16,28],[10,22,22],[12,12,24],
  [6,18,18],[12,24,24],[6,18,30],[9,9,21,21],[11,11,23,23],[7,19,19,31],
  [3,15,15,27],[5,17,17,29],[13,13,25,25]], # 15
 [[0],[12],[24],[36],[48],[1,11],[7,17],[13,23],[19,29],[13,23],[19,29], # 16
  [25,35],[25,35],[31,41],[37,47],[2,12,22],[6,16,26],[10,20,30],[10,20,30],
  [14,24,34],[18,28,38],[14,24,34],[18,28,38],[22,32,42],[26,36,46],
  [15,25,35,45],[17,27,27,37],[9,19,29,39],[11,21,21,31],[3,13,23,33],
  [20,30,30,40],[12,22,32,42],[14,24,24,34],[6,16,26,36],[8,18,18,28],
  [12,22,22,32,32],[4,14,24,34,44],[16,16,26,26,36],[8,18,28,28,38],
  [10,20,20,30,40],[5,15,15,25,25,35],[7,17,17,27,27,37],[9,19,19,29,29,39],
  [11,21,21,31,31,41],[13,23,23,33,33,43]],
 [[0],[12],[24],[36],[48],[30],[42],[54],[66],[78],[11,31],[17,37],[13,53], # 18
  [19,59],[13,53],[19,59],[25,65],[25,65],[31,71],[37,77],[1,41],[7,47],[35,55],
  [35,55],[41,61],[47,67],[23,43],[29,49],[23,43],[29,49],[2,22,42],[6,26,46],
  [10,30,50],[10,30,50],[14,34,54],[18,38,58],[14,34,54],[18,38,58],[22,42,62],
  [26,46,66],[12,32,52],[16,36,56],[20,40,60],[20,40,60],[24,44,64],[28,48,68],
  [24,44,64],[28,48,68],[32,52,72],[36,56,76],[15,35,55,75],[27,27,47,67],
  [19,39,39,59],[11,31,51,51],[3,23,43,63],[30,30,50,70],[22,42,42,62],
  [14,34,54,54],[6,26,46,66],[18,18,38,58],[25,45,45,65],[17,37,57,57],
  [9,29,49,69],[21,21,41,61],[13,33,33,53],[20,40,60,60],[12,32,52,72],
  [24,24,44,64],[16,36,36,56],[8,28,48,48],[12,32,32,52,52],[22,22,42,62,62],
  [4,24,44,44,64],[14,34,34,54,74],[16,16,36,56,56],[26,26,46,46,66],
  [8,28,28,48,68],[18,38,38,58,58],[20,20,40,40,60],[10,30,50,50,70],
  [15,15,35,35,55,55],[17,17,37,37,57,57],[19,19,39,39,59,59],
  [11,31,31,51,51,71],[13,33,33,53,53,73],[5,25,25,45,45,65],[7,27,27,47,47,67],
  [9,29,29,49,49,69],[21,21,41,41,61,61],[23,23,43,43,63,63]],
 [[0],[12],[24],[36],[48],[20],[32],[44],[56],[68],[40],[52],[64],[76],[88],
  [21,51],[27,57],[33,63],[39,69],[33,63],[39,69],[45,75],[45,75],[51,81],
  [57,87],[11,41],[17,47],[23,53],[29,59],[23,53],[29,59],[35,65],[35,65],
  [41,71],[47,77],[1,31],[7,37],[13,43],[19,49],[13,43],[19,49],[25,55],[25,55],
  [31,61],[37,67],[2,32,62],[26,26,56],[20,50,50],[20,50,50],[14,44,74],
  [38,38,68],[14,44,74],[38,38,68],[32,62,62],[26,56,86],[22,22,52],[16,46,46],
  [10,40,70],[10,40,70],[34,34,64],[28,58,58],[34,34,64],[28,58,58],[22,52,82],
  [46,46,76],[12,42,42],[6,36,66],[30,30,60],[30,30,60],[24,54,54],[18,48,78],
  [24,54,54],[18,48,78],[42,42,72],[36,66,66],[15,45,45,75],[27,27,57,57],
  [9,39,39,69],[21,21,51,51],[3,33,33,63],[35,35,65,65],[17,47,47,77],
  [29,29,59,59],[11,41,41,71],[23,23,53,53],[25,55,55,85],[37,37,67,67],
  [19,49,49,79],[31,31,61,61],[13,43,43,73],[30,30,60,60],[12,42,42,72],
  [24,24,54,54],[6,36,36,66],[18,18,48,48],[20,50,50,80],[32,32,62,62],
  [14,44,44,74],[26,26,56,56],[8,38,38,68],[40,40,70,70],[22,52,52,82],
  [34,34,64,64],[16,46,46,76],[28,28,58,58],[12,42,42,72,72],[32,32,32,62,62],
  [22,22,52,52,52],[24,24,54,54,84],[14,44,44,44,74],[4,34,34,64,64],
  [36,36,36,66,66],[26,26,56,56,56],[16,16,46,46,76],[18,48,48,48,78],
  [8,38,38,68,68],[28,28,28,58,58],[30,30,60,60,60],[20,20,50,50,80],
  [10,40,40,40,70],[25,25,25,55,55,55],[7,37,37,37,67,67],[19,19,49,49,49,79],
  [31,31,31,61,61,61],[13,43,43,43,73,73],[5,35,35,35,65,65],
  [17,17,47,47,47,77],[29,29,29,59,59,59],[11,41,41,41,71,71],
  [23,23,53,53,53,83],[15,15,45,45,45,75],[27,27,27,57,57,57],
  [9,39,39,39,69,69],[21,21,51,51,51,81],[33,33,33,63,63,63]],
 [[0],[12],[24],[36],[48],[20],[32],[44],[56],[68],[40],[52],[64],[76],[88],
  [30],[42],[54],[66],[78],[50],[62],[74],[86],[98],[70],[82],[94],[106],
  [118],[51,51],[57,57],[33,93],[39,99],[33,93],[39,99],[45,105],[45,105],
  [51,111],[57,117],[41,41],[47,47],[53,53],[59,59],[53,53],[59,59],[35,95],
  [35,95],[41,101],[47,107],[31,31],[37,37],[43,43],[49,49],[43,43],[49,49],
  [55,55],[55,55],
[31,91],[37,97],[21,81],[27,87],[63,63],[69,69],[63,63],[69,
69],[75,75],[75,75],[81,81],[87,87],[11,71],[17,77],[23,83],
[29,89],[23,83],[29,89],[65,65],[65,65],[71,71],[77,77],[1,
61],[7,67],[13,73],[19,79],[13,73],[19,79],[25,85],[25,85],
[61,61],[67,67],[2,62,62],[26,26,86],[50,50,50],[50,50,50],
[14,74,74],[38,38,98],[14,74,74],[38,38,98],[62,62,62],[26,
86,86],[32,32,92],[56,56,56],[20,80,80],[20,80,80],[44,44,
104],[68,68,68],[44,44,104],[68,68,68],[32,92,92],[56,56,
116],[22,22,82],[46,46,46],[10,70,70],[10,70,70],[34,34,94],
[58,58,58],[34,34,94],[58,58,58],[22,82,82],[46,46,106],[52,
52,52],[16,76,76],[40,40,100],[40,40,100],[64,64,64],[28,88,
88],[64,64,64],[28,88,88],[52,52,112],[76,76,76],[42,42,42],
[6,66,66],[30,30,90],[30,30,90],[54,54,54],[18,78,78],[54,
54,54],[18,78,78],[42,42,102],[66,66,66],[12,72,72],[36,36,
96],[60,60,60],[60,60,60],[24,84,84],[48,48,108],[24,84,84],
[48,48,108],[72,72,72],[36,96,96],[15,75,75,75],[27,27,87,
87],[39,39,39,99],[51,51,51,51],[3,63,63,63],[35,35,95,95],
[47,47,47,107],[59,59,59,59],[11,71,71,71],[23,23,83,83],
[55,55,55,115],[67,67,67,67],[19,79,79,79],[31,31,91,91],
[43,43,43,103],[30,30,90,90],[42,42,42,102],[54,54,54,54],
[6,66,66,66],[18,18,78,78],[50,50,50,110],[62,62,62,62],
[14,74,74,74],[26,26,86,86],[38,38,38,98],[70,70,70,70],
[22,82,82,82],[34,34,94,94],[46,46,46,106],[58,58,58,58],
[45,45,45,105],[57,57,57,57],[9,69,69,69],[21,21,81,81],
[33,33,33,93],[65,65,65,65],[17,77,77,77],[29,29,89,89],
[41,41,41,101],[53,53,53,53],[25,85,85,85],[37,37,97,97],
[49,49,49,109],[61,61,61,61],[13,73,73,73],[60,60,60,60],
[12,72,72,72],[24,24,84,84],[36,36,36,96],[48,48,48,48],
[20,80,80,80],[32,32,92,92],[44,44,44,104],[56,56,56,56],
[8,68,68,68],[40,40,100,100],[52,52,52,112],[64,64,64,64],
[16,76,76,76],[28,28,88,88],[12,72,72,72,72],[32,32,32,92,
92],[52,52,52,52,52],[42,42,42,102,102],[62,62,62,62,62],
[22,22,82,82,82],[24,24,84,84,84],[44,44,44,44,104],[4,64,
64,64,64],[54,54,54,54,114],[14,74,74,74,74],[34,34,34,94,
94],[36,36,36,96,96],[56,56,56,56,56],[16,16,76,76,76],[66,
66,66,66,66],[26,26,86,86,86],[46,46,46,46,106],[48,48,48,
48,108],[8,68,68,68,68],[28,28,28,88,88],[18,78,78,78,78],
[38,38,38,98,98],[58,58,58,58,58],[60,60,60,60,60],[20,20,
80,80,80],[40,40,40,40,100],[30,30,90,90,90],[50,50,50,50,
110],[10,70,70,70,70],[25,25,25,85,85,85],[7,67,67,67,67,
67],[49,49,49,49,49,109],[61,61,61,61,61,61],[43,43,43,43,
103,103],[35,35,35,35,95,95],[17,17,77,77,77,77],[59,59,59,
59,59,59],[11,71,71,71,71,71],[53,53,53,53,53,113],[45,45,
45,45,45,105],[27,27,27,87,87,87],[9,69,69,69,69,69],[21,
21,81,81,81,81],[63,63,63,63,63,63],[55,55,55,55,55,55],
[37,37,37,37,97,97],[19,19,79,79,79,79],[31,31,31,91,91,
91],[13,73,73,73,73,73],[5,65,65,65,65,65],[47,47,47,47,
47,107],[29,29,29,89,89,89],[41,41,41,41,101,101],[23,23,
83,83,83,83],[15,15,75,75,75,75],[57,57,57,57,57,57],[39,
39,39,39,99,99],[51,51,51,51,51,111],[33,33,33,93,93,93]],
 [[0],[20],[40],[21,39],[27,33],[11,29],[17,23],[1,19],[7,13],[2,20,38],
  [14,20,26],[10,22,28],[10,16,34],[12,18,30],[6,24,30],[3,9,21,27],
  [11,17,23,29],[13,19,31,37],[6,12,18,24],[8,14,26,32],[16,22,28,34],
  [12,18,24,30,36],[8,14,20,26,32],[4,10,16,22,28],[7,13,19,25,25,31],
  [9,15,15,21,27,33],[5,11,17,23,29,35]],
 [[0],[20],[40],[30],[50],[70],[39,51],[33,57],[21,69],[27,63],[29,41],[23,47],
  [17,53],[11,59],[19,31],[13,37],[7,43],[1,49],[2,38,50],[14,26,50],[20,32,68],
  [20,44,56],[10,22,58],[10,34,46],[28,40,52],[16,40,64],[18,30,42],[6,30,54],
  [12,48,60],[24,36,60],[3,27,39,51],[11,23,47,59],[19,31,43,67],[6,18,42,54],
  [14,26,38,62],[22,34,46,58],[9,21,33,57],[17,29,41,53],[13,37,49,61],
  [12,24,36,48],[8,32,44,56],[16,28,52,64],[12,24,36,48,60],[8,20,32,44,56],
  [4,16,28,40,52],[18,30,42,54,66],[14,26,38,50,62],[10,22,34,46,58],
  [13,25,25,37,49,61],[7,19,31,43,55,55],[11,23,35,35,47,59],[5,17,29,41,53,65],
  [9,21,33,45,45,57],[15,15,27,39,51,63]],
 [[0],[30],[11,19],[13,17],[1,29],[7,23],[2,10,18],[6,10,14],[12,20,28],
  [16,20,24],[3,11,19,27],[6,14,18,22],[9,13,17,21],[8,12,16,24],[4,8,12,16,20],
  [10,14,18,22,26],[7,11,15,15,19,23],[5,9,13,17,21,25]]]

chevieset(:G4_22, :sparseFakeDegrees,ST->sparseFakeDegrees4_22[ST-3])
chevieset(:G4_22, :FakeDegree, function (ST, phi, q)
  f=sparseFakeDegrees4_22[ST-3][findfirst(==(phi),
                      chevieget(:G4_22,:CharInfo)(ST)[:charparams])]
  sum(q.^f)
end)
chevieset(:G4_22, :LowestPowerFakeDegrees,ST->
        first.(chevieget(:G4_22, :sparseFakeDegrees)(ST)))
