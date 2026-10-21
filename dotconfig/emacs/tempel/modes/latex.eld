latex-mode

(begin "\\begin{" (s env) "}" r> n "\\end{" (s env) "}")
(center "\\begin{center}\n" r> n> "\\end{center}")
(displaymath "\\begin{displaymath}\n" r> n> "\\end{displaymath}")
(enumerate "\\begin{enumerate}\n\\item " r> n> "\\end{enumerate}")
(itemize "\\begin{itemize}\n\\item " r> n> "\\end{itemize}")
(equation "\\begin{equation}" r> n> "\\end{equation}")
(frac "\\frac{" p "}{" q "}")
(sfrac "\\sfrac{" p "}{" q "}")
(minipage "\\begin{minipage}[t]{0.5\\linewidth}\n" r> n> "\\end{minipage}")
(quote "\\begin{quote}\n" r> n> "\\end{quote}")
(verbatim "\\begin{verbatim}\n" r> n> "\\end{verbatim}")
(verbatimm "\\begin{verbatim*}\n" r> n> "\\end{verbatim*}")

;; misc

(colour "\\color{" p "}")
(nlb "\\nolinebreak")
(: "\\colon")
(hline "\\mbox{ }\\hline\\mbox{ }")
(ni "\\noindent")
(nl "\\newline")
(fn "\\footnote")
(text "\\text{" p "}")
(bls "\\vspace{-\\baselineskip}")
(sb "\\smallbreak")
(mb "\\medbreak")
(ul "\\ulcorner")
(ur "\\urcorner")
(nis "\\noitemsep")

(c "\\mathcal{" p "}")
(cm "\\mathcal{M}")
(f "\\mathfrak{" p "}")
(fg "\\mathfrak{G}")
(ff "\\mathfrak{F}")
(fm "\\mathfrak{M}")
(fmp "\\mathfrak{M'}")

;; connectives

(and "\\land")
(or "\\lor")
(n "\\lnot")
(fa "\\forall")
(ex "\\exists")
(lt "\\leadsto")
(ra "\\rightarrow")
(Ra "\\Rightarrow")
(la "\\leftarrow")
(La "\\Leftarrow")
(lra "\\leftrightarrow")
(Lra "\\Leftrightarrow")
(bw "{\\bigwedge}")
(bv "{\\bigvee}")
(mand "\\mathbin{\\&}")

;; Relations
;; (ss "\\subseteq")

;; Operators

(lb "\\Box")
(ld "\\Diamond")

;; Symbols

(es "\\emptyset")

;; Consequence relations

(vD "\\vDash")
(nvD "\\nvDash")
(vd "\\vdash")
(nvd "\\nvdash")
(dv "\\dashv")
(dV "\\dashV")

;; Models

(fcmod "\\mathcal{M^{f}}")
(mcs "\\textsc{mcs}")
(lml "\\mathfrak{M}^{\\varLambda}")
(lm,w,d "\\mathfrak{M}, w \\Vdash")
(LG "\\varLambda^{\\Gamma}")
(wr "\\langle W, R \\rangle")
(wrv "\\langle W, R, V \\rangle")

;; bib

(ca "citeauthor")
(tc "textcite")
(cy "citeyear")
(ct "citetitle")
(ar "autoref")
(qcite n> "\\mbox{ }\\hfill\\mbox{(" p ")}")
(apr"autopageref")

;; lists

(lrara "label=\\arabic*., ref=(\\arabic*)")
(lralph "label=\\alph*., ref=(\\alph*)")
(lrAlph "label=\\Alph*., ref=(\\Alph*)")
(lrroman "label=\\roman*., ref=(\\roman*)")
(lrRoman "label=\\Roman*., ref=(\\Roman*)")

;; probability

(pr "\\textsf{pr}")
(eu "\\mathbb{E}\\mathcal{U}")
