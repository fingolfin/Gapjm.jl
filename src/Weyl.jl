"""
Let  `V` be a  real vector space.  Finite Coxeter groups  coincide with the
finite  reflection subgroups of `GL(V)`, that is finite subgroups which can
be  generated by reflections.  *Weyl groups* are  the finite Coxeter groups
which can be defined over the rational numbers. We implement finite Coxeter
groups  as groups of  permutations of a  root system. Root  systems play an
important role in mathematics as they classify semi-simple Lie algebras and
algebraic groups.

Let  us give precise definitions. Let `V`  be a real vector space, `Vⱽ` its
dual  and let `(,)`  be the natural  pairing between `Vⱽ`  and `V`. A *root
system*  is a finite set  of vectors `R` which  generate `V` (the *roots*),
together  with  a  map  `r↦  rⱽ`  from  `R`  to  a subset `Rⱽ` of `Vⱽ` (the
*coroots*) such that:

-  For any `r∈  R`, we have  `(rⱽ,r)=2` so that  the formula `x↦ x-(rⱽ,x)r`
defines a reflection `sᵣ:V→ V` with root `r` and coroot `rⱽ`.
- The reflection `sᵣ` stabilizes `R`.

We  will only  consider *reduced*  root systems,  i.e., such  that the only
elements  of `R` colinear with `r∈ R` are `r` and `-r`; for Weyl groups, we
also ask that the root system be *crystallographic*, that is `(rⱽ,s)` is an
integer, for any `s∈ R,rⱽ∈ Rⱽ`.

The  subgroup `W=W(R)`  of `GL(V)`  generated by  the reflections `sᵣ` is a
finite  Coxeter group; when `R` is crystallographic, the representation `V`
of  `W`  is  defined  over  the  rational  numbers.  All finite-dimensional
(complex) representations of a finite reflection group can be realized over
the  same field as `V`. Weyl groups can also be characterized as the finite
Coxeter  groups such that all numbers `m(s,t)` in the Coxeter matrix are in
`{2,3,4,6}`.

If  we identify  `V` with  `Vⱽ` by  choosing a  `W`-invariant bilinear form
`(.;.)`,  then we have `rⱽ=2r/(r;r)`. A root system `R` is *irreducible* if
it is not the union of two orthogonal subsets. If `R` is reducible then the
corresponding  Coxeter group  is the  direct product  of the Coxeter groups
associated with the irreducible components of `R`.

The  irreducible  crystallographic  root  systems  are  classified  by  the
following  list of  *Dynkin diagrams*,  which, in  addition to  the Coxeter
matrix,  encode also the relative length of the roots. We show the labeling
of the nodes given by the function 'Diagram' described below.

```
A_n O—O—O—…—O   B_n O⇐O—O—…—O  C_n O⇒O—O—…—O  D_n  O 2
    1 2 3 … n       1 2 3 … n      1 2 3 … n       ￨
                                                 O—O—…—O
                                                 1 3 … n

G₂ O⇛O  F₄ O—O⇒O—O    E₆   O 2   E₇   O 2     E₈    O 2
   1  2     1 2  3 4       ￨          ￨             ￨
                       O—O—O—O—O  O—O—O—O—O—O   O—O—O—O—O—O—O
                       1 3 4 5 6  1 3 4 5 6 7   1 3 4 5 6 7 8
```

These diagrams encode the presentation of the Coxeter group `W` as follows:
the vertices represent the generating reflections; an edge is drawn between
`s`  and `t` if the order `m(s,t)` of `st` is greater than `2`; the edge is
single  if  `m(s,t)=3`,  double  if  `m(s,t)=4`,  triple if `m(s,t)=6`. The
arrows  indicate the relative root lengths when `W` has more than one orbit
on  `R`, as explained below; we  get the *Coxeter Diagram*, which describes
the  underlying Weyl group, if  we ignore the arrows:  we see that the root
systems `B_n` and `C_n` correspond to the same Coxeter group.

Here  are the Coxeter diagrams for the  finite Coxeter groups which are not
crystallographic:

```
       e        5         5
I₂(e) O—O   H₃ O—O—O  H₄ O—O—O—O
      1 2      1 2 3     1 2 3 4 
```

Let  us  now  describe  how  the  root  systems  are  encoded in the Dynkin
diagrams. Let `R` be a root system in `V`. Then we can choose a linear form
on  `V` which vanishes on  no element of `R`.  According to the sign of the
value  of this  linear form  on a  root `r  ∈ R`  we call `r` *positive* or
*negative*.  Then there exists  a unique subset  `Π` of the positive roots,
the  *simple roots*,  such that  any positive  root is a linear combination
with  non-negative coefficients  of roots  in `Π`.  Any two  sets of simple
roots  (corresponding to different choices of linear forms as above) can be
transformed into each other by a unique element of `W(R)`. Hence, since the
pairing  between `V` and `Vⱽ`  is `W`-invariant, if `Π`  is a set of simple
roots  and if  we define  the *Cartan  matrix* as  being the  `n` times `n`
matrix  `C={rⱽ(s)}ᵣₛ`, for `r,s∈Π` this matrix is unique up to simultaneous
permutation  of  rows  and  columns.  It  is precisely this matrix which is
encoded in a Dynkin diagram, as follows.

The  indices for the rows of `C` label the nodes of the diagram. The edges,
for  `r ≠ s`,  are given as  follows. If `Cᵣₛ`  and `Cₛᵣ` are integers such
that  `|Cᵣₛ|≥|Cₛᵣ|=1` the vertices  are connected by  `|Cᵣₛ|` lines, and if
`|Cᵣₛ|>1` then we put an additional arrow on the lines pointing towards the
node  with label `s`. In other cases,  we simply put a single line equipped
with the unique integer `pᵣₛ≥1` such that `CᵣₛCₛᵣ=cos^2 (π/pₛᵣ)`.

Conversely,  the whole root  system can be  recovered from the simple roots
and  the corresponding coroots. The  reflections in `W(R)` corresponding to
the  simple roots are called  *simple* reflections or *Coxeter generators*.
They are precisely the generators for which the Coxeter diagram encodes the
defining  relations of `W(R)`. Each root is  in the orbit of a simple root,
so  that `R` is obtained  as the orbit of  the simple roots under the group
generated  by  the  simple  reflections.  The  restriction  of  the  simple
reflections  to the span of `R` is  determined by the Cartan matrix, so `R`
is determined by the Cartan matrix and the set of simple roots.

The  Cartan  matrix  corresponding  to  one  of  the above irreducible root
systems  (with the specified labeling) is  returned by the command 'cartan'
which  takes as input  a `Symbol` giving  the type (that  is ':A', ':B', …,
':I')  and a positive `Int` giving the  rank (plus an `Int` giving the bond
for  type `:I`).  This function  returns a  matrix with  entries in `ℤ` for
crystallographic  types, and a  matrix of `Cyc`  for the other types. Given
two  Cartan matrices `c1` and `c2`,  their matrix direct sum (corresponding
to  the  orthogonal  direct  sum  of  the  root systems) can be produced by
`cat(c1,c2,dims=[1,2])`.

The  function 'rootdatum' takes as input a  list of simple roots and a list
of the corresponding coroots and produces a `struct` containing information
about  the root system `R` and about `W(R)`. If we label the positive roots
by  '1:N', and the negative roots  by 'N+1:2N', then each simple reflection
is  represented by the permutation of '1:2N' which it induces on the roots.
If  only one argument is given, the Cartan matrix of the root system, it is
taken  as the list  of coroots and  the list of  roots is assumed to be the
canonical basis of `V`.

If one only wants to work with Cartan matrices with a labeling as specified
by  the  above  list,  the  function  call  can  be  simplified. Instead of
'rootdatum(cartan(:D,4))' the following is also possible.

```julia-repl
julia> W=coxgroup(:D,4)
D₄

julia> cartan(W)
4×4 Array{Int64,2}:
  2   0  -1   0
  0   2  -1   0
 -1  -1   2  -1
  0   0  -1   2
```

Also,  the Weyl group struct associated to a direct sum of irreducible root
systems can be obtained as a product

```julia-repl
julia> W=coxgroup(:A,2)*coxgroup(:B,2)
A₂×B₂

julia> cartan(W)
4×4 Array{Int64,2}:
  2  -1   0   0
 -1   2   0   0
  0   0   2  -2
  0   0  -1   2
```
The  same `struct`  is constructed  by applying  'coxgroup' to  the matrix
'cat(cartan(:A,2), cartan(:B,2),dims=[1,2])'.

The elements of a Weyl group are permutations of the roots:
```julia-repl
julia> W=coxgroup(:D,4)
D₄

julia> p=W(1,3,2,1,3)
(1,14,13,2)(3,17,8,18)(4,12)(5,20,6,15)(7,10,11,9)(16,24)(19,22,23,21)

julia> word(W,p)
5-element Array{Int64,1}:
 1
 3
 1
 2
 3

```

finally, a benchmark on julia 1.0.2
```benchmark
julia> @btime length(elements(coxgroup(:E,7)))
  531.385 ms (5945569 allocations: 1.08 GiB)
```
GAP3 for the same computation takes 2.2s
"""
module Weyl

export coxgroup, FiniteCoxeterGroup, inversions, two_tree, rootdatum, torus,
 dimension, with_inversions, standard_parabolic, describe_involution, 
 relative_group, rootlengths
# to use as a stand-alone module uncomment the next line
# export roots

using Gapjm
using LinearAlgebra: SymTridiagonal
#------------------------ Cartan matrices ----------------------------------

"""
`cartan(m::AbstractMatrix)`

The  argument is a Coxeter matrix for a Coxeter group `W` and the result is
a  Cartan Matrix  for the  standard reflection  representation of  `W`. Its
diagonal   terms  are  `2`  and  the  coefficient  between  two  generating
reflections   `s`  and  `t`  is   `-2cos(π/m[s,t])`  (where  by  convention
`π/m[s,t]==0`  if  `m[s,t]==infty`,  which  is  represented here by setting
'm[s,t]=0').  The matrix  `m` is  symmetric, and  the result  is symmetric,
meaning  that all roots  in the constructed  reflection representation have
same length.

```julia-repl
julia> cartan([1 3;3 1])
2×2 Array{Cyc{Int64},2}:
  2  -1
 -1   2
```
"""
PermRoot.cartan(m::AbstractMatrix)=map(c->iszero(c) ? -2 : -E(2*c,-1)-E(2*c),m)

"""
`cartan(type, rank [,bond])`

return  the Cartan matrix for a finite  Coxeter group described by type and
rank.  The recognized types are `:A, :B,  :Bsym, :C, :D, :E, :F, :Fsym, :G,
:Gsym, :I, :H`. For type `:I` a third argument must be given describing the
bond between the two generators. The `sym` types correspond to root systems
where all roots have the same length.

```julia-repl
julia> cartan(:F,4)
4×4 Array{Int64,2}:
  2  -1   0   0
 -1   2  -1   0
  0  -2   2  -1
  0   0  -1   2

julia> cartan(:I,2,5)
2×2 Array{Cyc{Int64},2}:
       2  ζ₅²+ζ₅³
 ζ₅²+ζ₅³        2

julia> cartan(:Bsym,2)
2×2 Array{Cyc{Int64},2}:
   2  -√2
 -√2    2
```
"""
function PermRoot.cartan(t::Symbol,r::Int,b::Int=0)
  A(r,b=0)=Matrix(SymTridiagonal(fill(2,r),fill(-1,r-1)))
  Isym(r,b)=[2 -E(2*b)-E(2*b,-1);-E(2*b)-E(2*b,-1) 2]
  cartanDict=Dict{Symbol,Function}(
   :A=>A,
   :B=>function(r,b)m=A(r)
     if r>1 m[1,2]=-2 end
     m end,
   :Bsym=>function(r,b)m=convert.(Cyc{Int},A(r))
     m[1:2,1:2]=Isym(2,4)
     m end,
   :C=>function(r,b)m=A(r)
     if r>1 m[2,1]=-2 end
     m end,
   :D=>function(r,b)m=A(r)
     u=min(r,3); m[1:u,1:u]=[2 0 -1; 0 2 -1;-1 -1 2][1:u,1:u]
     m end,
   :E=>function(r,b)m=A(r)
     u=min(r,4); m[1:u,1:u]=[2 0 -1 0; 0 2 0 -1;-1 0 2 -1;0 -1 -1 2][1:u,1:u]
     m end,
   :F=>function(r,b)m=A(r)
     m[3,2]=-2 
     m end,
   :Fsym=>function(r,b)m=convert.(Cyc{Int},A(r))
     m[3,2]=m[2,3]=-ER(2)
     m end,
   :G=>function(r,b)m=A(r)
     m[2,1]=-3
     m end,
   :Gsym=>(r,b)->Isym(2,6),
   :H=>function(r,b)m=convert.(Cyc{Int},A(r))
     m[1:2,1:2]=Isym(2,5)
     m end,
   :I=>function(r,b)
     b%2==0 ? [2 -1;-2-E(b)-E(b,-1) 2] : Isym(2,b)
   end,
   :Isym=>Isym)
  if haskey(cartanDict,t) cartanDict[t](r,b)
  else error("Unknown Cartan type $(repr(t)). Known types are:\n",
             join(sort(repr.(collect(keys(cartanDict)))),", "))
  end
end

function PermRoot.cartan(t::Dict{Symbol,Any})
# println("t=$t")
  if haskey(t,:cartanType) 
    ct=t[:cartanType]
    if haskey(t,:bond) 
      C=convert.(typeof(ct),cartan(t[:series],length(t[:indices]),t[:bond]))
    else
      C=convert.(typeof(ct),cartan(t[:series],length(t[:indices])))
    end
    if t[:series]==:B
      C[1,2]=-t[:cartanType]
      C[2,1]=-2//t[:cartanType]
    elseif t[:series]==:G
      C[1,2]=-t[:cartanType]
      C[2,1]=-3//t[:cartanType]
    elseif t[:series]==:F
      C[2,3]=-t[:cartanType]
      C[3,2]=-2//t[:cartanType]
    elseif t[:series]==:I
      C[1,2]=-t[:cartanType]
      b=t[:bond]
      C[2,1]=(-2-E(b)-E(b,-1))/t[:cartanType]
    end
    if all(isinteger,C) C=Int.(C) end
    C
  elseif haskey(t,:bond) cartan(t[:series],length(t[:indices]),t[:bond])
  else cartan(t[:series],length(t[:indices]))
  end
end

"""
    two_tree(m)

 Given  a square  matrix m  with zeroes  (or falses,  for a boolean matrix)
 symmetric  with respect to the diagonal, let  G be the graph with vertices
 axes(m)[1] and an edge between i and j iff !iszero(m[i,j]).
 If G  is a line this function returns it as a Vector{Int}. 
 If  G  is  a  tree  with  one  vertex  c of valence 3 the function returns
 (c,b1,b2,b3)  where b1,b2,b3 are  the branches from  this vertex sorted by
 increasing length.
 Otherwise the function returns `nothing`
```julia-repl
julia> Weyl.two_tree(cartan(:A,4))
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> Weyl.two_tree(cartan(:E,8))
(4, [2], [3, 1], [5, 6, 7, 8])
```
"""
two_tree=function(m::AbstractMatrix)
  function branch(x)
    while true
      x=findfirst(i->m[x,i]!=0 && !(i in line),axes(m,2))
      if !isnothing(x) push!(line,x) else break end
    end
  end
  line=[1]
  branch(1)
  l=length(line)
  branch(1)
  line=vcat(line[end:-1:l+1],line[1:l])
  l=length(line)
  if any(i->any(j->m[line[j],line[i]]!=0,1:i-2),1:l) return nothing end
  r=size(m,1)
  if l==r return line end
  p = findfirst(x->any(i->!(i in line)&&(m[x,i]!=0),1:r),line)
  branch(line[p])
  if length(line)!=r return nothing end
  (line[p],sort([line[p-1:-1:1],line[p+1:l],line[l+1:r]], by=length)...)
end

" (series,rank) for an irreducible Cartan matrix"
function type_fincox_cartan(m::AbstractMatrix)
  rank=size(m,1)
  s=two_tree(m)
  if isnothing(s) return nothing end
  t=Dict{Symbol,Any}()
  if s isa Tuple # types D,E
    (vertex,b1,b2,b3)=s
    if length(b2)==1 t[:series]=:D 
      t[:indices]=[b1;b2;vertex;b3]::Vector{Int}
    else t[:series]=:E 
      t[:indices]=[b2[2];b1[1];b2[1];vertex;b3]::Vector{Int}
    end 
  else  # types A,B,C,F,G,H,I
    l=i->m[s[i],s[i+1]]
    r=i->m[s[i+1],s[i]] 
    function rev() s=s[end:-1:1] end
    if rank==1 t[:series]=:A 
    elseif rank==2 
#     println("l(1)=",l(1)," r(1)=",r(1))
      if l(1)*r(1)==1 t[:series]=:A 
      elseif l(1)*r(1)==2 t[:series]=:B  
        if l(1)==-1 rev() end # B2 preferred to C2
        t[:cartanType]=-l(1)
      elseif l(1)*r(1)==3 t[:series]=:G  
        if r(1)==-1 rev() end 
        t[:cartanType]=-l(1)
      else n=conductor(l(1)*r(1))
        if r(1)==-1 rev() end
        if l(1)*r(1)==2+E(n)+E(n,-1) bond=n else bond=2n end
        t[:series]=:I
        if bond%2==0 t[:cartanType]=-l(1) end
        t[:bond]=bond
      end
    else
      if l(rank-1)*r(rank-1)!=1 rev() end 
      if l(1)*r(1)==1
        if l(2)*r(2)==1 t[:series]=:A 
        else t[:series]=:F
          if r(2)==-1 rev() end 
          t[:cartanType]=-l(2)
        end
      else n=conductor(l(1)*r(1))
        if n==5 t[:series]=:H
        else t[:series]=:B
          t[:cartanType]=-l(1)
        end  
      end  
    end 
    t[:indices]=s::Vector{Int}
  end 
# println("t=$t")
# println("indices=",t[:indices]," cartan=",cartan(t)," m=$m")
  if cartan(t)!=m[t[:indices],t[:indices]] return nothing end  # countercheck
  t
end

"""
    type_cartan(C)

 return a list of (series=s,indices=[i1,..,in]) for a Cartan matrix
"""
function type_cartan(m::AbstractMatrix)
  map(diagblocks(m)) do I
    t=type_fincox_cartan(m[I,I])
    if isnothing(t) error("unknown Cartan matrix ",m[I,I]) end
    t[:indices]=I[t[:indices]]
    TypeIrred(t)
  end
end

"""
    roots(C)

 return the set of positive roots defined by the Cartan matrix C
 works for any finite Coxeter group
"""
function Gapjm.roots(C::Matrix)
  o=one(C)
  R=[o[i,:] for i in axes(C,1)] # fast way to get rows of one(C)
  j=1
  while j<=length(R)
    a=R[j]
    c=C*a
    for i in axes(C,1)
      if j!=i 
        v=copy(a)
        v[i]-=c[i]
        if !(v in R) push!(R,v) end
      end
    end
    j+=1
  end 
  if eltype(C)<:Integer sort!(R,by=x->(sum(x),-x)) 
  else R
  end
  # important roots are sorted as in CHEVIE for data (KLeftCells) to work
end 

#-------Finite Coxeter groups --- T=type of elements----T1=type of roots------
abstract type FiniteCoxeterGroup{T,T1} <: CoxeterGroup{T} end

coxmat(W::FiniteCoxeterGroup)=coxmat(cartan(W))

"""
`inversions(W,w)`

Returns  the inversions of the element `w` of the finite Coxeter group `W`,
that  is, the list of the  indices of roots of `W`  sent by `w` to negative
roots.  The element `w` can also be  a word `s₁…sₙ` (a vector of integers),
in  which  case  the  function  returns  inversions  in  the  order  of the
reflections `W(s₁), W(s₁,s₂,s₁), …, W(s₁,s₂,…,sₙ,sₙ₋₁,…,s₁)`.

```julia-repl
julia> W=coxgroup(:A,3)
A₃

julia> inversions(W,W(1,2,1))
3-element Array{Int64,1}:
 1
 2
 4

julia> inversions(W,[1,2,1])
3-element Array{Int16,1}:
 1
 4
 2
```
"""
inversions(W::FiniteCoxeterGroup,w)=
     [i for i in 1:nref(W) if isleftdescent(W,w,i)]

inversions(W::FiniteCoxeterGroup,w::AbstractVector{<:Integer})=
   map(i->action(W,w[i],W(w[i-1:-1:1]...)),eachindex(w))


"""
`with_inversions(W,N)`

`W`  should be  a finite  Coxeter group  and `N`  a subset  of `1:nref(W)`.
Returns  the  element  `w`  of  `W` such that `N==inversions(W,w)`. Returns
`nothing` if no such element exists.

```julia-repl
julia> W=coxgroup(:A,2)
A₂

julia> map(N->with_inversions(W,N),combinations(1:nref(W)))
8-element Array{Union{Nothing, Perm{Int16}},1}:
 ()
 (1,4)(2,3)(5,6)
 (1,3)(2,5)(4,6)
 nothing
 nothing
 (1,6,2)(3,5,4)
 (1,2,6)(3,4,5)
 (1,5)(2,4)(3,6)
```
"""
function with_inversions(W,N)
  w=one(W)
  n=N
  while !isempty(n)
    p=findfirst(x->x>0 && x<=semisimplerank(W),n)
    if isnothing(p) return nothing end
    r=reflection(W,n[p])
    n=action.(Ref(W),setdiff(n,[n[p]]),r)
    w=r*w
  end
  w^-1
end

"""
`standard_parabolic(W,H)`

Given a parabolic subgroup H or the indices of its simple roots returns w such
that H^w is a standard parabolic subgroup of W
"""
function standard_parabolic(W::FiniteCoxeterGroup,hr::AbstractVector{<:Integer})
  if isempty(hr) return Perm() end
  b=W.rootdec[hr]
  heads=map(x->findfirst(y->!iszero(y),x),filter(!iszero,toL(echelon(toM(b))[1])))
  b=vcat(W.rootdec[setdiff(1:semisimplerank(W),heads)],b)
# complete basis of I with part of S to make basis
  l=map(eachrow(toM(W.rootdec[1:W.N])*inv(toM(b).//1)))do v
   for x in v 
     if (x isa Rational && x<0) || Real(x)<0 return true
     elseif (x isa Rational && x>0) || Real(x)>0 return false 
     end 
   end end
  N=(1:W.N)[l]
# find negative roots for associated order and make order standard
  w=with_inversions(W,N)
  if issubset(action.(Ref(W),hr,w),eachindex(gens(W))) return w
  else return nothing
  end
end

standard_parabolic(W::FiniteCoxeterGroup,H::FiniteCoxeterGroup)=
  standard_parabolic(W,restriction(W,inclusiongens(H)))

"""
`describe_involution(W,w)`

Given  an involution `w` of a Coxeter group `W`, by a theorem of Richardson
cite{rich82} there is a unique parabolic subgroup `P` of `W` such that that
`w`  is the  longest element  of `P`,  and is  central in `P`. The function
returns `I` such that `P=reflection_subgroup(W,I)`, so that
`w=longest(reflection_subgroup(W,I))`.

```julia-repl
julia> W=coxgroup(:A,2)
A₂

julia> w=longest(W)
(1,5)(2,4)(3,6)

julia> describe_involution(W,w)
1-element Array{Int64,1}:
 3

julia> w==longest(reflection_subgroup(W,[3]))
true
```
For now does not work for abscox groups.
"""
describe_involution(W,w)=SimpleRootsSubsystem(W,
                                        filter(i->action(W,i,w)==i+W.N,1:W.N))

Base.length(W::FiniteCoxeterGroup,w)=count(i->isleftdescent(W,w,i),1:nref(W))

function PermRoot.refltype(W::FiniteCoxeterGroup)::Vector{TypeIrred}
  gets(W,:refltype)do
    W.G.prop[:refltype]=type_cartan(cartan(W))
  end
end

#"""
#  The reflection degrees of W
#"""
#function Gapjm.degrees(W::FiniteCoxeterGroup)
#  if iszero(W.N) return Int[] end
#  l=sort(map(length,values(groupby(sum,W.rootdec[1:W.N]))),rev=true)
#  reverse(1 .+conjugate_partition(l))
#end

dimension(W::FiniteCoxeterGroup)=2*nref(W)+Gapjm.rank(W)
Base.length(W::FiniteCoxeterGroup)=prod(degrees(W))

#forwarded methods to PermRoot/W.G
Base.iterate(W::FiniteCoxeterGroup,a...)=iterate(W.G,a...)
Base.eltype(W::FiniteCoxeterGroup)=eltype(W.G)
Base.parent(W::FiniteCoxeterGroup)=W
Base.:/(W::FiniteCoxeterGroup,H)=PermGroup(W)/PermGroup(H)
Base.in(w,W::FiniteCoxeterGroup)=w in W.G
Gapjm.degree(W::FiniteCoxeterGroup)=degree(W.G)
Gapjm.roots(W::FiniteCoxeterGroup)=roots(W.G)
Gapjm.roots(W::FiniteCoxeterGroup,i)=roots(W.G)[i]
PermRoot.simpleroots(W::FiniteCoxeterGroup)=simpleroots(W.G)
Perms.reflength(W::FiniteCoxeterGroup,w)=reflength(W.G,w)
Groups.position_class(W::FiniteCoxeterGroup,a...)=position_class(W.G,a...)
PermGroups.PermGroup(W::FiniteCoxeterGroup)=PermGroup(W.G)
PermGroups.class_reps(W::FiniteCoxeterGroup)=class_reps(W.G)
PermRoot.cartan(W::FiniteCoxeterGroup,a...)=cartan(W.G,a...)
PermRoot.reflections(W::FiniteCoxeterGroup)=reflections(W.G)
PermRoot.invariants(W::FiniteCoxeterGroup)=invariants(W.G)
PermRoot.coroots(W::FiniteCoxeterGroup,i...)=coroots(W.G,i...)
PermRoot.simplecoroots(W::FiniteCoxeterGroup)=simplecoroots(W.G)
PermRoot.hyperplane_orbits(W::FiniteCoxeterGroup)=hyperplane_orbits(W.G)
PermRoot.refleigen(W::FiniteCoxeterGroup)=refleigen(W.G)
PermRoot.torus_order(W::FiniteCoxeterGroup,i,q)=torus_order(W.G,i,q)
PermRoot.rank(W::FiniteCoxeterGroup)=rank(W.G)
PermRoot.refrep(W::FiniteCoxeterGroup,w...)=refrep(W.G,w...)
PermRoot.PermX(W::FiniteCoxeterGroup,M)=PermX(W.G,M)
PermRoot.inclusion(W::FiniteCoxeterGroup,x...)=inclusion(W.G,x...)
PermRoot.reflchar(W::FiniteCoxeterGroup,x...)=reflchar(W.G,x...)
PermRoot.inclusiongens(W::FiniteCoxeterGroup)=inclusiongens(W.G)
PermRoot.independent_roots(W::FiniteCoxeterGroup)=independent_roots(W.G)
PermRoot.semisimplerank(W::FiniteCoxeterGroup)=semisimplerank(W.G)
PermRoot.restriction(W::FiniteCoxeterGroup,a...)=restriction(W.G,a...)
PermRoot.action(W::FiniteCoxeterGroup,a...)=action(W.G,a...)
#--------------- FCG -----------------------------------------
struct FCG{T,T1,TW<:PermRootGroup{T1,T}} <: FiniteCoxeterGroup{Perm{T},T1}
  G::TW
  rootdec::Vector{Vector{T1}}
  N::Int
  prop::Dict{Symbol,Any}
end

function Base.show(io::IO,t::Type{FCG{T,T1,TW}})where {T,T1,TW}
  print(io,"FiniteCoxeterGroup{Perm{$T},$T1}")
end

"number of reflections of W"
@inline CoxGroups.nref(W::FCG)=W.N
CoxGroups.isleftdescent(W::FCG,w,i::Int)=i^w>W.N

"""
`coxgroup(type,rank[,bond])`
    
This is equivalent to 'rootdatum(cartan(type,rank[,bond]))`.
                          
The  resulting object, that we will  call a *Coxeter datum*, has additional
entries and functions describing various information on the root system and
Coxeter group that we describe below.

`nref(W)`:   the number of positive roots

`W.rootdec`:  the  root  vectors,  given  as  linear combinations of simple
roots.  The first 'nref(W)' roots are  positive, the next 'nref(W)' are the
corresponding negative roots. Moreover, the first 'semisimplerank(W)' roots
are the simple roots. The positive roots are ordered by increasing height.

'coroots(W)':  the  same  information  for  the  simple coroots. The coroot
corresponding  to a given root is in the same relative position in the list
of coroots as the root in the list of roots.

'rootlengths(W)':  the  vector  of  length  of  roots the simple roots. The
shortest  roots in  an irreducible  subsystem are  given the  length 1. The
others  then  have  length  2  (or  3  in  type  G_2).  The  matrix  of the
`W`-invariant bilinear form is given by
'map(i->(rootLengths)[i]*W.cartan[i,:],1:semisimplerank(W))'.

'simple_representatives(W)[i]':  this gives the  smallest index of  a root in
the same `W`-orbit as the `i`-th root.

'simple_conjugating_element(W,i)': returns an element `w` of `W` of minimal
length such that `i==simple_representative(W,i)^w'.

`refrep(W)`:    the  matrices  (in  row  convention  ---  that is the matrices
     operate  *from the right*) of the  simple reflections of the Coxeter group.

`gens(W)`:   the generators as permutations of the root vectors.  They
       are given in the same order as the first `semisimplerank(W)` roots.

```julia_repl
julia> W=coxgroup(:A,3)
A₃

julia> cartan(W)
3×3 Array{Int64,2}:
  2  -1   0
 -1   2  -1
  0  -1   2

julia> W.rootdec
12-element Array{Array{Int64,1},1}:
 [1, 0, 0]   
 [0, 1, 0]   
 [0, 0, 1]   
 [1, 1, 0]   
 [0, 1, 1]   
 [1, 1, 1]   
 [-1, 0, 0]  
 [0, -1, 0]  
 [0, 0, -1]  
 [-1, -1, 0] 
 [0, -1, -1] 
 [-1, -1, -1]

 julia> refrep(W)
3-element Array{Array{Int64,2},1}:
 [-1 0 0; 1 1 0; 0 0 1]
 [1 1 0; 0 -1 0; 0 1 1]
 [1 0 0; 0 1 1; 0 0 -1]
```
"""
coxgroup(t::Symbol,r::Int=0,b::Int=0)=iszero(r) ? coxgroup() : rootdatum(cartan(t,r,b))

" Adjoint root datum from cartan mat"
rootdatum(C::Matrix)=rootdatum(one(C),C)

" root datum from 2 matrices: roots on basis of X(T), coroots on basis of Y(T)"
function rootdatum(rr::Matrix,cr::Matrix)
  C=cr*permutedims(rr) # Cartan matrix
  rootdec=roots(C) # difference with PermRootGroup is order of roots here
  N=length(rootdec)
  r=Ref(permutedims(rr)).*rootdec
  r=vcat(r,-r)
  rootdec=vcat(rootdec,-rootdec)
  mats=map(reflection,eachrow(rr),eachrow(cr)) # refrep
  # permutations of the roots effected by mats
  gens=map(M->Perm(r,Ref(permutedims(M)).*r),mats)
  rank=size(C,1)
  coroots=Vector{Vector{eltype(cr)}}(undef,length(r))
  coroots[axes(cr,1)].=eachrow(cr)
  G=PRG(gens,mats,r,coroots,Dict{Symbol,Any}(:cartan=>C))
  FCG(G,rootdec,N,Dict{Symbol,Any}())
end


"""
`torus(rank)`

This  function returns the object corresponding to the notion of a torus of
dimension  `rank`, a Coxeter  group of semisimple  rank 0 and given `rank`.
This  corresponds to a split torus; the extension to Coxeter cosets is more
useful.

```julia-repl
julia> torus(3)
.
```
"""
function torus(i)
  G=PRG(Perm{Int16}[],Matrix{Int}[],Vector{Int}[],Vector{Int}[],
    Dict{Symbol,Any}(:rank=>i))
  FCG(G,Vector{Int}[],0,Dict{Symbol,Any}())
end

coxgroup()=torus(0)

Base.show(io::IO, W::FCG)=PermRoot.showtypes(io,refltype(W))
  
#function refrep(W::FCG,w)
#  vcat(permutedims(hcat(roots.(Ref(W),(1:coxrank(W)).^w)...)))
#end

function cartancoeff(W::FCG,i,j)
  v=findfirst(!iszero,roots(W,i))
  r=roots(W,j)-roots(W,j^reflection(W,i))
  c=r[v]//roots(W,i)[v]
  isinteger(c) ? Int(c) : c
end

# root lengths for parent group
function rootlengths(W::FCG)
  gets(W,:rootlengths)do
    C=cartan(W)
    lengths=fill(eltype(C)(1),2*W.N)
    for t in refltype(W)
      I=t.indices
      if length(I)>1 && C[I[1],I[2]]!=C[I[2],I[1]]
        lengths[I[2]]=-C[I[1],I[2]]
        lengths[I[1]]=-C[I[2],I[1]]
      elseif length(I)>2 && C[I[2],I[3]]!=C[I[3],I[2]]
        lengths[I[3]]=-C[I[2],I[3]]
        lengths[I[1]]=-C[I[3],I[2]]
      end
    end
    for i in eachindex(lengths) 
      lengths[i]=lengths[simple_representatives(W.G)[i]] 
    end
    lengths
  end
end

function Base.:*(W1::FiniteCoxeterGroup,W2::FiniteCoxeterGroup)
  mroots(W)=toM(simpleroots(W))
  mcoroots(W)=toM(simplecoroots(W))
  r=roots(W1.G)
  cr=roots(W2.G)
  if isempty(r)
    if isempty(cr) return torus(Gapjm.rank(W1)+Gapjm.rank(W2)) end
    r=mroots(W2)
    r=hcat(r,zeros(eltype(r),size(r,1),Gapjm.rank(W1)))
    cr=mcoroots(W2)
    cr=hcat(cr,zeros(eltype(cr),size(cr,1),Gapjm.rank(W1)))
  elseif isempty(cr)
    r=mroots(W1)
    r=hcat(r,zeros(eltype(r),size(r,1),Gapjm.rank(W2)))
    cr=mcoroots(W1)
    cr=hcat(cr,zeros(eltype(cr),size(cr,1),Gapjm.rank(W2)))
  else
    r=cat(mroots(W1),mroots(W2),dims=[1,2])
    cr=cat(mcoroots(W1),mcoroots(W2),dims=[1,2])
  end
  return rootdatum(r,cr)
end

"for each root index of simple representative"
PermRoot.simple_representatives(W::FCG)=simple_representatives(W.G)
  
PermRoot.simple_conjugating_element(W::FCG,i)=
   simple_conjugating_element(W.G,i)

PermRoot.reflection(W::FCG,i::Integer)=reflection(W.G,i)
#--------------- FCSG -----------------------------------------
struct FCSG{T,T1,TW<:PermRootGroup{T1,T}} <: FiniteCoxeterGroup{Perm{T},T1}
  G::TW
  rootdec::Vector{Vector{T1}}
  N::Int
  parent::FCG{T,T1}
  prop::Dict{Symbol,Any}
end

function Base.show(io::IO,t::Type{FCSG{T,T1,TW}})where {T,T1,TW}
  print(io,"FiniteCoxeterSubGroup{Perm{$T},$T1}")
end

CoxGroups.nref(W::FCSG)=W.N

Base.parent(W::FCSG)=W.parent

# if I are all the positive roots of a subsystem find the simple ones
function SimpleRootsSubsystem(W,I) 
  filter(I) do i
    r=reflection(W,i)
    for j in I
      if j!=i && isleftdescent(W,r,j) return false end
    end
    return true
  end
end

"""
reflection_subgroup(W,I)
The subgroup of W generated by reflections(W)[I]

A   theorem  discovered  by  Deodhar  cite{Deo89}  and  Dyer  cite{Dye90}
independently  is that a subgroup `H` of a Coxeter system `(W,S)` generated
by  reflections has  a canonical  Coxeter generating  set, formed of the `t
∈Ref(H)`  such `l(tt')>l(t)` for any `t'∈  Ref(H)` different from `t`. This
is used by 'reflection_subgroup' to determine the Coxeter system of `H`.

```julia-repl
julia> W=coxgroup(:G,2)
G₂

julia> Diagram(W)
O⇛ O
1  2

julia> H=reflection_subgroup(W,[2,6])
G₂₍₂₆₎=Ã₁×A₁

julia> Diagram(H)
O
1
O
2
```

The  notation `G₂₍₂₆₎` means  that 'W.G.roots[2:6]' form  a system of simple
roots for `H`.

A  reflection subgroup has specific properties  the most important of which
is  'inclusion' which gives the positions of the roots of H in the roots of
W. The inverse (partial) map is 'restriction'.

```julia-repl
julia> inclusion(H)
4-element Array{Int64,1}:
  2
  6
  8
 12

julia> restriction(H)
12-element Array{Int64,1}:
 0
 1
 0
 0
 0
 2
 0
 3
 0
 0
 0
 4
```

If  H is a standard parabolic subgroup of a Coxeter group W then the length
function on H (with respect to its set of generators) is the restriction of
the  length function on  W. This need  not no longer  be true for arbitrary
reflection subgroups of W:

```julia-repl
julia> word(W,H(2))
5-element Array{Int64,1}:
 1
 2
 1
 2
 1
```

In  this package, finite  reflection groups are  represented as permutation
groups  on a set of roots. Consequently,  a reflection subgroup `H⊆ W` is a
permutation  subgroup, thus its elements are represented as permutations of
the roots of the parent group.

```julia-repl
julia> elH=word.(Ref(H),elements(H))
4-element Array{Array{Int64,1},1}:
 []    
 [2]   
 [1]   
 [1, 2]

julia> elW=word.(Ref(W),elements(H))
4-element Array{Array{Int64,1},1}:
 []                
 [1, 2, 1, 2, 1]   
 [2]               
 [1, 2, 1, 2, 1, 2]

julia> map(w->H(w...),elH)==map(w->W(w...),elW)
true

```
Another  basic result about reflection subgroups  of Coxeter groups is that
each  coset of  H in  W contains  a unique  element of  minimal length, see
`reduced`.
"""
function PermRoot.reflection_subgroup(W::FCG{T,T1},I::AbstractVector{<:Integer})where {T,T1}
# contrary to Chevie, I is indices in W and not parent(W)
  inclusion=sort!(vcat(orbits(reflection.(Ref(W),I),I)...))
  N=div(length(inclusion),2)
  if all(i->i in 1:coxrank(W),I)
    C=cartan(W)[I,I]
  else
    I=SimpleRootsSubsystem(W,inclusion[1:N])
    C=T1[cartancoeff(W,i,j) for i in I, j in I]
  end
  rootdec=isempty(C) ? Vector{T1}[] : roots(C)
  rootdec=vcat(rootdec,-rootdec)
  if isempty(rootdec) inclusion=Int[]
  else inclusion=map(rootdec)do r
    findfirst(isequal(sum(r.*W.rootdec[I])),W.rootdec)
    end
  end
  restriction=zeros(Int,2*W.N)
  restriction[inclusion]=1:length(inclusion)
  prop=Dict{Symbol,Any}(:cartan=>C,:refltype=>type_cartan(C))
  prop[:refltype]=map(prop[:refltype]) do t
   if (t.series in [:A,:D]) && rootlengths(W)[inclusion[t.indices[1]]]==1
     for s in refltype(W) 
       if inclusion[t.indices[1]] in s.indices && s.series in [:B,:C,:F,:G]
          getfield(t,:prop)[:short]=true
       end
     end
   end
   t
  end
  if isempty(inclusion) prop[:rank]=PermRoot.rank(W) end
  gens=isempty(I) ? Perm{T}[] : reflection.(Ref(W),I)
  G=PRSG(gens,inclusion,restriction,W.G,prop)
  FCSG(G,rootdec,N,W,prop)
end

Base.show(io::IO, W::FCSG)=show(io,W.G)
  
PermRoot.reflection_subgroup(W::FCSG,I::AbstractVector{<:Integer})=
  reflection_subgroup(W.parent,inclusion(W)[I])

@inbounds CoxGroups.isleftdescent(W::FCSG,w,i::Int)=inclusion(W,i)^w>W.parent.N

"""
relative_group(W::FiniteCoxeterGroup,J)

`J` should be a if *distinguished* subset of `S==eachindex(gens(W))`,
that is if for s∈ S-J we  set v(s,J)=w_0^{J∪ s}w_0^J then J  is stable 
by all v(s,J). Then
R=N_W(W_J)/W_J  is a Coxeter group with  Coxeter system the v(s,J). The
program  return  R  in  its  reflection  representation  on X(ZL_J/ZG).
(according to Lusztig's "Coxeter Orbits...", the images of the roots of
W in X(ZL_J/ZG) form a root system).

R.prop has the fields:
:relativeIndices=setdiff(S,J)
:parentMap:=the list of v(s,J)
:MappingFromNormalizer maps J-reduced elements of N_W(W_J) to
elements of R

"""
function relative_group(W::FiniteCoxeterGroup,J)
  S=eachindex(gens(W))
  if !issubset(J,S) 
    error("implemented only for standard parabolic subgroups")
  end
  I=setdiff(S,J) # keep the order of S
  vI=map(i->longest(W,vcat([i],J))*longest(W,J),I)
  if any(g->sort(action.(Ref(W),J,g))!=sort(J),vI) 
    error("$J is not distinguished in $W") 
  end
  qr=i->W.rootdec[i][I]
  res=isempty(J) ? W : isempty(I) ? coxgroup() :
    rootdatum([ratio(qr(j)-qr(action(W,j,vI[ni])),qr(i)) 
                                  for (ni,i) in enumerate(I), j in I])
  res.prop[:relativeIndices]=I
  res.prop[:parentMap]=vI
  res.prop[:MappingFromNormalizer]=# maps w∈N_W(W_J) to elt of R
    function(w)c=Perm()
      while true
        r=findfirst(x->isleftdescent(W,w,x),I)
        if isnothing(r) return c end
 	w=vI[r]*w
        c*=res(r)
      end
    end
  res
end

end
