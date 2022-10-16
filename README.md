
## Logical Zonotope: A Set Representation for Binary Vectors

This repo cotains the code for our paper:
Logical Zonotope: A Set Representation for Binary Vectors
Authors: Amr Alanwar, Frank J. Jiang, Samy Amin and Karl Henrik Johansson 

## Abstract
We propose a new set representation for binary vectors called logical zonotopes.
 A logical zonotope is constructed by XOR-ing a binary vector with a combination of binary vectors called generators.
 A logical zonotope can efficiently represent up to $2^\gamma$ binary vectors using only $\gamma$ generators. 
Instead of the explicit enumeration of the zonotopes' members, logical operations over sets of binary vectors are applied directly to a zonotopes' generators. Thus, logical zonotopes can be used to greatly reduce the computational complexity of a variety of operations over sets of binary vectors, including logical operations (e.g. XOR, NAND, AND, OR) and semi-tensor products. Additionally, we show that, similar to the role classical zonotopes play for formally verifying dynamical systems defined over real vector spaces, logical zonotopes can be used to efficiently analyze the forward reachability of dynamical systems defined over binary vector spaces (e.g. logical circuits or Boolean networks).
To showcase the utility of logical zonotopes, we illustrate three use cases: (1) discovering the key of a linear-feedback shift register with a linear time complexity, (2) verifying the safety of a logical vehicle intersection crossing protocol, and (3) performing reachability analysis for a high-dimensional Boolean function.


## Running 
1- Add the repo folder and subfolders to the Matlab path.  <br />
2- Run FindLFSRkeyExample.m for Example 1 in the paper  <br />
4- Run VechIntersectionExample.m for Example 2 in the paper <br />
5- Run BoolFunctionExample.m for Example 3 in the paper <br /><br />
<br/> 

## Main Support APIs
Z = xor(Z1,Z2): XOR between two logical zontoopes <br />
Z = and(Z1,Z2): AND between two logical zontoopes  <br />
Z = or(Z1,Z2): OR between two logical zontoopes  <br />
Z = nor(Z1,Z2): NOR between two logical zontoopes  <br />
Z = nand(Z1,Z2): NAND between two logical zontoopes  <br />
Z = not(Z1): not a logical zontoope  <br />
Z = semiKron(Z1,Z2): Semi Tensor Produce between Z1 and Z2 <br />
Flag = Z.containPoints(P): Determines if the point p is inside the logical zonotope Z <br />
Z = enclosePoints(points): Encloses points with a logical zonotope Z <br />
Zred = reduce(Z): Reduces the number of generators of a logical zonotope  <br />
<br /><br />


```
@article{logicalZonotope,
  title={Logical Zonotope: A Set Representation for Binary Vectors},
  author={Alanwar, Amr and Jiang, Frank J. and Amin, Samy and Johansson, Karl Henrik},
  journal={arXiv preprint },
  year={2022}
}
```


