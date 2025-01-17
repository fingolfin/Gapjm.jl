module ComplexR
using ..Gapjm
export complex_reflection_group, crg, reflection_name, diagram, codegrees,
  reflection_group, torusfactors, ComplexReflectionGroup

const ComplexReflectionGroup=Union{PermRootGroup,FiniteCoxeterGroup}

Gapjm.roots(t::TypeIrred)=
 t.series==:ST ? getchev(t,:GeneratingRoots) : collect(eachrow(one(cartan(t))))

function PermRoot.coroots(t::TypeIrred)
  if t.series==:ST
    cr=getchev(t,:GeneratingCoRoots)
    if isnothing(cr)
      r=getchev(t,:GeneratingRoots)
      cr=coroot.(r,E.(ordergens(t)))
    end
    return map(x->convert.(Cyc{Rational{Int}},x),cr)
  end
  toL(cartan(t))
end

"""
`complex_reflection_group(STnumber)`

`complex_reflection_group(p,q,r)`

The  first form of `complex_reflection_group`  returns the complex reflection
group which has Shephard-Todd number `STnumber`, see
[Shephard-Todd1954](biblio.htm#ST54).   The   second   form   returns   the
imprimitive complex reflection group `G(p,q,r)`.

```julia-repl
julia> G=complex_reflection_group(4)
G₄

julia> degrees(G)
2-element Vector{Int64}:
 4
 6

julia> length(G)
24

julia> W*coxgroup(:A,2) # how to make a non-irreducible group
G₄×A₂

julia> complex_reflection_group(1,1,3) # another way to enter A₂
A₂

julia> crg(4) # there is also a short alias
G₄
```
"""
function complex_reflection_group(i::Int)
  if i==23     coxgroup(:H,3)
  elseif i==28 coxgroup(:F,4)
  elseif i==30 coxgroup(:H,4)
  elseif i==35 coxgroup(:E,6)
  elseif i==36 coxgroup(:E,7)
  elseif i==37 coxgroup(:E,8)
  else t=TypeIrred(Dict(:series=>:ST,:ST=>i))
    PRG(roots(t),coroots(t))
  end
end

function complex_reflection_group(p,q,r)
  if !iszero(p%q) || p<=0 || r<=0 || (r==1 && q!=1)
   error("complex_reflection_group(p,q,r) must satisfy: q|p, r>0, and r=1 => q=1")
  end
  if p==1 return coxgroup(:A,r-1)
  elseif p==2
    if q==2 return coxgroup(:D,r)
    else return coxgroup(:B,r) end
  elseif p==q && r==2 return coxgroup(:I,2,p)
  end
  t=TypeIrred(Dict(:series=>:ST,:p=>p,:q=>q,:rank=>r))
  PRG(roots(t),coroots(t))
end

const crg=complex_reflection_group

# converts a type back to a group
function reflection_group(t::TypeIrred)
  if haskey(t,:orbit)
    W=reflection_group(t.orbit)
    if length(t.orbit)>1
      spets(W,reflrep(W,Perm(vcat(circshift(map(x->x.indices,
                                        refltype(W)),-1)...))*t.twist))
    else spets(W,t.twist)
    end
  elseif t.series==:ST PRG(roots(t),coroots(t))
  else C=cartan(t)
    all(isreal,C) ? rootdatum(C) : PRG(one(C),C)
  end
end

function reflection_group(l::Vector{TypeIrred})
  if isempty(l) return coxgroup() end
  prod(reflection_group.(l))
end

"""
`degrees(W)`

returns  a list  holding the  degrees of  `W` as  a reflection group on the
vector  space `V` on which  it acts. These are  the degrees `d₁,…,dₙ` where
`n`  is the dimension of  `V` of the basic  invariants of `W` in `SV`. They
reflect  various properties  of `W`;  in particular,  their product  is the
cardinality of `W`.

```julia-repl
julia> W=complex_reflection_group(30)
H₄

julia> degrees(W)
4-element Vector{Int64}:
  2
 12
 20
 30

julia> length(W)
14400
```
"""
function Gapjm.degrees(W::Group)
  get!(W,:degrees)do
    vcat(fill(1,rank(W)-semisimplerank(W)),degrees.(refltype(W))...)
  end
end

torusfactors(WF::Spets)=eigmat(central_action(Group(WF),WF.F))

"""
`degrees(WF::Spets)`

Let  `W` be  the group  of the  reflection coset  `WF`, and  let `V` be the
vector  space  of  dimension  'rank(W)'  on  which `W` acts as a reflection
group.  Let  `f₁,…,fₙ`  be  the  basic  invariants  of `W` on the symmetric
algebra  `SV` of `V`;  they can be  chosen so they  are eigenvectors of the
matrix  `WF.F`. The corresponding  eigenvalues are called  the *factors* of
`F` acting on `V`; they characterize the coset --- they are equal to 1 only
for  the trivial  coset. The  *generalized degrees*  of `WF`  are the pairs
formed of the reflection degrees and the corresponding factor.

```julia-repl
julia> W=coxgroup(:E,6)
E₆

julia> WF=spets(W)
E₆

julia> phi=W(6,5,4,2,3,1,4,3,5,4,2,6,5,4,3,1);

julia> HF=subspets(WF,2:5,phi)
E₆₍₂₃₄₅₎=³D₄Φ₃

julia> Diagram(HF)
ϕ acts as (1,2,4) on the component below
  O 2
  ￨
O—O—O D₄
1 3 4

julia> degrees(HF)
6-element Vector{Tuple{Int64, Cyc{Int64}}}:
 (1, ζ₃)
 (1, ζ₃²)
 (2, 1)
 (4, ζ₃)
 (6, 1)
 (4, ζ₃²)
```
"""
function Gapjm.degrees(W::Spets)
  get!(W,:degrees)do
   vcat(map(x->(1,Cyc(x)::Cyc{Int}),torusfactors(W)),degrees.(refltype(W))...)
  end
end

function Gapjm.degrees(t::TypeIrred)
  if !haskey(t,:orbit) return getchev(t,:ReflectionDegrees) end
  d=getchev(t.orbit[1],:ReflectionDegrees)
# Let  t.scalar=[s_1,..,s_r],  where  r=length(t.orbit)  and  let  p be the
# PhiFactor   of  t.twist  associated  to  the  reflection  degree  d_i  of
# t.orbit[1].   If   G0   is   the   Spets  described  by  t.orbit[1],  and
# G1:=Ennola(Product(t.scalar),G0)  then G is isomorphic  to the descent of
# scalars  of G1. According to spets 1.5, a Phifactor of Ennola(zeta,G0) is
# \zeta^{d_i}  times  that  of  G0;  and  by  spets  1.5  or [Digne-Michel,
# parabolic A.1] those of an a-descent of scalars are
# \zeta_a^j\zeta_i^{1/a} (all the a-th roots of \zeta_i).
  if order(t.twist)>1
   f=getchev(t,:PhiFactors)
   if isnothing(f) return f end
  else f=fill(1,length(d))
  end
  if haskey(t,:scalar)
    p=prod(t.scalar)
    f=[f[i]*p^d[i] for i in eachindex(d)]
  end
  f=collect(zip(d,f))
  a=length(t.orbit)
  if a==1 return f end
  vcat(map(f)do (d,e) map(x->(d,x),root(e,a).*E.(a,0:a-1)) end...)
end

function codegrees(t::TypeIrred)
  if !haskey(t,:orbit)
    d=getchev(t,:ReflectionCoDegrees)
    if !isnothing(d) return d
    else
      d=getchev(t,:ReflectionDegrees)
      return reverse(maximum(d).-d)
    end
  end
  d=getchev(t,:ReflectionCoDegrees)
  if isnothing(d)
    d=getchev(t.orbit[1],:ReflectionDegrees)
    a=argmax(d)
    d=reverse(d[a].-d)
    if order(t.twist)==1
      f=fill(1,length(d))
    else
      f=getchev(t,:PhiFactors)
      if isnothing(f) return f end
      f=reverse(map(x->f[a]//x,f))
    end
    d=zip(d,f)
  elseif order(t.twist)==1
    d=zip(d,fill(1,length(d)))
  end
  if haskey(t,:scalar)
    f=prod(t.scalar)
    d=[(deg,eps*f^deg) for (deg,eps) in d]
  end
  a=length(t.orbit)
  if a==1 return d end
  vcat(map(d)do (d,e) map(x->(d,x),root(e,a).*E.(a,0:a-1)) end...)
end

"""
`codegrees(W)`

returns  the vector of codegrees of `W`  as a reflection group on the space
`V`  of `reflrep(W)`.  These are  one less  than the  degrees of  the basic
derivations of ` W` on `SV⊗ V^vee`.

```julia-repl
julia> W=complex_reflection_group(4)
G₄

julia> codegrees(W)
2-element Vector{Int64}:
 0
 2
```
"""
function codegrees(W::Group)
  vcat(fill(-1,rank(W)-semisimplerank(W)),collect.(codegrees.(refltype(W)))...)
end

function codegrees(W::Spets)
  get!(W,:codegrees)do
    vcat(map(x->(-1,x),Cyc.(inv.(torusfactors(W)))),
         collect.(codegrees.(refltype(W)))...)
  end
end

function diagram(W)
  for t in refltype(W)
    getchev(t,:PrintDiagram,t.indices,getchev(t,:ReflectionName,Dict()))
  end
end

nr_conjugacy_classes(W)=prod(getchev(W,:NrConjugacyClasses))

function reflection_name(io::IO,W)
  opt=IOContext(io,:TeX=>true).dict
  r=join(getchev(W,:ReflectionName,opt),"×")
  fromTeX(io,r)
end

reflection_name(t::TypeIrred)=getchev(t,:ReflectionName,Dict())

end
