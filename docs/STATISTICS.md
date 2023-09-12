# Project Statistics
Currently 43 commits.
## Github additions and deletions.
These github do not include any lucky cli generated code.
[Github compare before adding lucky init](https://github.com/WyvernIXTL/webtrans/compare/827c7b3850c5a59059b84902424bb48837612aab..bbb4cc01669d87d23ab3dec71e6eddc745699492)
[Github compare after adding lucky and initializing it](https://github.com/WyvernIXTL/webtrans/compare/30f43bc7c5147db69cfad984e0553ca25e1531d5..4b9951a3c7348dfa42d12ea093ffc90e2df9ba67)
The additions here of course include comments and documentation, thus arent strictly LOC.

| Time Period  | Additions | Deletions  |
|--------------|-----------|------------|
| Before Lucky | 151       | 23         |
| After Lucky  | 1197      | 187        |
| Together     | 1348      | 210        |

## Lines of code with [CLOC](https://github.com/AlDanial/cloc)

Before adding lucky auto generated files:
```bash
cloc bbb4cc01669d87d23ab3dec71e6eddc745699492
       8 text files.
       5 unique files.
       3 files ignored.

github.com/AlDanial/cloc v 1.98  T=0.32 s (15.7 files/s, 671.6 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Dockerfile                       1             50             33             52
Bourne Shell                     2             10             11             25
Markdown                         1              3              0             20
Text                             1              0              0             10
-------------------------------------------------------------------------------
SUM:                             5             63             44            107
-------------------------------------------------------------------------------
```
Adding the lucky project. This needs to be removed:
```bash
cloc 30f43bc7c5147db69cfad984e0553ca25e1531d5
     128 text files.
     119 unique files.
      29 files ignored.

github.com/AlDanial/cloc v 1.98  T=1.13 s (105.3 files/s, 2518.4 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Crystal                          95            225            379           1231
Bourne Shell                      4             33             29            219
Bourne Again Shell                4             35             57             89
YAML                              3              7              5             80
Dockerfile                        2             56             44             69
JavaScript                        3              9             84             52
SCSS                              1              6             17             43
JSON                              1              0              0             24
Markdown                          1              3              0             20
Text                              2              0              0             14
INI                               1              1              0              8
Embedded Crystal                  2              2              0              4
--------------------------------------------------------------------------------
SUM:                            119            377            615           1853
--------------------------------------------------------------------------------
```
Doing the rest of the project:
```bash
cloc 4b9951a3c7348dfa42d12ea093ffc90e2df9ba67
     158 text files.
     146 unique files.
      35 files ignored.

github.com/AlDanial/cloc v 1.98  T=1.37 s (106.6 files/s, 2791.0 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Crystal                         114            301            538           1609
Bourne Shell                      4             33             29            219
Markdown                          2             37              0            198
YAML                              6             22              9            182
Bourne Again Shell                4             35             57             89
Dockerfile                        3             26             45             85
JavaScript                        4             13             94             63
JSON                              1              0              0             26
Text                              3              0              0             17
INI                               1              1              0              8
Embedded Crystal                  2              2              0              4
Python                            1              3              3              4
SCSS                              1              6             62              1
--------------------------------------------------------------------------------
SUM:                            146            479            837           2505
--------------------------------------------------------------------------------
```

### Result
| @commit                                  | LOC       |
|------------------------------------------|-----------|
| bbb4cc01669d87d23ab3dec71e6eddc745699492 | 107       |
| 30f43bc7c5147db69cfad984e0553ca25e1531d5 | 1853      |
| 4b9951a3c7348dfa42d12ea093ffc90e2df9ba67 | 2505      |
| 2505 - (1853 - 107)                      | 759       |
