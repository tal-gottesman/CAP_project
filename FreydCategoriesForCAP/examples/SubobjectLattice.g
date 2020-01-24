#! @Chapter Examples and Tests

#! @Section Subobject lattice

LoadPackage( "FreydCategoriesForCAP" );;

#! We compute the number of the generic subobject lattice generated by 2 independent subobjects y,z
#! and one subobject x of y.

#! @Example
ReadPackage( "FreydCategoriesForCAP", "examples/SubobjectLatticeFunctions.g" );;
quiver := RightQuiver( "Q(4)[a:1->2,b:2->3,c:1->4]" );;
QQ := HomalgFieldOfRationals();;
B := PathAlgebra( QQ, quiver );;
RowsB := QuiverRowsDescentToZDefinedByBasisPaths( B : overhead := false );;
Adel := AdelmanCategory( RowsB : overhead := false );;
a := B.a/RowsB/Adel;;
b := B.b/RowsB/Adel;;
c := B.c/RowsB/Adel;;
x := KernelEmbedding( a );;
y := KernelEmbedding( PreCompose( a, b ) );;
z := KernelEmbedding( c );;
gens := [ x, y, z ];;
Size( GenerateSubobjects( gens ) );
#! 8
#! @EndExample
