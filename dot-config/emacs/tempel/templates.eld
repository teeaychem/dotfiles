fundamental-mode ;; Available everywhere

(today (format-time-string "%Y-%m-%d"))

;; abbreviations

(nbhd "neighbourhood")
(prop "proposition")
(inf "information")
(prob "probability")
(inqu "inquisitive")
(pmods "plausibility models")
(plau "plausibility")
(int "interrogative")
(dec "declarative")
(cond "conditional")
(epi "epistemic")
(dox "doxastic")
(pref "preference")

prog-mode

(fixme (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "FIXME ")
(todo (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "TODO ")
(bug (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "BUG ")
(hack (if (derived-mode-p 'emacs-lisp-mode) ";; " comment-start) "HACK ")

latex-mode

(begin "\\begin{" (s env) "}" r> n "\\end{" (s env) "}")
(center "\\begin{center}\n" r> n> "\\end{center}")
(displaymath "\\begin{displaymath}\n" r> n> "\\end{displaymath}")
(enumerate "\\begin{enumerate}\n\\item " r> n> "\\end{enumerate}")
(itemize "\\begin{itemize}\n\\item " r> n> "\\end{itemize}")
(equation "\\begin{equation}" r> n> "\\end{equation}")
(frac "\\frac{" p "}{" q "}")
(sfrac "\\sfrac{" p "}{" q "}")
(minipage "\\begin{minipage}[t]{0.5\linewidth}\n" r> n> "\\end{minipage}")
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

org-mode

(caption "#+caption: ")
(drawer ":" p ":" n r ":end:")
(begin "#+begin_" (s name) n> r> n "#+end_" name)
(quote "#+begin_quote" n> r> n "#+end_quote")
(sidenote "#+begin_sidenote" n> r> n "#+end_sidenote")
(marginnote "#+begin_marginnote" n> r> n "#+end_marginnote")
(example "#+begin_example" n> r> n "#+end_example")
(center "#+begin_center" n> r> n "#+end_center")
(ascii "#+begin_export ascii" n> r> n "#+end_export")
(html "#+begin_export html" n> r> n "#+end_export")
(latex "#+begin_export latex" n> r> n "#+end_export")
(comment "#+begin_comment" n> r> n "#+end_comment")
(verse "#+begin_verse" n> r> n "#+end_verse")
(src "#+begin_src " q n r n "#+end_src")
(gnuplot "#+begin_src gnuplot :var data=" (p "table") " :file " (p "plot.png") n r n "#+end_src" :post (org-edit-src-code))
(elisp "#+begin_src emacs-lisp" n r n "#+end_src" :post (org-edit-src-code))
(racket "#+begin_src racket" n r n "#+end_src" :post (org-edit-src-code))
(inlsrc "src_" p "{" q "}")
(title "#+title: " p n "#+author: sparkes" n "#+language: en")


c++-mode

(cout "std::cout << " p " << "\\n";")
(amain "
using namespace std;

int main(int argc, char *argv[]) {"
p
"
return 0;
}")


c-mode

(dereference "->")
(reference "&")

;; https://gligan.net/emacs-config
(guard "#ifndef " (r (upcase (file-name-base (buffer-name))) header-name) "_H" n
       "#define " header-name "_H" n n
       q n n
       "#endif  /* " header-name "_H */" n)
