# auto-generated tests from julia-repl docstrings
using Test, Gapjm
function mytest(a::String,b::String)
  a=repr(MIME("text/plain"),eval(Meta.parse(a)),context=:limit=>true)
  a=replace(a,r" *\n"s=>"\n")
  a=replace(a,r" *$"s=>"")
  if a!=b print("a=$a
b=$b
") end
  a==b
end
@testset "CoxGroups.jl" begin
@test mytest("W=coxsym(4)","coxsym(4)")
@test mytest("p=W(1,3,2,1,3)","UInt8(1,4)")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 2\n 3\n 2\n 1")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 2\n 3\n 2\n 1")
@test mytest("word(W,longest(W))","6-element Array{Int64,1}:\n 1\n 2\n 1\n 3\n 2\n 1")
@test mytest("w0=longest(W)","UInt8(1,4)(2,3)")
@test mytest("length(W,w0)","6")
@test mytest("map(i->word(W,reflection(W,i)),1:nref(W))","6-element Array{Array{Int64,1},1}:\n [1]\n [2]\n [3]\n [1, 2, 1]\n [2, 3, 2]\n [1, 2, 3, 2, 1]")
@test mytest("[length(elements(W,i)) for i in 0:nref(W)]","7-element Array{Int64,1}:\n 1\n 3\n 5\n 6\n 5\n 3\n 1")
@test mytest("[length(elements(W,i)) for i in 0:nref(W)]","7-element Array{Int64,1}:\n 1\n 3\n 5\n 6\n 5\n 3\n 1")
@test mytest("W=coxgroup(:G,2)","W(G₂)")
@test mytest("H=reflection_subgroup(W,[2,6])","W(G₂)₂₄")
@test mytest("Set(word.(Ref(W),reduced.(Ref(H),elements(W))))","Set(Array{Int64,1}[[1], []])")
@test mytest("Set(word.(Ref(W),reduced.(Ref(H),elements(W))))","Set(Array{Int64,1}[[1], []])")
@test mytest("W=coxgroup(:G,2)","W(G₂)")
@test mytest("H=reflection_subgroup(W,[2,6])","W(G₂)₂₄")
@test mytest("[word(W,w) for S in reduced(H,W) for w in S]","2-element Array{Array{Int64,1},1}:\n []\n [1]")
end
@testset "CycPols.jl" begin
@test mytest("Pol(:q)","q")
@test mytest("p=CycPol(q^18 + q^16 + 2*q^12 + q^8 + q^6)","(q⁸+q⁶-q⁴+q²+1)q⁶Φ₈")
@test mytest("p*inv(CycPol(q^2+q+1))","(q⁸+q⁶-q⁴+q²+1)q⁶Φ₃⁻¹Φ₈")
end
@testset "Cycs.jl" begin
@test mytest("E(3)+E(4)","ζ₁₂⁴-ζ₁₂⁷-ζ₁₂¹¹")
@test mytest("E(3,2)","ζ₃²")
@test mytest("1+E(3,2)","-ζ₃")
@test mytest("a=E(4)-E(4)","0")
@test mytest("conductor(a)","1")
@test mytest("typeof(convert(Int,a))","Int64")
@test mytest("c=inv(1+E(4))","1//2+(-1//2)ζ₄")
@test mytest("typeof(c)","Cyc{Rational{Int64}}")
@test mytest("typeof(1+E(4))","Cyc{Int64}")
@test mytest("Cyc(1+im)","1+ζ₄")
@test mytest("1//(1+E(4))","1//2+(-1//2)ζ₄")
@test mytest("typeof(Cyc(1//2))","Cyc{Rational{Int64}}")
@test mytest("conj(1+E(4))","1-ζ₄")
@test mytest("c=E(9)","-ζ₉⁴-ζ₉⁷")
@test mytest("Root1(c)","Root1(1//9)")
@test mytest("c=Complex(E(3))","-0.4999999999999998 + 0.8660254037844387im")
@test mytest("Cyc(c)","-0.4999999999999998+0.8660254037844387ζ₄")
@test mytest("Cyc(c)","-0.4999999999999998+0.8660254037844387ζ₄")
@test mytest("galois(1+E(4),-1)","1-ζ₄")
@test mytest("galois(ER(5),2)==-ER(5)","true")
@test mytest("galois(ER(5),2)==-ER(5)","true")
@test mytest("ER(-3)","ζ₃-ζ₃²")
@test mytest("ER(3)","-ζ₁₂⁷+ζ₁₂¹¹")
@test mytest("ER(3)","-ζ₁₂⁷+ζ₁₂¹¹")
@test mytest("quadratic(1+E(3))","(a = 1, b = 1, root = -3, den = 2)")
@test mytest("quadratic(1+E(5))","nothing")
end
@testset "Garside.jl" begin
@test mytest("W=coxgroup(:A,4)","W(A₄)")
@test mytest("B=BraidMonoid(W)","BraidMonoid(W(A₄))")
@test mytest("B=BraidMonoid(W)","BraidMonoid(W(A₄))")
@test mytest("w=B(1,2,3,4)","1234")
@test mytest("w^3","121321432.343")
@test mytest("word(W,α(w^3))","9-element Array{Int64,1}:\n 1\n 2\n 1\n 3\n 2\n 1\n 4\n 3\n 2")
@test mytest("w^4","δ.232432")
@test mytest("inv(w)","(1234)⁻¹")
@test mytest("inv(w)","(1234)⁻¹")
@test mytest("repr(w^-1,context=IOContext(stdout,:greedy=>true,:limit=>true))","\"δ⁻¹.232432\"")
@test mytest("repr(w^-1,context=IOContext(stdout,:greedy=>true,:limit=>true))","\"δ⁻¹.232432\"")
@test mytest("repr(w)","\"B(1,2,3,4)\"")
@test mytest("repr(w^3)","\"B(1,2,1,3,2,1,4,3,2,3,4,3)\"")
@test mytest("repr(w^-1)","\"B(-4,-3,-2,-1)\"")
@test mytest("repr(w^-1)","\"B(-4,-3,-2,-1)\"")
@test mytest("b=B(2,1,4,1,4)","214.14")
@test mytest("c=B(1,4,1,4,3)","14.143")
@test mytest("d=representative_operation(b,c)","(1)⁻¹21321432")
@test mytest("b^d","14.143")
@test mytest("centralizer_generators(b)","3-element Array{Gapjm.Garside.GarsideElm{Perm{Int16},BraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1}:\n 21.1\n 321432.213243\n 4")
@test mytest("C=conjcat(b,:ss)","category with 10 objects and 32 maps")
@test mytest("C.obj","10-element Array{Gapjm.Garside.GarsideElm{Perm{Int16},BraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1}:\n 214.14\n 14.124\n 143.13\n 1214.4\n 13.134\n 124.24\n 1343.1\n 24.214\n 134.14\n 14.143")
@test mytest("C.obj","10-element Array{Gapjm.Garside.GarsideElm{Perm{Int16},BraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1}:\n 214.14\n 14.124\n 143.13\n 1214.4\n 13.134\n 124.24\n 1343.1\n 24.214\n 134.14\n 14.143")
@test mytest("word(W,preferred_prefix(b))","2-element Array{Int64,1}:\n 2\n 1")
@test mytest("b^B(preferred_prefix(b))","1214.4")
@test mytest("b1=b^B(preferred_prefix(b))","1214.4")
@test mytest("C=conjcat(b)","category with 3 objects and 7 maps")
@test mytest("C.obj","3-element Array{Gapjm.Garside.GarsideElm{Perm{Int16},BraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1}:\n 214.14\n 1214.4\n 1343.1")
@test mytest("C.obj","3-element Array{Gapjm.Garside.GarsideElm{Perm{Int16},BraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1}:\n 214.14\n 1214.4\n 1343.1")
@test mytest("W=coxgroup(:A,3)","W(A₃)")
@test mytest("B=BraidMonoid(W)","BraidMonoid(W(A₃))")
@test mytest("pi=B(B.delta)^2","δ²")
@test mytest("root(pi,2)","δ")
@test mytest("root(pi,3)","1232")
@test mytest("root(pi,4)","132")
@test mytest("root(pi,4)","132")
@test mytest("W=coxgroup(:A,3)","W(A₃)")
@test mytest("B=BraidMonoid(W)","BraidMonoid(W(A₃))")
@test mytest("map(x->B.(x),Garside.left_divisors(B,W(1,3,2)))","4-element Array{Array{Gapjm.Garside.GarsideElm{Perm{Int16},BraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1},1}:\n [.]\n [1, 3]\n [13]\n [132]")
@test mytest("B=DualBraidMonoid(W)","DualBraidMonoid(W(A₃),c=[1, 3, 2])")
@test mytest("map(x->B.(x),Garside.left_divisors(B,W(1,3,2)))","4-element Array{Array{Gapjm.Garside.GarsideElm{Perm{Int16},DualBraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1},1}:\n [.]\n [1, 2, 3, 4, 5, 6]\n [12, 13, 15, 25, 34, 45]\n [δ]")
@test mytest("map(x->B.(x),Garside.left_divisors(B,W(1,3,2)))","4-element Array{Array{Gapjm.Garside.GarsideElm{Perm{Int16},DualBraidMonoid{Perm{Int16},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}},1},1}:\n [.]\n [1, 2, 3, 4, 5, 6]\n [12, 13, 15, 25, 34, 45]\n [δ]")
@test mytest("W=coxgroup(:A,3)","W(A₃)")
@test mytest("B=DualBraidMonoid(W)","DualBraidMonoid(W(A₃),c=[1, 3, 2])")
@test mytest("B(2,1,2,1,1)","12.1.1.1")
@test mytest("B(-1,-2,-3,1,1)","(25.1)⁻¹1.1")
@test mytest("B(-1,-2,-3,1,1)","(25.1)⁻¹1.1")
@test mytest("B=BraidMonoid(coxgroup(:A,3))","BraidMonoid(W(A₃))")
@test mytest("b=B( 2, 1, -3, 1, 1)","(23)⁻¹321.1.1")
@test mytest("fraction(b)","(23, 321.1.1)")
@test mytest("fraction(b)","(23, 321.1.1)")
@test mytest("B=BraidMonoid(coxgroup(:A,3))","BraidMonoid(W(A₃))")
@test mytest("b=B(2,1,2,1,1)*inv(B(2,2))","(21)⁻¹1.12.21")
@test mytest("word(b)","7-element Array{Int64,1}:\n -1\n -2\n  1\n  1\n  2\n  2\n  1")
@test mytest("word(b)","7-element Array{Int64,1}:\n -1\n -2\n  1\n  1\n  2\n  2\n  1")
@test mytest("W=coxgroup(:D,4)","W(D₄)")
@test mytest("B=BraidMonoid(coxgroup(:D,4))","BraidMonoid(W(D₄))")
@test mytest("b=B(2,3,1,2,4,3);b1=B(1,4,3,2,2,2)","1432.2.2")
@test mytest("representative_operation(b,b1)","(134312.23)⁻¹")
@test mytest("representative_operation(b,b1,:cyc)","232.2")
@test mytest("representative_operation(b,b1,:cyc)","232.2")
@test mytest("B=BraidMonoid(coxsym(3))","BraidMonoid(coxsym(3))")
@test mytest("b=[B(1)^3,B(2)^3,B(-2,-1,-1,2,2,2,2,1,1,2),B(1,1,1,2)]","4-element Array{Gapjm.Garside.GarsideElm{Perm{UInt8},BraidMonoid{Perm{UInt8},Gapjm.CoxGroups.CoxSymmetricGroup{UInt8}}},1}:\n 1.1.1\n 2.2.2\n (1.12)⁻¹2.2.2.21.12\n 1.1.12")
@test mytest("shrink(b)","2-element Array{Gapjm.Garside.GarsideElm{Perm{UInt8},BraidMonoid{Perm{UInt8},Gapjm.CoxGroups.CoxSymmetricGroup{UInt8}}},1}:\n 2\n 1")
end
@testset "Hecke.jl" begin
@test mytest("W=coxgroup(:A,2)","W(A₂)")
@test mytest("H=hecke(W,0)","Hecke(W(A₂),0)")
@test mytest("T=Tbasis(H)","(::getfield(Gapjm.Hecke, Symbol(\"#f#24\")){Int64,Perm{Int16},HeckeAlgebra{Int64,Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}}) (generic function with 4 methods)")
@test mytest("el=words(W)","6-element Array{Array{Int8,1},1}:\n []\n [2]\n [1]\n [2, 1]\n [1, 2]\n [1, 2, 1]")
@test mytest("T.(el)*permutedims(T.(el))","6×6 Array{HeckeTElt{Perm{Int16},Int64,Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}},2}:\n T.    T₂     T₁     T₂₁    T₁₂    T₁₂₁\n T₂    -T₂    T₂₁    -T₂₁   T₁₂₁   -T₁₂₁\n T₁    T₁₂    -T₁    T₁₂₁   -T₁₂   -T₁₂₁\n T₂₁   T₁₂₁   -T₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁\n T₁₂   -T₁₂   T₁₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁\n T₁₂₁  -T₁₂₁  -T₁₂₁  T₁₂₁   T₁₂₁   -T₁₂₁")
@test mytest("T.(el)*permutedims(T.(el))","6×6 Array{HeckeTElt{Perm{Int16},Int64,Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}},2}:\n T.    T₂     T₁     T₂₁    T₁₂    T₁₂₁\n T₂    -T₂    T₂₁    -T₂₁   T₁₂₁   -T₁₂₁\n T₁    T₁₂    -T₁    T₁₂₁   -T₁₂   -T₁₂₁\n T₂₁   T₁₂₁   -T₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁\n T₁₂   -T₁₂   T₁₂₁   -T₁₂₁  -T₁₂₁  T₁₂₁\n T₁₂₁  -T₁₂₁  -T₁₂₁  T₁₂₁   T₁₂₁   -T₁₂₁")
@test mytest("W=coxgroup(:B,2)","W(B₂)")
@test mytest("Pol(:q)","q")
@test mytest("H=hecke(W,q)","Hecke(W(B₂),q)")
@test mytest("H.para","2-element Array{Array{Pol{Int64},1},1}:\n [q, -1]\n [q, -1]")
@test mytest("H=hecke(W,q^2,rootpara=q)","Hecke(W(B₂),q²,rootpara=q)")
@test mytest("[H.para,rootpara(H)]","2-element Array{Array{T,1} where T,1}:\n Array{Pol{Int64},1}[[q², -1], [q², -1]]\n Pol{Int64}[q, q]")
@test mytest("H=hecke(W,[q^2,q^4],rootpara=[q,q^2])","Hecke(W(B₂),Pol{Int64}[q², q⁴],rootpara=Pol{Int64}[q, q²])")
@test mytest("[H.para,rootpara(H)]","2-element Array{Array{T,1} where T,1}:\n Array{Pol{Int64},1}[[q², -1], [q⁴, -1]]\n Pol{Int64}[q, q²]")
@test mytest("H=hecke(W,9,rootpara=3)","Hecke(W(B₂),9,rootpara=3)")
@test mytest("[H.para,rootpara(H)]","2-element Array{Array{T,1} where T,1}:\n Array{Int64,1}[[9, -1], [9, -1]]\n [3, 3]")
end
@testset "KL.jl" begin
@test mytest("W=coxgroup(:F,4)","W(F₄)")
@test mytest("w=longest(W)*gens(W)[1];length(W,w)","23")
@test mytest("y=element(W,1:4...);length(W,y)","4")
@test mytest("cr=KL.critical_pair(W,y,w);length(W,cr)","16")
@test mytest("Pol(:x);KLPol(W,y,w)","x³+1")
@test mytest("KLPol(W,cr,w)","x³+1")
@test mytest("KLPol(W,cr,w)","x³+1")
@test mytest("W=coxgroup(:B,3)","W(B₃)")
@test mytest("map(i->map(x->KLPol(W,one(W),x),elements(W,i)),1:W.N)","9-element Array{Array{Pol{Int64},1},1}:\n [1, 1, 1]\n [1, 1, 1, 1, 1]\n [1, 1, 1, 1, 1, 1, 1]\n [1, 1, 1, x+1, 1, 1, 1, 1]\n [x+1, 1, 1, x+1, x+1, 1, x+1, 1]\n [1, x+1, 1, x+1, x+1, x²+1, 1]\n [x+1, x+1, x²+x+1, 1, 1]\n [x²+1, x+1, 1]\n [1]")
@test mytest("map(i->map(x->KLPol(W,one(W),x),elements(W,i)),1:W.N)","9-element Array{Array{Pol{Int64},1},1}:\n [1, 1, 1]\n [1, 1, 1, 1, 1]\n [1, 1, 1, 1, 1, 1, 1]\n [1, 1, 1, x+1, 1, 1, 1, 1]\n [x+1, 1, 1, x+1, x+1, 1, x+1, 1]\n [1, x+1, 1, x+1, x+1, x²+1, 1]\n [x+1, x+1, x²+x+1, 1, 1]\n [x²+1, x+1, 1]\n [1]")
@test mytest("W=coxgroup(:B,3)","W(B₃)")
@test mytest("Pol(:v);H=hecke(W,v^2,rootpara=v)","Hecke(W(B₃),v²,rootpara=v)")
@test mytest("C=Cpbasis(H)","(::getfield(Gapjm.KL, Symbol(\"#f#10\")){Pol{Int64},Perm{Int16},HeckeAlgebra{Pol{Int64},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}}) (generic function with 4 methods)")
@test mytest("T=Tbasis(H)","(::getfield(Gapjm.Hecke, Symbol(\"#f#24\")){Pol{Int64},Perm{Int16},HeckeAlgebra{Pol{Int64},Gapjm.Weyl.FCG{Int16,Int64,PRG{Int64,Int16}}}}) (generic function with 4 methods)")
@test mytest("T(C(1,2))","v⁻²T.+v⁻²T₂+v⁻²T₁+v⁻²T₁₂")
end
@testset "PermGroups.jl" begin
@test mytest("G=PermGroup([Perm(i,i+1) for i in 1:2])","PermGroup((1,2),(2,3))")
@test mytest("collect(G)","6-element Array{Perm{Int64},1}:\n (1,2)\n (1,3,2)\n ()\n (1,2,3)\n (1,3)\n (2,3)")
@test mytest("degree(G)","3")
@test mytest("orbit(G,1)","3-element Array{Int64,1}:\n 2\n 3\n 1")
@test mytest("orbit_and_representative(G,1)","Dict{Int64,Perm{Int64}} with 3 entries:\n  2 => (1,2)\n  3 => (1,3,2)\n  1 => ()")
@test mytest("orbit_and_representative(G,[1,2],action=(x,y)->x.^Ref(y))","Dict{Array{Int64,1},Perm{Int64}} with 6 entries:\n  [1, 3] => (2,3)\n  [1, 2] => ()\n  [2, 3] => (1,2,3)\n  [3, 2] => (1,3)\n  [2, 1] => (1,2)\n  [3, 1] => (1,3,2)")
@test mytest("Perm(1,2) in G","true")
@test mytest("Perm(1,2,4) in G","false")
@test mytest("base(G)","2-element Array{Int64,1}:\n 1\n 2")
@test mytest("centralizers(G)","2-element Array{PermGroup{Int64},1}:\n PermGroup((1,2),(2,3))\n PermGroup((2,3))")
@test mytest("centralizer_orbits(G)","2-element Array{Dict{Int64,Perm{Int64}},1}:\n Dict(2=>(1,2),3=>(1,3,2),1=>())\n Dict(2=>(),3=>(2,3))")
@test mytest("minimal_words(G)","Dict{Perm{Int64},Array{Int64,1}} with 6 entries:\n  ()      => Int64[]\n  (2,3)   => [2]\n  (1,3,2) => [1, 2]\n  (1,3)   => [1, 2, 1]\n  (1,2)   => [1]\n  (1,2,3) => [2, 1]")
end
@testset "Perms.jl" begin
@test mytest("p=Perm(1,2)*Perm(2,3)","(1,3,2)")
@test mytest("Perm{Int8}(p)","Int8(1,3,2)")
@test mytest("1^p","3")
@test mytest("Matrix(p)","3×3 Array{Int64,2}:\n 0  0  1\n 1  0  0\n 0  1  0")
@test mytest("p^Perm(3,10)","(1,10,2)")
@test mytest("inv(p)","(1,2,3)")
@test mytest("one(p)","()")
@test mytest("order(p)","3")
@test mytest("degree.((Perm(1,2),Perm(2,3)))","(2, 3)")
@test mytest("largest_moved_point(Perm(1,2)*Perm(2,3)^2)","2")
@test mytest("smallest_moved_point(Perm(2,3))","2")
#@test mytest("rand(Perm,10)","(1,8,4,2,9,7,5,10,3,6)")
#@test mytest("rand(Perm,10)","(1,8,4,2,9,7,5,10,3,6)")
@test mytest("cycles(Perm(1,2)*Perm(4,5))","3-element Array{Array{Int64,1},1}:\n [1, 2]\n [3]\n [4, 5]")
@test mytest("cycles(Perm(1,2)*Perm(4,5))","3-element Array{Array{Int64,1},1}:\n [1, 2]\n [3]\n [4, 5]")
@test mytest("cycletype(Perm(1,2)*Perm(3,4))","1-element Array{Pair{Tuple{Int64,Int64},Int64},1}:\n (2, 1) => 2")
end
@testset "Pols.jl" begin
@test mytest("Pol(:q)","q")
@test mytest("Pol([1,2],0)","2q+1")
@test mytest("p=Pol([1,2],-1)","2+q⁻¹")
@test mytest("valuation(p)","-1")
@test mytest("p=(q+1)^2","q²+2q+1")
@test mytest("degree(p)","2")
@test mytest("p(1//2)","9//4")
@test mytest("divrem(q^3+1,q+2)","(1.0q²-2.0q+4.0, -7.0)")
@test mytest("divrem1(q^3+1,q+2)","(q²-2q+4, -7)")
@test mytest("cyclotomic_polynomial(24)","q⁸-q⁴+1")
@test mytest("cyclotomic_polynomial(24)","q⁸-q⁴+1")
@test mytest("gcd(q+1,q^2-1)","1.0q+1.0")
@test mytest("gcd(q+1//1,q^2-1//1)","(1//1)q+1//1")
end
@testset "Symbols.jl" begin
@test mytest("shiftβ([4,5],3)","5-element Array{Int64,1}:\n 0\n 1\n 2\n 7\n 8")
@test mytest("shiftβ([0,1,4,5],-2)","2-element Array{Int64,1}:\n 2\n 3")
@test mytest("shiftβ([0,1,4,5],-2)","2-element Array{Int64,1}:\n 2\n 3")
@test mytest("βSet([3,3,1])","3-element Array{Int64,1}:\n 1\n 4\n 5")
@test mytest("βSet([3,3,1])","3-element Array{Int64,1}:\n 1\n 4\n 5")
@test mytest("partβ([0,4,5])","2-element Array{Int64,1}:\n 3\n 3")
@test mytest("partβ([0,4,5])","2-element Array{Int64,1}:\n 3\n 3")
@test mytest("symbol_partition_tuple([[1,2],[1]],1)","2-element Array{Array{Int64,1},1}:\n [2, 2]\n [1]")
@test mytest("symbol_partition_tuple([[1,2],[1]],0)","2-element Array{Array{Int64,1},1}:\n [2, 2]\n [0, 2]")
@test mytest("symbol_partition_tuple([[1,2],[1]],-1)","2-element Array{Array{Int64,1},1}:\n [2, 2]\n [0, 1, 3]")
@test mytest("symbol_partition_tuple([[1,2],[1]],-1)","2-element Array{Array{Int64,1},1}:\n [2, 2]\n [0, 1, 3]")
@test mytest("ranksymbol([[1,2],[1,5,6]])","11")
@test mytest("ranksymbol([[1,2],[1,5,6]])","11")
@test mytest("stringsymbol.(symbols(3,2,1))","14-element Array{String,1}:\n \"(12,0,0)\"\n \"(02,1,0)\"\n \"(02,0,1)\"\n \"(012,12,01)\"\n \"(01,1,1)\"\n \"(012,01,12)\"\n \"(2,,)\"\n \"(01,2,0)\"\n \"(01,0,2)\"\n \"(1,012,012)\"\n \"(,02,01)\"\n \"(,01,02)\"\n \"(0,,012)\"\n \"(0,012,)\"")
@test mytest("stringsymbol.(symbols(3,3,0))","10-element Array{String,1}:\n \"(1,1,1)\"\n \"(01,12,02)\"\n \"(01,02,12)\"\n \"(012,012,123)\"\n \"(0,1,2)\"\n \"(0,2,1)\"\n \"(01,01,13)\"\n \"(0,0,3)\"\n \"(012,,)\"\n \"(012,012,)\"")
@test mytest("stringsymbol.(symbols(3,3,0))","10-element Array{String,1}:\n \"(1,1,1)\"\n \"(01,12,02)\"\n \"(01,02,12)\"\n \"(012,012,123)\"\n \"(0,1,2)\"\n \"(0,2,1)\"\n \"(01,01,13)\"\n \"(0,0,3)\"\n \"(012,,)\"\n \"(012,012,)\"")
@test mytest("fegsymbol([[1,5,6],[1,2]])","q¹⁶Φ₅Φ₇Φ₈Φ₉Φ₁₀Φ₁₁Φ₁₄Φ₁₆Φ₁₈Φ₂₀Φ₂₂")
end
@testset "Weyl.jl" begin
@test mytest("W=coxgroup(:D,4)","W(D₄)")
@test mytest("cartan(W)","4×4 Array{Int64,2}:\n  2   0  -1   0\n  0   2  -1   0\n -1  -1   2  -1\n  0   0  -1   2")
@test mytest("cartan(W)","4×4 Array{Int64,2}:\n  2   0  -1   0\n  0   2  -1   0\n -1  -1   2  -1\n  0   0  -1   2")
@test mytest("W=coxgroup(:A,2)*coxgroup(:B,2)","W(A₂)× W(B₂)₍₃₄₎")
@test mytest("cartan(W)","4×4 Array{Int64,2}:\n  2  -1   0   0\n -1   2   0   0\n  0   0   2  -2\n  0   0  -1   2")
@test mytest("cartan(W)","4×4 Array{Int64,2}:\n  2  -1   0   0\n -1   2   0   0\n  0   0   2  -2\n  0   0  -1   2")
@test mytest("W=coxgroup(:D,4)","W(D₄)")
@test mytest("p=W(1,3,2,1,3)","Int16(1,14,13,2)(3,17,8,18)(4,12)(5,20,6,15)(7,10,11,9)(16,24)(19,22,23,21)")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 3\n 1\n 2\n 3")
@test mytest("word(W,p)","5-element Array{Int64,1}:\n 1\n 3\n 1\n 2\n 3")
@test mytest("cartan(:A,4)","4×4 Array{Int64,2}:\n  2  -1   0   0\n -1   2  -1   0\n  0  -1   2  -1\n  0   0  -1   2")
@test mytest("cartan(:A,4)","4×4 Array{Int64,2}:\n  2  -1   0   0\n -1   2  -1   0\n  0  -1   2  -1\n  0   0  -1   2")
@test mytest("Weyl.two_tree(cartan(:A,4))","4-element Array{Int64,1}:\n 1\n 2\n 3\n 4")
@test mytest("Weyl.two_tree(cartan(:E,8))","(4, [2], [3, 1], [5, 6, 7, 8])")
@test mytest("Weyl.two_tree(cartan(:E,8))","(4, [2], [3, 1], [5, 6, 7, 8])")
@test mytest("W=coxgroup(:G,2)","W(G₂)")
@test mytest("Diagram(W)","O⇛ O\n1  2")
@test mytest("H=reflection_subgroup(W,[2,6])","W(G₂)₂₄")
@test mytest("Diagram(H)","O—O\n1 2")
@test mytest("Diagram(H)","O—O\n1 2")
@test mytest("inclusion(H)","3-element Array{Int64,1}:\n 2\n 4\n 6")
@test mytest("restriction(H)","12-element Array{Int64,1}:\n 0\n 1\n 0\n 2\n 0\n 3\n 0\n 0\n 0\n 0\n 0\n 0")
@test mytest("restriction(H)","12-element Array{Int64,1}:\n 0\n 1\n 0\n 2\n 0\n 3\n 0\n 0\n 0\n 0\n 0\n 0")
@test mytest("word(W,H(2))","3-element Array{Int64,1}:\n 1\n 2\n 1")
@test mytest("word(W,H(2))","3-element Array{Int64,1}:\n 1\n 2\n 1")
@test mytest("elH=word.(Ref(H),elements(H))","6-element Array{Array{Int64,1},1}:\n []\n [2]\n [1]\n [2, 1]\n [1, 2]\n [1, 2, 1]")
@test mytest("elW=word.(Ref(W),elements(H))","6-element Array{Array{Int64,1},1}:\n []\n [1, 2, 1]\n [2]\n [1, 2, 1, 2]\n [2, 1, 2, 1]\n [2, 1, 2, 1, 2]")
@test mytest("map(w->H(w...),elH)==map(w->W(w...),elW)","true")
end
