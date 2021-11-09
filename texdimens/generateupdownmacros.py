#! /usr/bin/env python

TeXUnits=[
    (803,    800, "bp"),
    (685,    642, "nd"),
    (1238,  1157, "dd"),
    (7227,  2540, "mm"),
    (12,       1, "pc"),
    (1370,   107, "nc"),
    (14856, 1157, "cc"),
    (7227,   254, "cm"),
    (7227,   100, "in"),
]

with open('tempmacros.tex', 'w') as f:
    for a,b,uu in TeXUnits:
        bplus1 = b + 1
        c = 2*b*(a-1) + a
        d = 2*a*b + a
        b2 = 2*b
        a2 = 2*a
        a2sur2 = a
        deux = "2*"
        if not (a&1):
            c = c//2
            d = d//2
            b2 = b
            a2 = a
            a2sur2 = a//2
            deux = ""
        f.write(r"""
% {U} {A}/{B}
% T = {A} k + r
% Zd = {B} k + {B} - <({C} - {B2} r)/{A2}>
\def\texdimen{U}down#1{{\expandafter\texdimenstrippt\the\dimexpr
    \expandafter\texdimen{U}down_a\the\numexpr\dimexpr#1;%
}}%
\def\texdimen{U}down_a#1{{\texdimenzerominusfork
                        #1-\texdimenuudownup_zero
                        0#1\texdimenuudownup_neg
                         0-{{}}%
                        \krof \texdimen{U}down_b#1}}%
\def\texdimen{U}down_b#1;{{\expandafter\texdimen{U}down_c\the\numexpr({Deux}#1-{A2sur2})/{A2};#1;}}%
\def\texdimen{U}down_c#1;#2;{{\expandafter\texdimen{U}down_d\the\numexpr#2-{A}*#1;#1;}}%
\def\texdimen{U}down_d#1;#2;{{\numexpr{B}*#2+{B}-({C}-{B2}*#1)/{A2}sp\relax}}%
% Zu = {B} k + {B} + 1 - <({D} - {B2} r)/{A2}>
\def\texdimen{U}up#1{{\expandafter\texdimenstrippt\the\dimexpr
    \expandafter\texdimen{U}up_a\the\numexpr\dimexpr#1;%
}}%
\def\texdimen{U}up_a#1{{\texdimenzerominusfork
                        #1-\texdimenuudownup_zero
                        0#1\texdimenuudownup_neg
                         0-{{}}%
                      \krof \texdimen{U}up_b#1}}%
\def\texdimen{U}up_b#1;{{\expandafter\texdimen{U}up_c\the\numexpr({Deux}#1-{A2sur2})/{A2};#1;}}%
\def\texdimen{U}up_c#1;#2;{{\expandafter\texdimen{U}up_d\the\numexpr#2-{A}*#1;#1;}}%
\def\texdimen{U}up_d#1;#2;{{\numexpr{B}*#2+{Bplus1}-({D}-{B2}*#1)/{A2}sp\relax}}%
""".format(U=uu,A=a,B=b,Bplus1=bplus1,C=c,D=d,B2=b2,A2=a2,Deux=deux,A2sur2=a2sur2))



