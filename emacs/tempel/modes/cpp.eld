c++-ts-mode

(amain "
using namespace std;

int main(int argc, char *argv[]) {"
p
"
}")

(include "#include <" p ">")
(using "using " p " = " q ";")

(ns "namespace " (s name) " {" n> r> n "}" " // namespace " name)
(anonns "namespace {" n> r> n "}")

(class "class " (s name) " {" n
       "public:" n>
       name "();" n>
       "~" name "() = default;" n
       n
       "private:" n>
       q n
       "};")

(struct "struct " (s name) " {" n> q n "};")

(lambda "[" p "](" p ") {" n> r> n "}")
(auto "auto " p " = " q ";")
(constauto "const auto " p " = " q ";")

(scast "static_cast<" (p "type") ">(" q ")")
(ccast "const_cast<" (p "type") ">(" q ")")
(rcast "reinterpret_cast<" (p "type") ">(" q ")")
(dcast "dynamic_cast<" (p "type") ">(" q ")")
(cast "(" (p "type") ")" q)

(fori "for (std::size_t " (p "i") " = 0; " (s i) " < " (p "n") "; ++" i ") {" n> r> n "}")
(forr "for (auto& " (p "x") " : " (p "xs") ") {" n> r> n "}")
(cforr "for (const auto& " (p "x") " : " (p "xs") ") {" n> r> n "}")

(if "if (" p ") {" n> r> n "}")
(ife "if (" p ") {" n> r> n "} else {" n> q n "}")

(cout "std::cout << " p " << \"\\n\";")
(cerr "std::cerr << " p " << \"\\n\";")

(enum "enum class " (s name) " {" n> q n "};")

(tpl "template <typename " (p "T") ">" n q)

(req "requires " p)

(staticassert "static_assert(" p ");")

(noexcept "noexcept(" p ")")

(op "operator" p "(" p ")" q)
