size = 7
V = MatLieAlgElem(7,[
    0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,
    1,0,0,0,0,0,0,
    0,1,1,0,0,0,0,
    0,0,0,0,0,0,0,
    0,0,0,0,1,0,0,
    0,0,0,0,1,0,0,
    ])
U = MatLieAlgElem(7,[
        0,1,1,0,0,0,0,
        0,0,0,1,0,0,0,
        0,0,0,1,0,0,0,
        0,0,0,0,0,0,0,
        0,0,0,0,0,1,1,
        0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,
    ])
E = MatLieAlgElem(7,[
     0,0,0,0,0,0,0,
     0,0,0,0,0,0,0,
     0,0,0,0,0,0,0,
     0,0,0,0,0,0,0,
     1,0,0,0,0,0,0,
     0,1,0,0,0,0,0,
     0,0,1,0,0,0,0,
    ])
F = MatLieAlgElem(7,[
      0,0,0,0,1,0,0,
      0,0,0,0,0,1,0,
      0,0,0,0,0,0,1,
      0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,
    ])

C12 = MatLieAlg(size,[V,U,E,F])

sl5 = make_sl(5)
sl2 = make_sl(2)

dims_match = (C12.dim() == sl5.dim() + sl2.dim())
signatures_match = (C12.signature() == sl5.signature() + sl2.signature())
