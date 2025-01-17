"""
This package depends only on the packages `Primes`, `ModuleElts`,
`CyclotomicNumbers`, `LaurentPolynomials` and `Combinat`. 

Cyclotomic  numbers, and cyclotomic polynomials  over the rationals or some
cyclotomic  field,  are  important  in  reductive  groups and  Spetses.  In
particular  Schur  elements  of  cyclotomic  Hecke algebras are products of
cyclotomic polynomials.

The  type `CycPol`  represents the  product of  a `coeff`  (a constant or a
polynomial)  with a  rational fraction  in one  variable with  all poles or
zeroes  equal to  0 or  roots of  unity. The  advantages of representing as
`CycPol`  such objects are:  nice display (factorized),  less storage, fast
multiplication,  division and evaluation. The drawback is that addition and
subtraction are not implemented!

The  method `CycPol`  takes a  `Pol` with  integer, rational  or cyclotomic
coefficients,  and  finds  the  largest  `CycPol` dividing, leaving a `Pol`
`coefficient` if the polynomial had not all its roots being roots of unity.

```julia-repl
julia> @Pol q
Pol{Int64}: q

julia> p=CycPol(q^25-q^24-2q^23-q^2+q+2) # a `Pol` coefficient remains
(q-2)Φ₁Φ₂Φ₂₃

julia> p(q) # evaluate CycPol p at q
Pol{Int64}: q²⁵-q²⁴-2q²³-q²+q+2

julia> p*inv(CycPol(q^2+q+1)) # inv is defined
(q-2)Φ₁Φ₂Φ₃⁻¹Φ₂₃

julia> -p  # one can multiply by a scalar
(-q+2)Φ₁Φ₂Φ₂₃

julia> valuation(p)
0

julia> degree(p)
25

julia> lcm(p,CycPol(q^3-1)) # lcm is fast between CycPol
(q-2)Φ₁Φ₂Φ₃Φ₂₃
```
Evaluating  a `CycPol` at  some value gives  in general a  `Pol`. There are
exceptions  where the value is still a `CycPol`: evaluating at `Pol()^n` or
at `Pol([E(n,k)],1)`. Then `subs` gives that evaluation:

```julia-repl
julia> subs(p,Pol()^-1) # evaluate as a CycPol at Pol()^-1
(2-q⁻¹)q⁻²⁴Φ₁Φ₂Φ₂₃

julia> subs(p,Pol([E(2)],1)) # or at Pol([Root1],1)
(q+2)Φ₁Φ₂Φ₄₆

```
The variable name used when printing a `CycPol` is the same as for `Pol`s.

`CycPol`s are internally a `struct` with fields:

`.coeff`:  a coefficient, usually a `Cyc` or a `Pol`. The `Pol` case allows
   to represent as `CycPol`s arbitrary `Pol`s which is useful sometimes.

`.valuation`: an `Int`.

`.v`: a list of pairs `ζ=>m` of a `Root1` `ζ` and a multiplicity `m`.

So `CycPol(c,val,v)` represents `c*q^val*prod((q-ζ)^m for (r,m) in v)`.

When showing a `CycPol`, some factors of the cyclotomic polynomial `Φₙ` are
given a special name. If `n` has a primitive root `ξ`, `ϕ′ₙ` is the product
of  the `(q-ζ)` where `ζ` runs over the odd powers of `ξ`, and `ϕ″ₙ` is the
product  for the even powers. Some further factors are recognized for small
`n`.  The  function  `show_factors`  gives  the complete list of recognized
factors:

```julia-rep1
julia> CycPols.show_factors(24)
Φ₂₄=q⁸-q⁴+1
Φ′₂₄=q⁴+ζ₃²
Φ″₂₄=q⁴+ζ₃
Φ‴₂₄=q⁴-√2q³+q²-√2q+1
Φ⁗₂₄=q⁴+√2q³+q²+√2q+1
Φ⁽⁵⁾₂₄=q⁴-√6q³+3q²-√6q+1
Φ⁽⁶⁾₂₄=q⁴+√6q³+3q²+√6q+1
Φ⁽⁷⁾₂₄=q⁴+√-2q³-q²-√-2q+1
Φ⁽⁸⁾₂₄=q⁴-√-2q³-q²+√-2q+1
Φ⁽⁹⁾₂₄=q²+ζ₃²√-2q-ζ₃
Φ⁽¹⁰⁾₂₄=q²-ζ₃²√-2q-ζ₃
Φ⁽¹¹⁾₂₄=q²+ζ₃√-2q-ζ₃²
Φ⁽¹²⁾₂₄=q²-ζ₃√-2q-ζ₃²
Φ⁽¹³⁾₂₄=q⁴-ζ₄q²-1
Φ⁽¹⁴⁾₂₄=q⁴+ζ₄q²-1
```
Such a factor can be obtained directly as:

```julia-repl
julia> CycPol(;conductor=24,no=8)
Φ⁽⁷⁾₂₄

julia> CycPol(;conductor=24,no=8)(q)
Pol{Cyc{Int64}}: q⁴+√-2q³-q²-√-2q+1
```

This package also defines
```julia-repl
julia> p=cyclotomic_polynomial(24)
Pol{Int64}: q⁸-q⁴+1

julia> CycPol(p)
Φ₂₄
```
"""
module CycPols

export CycPol, cyclotomic_polynomial, subs

using Primes: primes, factor, eachfactor, totient #Euler φ
using ModuleElts: ModuleElts, ModuleElt
using CyclotomicNumbers: CyclotomicNumbers, Root1, E, conductor, Cyc, order
using LaurentPolynomials: Pol, LaurentPolynomials, degree, valuation,
                          coefficients, pseudodiv, exactdiv
using ..Combinat: primitiveroot, divisors, collectby

Base.numerator(p::Pol{<:Integer})=p  # to put in LaurentPolynomials
Base.numerator(p::Pol{Cyc{Rational{T}}}) where T<:Integer =
  Pol{Cyc{T}}(p*denominator(p))
Base.numerator(p::Pol{Cyc{T}}) where T<:Integer =p
CyclotomicNumbers.conductor(x::Pol)=lcm(conductor.(coefficients(x)))

prime_residues=CyclotomicNumbers.prime_residues
stringexp=LaurentPolynomials.stringexp
stringind=CyclotomicNumbers.stringind
format_coefficient=CyclotomicNumbers.format_coefficient

# routine copied here to avoid dependency on Util
function stringprime(io::IO,n)
  if iszero(n) return "" end
  if get(io,:TeX,false) return "'"^n end
  n<5 ? ["′","″","‴","⁗"][n] : "⁽"*stringexp(io,n)*"⁾"
end
  
# The  computed  cyclotomic  polynomials  are  cached 
const cyclotomic_polynomial_dict=Dict(1=>Pol([-1,1]))
"""
`cyclotomic_polynomial(n)`
 
returns the `n`-th cyclotomic polynomial.
 
```julia-repl
julia> cyclotomic_polynomial(5)
Pol{Int64}: q⁴+q³+q²+q+1

julia> cyclotomic_polynomial(24)
Pol{Int64}: q⁸-q⁴+1
```
"""
function cyclotomic_polynomial(n::Integer)::Pol{Int}
  get!(cyclotomic_polynomial_dict,n) do
    res=Pol(fill(1,n),0;check=false)
    for d in divisors(n)
      if d!=1 && d!=n
        res,_=pseudodiv(res,cyclotomic_polynomial(d))
      end
    end
    res
  end
end

struct CycPol{T}
  coeff::T
  valuation::Int
  v::ModuleElt{Root1,Int}
end

# CycPols are scalars for broadcasting
Base.broadcastable(p::CycPol)=Ref(p)

Base.convert(::Type{CycPol{T1}},p::CycPol{T}) where {T1,T}=T==T1 ? p :
                               CycPol(T1(p.coeff),p.valuation,p.v)

Base.hash(a::CycPol, h::UInt)=hash(a.coeff,hash(a.valuation,hash(a.v,h)))

function Base.cmp(a::CycPol,b::CycPol)
  res=cmp(a.valuation,b.valuation)
  if !iszero(res) return res end
  res=cmp(a.v,b.v)
  if !iszero(res) return res end
  cmp(a.coeff,b.coeff)
end

Base.isless(a::CycPol,b::CycPol)=cmp(a,b)==-1

Base.:(==)(a::CycPol,b::CycPol)=cmp(a,b)==0

# see if check should be false
CycPol(c,val::Int,v::Pair{Rational{Int},Int}...)=CycPol(c,val,
  ModuleElt(Pair{Root1,Int}[Root1(;r=r)=>m for (r,m) in v];check=false)) 

Base.one(::Type{CycPol})=CycPol(1,0)
Base.one(p::CycPol)=CycPol(one(p.coeff),0)
Base.isone(p::CycPol)=isone(p.coeff) && iszero(p.valuation) && iszero(p.v)
Base.zero(::Type{CycPol{T}}) where T=CycPol(zero(T),0)
Base.zero(::Type{CycPol})=zero(CycPol{Int})
Base.zero(a::CycPol)=CycPol(zero(a.coeff),0)
Base.iszero(a::CycPol)=iszero(a.coeff)
Base.copy(a::CycPol)=CycPol(a.coeff,a.valuation,a.v)

LaurentPolynomials.degree(a::CycPol)=reduce(+,values(a.v);init=0)+a.valuation+degree(a.coeff)
LaurentPolynomials.valuation(a::CycPol)=a.valuation
LaurentPolynomials.valuation(a::CycPol,d::Root1)=reduce(+,c for (r,c) in a.v if r==d;init=0)

function Base.:*(a::CycPol,b::CycPol)
  if iszero(a) || iszero(b) return zero(a) end
  CycPol(a.coeff*b.coeff,a.valuation+b.valuation,a.v+b.v)
end

Base.conj(a::CycPol)=CycPol(conj(a.coeff),a.valuation,ModuleElt(
           inv(r)=>m for (r,m) in a.v))
Base.transpose(a::CycPol)=a
Base.:*(a::CycPol,b::Number)=iszero(b) ? zero(a) : CycPol(a.coeff*b,a.valuation,a.v)
Base.:*(b::Number,a::CycPol)=a*b
Base.:-(a::CycPol)=CycPol(-a.coeff,a.valuation,a.v)
Base.inv(a::CycPol)=CycPol(LaurentPolynomials.bestinv(a.coeff), -a.valuation, -a.v)
Base.:^(a::CycPol, n::Integer)=n>=0 ? Base.power_by_squaring(a,n) :
                                      Base.power_by_squaring(inv(a),-n)
Base.://(a::CycPol,b::CycPol)=CycPol(a.coeff//b.coeff, a.valuation-b.valuation, a.v-b.v)
Base.://(a::CycPol,b::Number)=CycPol(a.coeff//b,a.valuation,a.v)
Base.:div(a::CycPol,b::Number)=CycPol(div(a.coeff,b),a.valuation,a.v)

function Base.lcm(a::CycPol,b::CycPol) # forgets .coeff
  if (b.coeff isa Pol && !iszero(degree(b))) error(b,".coeff should be scalar") end
  CycPol(a.coeff,max(a.valuation,b.valuation),ModuleElts.merge2(max,a.v,b.v))
end

Base.lcm(v::AbstractArray{<:CycPol})=reduce(lcm,v;init=one(CycPol))

const dec_dict=Dict(1=>[[1]],2=>[[1]],
  8=>[[1,3,5,7],[1,5],[3,7],[1,7],[3,5],[1,3],[5,7]],
 12=>[[1,5,7,11],[1,5],[7,11],[1,7],[5,11],[1,11],[5,7]],
 15=>[[1,2,4,7,8,11,13,14],[1,4,11,14],[2,7,8,13],[1,4,7,13],[2,8,11,14],
      [1,4],[7,13],[11,14],[2,8]],
 16=>[[1,3,5,7,9,11,13,15],[1,7,9,15],[3,5,11,13],[1,5,9,13],[3,7,11,15]],
 20=>[[1,3,7,9,11,13,17,19],[1,9,11,19],[3,7,13,17],[1,9,13,17],[3,7,11,19]],
 21=>[[1,2,4,5,8,10,11,13,16,17,19,20],[1,4,10,13,16,19],[2,5,8,11,17,20]],
 24=>[[1,5,7,11,13,17,19,23],[1,7,13,19],[5,11,17,23],[1,7,17,23],[5,11,13,19],
      [1,5,19,23],[7,11,13,17],[1,11,17,19],[5,7,13,23],
      [7,13],[1,19],[5,23],[11,17],[1,5,13,17],[7,11,19,23]],
 30=>[[1,7,11,13,17,19,23,29],[1,11,19,29],[7,13,17,23],[1,7,13,19],
      [11,17,23,29],[11,29],[17,23],[1,19],[7,13]],
 36=>[[1,5,7,11,13,17,19,23,25,29,31,35],[1,7,13,19,25,31],[5,11,17,23,29,35],
      [7,11,19,23,31,35],[1,5,13,17,25,29]],
42=>[[1,5,11,13,17,19,23,25,29,31,37,41],[1,13,19,25,31,37],[5,11,17,23,29,41]])

# returns list of subsets of primitive_roots(d) wich have a "name" Φ_d^(i)
function dec(d::Int)
  get!(dec_dict,d) do
    dd=[prime_residues(d)]
    if (r=primitiveroot(d))!==nothing
      for a in 0:1
        push!(dd,sort(powermod.(r,(0:2:totient(d)-2).+a,d)))
      end
    end
    dd
  end
end

CycPol(;conductor=1,no=1)=CycPol(1,0,map(i->i//conductor=>1,dec(conductor)[no])...)
  
function show_factors(d)
  for i in eachindex(CycPols.dec(d))
    p=CycPol(;conductor=d,no=i)
    println(IOContext(stdout,:limit=>true),p,"=",p(Pol()))
  end
end

pr()=for d in sort(collect(keys(dec_dict))) show_factors(d) end

# decompose the .v of a CycPol in subsets Φ^i (used for printing and value)
function decompose(v::Vector{Pair{Root1,Int}})
  rr=NamedTuple{(:conductor, :no,:mul),Tuple{Int,Int,Int}}[]
  for t in collectby(x->order(first(x)),v)
    c=order(first(t[1]))
    if c==1 
      push!(rr,(conductor=c,no=1,mul=last(t[1])))
      continue
    end
    res=[]
    v=fill(0,c)
    @views v[exponent.(first.(t))].=last.(t)
    for (i,r) in enumerate(dec(c))
      if (n=minimum(@view v[r]))>0 || (n=maximum(@view v[r]))<0 
        @views v[r].-=n 
        push!(res,(conductor=c,no=i,mul=n))
      end
    end
    for i in 1:c  
      if v[i]!=0 push!(res,(conductor=c,no=-i,mul=v[i])) end 
    end
    append!(rr,res)
  end
  rr
end

function Base.show(io::IO, ::MIME"text/html", a::CycPol)
  print(io, "\$")
  show(IOContext(io,:TeX=>true),a)
  print(io, "\$")
end

function Base.show(io::IO,a::CycPol)
 if !(get(io,:limit,false) || get(io,:TeX,false))
    print(io,"CycPol(",a.coeff,",",a.valuation)
    for (r,m) in a.v print(io,",",r.r,"=>",m) end
    print(io,")")
    return
  end
  den=denominator(a.coeff)
  c=numerator(a.coeff)
  s=repr(c; context=io)
  if iszero(a.valuation) && isempty(a.v) print(io,s)
  else
    s=format_coefficient(s)
    print(io,s) 
    v=LaurentPolynomials.varname[]
    if a.valuation==1 print(io,v)
    elseif a.valuation!=0 print(io,v,stringexp(io,a.valuation)) end
    for e in decompose(a.v.d)
  #   println(e)
      if e.no>0  
        if get(io,:expand,false)
          print(io,"(",prod(i->Pol()-E(e.conductor,i),dec(e.conductor)[e.no]),")")
        else print(io,get(io,:TeX,false) ? "\\Phi" : "Φ")
          print(io,stringprime(io,e.no-1))
          print(io,stringind(io,e.conductor))
        end
      else print(io,"(",v,"-",E(e[1],-e.no),")")
      end
      if e.mul!=1 print(io,stringexp(io,e.mul)) end
    end
  end
  if !isone(den) print(io,"/",den) end
end

# fields to test first: all n such that totient(n)<=12 except 11,13,22,26
const tested=[1,2,4,3,6,8,12,5,10,9,18,7,14,24,16,20,15,30,36,28,21,42]

# list of i such that φᵢ/φ_(i∩ conductor))≤d, so a polynomial of
# degree ≤d with coeffs in Q(ζ_conductor) could have roots power of ζᵢ
function bounds(conductor::Int,d::Int)::Vector{Int}
  if d==0 return Int[] end
  t=Vector{Int}[];t1=Vector{Int}[]
  for (p,m) in eachfactor(conductor)
    tp=[1];pw=p;while pw<=d push!(tp,pw);pw*=p end # tp=={powers of p<=d}
    push!(t,tp)
    push!(t1,tp*p^m)
  end
  for p in setdiff(primes(d+1),keys(factor(conductor)))
    tp=[1,p-1];pw=p*(p-1)
    while pw<=d push!(tp,pw);pw*=p end
    push!(t,tp)
    push!(t1,p.^(eachindex(tp).-1))
  end
  produ=function(l,d)
    p=filter(x->l[1][x]<=d,eachindex(l[1]))
    if length(l)==1 return map(x->[x],p) end
    return reduce(vcat,map(i->vcat.([i],produ(l[2:end],div(d,l[1][i]))),p))
  end
  p=[prod(map((i,j)->j[i],l,t1)) for l in produ(t,d)]
  p=union(map(divisors,p)...)
  p=setdiff(p,tested)
  sort(p,by=x->x/length(divisors(x)))
end

# next function is twice the speed of p(Cyc(x))
(p::Pol)(x::Root1)=transpose(p.c)*x.^(p.v:degree(p))
  
"""
`CycPol(p::Pol)`
    
Converts a `Pol` to `CycPol`
    
```julia-repl
julia> @Pol q;CycPol(3*q^3-3q)
3qΦ₁Φ₂
```
"""
function CycPol(p::Pol{T};trace=false)where T
 # lot of code to be as efficient as possible in all cases
  if iszero(p) return zero(CycPol{T})
  elseif length(p.c)==1 # p==ax^s
    return CycPol(p.c[1],valuation(p))
  elseif 2==count(!iszero,p.c) # p==ax^s+bx^t
    a=Root1(-p[begin]//p[end])
    if a===nothing return CycPol(Pol(coefficients(p)),valuation(p)) end
    d=degree(p)-valuation(p)
    vcyc=(Root1(;r=(a.r+i)//d)=>1 for i in 0:d-1)
    return CycPol(p[end],valuation(p),ModuleElt(vcyc))
  end
  val=valuation(p)
  p=Pol(coefficients(p))
  coeff=p[end]
  p=coeff^2==1 ? p*coeff : p//coeff
  if denominator(p)==1 p=numerator(p) end
  vcyc=Pair{Root1,Int}[]

  # find factors Phi_i
  testcyc=function(c)
    if trace print("C$c") end
    found=false
    while true
      np,r=pseudodiv(p,cyclotomic_polynomial(c))
      if iszero(r) 
        append!(vcyc,[E(c,j)=>1 for j in (c==1 ? [0] : prime_residues(c))])
        p=(np[begin] isa Cyc) ? np : Pol(coefficients(np)) # why?
        if trace print("(d°$(degree(p))c$(conductor(p.c)))") end
        found=true
      else break
      end
    end
    return found
  end

  # find other primitive i-th roots of unity
  testall=function(i)
    if eltype(coefficients(p))<:Integer return false end # cannot have partial product
    found=false
    to_test=prime_residues(i)
    while true 
      to_test=filter(r->iszero(p(E(i,r))),to_test)
      if isempty(to_test) return found end
      found=true
      p=exactdiv(p,prod(r->Pol([-E(i,r),1],0),to_test))
      append!(vcyc,E.(i,to_test).=>1)
      if trace print("[d°$(degree(p))c$(conductor(p.c)),$i:",join(to_test,","),"]") end
      if degree(p)<div(totient(i),totient(gcd(i,conductor(p.c)))) return found end
    end
  end

  # first try commonly occuring fields
  for i in tested 
    if degree(p)>=totient(i) testcyc(i) end
    if degree(p)>0 testall(i) end
    if degree(p)==0 return CycPol(coeff,val,ModuleElt(vcyc)) end
  end
  
  # if not finished do a general search.
  # p is in Q(zeta_conductor)[x] so can only have a root in mu_i for i below
  cond=(p.c[1] isa Cyc) ? conductor(p.c) : 1
  try_=bounds(cond,degree(p))
# println("try_=$try_\n")
  i=1
  while i<=length(try_) 
#   push!(tested,try_[i])
    found=if cond==1 # All factors are Phi_i
         testcyc(try_[i])
    else testall(try_[i])
    end
    if found  
      cond=(p.c[1] isa Cyc) ? conductor(p.c) : 1
      try_=bounds(cond,degree(p))
      i=1
#	  print("tested==",tested,"\n")
    else i+=1
    end
  end
# println("now p=$p val=$val")
  
  CycPol(degree(p)==0 ? coeff : p*coeff,val,ModuleElt(vcyc))
end

function (p::CycPol)(x)
  res=p.valuation<0 ? (x//1)^p.valuation : x^p.valuation
  l=decompose(p.v.d)
  for e in l
    if iszero(res) return res end
    if e.no==1 res*=(cyclotomic_polynomial(e.conductor)(x))^e.mul end
  end
  for e in l
    if iszero(res) return res end
    if e.no>1 
      res*=prod(x-E(e.conductor,j) for j in dec(e.conductor)[e.no])^e.mul 
    end
  end
  pp=one(x)
  co=0
  pp=one(x)
  for e in l
    if iszero(res) return res end
    if e.no<0 
      if co==e.conductor pp*=(x-E(e.conductor,-e.no))^e.mul 
      else co=e.conductor
        res*=pp
        pp=(x-E(e.conductor,-e.no))^e.mul 
      end
    end
  end
  res*=pp
  if p.coeff isa Pol res*p.coeff(x) else res*p.coeff end
end

# Fast routine for CycPol(p(Pol([e],1))) for e::Root1
function subs(p::CycPol,v::Pol{Root1})
  if degree(v)!=1 || valuation(v)!=1 error(v," should be Pol([Root1],1)") end
  e=v[1]
  coeff=p.coeff*e^degree(p)
  if coeff isa Pol coeff=coeff(v) end
  re=inv(Root1(e))
  CycPol(coeff,valuation(p),ModuleElt(r*re=>m for (r,m) in p.v))
end

# Fast routine for  CycPol(p(Pol()^n))
function subs(p::CycPol,v::Pol{Int})
  if degree(v)!=valuation(v) || coefficients(v)!=[1] error(v," should be Pol()^n") end
  n=valuation(v)
  if n==0 return CycPol(p(1),0) end
  n=Int(n)
  val=n*valuation(p)
  if p.coeff isa Pol coeff=p.coeff(v) else coeff=p.coeff end
  if n>0
    vcyc=vcat((map(i->Root1(;r=i)=>pow,((0:n-1).+r.r)/n) for (r,pow) in p.v)...)
  else
    val+=n*sum(values(p.v))
    coeff*=(-1)^sum(values(p.v))*Cyc(prod(r^p for (r,p) in p.v))
    vcyc=vcat((map(i->Root1(;r=i)=>pow,((0:-n-1).-r.r)/-n) for (r,pow) in p.v)...)
  end
  CycPol(coeff,val,ModuleElt(vcyc))
end
    
# 281st generic degree of G34
const p=CycPol(E(3)//6,19,0//1=>3, 1//2=>6, 1//4=>2, 3//4=>2,
1//5=>1, 2//5=>1, 3//5=>1, 4//5=>1, 1//6=>4, 5//6=>4, 1//7=>1, 2//7=>1,
3//7=>1, 4//7=>1, 5//7=>1, 6//7=>1, 1//8=>1, 3//8=>1, 5//8=>1, 7//8=>1,
1//9=>1, 4//9=>1, 7//9=>1, 1//10=>1, 3//10=>1, 7//10=>1, 9//10=>1, 1//14=>1,
3//14=>1, 5//14=>1, 9//14=>1, 11//14=>1, 13//14=>1, 2//15=>1, 8//15=>1,
11//15=>1, 14//15=>1, 1//18=>1, 5//18=>1, 7//18=>1, 11//18=>1, 13//18=>1,
17//18=>1, 1//21=>1, 2//21=>1, 4//21=>1, 5//21=>1, 8//21=>1, 10//21=>1,
11//21=>1, 13//21=>1, 16//21=>1, 17//21=>1, 19//21=>1, 20//21=>1, 1//24=>1,
7//24=>1, 13//24=>1, 19//24=>1, 1//30=>1, 7//30=>1, 11//30=>1, 13//30=>1,
17//30=>1, 19//30=>1, 23//30=>1, 29//30=>1, 1//42=>1, 5//42=>1, 11//42=>1,
13//42=>1, 17//42=>1, 19//42=>1, 23//42=>1, 25//42=>1, 29//42=>1, 31//42=>1,
37//42=>1, 41//42=>1)
#=
  benchmark on Julia 1.7.2
julia> @btime u=CycPols.p(Pol()) # gap 1.25 ms
  341.214 μs (9542 allocations: 662.91 KiB)
julia> @btime CycPol(u) # gap 8.2ms
  5.591 ms (123484 allocations: 9.19 MiB)
julia> @btime u(1)  # gap 40μs
  31.999 μs (897 allocations: 64.75 KiB)
julia> @btime CycPols.p(1) # gap 142μs
  25.402 μs (547 allocations: 35.55 KiB)
=#

# a worse polynomial; u=p2(Pol()) 17ms (gap3 9ms) CycPol(u) 1.17s (gap3 1.33s)
const p2=CycPol(-4E(3),-129,1//3=>1,2//3=>1,1//6=>1,5//6=>1,1//8=>2,5//8=>1,7//8=>1,
2//9=>1,5//9=>1,8//9=>1,7//12=>1,11//12=>1,1//16=>1,3//16=>1,5//16=>1,
9//16=>1,11//16=>1,13//16=>1,5//18=>2,11//18=>2,17//18=>2,2//21=>1,5//21=>1,
8//21=>1,11//21=>1,17//21=>1,20//21=>1,2//27=>1,5//27=>1,8//27=>1,11//27=>1,
14//27=>1,17//27=>1,20//27=>1,23//27=>1,26//27=>1,7//32=>1,15//32=>1,
23//32=>1,31//32=>1,1//39=>1,4//39=>1,7//39=>1,10//39=>1,16//39=>1,19//39=>1,
22//39=>1,25//39=>1,28//39=>1,31//39=>1,34//39=>1,37//39=>1,1//42=>1,
13//42=>1,19//42=>1,25//42=>1,31//42=>1,37//42=>1,11//48=>1,19//48=>1,
35//48=>1,43//48=>1,7//60=>1,19//60=>1,31//60=>1,43//60=>1,5//78=>1,11//78=>1,
17//78=>1,23//78=>1,29//78=>1,35//78=>1,41//78=>1,47//78=>1,53//78=>1,
59//78=>1,71//78=>1,77//78=>1,7//80=>1,23//80=>1,31//80=>1,39//80=>1,
47//80=>1,63//80=>1,71//80=>1,79//80=>1,3//88=>1,19//88=>1,27//88=>1,
35//88=>1,43//88=>1,51//88=>1,59//88=>1,67//88=>1,75//88=>1,83//88=>1,
1//90=>1,7//90=>1,13//90=>1,19//90=>1,31//90=>1,37//90=>1,43//90=>1,49//90=>1,
61//90=>1,67//90=>1,73//90=>1,79//90=>1,5//96=>1,13//96=>1,29//96=>1,
37//96=>1,53//96=>1,61//96=>1,77//96=>1,85//96=>1,1//104=>1,9//104=>1,
17//104=>1,25//104=>1,33//104=>1,41//104=>1,49//104=>1,57//104=>1,73//104=>1,
81//104=>1,89//104=>1,97//104=>1,1//144=>1,17//144=>1,25//144=>1,41//144=>1,
49//144=>1,65//144=>1,73//144=>1,89//144=>1,97//144=>1,113//144=>1,
121//144=>1,137//144=>1,5//152=>1,13//152=>1,21//152=>1,29//152=>1,37//152=>1,
45//152=>1,53//152=>1,61//152=>1,69//152=>1,77//152=>1,85//152=>1,93//152=>1,
101//152=>1,109//152=>1,117//152=>1,125//152=>1,141//152=>1,149//152=>1,
11//204=>1,23//204=>1,35//204=>1,47//204=>1,59//204=>1,71//204=>1,83//204=>1,
95//204=>1,107//204=>1,131//204=>1,143//204=>1,155//204=>1,167//204=>1,
179//204=>1,191//204=>1,203//204=>1)

const p1=Pol([1,0,-1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,-1,0,1],0)
end
