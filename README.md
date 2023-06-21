
## Logical Zonotope: A Set Representation for Binary Vectors

This repo cotains the code for our two papers: <br />

1- Polynomial Logical Zonotopes: A Set Representation for Reachability Analysis of Logical Systems <br />
Authors: Amr Alanwar, Frank J. Jiang, and Karl Henrik Johansson  <br />

1- Logical Zonotope: A Set Representation for Binary Vectors <br />
Authors: Amr Alanwar, Frank J. Jiang, Samy Amin and Karl Henrik Johansson  <br />


## Abstract
In this paper, we introduce a set representation called polynomial logical zonotopes<br />
 for performing exact and computationally efficient reachability analysis on logical <br />
systems. Polynomial logical zonotopes are a generalization of logical zonotopes, which <br />
are able to represent up to $2^\gamma$ binary vectors using only $\gamma$ generators. <br />
Due to their construction, logical zonotopes are only able to support exact computations<br />
 of some logical operations (XOR, NOT, XNOR), while other operations (AND, NAND, OR, NOR)<br />
 result in over-approximations. In order to perform all fundamental logical operations <br />
exactly, we formulate a generalization of logical zonotopes that is constructed by <br />
additional dependent generators and exponent matrices. We prove that through this <br />
polynomial-like construction, we are able to perform all of the fundamental logical <br />
operations  (XOR, NOT, XNOR, AND, NAND, OR, NOR) exactly. While we are able to perform <br />
all of the logical operations exactly, this comes with a slight increase in computational<br />
 complexity compared to logical zonotopes. We show that we can use polynomial logical <br />
zonotopes to perform exact reachability analysis while retaining a low computational <br />
complexity. To illustrate and showcase the computational benefits of polynomial logical <br />
zonotopes, we present the results of performing reachability analysis on two use cases: <br />
(1) safety verification of an intersection crossing protocol, (2) and reachability analysis <br />
on a high-dimensional Boolean function. Moreover, to highlight the extensibility of logical <br />
zonotopes, we include an additional use case where we perform a computationally tractable <br />
exhaustive search for the key of a linear-feedback shift register.

## Running 
1- Add the repo folder and subfolders to the Matlab path.  <br />
2- Run TestLogicalFunctions.m for doing logical functions in the generator space of logical zonotope <br />
3- Run TestPolyLogicalFunctions.m for doing logical functions in the generator space of polynomial logical zonotope <br />
4- Run FindLFSRkeyExample.m for finding the key example in the papers  <br />
5- Run VechIntersection4Cars.m for the vehicle Intersections in the papers <br />
6- Run BoolFunctionExample.m for the high dimensional Boolean function in the paper <br /><br /><br/> 

## Main Support APIs
Z = xor(Z1,Z2): XOR between two logical zontoopes or polynomial logical zonotopes <br />
Z = and(Z1,Z2): AND between two logical zontoopes or polynomial logical zonotopes <br />
Z = or(Z1,Z2): OR between two logical zontoopes or polynomial logical zonotopes <br />
Z = nor(Z1,Z2): NOR between two logical zontoopes or polynomial logical zonotopes <br />
Z = nand(Z1,Z2): NAND between two logical zontoopes or polynomial logical zonotopes <br />
Z = not(Z1): not a logical zontoope or polynomial logical zonotope <br />
Z = semiKron(Z1,Z2): Semi Tensor Produce between Z1 and Z2 <br />
Flag = Z.containPoints(P): Determines if the point p is inside the logical zonotope Z <br />
Z = enclosePoints(points): Encloses points with a logical zonotope Z <br />
Zred = reduce(Z): Reduces the number of generators of a logical zonotope  <br />
<br /><br />


```
@article{polylogicalZonotope,
  title={Polynomial Logical Zonotopes: A Set Representation for Reachability Analysis of Logical Systems},
  author={Alanwar, Amr and Jiang, Frank J. and Johansson, Karl Henrik},
  journal={arXiv preprint },
  year={2022}
}
```

```
@article{logicalZonotope,
  title={Logical Zonotopes: A Set Representation for the Formal Verification of Boolean Functions},
  author={Alanwar, Amr and Jiang, Frank J. and Amin, Samy and Johansson, Karl Henrik},
  journal={arXiv preprint arXiv:2210.08596},
  year={2022}
}
```
